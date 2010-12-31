#!/usr/bin/env python3

"""Wyvern Build System

Intelligently manages wyvern builds based on a simple conditional
compilation system.
"""

import configparser
from optparse import OptionParser
import os

# TODO create proper exception hierarchy

class Project:
    """Represents a project.

    In ordinary usage (i.e. for simple projects) there will be only one of
    these.
    """
    def __init__(self, settings):
        # Copy the settings in directly
        for key in settings:
            self.__dict__[key] = settings[key]
        self.settings = settings

class Component:
    """

    """
    pass

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

# Create the project from a generated dictionary of project settings
proj_opts = cfgparser.options("Project")
project_settings = {}
for opt in proj_opts:
    project_settings[opt] = cfgparser.get("Project", opt)

project = Project(project_settings)

# Create the specified components

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

# TODO read in the kernel configuration file

