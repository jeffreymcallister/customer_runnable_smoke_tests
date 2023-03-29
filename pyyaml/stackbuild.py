#!/usr/bin/env python3
############################################################################
# Copyright (C) 2020 Intel Corporation
#
# SPDX-License-Identifier: MIT
############################################################################
"""
Generate a script to build or install a stack from composable components
"""

import argparse
import os.path
import sys
from contextlib import contextmanager
import yaml


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
    parser.add_argument("-o", "--output", help="Destination file", default="Dockerfile")
    parser.add_argument("-f", "--format", choices=["shell", "docker"], default="docker")
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

def add_shell_commands(step, outfile,install_prefix):
    for cmd in step['commands']:
        outfile.write("RUN "+cmd+"\n")
    
def add_autotools_commands(step, outfile,install_prefix):
    outfile.write("    ./autogen.sh && \\ \n")
    outfile.write(F"    ./configure --prefix={install_prefix} && \\ \n")
    outfile.write("     make && make install ")

def add_meson_commands(step, outfile,install_prefix):
    outfile.write(F"    meson --prefix={install_prefix}")
    outfile.write(F"--libdir={install_prefix}/lib builddir && \\ \n")
    outfile.write("    ninja -C builddir install  \n")

def add_cmake_commands(step, outfile,install_prefix):
    outfile.write("    mkdir -p build && cd build && \\ \n")
    outfile.write(F"    cmake -DCMAKE_INSTALL_PREFIX={install_prefix} .. && \\ \n")
    outfile.write("    make -j && make install \n")

def build_layer(layerfile, outfile):
    with open(layerfile, encoding='utf-8') as layer_src:
        try:
            targetstack = yaml.safe_load(layer_src)
        except yaml.YAMLError as yaml_err:
            print(f"Error reading {layerfile}")
            sys.exit(1)

    if 'install_prefix' in targetstack:
        install_prefix=targetstack['install_prefix']
    else:
        install_prefix="/usr/local"

    steps = targetstack['steps']
    for step in steps:
       
        print("adding "+step['name'],step['buildsystem'])
        outfile.write("#----\n")
        outfile.write("# build ")
        if 'layername' in targetstack:
            outfile.write(targetstack['layername']+" component ")
        outfile.write(step['name']+"\n")
        outfile.write("#----\n")

        if 'giturl' in step:
            cmd='RUN git clone '
            if 'branch' in step:
                cmd+=" -b "+step['branch']+" "
            cmd+= step['giturl'] + " && \\ "
            outfile.write(cmd+"\n")

        if 'dir' in step:
            outfile.write("    cd "+step['dir']+" && \\ \n")

        if step['buildsystem']=="shell":
            add_shell_commands(step, outfile,install_prefix)
        elif step['buildsystem']=="autotools":
            add_autotools_commands(step, outfile,install_prefix)
        elif step['buildsystem']=="meson":
            add_meson_commands(step, outfile,install_prefix)
        elif step['buildsystem']=="cmake":
            add_cmake_commands(step, outfile,install_prefix)


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

    with open(args.output, encoding='utf-8', mode='w') as outfile:
        if args.format=="docker":
            outfile.write("FROM "+yaml_obj['os']+"\n\n")

        stack_layers=yaml_obj['stack_layers']
        for layer in stack_layers:
            build_layer(layer,outfile)

if __name__ == '__main__':
    main(read_command_line())