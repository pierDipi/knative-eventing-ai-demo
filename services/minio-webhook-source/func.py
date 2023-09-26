from flask import Flask, request

application = Flask(__name__)


@application.route('/health/readiness')
def probe_health():
    return ""


@application.route('/health/liveness')
def probe_live():
    return ""


@application.route('/')
def hello():
    application.logger.error('%s %s %s %s %s', request.remote_addr, request.method,
                             request.scheme, request.full_path, request.data)
    return "Hello"


if __name__ == '__main__':
    application.run()
