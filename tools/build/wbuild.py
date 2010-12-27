#!/usr/bin/env python3

"""Wyvern Build System

Intelligently manages wyvern builds based on a simple conditional
compilation system.
"""

import configparser
from optparse import OptionParser
import os

# Find configuration file
root = os.getcwd()
while not os.path.exists(os.path.join(root, 'WBuildConfig')):
    root = os.path.dirname(root)
    if root is None or root=="" or root=="/":
        # TODO print an actual error message
        print("No WBuildConfig file found")
        exit(1)

# Read the configuration file
cfgfname = os.path.join(root, 'WBuildConfig')
cfgparser = configparser.ConfigParser()
cfgparser.read(cfgfname)

# Parse options
usage = "usage: %prog [-f FILE]"
parser = OptionParser(usage=usage)
parser.add_option("-f", "--config", dest="kcfgfname",
    default="KConfig", help="kernel configuration file",
    metavar="FILE")
parser.add_option("-v", "--verbose", action="store_true",
    dest="verbose", default=False, 
    help="enable verbose output")
parser.add_option("-V", "--version", action="store_true",
    dest="version", default=False,
    help="display version information")


(options, args) = parser.parse_args()

# Print version information (and exit) if asked for.
if options.version:
    print("%s %s" % (cfgparser.get("Project", "name").lower(), 
        cfgparser.get("Project", "version")))
    exit(0)

# TODO handle the arguments

