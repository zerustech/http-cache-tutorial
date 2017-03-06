#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../../bootstrap.sh                                     

# This script runs the test cases of stale contents.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web

# default_grace is 10 seconds, so when the origin server is not available, stale
# responses will be served if they have exceeded the freshness lifetime by 10
# seconds or less.
$service/php.start && $service/varnish.start ""

# wait for the php builtin server to start
sleep 1

# stale response
tty_printf -f green "Test Case: stale response.\n"
tty_print_line -f green

tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php

tty_printf "Stop php builtin server.\n"
$service/php.stop

tty_printf "Sleep for 6 seconds and access index.php: receives a cached 200
response (hit).\n"
sleep 6 && $app_vendor_zerustech_cli_bin/http/http.get -l /index.php

tty_printf "Sleep for 10 seconds and access index.php: fails with a 503
response.\n"
sleep 10 && $app_vendor_zerustech_cli_bin/http/http.get -l /index.php

$service/php.stop && $service/varnish.stop
