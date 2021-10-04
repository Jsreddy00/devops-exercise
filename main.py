from flask import Flask
import socket
from datetime import datetime
import os

app = Flask(__name__)


@app.route("/")
def collect_info():
    client_host = socket.gethostname()
    client_ip = socket.gethostbyname(client_host)
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    load1, load5, load15 = os.getloadavg()

    return "Hello, " + client_ip + " " + socket.gethostbyname("localhost") + " " + current_time + " " + \
           str(load1) + " " + str(load5) + " " + str(load15)


if __name__ == "__main__":
    app.run(host="localhost", port=8080)
