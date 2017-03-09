#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../bootstrap.sh

# This script kills all running php bulitin servers and varnish cache servers
# and cleans up the pid and log files.
# 
# @author Michael Lee <michael.lee@zerustech.com>

find $app_var -name "*.pid" -print0 | xargs -0 -I {} cat {} | xargs -I {} kill -9 {}

rm -rf $app_var/*.pid

lsof -i4 | grep http | grep varnish | awk '{print $2}' | xargs -I {} kill -9 {}
