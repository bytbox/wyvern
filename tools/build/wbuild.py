#!/usr/bin/env python3

from optparse import OptionParser

# Find configuration file

# Parse options
usage = "usage: %prog [options]"
parser = OptionParser(usage=usage)
parser.add_option("-v", "--verbose", action="store_true",
	dest="verbose", default=False, 
	help="enable verbose output");
(options, args) = parser.parse_args()

