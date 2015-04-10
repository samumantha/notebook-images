from flask.ext.testing import TestCase

from pouta_blueprints.server import app, db
from pouta_blueprints.config import TestConfig


class BaseTestCase(TestCase):
    def create_app(self):
        app.config.from_object(TestConfig())
        app.config['TESTING'] = True
        return app

    def setUp(self):
        db.create_all()

    def tearDown(self):
        db.session.remove()
        db.drop_all()
