import json
import time
import uuid
from docker.tls import TLSConfig
import os
from pouta_blueprints.client import PBClient
from pouta_blueprints.drivers.provisioning import base_driver
import docker
from pouta_blueprints.services.openstack_service import OpenStackService

SLEEP_BETWEEN_POLLS = 3
POLL_MAX_WAIT = 180


class DockerDriver(base_driver.ProvisioningDriverBase):
    def get_configuration(self):
        from pouta_blueprints.drivers.provisioning.docker_driver_config import CONFIG

        config = CONFIG.copy()

        return config

    def do_update_connectivity(self, token, instance_id):
        self.logger.warning('do_update_connectivity not implemented')

    def do_provision(self, token, instance_id):
        self.logger.debug("do_provision %s" % instance_id)
        pbclient = PBClient(token, self.config['INTERNAL_API_BASE_URL'], ssl_verify=False)

        instance = pbclient.get_instance_description(instance_id)

        dh = self._select_host()
        self.logger.debug('selected host %s' % dh)

        # TODO: fix certificate/runtime path
        # TODO: figure out why server verification does not work (crls?)
        tls_config = TLSConfig(
            client_cert=(
                '/webapps/pouta_blueprints/run/client_cert.pem', '/webapps/pouta_blueprints/run/client_key.pem'),
            #            ca_cert='/webapps/pouta_blueprints/run/ca_cert.pem',
            verify=False,
        )
        dc = docker.Client(base_url=dh['docker_url'], tls=tls_config)

        container_name = instance['name']

        config = {
            'image': 'jupyter/demo',
            'name': container_name
        }
        dc.pull(config['image'])

        res = dc.create_container(**config)
        container_id = res['Id']
        self.logger.info("created container '%s' (id: %s)", container_name, container_id)

        dc.start(container_id, publish_all_ports=True)
        self.logger.info("started container '%s'", container_name)

        public_ip = dh['public_ip']
        # get the public port
        res = dc.port(container_id, 8888)
        public_port = res[0]['HostPort']

        instance_data = {
            'endpoints': [
                {'name': 'http', 'access': 'http://%s:%s' % (public_ip, public_port)},
            ],
            'docker_url': dh['docker_url']
        }

        pbclient.do_instance_patch(
            instance_id,
            {'public_ip': public_ip, 'instance_data': json.dumps(instance_data)}
        )

        self.logger.debug("do_provision done for %s" % instance_id)

    def do_deprovision(self, token, instance_id):
        self.logger.debug("do_deprovision %s" % instance_id)

        pbclient = PBClient(token, self.config['INTERNAL_API_BASE_URL'], ssl_verify=False)
        instance = pbclient.get_instance_description(instance_id)

        docker_url = instance['instance_data']['docker_url']

        tls_config = TLSConfig(
            client_cert=(
                '/webapps/pouta_blueprints/run/client_cert.pem', '/webapps/pouta_blueprints/run/client_key.pem'),
            verify=False,
        )
        dc = docker.Client(docker_url, tls=tls_config)

        container_name = instance['name']

        dc.remove_container(container_name, force=True)

        self.logger.debug("do_deprovision done for %s" % instance_id)

    def do_housekeep(self, token):
        hosts = self._get_hosts()

        # find active hosts
        active_hosts = [x for x in hosts if x['is_active']]

        # if there are no active hosts, spawn one
        if len(active_hosts) == 0:
            new_host = self._spawn_host()
            self.logger.info('do_housekeep() spawned a new host %s' % new_host['id'])
            hosts.append(new_host)
            self._save_hosts(hosts)
            return

        # mark old ones inactive
        for host in active_hosts:
            if host['spawn_ts'] < time.time() - 36000:
                self.logger.info('do_housekeep() making host %s inactive' % host['id'])
                host['is_active'] = False

        # remove inactive hosts that have no instances on them
        for host in hosts:
            if host['is_active']:
                continue
            if host['num_instances'] == 0:
                self.logger.info('do_housekeep() removing host %s' % host['id'])
                self._remove_host(host)
                hosts.remove(host)
                self._save_hosts(hosts)
            else:
                self.logger.debug('do_housekeep() inactive host %s still has %d instances' %
                                  (host['id'], host['num_instances']))

    def _select_host(self):
        hosts = self._get_hosts()
        return hosts[0]

    def _get_hosts(self):
        self.logger.debug("_get_hosts")

        data_file = '%s/%s' % (self.config['INSTANCE_DATA_DIR'], 'docker_driver.json')

        if os.path.exists(data_file):
            with open(data_file, 'r') as df:
                hosts = json.load(df)
        else:
            hosts = []

        return hosts

    def _save_hosts(self, hosts):
        self.logger.debug("_save_hosts")

        data_file = '%s/%s' % (self.config['INSTANCE_DATA_DIR'], 'docker_driver.json')
        if os.path.exists(data_file):
            os.rename(data_file, '%s.%s' % (data_file, int(time.time())))
        with open(data_file, 'w') as df:
            json.dump(hosts, df)

    def _spawn_host(self):
        return self._spawn_host_os_service()

    def _spawn_host_dummy(self):
        self.logger.debug("_spawn_host")
        return {
            'id': uuid.uuid4().hex,
            'provider_id': uuid.uuid4().hex,
            'docker_url': 'https://192.168.44.152:2376',
            'public_ip': '86.50.169.98',
            'spawn_ts': int(time.time()),
            'is_active': True,
            'num_instances': 0,
        }

    def _spawn_host_os_service(self):
        self.logger.debug("_spawn_host_os_service")

        config = {
            'image': 'CentOS-7.0',
            'flavor': 'mini',
            'key': 'pb_dockerdriver',
            '': '',
        }
        instance_name = 'pb_dd_%s' % uuid.uuid4().hex
        image_name = config['image']
        flavor_name = config['flavor']
        key_name = config['key']

        oss = OpenStackService({'M2M_CREDENTIAL_STORE': self.config['M2M_CREDENTIAL_STORE']})

        # make sure the our key is in openstack
        oss.upload_key(key_name, '/home/pouta_blueprints/.ssh/id_rsa.pub')

        # run actual provisioning
        res = oss.provision_instance(
            display_name=instance_name,
            image_name=image_name,
            flavor_name=flavor_name,
            key_name=key_name,
            master_sg_name='pb_server'
        )

        self.logger.debug("_spawn_host_os_service: spawned %s" % res)

        return {
            'id': instance_name,
            'provider_id': res['server_id'],
            'docker_url': 'https://%s:2376' % res['ip']['private_ip'],
            'public_ip': res['ip']['public_ip'],
            'spawn_ts': int(time.time()),
            'is_active': True,
            'num_instances': 0,
        }

    def _remove_host(self, host):
        self.logger.debug("_remove_host")
        self._remove_host_os_service(host)

    def _remove_host_os_service(self, host):
        self.logger.debug("_remove_host_os_service")
        oss = OpenStackService({'M2M_CREDENTIAL_STORE': self.config['M2M_CREDENTIAL_STORE']})
        oss.deprovision_instance(host['provider_id'])

    def _check_host(self, host):
        self.logger.debug("_check_host %s" % host)
        self.logger.warning("_check_host not implemented")
