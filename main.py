from flask import Flask, render_template, request
from datetime import datetime
import os

app = Flask(__name__)


@app.route("/")
@app.route("/index")
def collect_info():
    client_ip = request.environ.get('HTTP_X_REAL_IP', request.remote_addr)
    server_ip = request.host
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    load1, load5, load15 = os.getloadavg()
    return render_template('index.html', client_ip=client_ip, current_time=current_time, server_ip=server_ip,
                           load1=load1, load5=load5, load15=load15)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
