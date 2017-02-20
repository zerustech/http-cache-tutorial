#!/bin/sh

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../bootstrap.sh

# This script starts varnishhist from the command line.
# 
# @author Michael Lee <michael.lee@zerustech.com>

sudo $varnish_home/bin/varnishhist "$@"
