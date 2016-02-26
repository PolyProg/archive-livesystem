#!/usr/bin/python3
# -*- coding: utf-8 -*-

import argparse
import os

from flask import Flask, request, abort
import paramiko


__author__ = "Benjamin Schubert <ben.c.schubert@gmail.com>"


app = Flask(__name__)
BACKGROUND_FILE = "/usr/share/backgrounds/contest.png"


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
    ssh.connect(request.remote_addr, 22, "root")
    (stdin, stdout, stderr) = ssh.exec_command("hostname")
    if len(stderr.readlines()):
        abort(404)

    hostname = stdout.readlines()[0].strip("\n")

    with open("/etc/hosts", "a") as f:
        f.write(request.remote_addr + "\t" + hostname + "\n")

    with open("/etc/icinga2/conf.d/hosts.conf", "a") as f:
        f.write("object Host \"{}\" {{\n".format(".".join(hostname.split(".")[:-1])))
        f.write("\timport \"generic-host\"\n")
        f.write("\taddress = \"{}\"\n}}\n\n".format(request.remote_addr))

    if os.path.exists(BACKGROUND_FILE):
        sftp = ssh.open_sftp()
        sftp.put(BACKGROUND_FILE, BACKGROUND_FILE)

        ssh.exec_command((
            "update-alternatives --install /usr/share/images/desktop-base/desktop-background"
            "desktop-background /usr/share/backgrounds/contest.png 10"
        ))
        ssh.exec_command("update-alternatives --set desktop-background /usr/share/backgrounds/contest.png")

    ssh.close()
    return "OK"

if __name__ == "__main__":
    app.run(**parse_args())
