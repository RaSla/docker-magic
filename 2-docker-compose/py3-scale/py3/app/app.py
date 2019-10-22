from flask import Flask
from flask import Response
from redis import Redis
import datetime
import os
import socket

app = Flask(__name__)
host = socket.gethostname()

# Connect to Redis
#redis_pass = os.getenv('REDIS_PASSWORD', '')
#redis = Redis(host='redis', port=6379, db=0, password=redis_pass, socket_timeout=None, connection_pool=None, charset='utf-8')
redis = Redis(host='redis', port=6379, db=0)

@app.route('/')
def hello():
    dt_iso = datetime.datetime.utcnow().replace(microsecond=0, tzinfo=datetime.timezone.utc).isoformat()
    txt = 'Hello World from Python & Flask!\n DateTime (UTC): "%s"\n My hostname is "%s"\n\n/py3/hits - try Redis hits-counter\n' % (dt_iso, host)
    return Response(txt, mimetype='text/plain')

@app.route('/py3/hits')
def hits():
    dt_iso = datetime.datetime.utcnow().replace(microsecond=0, tzinfo=datetime.timezone.utc).isoformat()
    hits = redis.incr('hits')
    txt = 'Python says:\n DateTime (UTC): "%s"\n My hostname is "%s"\n\n Redis "hits": %s\n' % (dt_iso, host, hits)
    return Response(txt, mimetype='text/plain')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
