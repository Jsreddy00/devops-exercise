from flask import Flask, render_template
import socket
from datetime import datetime
import os
import requests

app = Flask(__name__)


@app.route("/")
@app.route("/index")
def collect_info():
    client_ip = requests.get('https://checkip.amazonaws.com').text.strip()
    server_ip = socket.gethostbyname(socket.gethostname())
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    load1, load5, load15 = os.getloadavg()
    return render_template('index.html', client_ip=client_ip, current_time=current_time, server_ip=server_ip,
                           load1=load1, load5=load5, load15=load15)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
