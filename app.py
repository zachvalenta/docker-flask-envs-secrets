from flask import Flask

app = Flask(__name__)

@app.route('/healthcheck')
def index():
    return "docker-flask-envs-secrets running", 200
