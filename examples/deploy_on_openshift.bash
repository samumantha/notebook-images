#!/usr/bin/env bash

set -e

# select the notebook to deploy
notebook_image='pb-jupyter-ml'
#notebook_image='pb-rocker-rstudio'

# configure names and count
name_prefix='nb'
name_start='01'
name_end='05'

# set the subdomain for routes
subdomain='oso-pilot.csc.fi'

# generate a name list for
names=''
for i in $(seq -w $name_start $name_end); do
    names="$names $name_prefix$i"
done

echo "Deploying $notebook_image, $name_start to $name_end, to $subdomain"

# print the current context
echo
echo -n 'Querying OpenShift project: '
oc project

echo -n 'Querying OpenShift identity: '
oc whoami

# give some time to bail out
echo 'Waiting a bit'
sleep 2

echo "deploying notebooks from $name_prefix$name_start to $name_prefix$name_end"

# build ML image, if no build config found
if ! oc get bc $notebook_image > /dev/null; then
    echo "build config not found, building"
    pushd ../builds
    ./build_openshift.sh $notebook_image
    popd

    # wait for the build to complete
    oc logs bc/$notebook_image -f
else
    echo "build config found, not rebuilding"
fi

# deploy notebooks and create routes
for name in $names; do
    # adapt this to your needs
    oc new-app --image-stream ml/$notebook_image \
      -e AUTODOWNLOAD_URL='https://raw.githubusercontent.com/CSC-IT-Center-for-Science/machine-learning-scripts/master/notebooks/download.sh' \
      -e AUTODOWNLOAD_EXEC='download.sh' \
      --labels='script=deploy_notebooks' \
      --name $name

    oc create route edge $name --service=$name --hostname="$name.$subdomain"
done

echo
echo 'Done.'
echo 'List of notebooks urls:'
echo
for name in $names; do
    echo "  https://$name.$subdomain"
done

echo
echo 'To delete the notebooks, run'
echo
echo '    oc delete all -l script=deploy_notebooks'
echo
