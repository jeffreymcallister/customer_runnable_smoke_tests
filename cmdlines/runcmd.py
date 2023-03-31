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
import subprocess
from termcolor import colored


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
    parser.add_argument("-c",
                        "--config",
                        type=config_file,
                        help="Configuration file",
                        required=True)
    parser.add_argument("-o",
                        "--output",
                        help="Destination file",
                        default="cmds.rst")
    parser.add_argument("-f",
                        "--format",
                        choices=["shell", "rst"],
                        default="shell")
    # parse arguments (will exit here on invalid args or help)

    try:
        args = parser.parse_args(args=cmd_line)
    except Exception as err:
        print(type(err))  # the exception instance
        print(err.args)  # arguments stored in .args
        print(err)  # __str__ allows args to be printed directly,
        # but may be overridden in exception subclasses

        exit(1)

    return args


def process_cmd_shell(step):
    stepname = step['name']
    print(f"running {stepname:<30}", end=" ")
    cmd = ""
    for cmdstep in step['commands']:
        cmd += cmdstep + "; "
    cmd += " echo ''"

    out = subprocess.run(cmd,
                         shell=True,
                         capture_output=True,
                         executable='/bin/bash')
    #print(cmd)
    #print(out.stdout+out.stderr)
    cmd_output = str(out.stdout) + " " + str(out.stderr)
    expected_out = step['expect']
    if (str(expected_out) in cmd_output): print(colored("PASS", 'green'))
    else:
        print(colored("FAIL", 'red'))
        print(out)


def process_cmd_rst(step, outfile):
    print("adding " + step['name'])

    outfile.write(step['name'] + "\n")
    outfile.write("---------------\n\n")
    outfile.write(step['description'] + "\n\n")
    outfile.write(".. code-block:: bash\n\n")

    for cmdstep in step['commands']:
        outfile.write("\t" + cmdstep + "\n")

    outfile.write("\n\n")


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

    cmdlinelist = yaml_obj['cmdlines']

    if args.format == "shell":
        for step in cmdlinelist:
            process_cmd_shell(step)
    elif args.format == "rst":
        with open(args.output, encoding='utf-8', mode='w') as outfile:
            outfile.write("Example command lines\n")
            outfile.write("=====================\n")
            outfile.write("\n")
            outfile.write(".. contents::\n\n")

            for step in cmdlinelist:
                process_cmd_rst(step, outfile)


if __name__ == '__main__':
    main(read_command_line())
