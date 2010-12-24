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
usage = "usage: %prog [options]"
parser = OptionParser(usage=usage)
parser.add_option("-v", "--verbose", action="store_true",
    dest="verbose", default=False, 
    help="enable verbose output")
(options, args) = parser.parse_args()

