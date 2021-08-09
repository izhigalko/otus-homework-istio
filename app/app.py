import os
import math
from flask import Flask, request
app = Flask(__name__)


@app.route('/hello')
def hello():
    version = os.environ.get('SERVICE_VERSION')

    return 'Hello version: %s, instance: %s\n' % (version, os.environ.get('HOSTNAME'))


@app.route('/health')
def health():
    return 'Helloworld is healthy', 200


if __name__ == "__main__":
    app.run(host='0.0.0.0', threaded=True)