from os import getenv

from flask import Flask

app = Flask(__name__)

@app.route('/healthcheck')
def index():
    return f"docker-flask-envs-secrets running in {getenv('ENV')}", 200
