#!/usr/bin/python3
# -*- coding: utf-8 -*-

from flask import Flask, request
import paramiko


__author__ = "Benjamin Schubert <ben.c.schubert@gmail.com>"


app = Flask(__name__)


@app.route("/register", methods=["PUT"])
def register():
    ssh = paramiko.SSHClient()
    ssh.load_system_host_keys()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(request.remote_addr, 22, "root")
    (stdin, stdout, stderr) = ssh.exec_command("hostname")
    print(stdout)


if __name__ == "__main__":
    app.run()
