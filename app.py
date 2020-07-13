from os import getenv

from flask import Flask

app = Flask(__name__)


@app.route("/healthcheck")
def index():
    msg = f"docker-flask-envs-secrets running from: *** {getenv('ENV')} ***"
    if getenv("ENV") == "prod":
        return f"{msg} and the secret key is *** {getenv('SECRET_KEY')} ***", 200
    return msg, 200
