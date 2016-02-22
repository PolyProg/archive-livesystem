#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import logging
import os
import re
import shutil
import subprocess
from configparser import ConfigParser, _UNSET, NoSectionError, NoOptionError
from contextlib import suppress

import requests
import sys


VERBOSE = int((logging.INFO + logging.DEBUG) / 2)
DEFAULT_CONFIGURATION_PATH = os.path.join(os.path.abspath(os.path.dirname(__file__)), ".livesystem.config")

logger = logging.getLogger("builder")
logger.setLevel(logging.INFO)
console_handler = logging.StreamHandler(sys.stdout)
logger.addHandler(console_handler)


class EnhancedConfigParser(ConfigParser):
    LIST_SEPARATOR = ","

    @staticmethod
    def _convert_to_list(value: str) -> list:
        """
        Converts a vcs string to a list
        :param value: string to convert
        :return: the corresponding list
        """
        return [item for item in re.split(r"{}\s*".format(EnhancedConfigParser.LIST_SEPARATOR), value) if item != ""]

    def getlist(self, section: str, option, *, raw: bool=False, vars=None, fallback=_UNSET) -> list:
        """
        Return a list value for the named option in the named section
        :param section: the section to search
        :param option: the wanted option
        :param raw: if True, will not interpolate values
        :param vars: additional substitutions
        :param fallback: fallback value
        :return: the given option as a list
        """
        try:
            return self._get(section, self._convert_to_list, option, raw=raw, vars=vars)
        except (NoSectionError, NoOptionError):
            if fallback is _UNSET:
                raise
            else:
                return fallback


def parse_args(args):
    parser = argparse.ArgumentParser(description="Live iso builder")
    parser.add_argument("--config", default=DEFAULT_CONFIGURATION_PATH,
                        help="Configuration file to use, default={}".format(DEFAULT_CONFIGURATION_PATH))
    parser.add_argument("-f", "--full", action="store_true", help="rebuild from scratch")
    parser.add_argument("-e", "--export", default=".", help="Directory to export the built iso(s)")

    log_level = parser.add_mutually_exclusive_group()
    log_level.add_argument("-q", "--quiet", action="store_true", help="quiet output")
    log_level.add_argument("-v", "--verbose", action="store_true", help="verbose output")
    log_level.add_argument("-d", "--debug", action="store_true", help="debug output")

    isos = parser.add_argument_group("Systems to build")
    isos.add_argument("-c", "--client", action="store_true", help="Build client")
    isos.add_argument("-s", "--server", action="store_true", help="Build server")

    arguments = parser.parse_args(args)

    if not arguments.server and not arguments.client:
        arguments.server = arguments.client = True

    dict_args = vars(arguments)

    if arguments.debug:
        dict_args["verbosity"] = logging.DEBUG
    elif arguments.verbose:
        dict_args["verbosity"] = VERBOSE
    elif arguments.quiet:
        dict_args["verbosity"] = logging.WARNING
    else:
        dict_args["verbosity"] = logging.INFO

    del dict_args["debug"]
    del dict_args["verbose"]
    del dict_args["quiet"]

    return dict_args


def run(command: list, cwd: str):
    proc = subprocess.Popen(command, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    for line in iter(proc.stdout.readline, b''):
        logger.debug(line.decode().strip("\n"))

    if proc.wait():
        raise subprocess.CalledProcessError(cmd=command, returncode=proc.wait())


def get_external_package(config, build_path, rebuild=False):
    extract_path = os.path.join(build_path, "config/includes.chroot", config["directory"].strip("/"))
    filepath = os.path.join(config.get("cache", ".cache"), config["url"].split("/")[-1])

    if rebuild:
        with suppress(FileNotFoundError):
            shutil.rmtree(os.path.join(extract_path, config.name))
        with suppress(FileNotFoundError):
            shutil.rmtree(config.get("cache", ".cache"))

    if os.path.exists(os.path.join(extract_path, config.name)):
        return

    os.makedirs(config.get("cache", ".cache"), exist_ok=True)
    req = requests.get(config["url"])
    with open(filepath, "wb") as dl:
        dl.write(req.content)

    shutil.unpack_archive(filepath, extract_path)


def build(path, full_rebuild, config):
    build_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), path)
    logger.setLevel(int(config[path]["verbosity"]))

    logging.info("Building " + path)

    if full_rebuild or not os.path.exists(os.path.join(build_path, "binary")):
        logger.log(VERBOSE, "Full rebuild needed, cleaning up files")
        for folder in ["normal", "live"]:
            directory = os.path.join(build_path, "config/hooks", folder)
            for entry in os.listdir(directory):
                if os.path.islink(os.path.join(directory, entry)):
                    os.remove(os.path.join(directory, entry))

        run(["sudo", "lb", "clean", "--purge"], cwd=build_path)
        run(["lb", "config"], cwd=build_path)
    else:
        logger.log(VERBOSE, "No full rebuild needed")
        run(["sudo", "lb", "clean"], cwd=build_path)

    for package in config.getlist(path, "external_packages", fallback=[]):
        get_external_package(config[package], build_path, full_rebuild)

    logger.log(VERBOSE, "Building iso for {}".format(path))
    run(["sudo", "lb", "build"], cwd=build_path)

    export = os.path.join(os.path.abspath(config[path]["export"]), "{}.iso".format(path))
    logger.log(VERBOSE, "Copying iso to {}".format(export))
    with suppress(FileNotFoundError):
        os.remove(export)

    shutil.move(os.path.join(build_path, "live-image-amd64.hybrid.iso"), export)


def main(server, client, config, full, **kwargs):
    configuration = EnhancedConfigParser()
    configuration.read(config)

    for entry in kwargs.keys():
        for section in configuration.sections():
            configuration[section][entry] = str(kwargs[entry])

    if server:
        build("server", full, configuration)

    if client:
        build("client", full, configuration)


if __name__ == "__main__":
    main(**parse_args(sys.argv[1:]))
