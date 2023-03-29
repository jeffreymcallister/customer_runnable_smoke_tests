#!/usr/bin/env python3
############################################################################
# Copyright (C) 2020 Intel Corporation
#
# SPDX-License-Identifier: MIT
############################################################################
"""
Run command lines and check results
"""

import argparse
import os.path
import sys
from contextlib import contextmanager
import yaml
import pexpect


def config_file(path):
    """
    Argparse wrapper for config file
    """
    if not os.path.isfile(path):
        raise FileNotFoundError(path)
    return path


def read_command_line(cmd_line=None):
    """
    Read command line arguments
    """
    # Now read full arguments
    parser = argparse.ArgumentParser(
        description=globals()['__doc__'],
        formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument("-c", "--config", type=config_file, help="Configuration file", required=True)
    parser.add_argument("-o", "--output", help="Destination file", default="cmds.md")
    parser.add_argument("-f", "--format", choices=["shell", "md"], default="md")
    # parse arguments (will exit here on invalid args or help)

    try:
        args = parser.parse_args(args=cmd_line)
    except Exception as err:
        print(type(err))    # the exception instance
        print(err.args)     # arguments stored in .args
        print(err)          # __str__ allows args to be printed directly,
                             # but may be overridden in exception subclasses

        exit(1)

    return args

#def add_shell_commands(step, outfile,install_prefix):
#    for cmd in step['commands']:
#        outfile.write("RUN "+cmd+"\n")
    

def process_cmd(step, outfile):
    print("adding "+step['name'])

def main(args):
    """
    CLI entry point
    """
    with open(args.config, encoding='utf-8') as yaml_src:
        try:
            yaml_obj = yaml.safe_load(yaml_src)
            args.config = yaml_obj
        except yaml.YAMLError as yaml_err:
            print(f"Error reading {args.config}\n{yaml_err}")
            sys.exit(1)

    with open(args.output, encoding='utf-8', mode='w') as outfile:
        print("args.format=",args.format)

        steps=yaml_obj['steps']
        for step in steps:
            process_cmd(step, outfile)


if __name__ == '__main__':
    main(read_command_line())
