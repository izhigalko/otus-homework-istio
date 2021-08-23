import os
from flask import Flask

app = Flask(__name__)


@app.route("/version")
def version():
    ver = os.environ.get("SERVICE_VERSION")

    return f"Version: {ver}, instance: {os.environ.get('HOSTNAME')}\n"


@app.route("/health")
def health():
    return "{'status': 'ok'}"
