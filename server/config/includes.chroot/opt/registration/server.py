#!/usr/bin/python3
# -*- coding: utf-8 -*-

import argparse
from flask import Flask, request
import paramiko


__author__ = "Benjamin Schubert <ben.c.schubert@gmail.com>"


app = Flask(__name__)


def parse_args():
    parser = argparse.ArgumentParser("Run registration server")
    parser.add_argument("-p", "--port", help="Port on which to listen", default=5000)
    parser.add_argument("--host", help="Interface on which to listen, 0.0.0.0 for all", default="127.0.0.1")

    return vars(parser.parse_args())


@app.route("/register", methods=["PUT"])
def register():
    ssh = paramiko.SSHClient()
    ssh.load_system_host_keys()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(request.remote_addr, 22, "root", key_filename="~/.ssh/id_rsa")
    (stdin, stdout, stderr) = ssh.exec_command("hostname")
    print(stdout)


if __name__ == "__main__":
    app.run(**parse_args())
