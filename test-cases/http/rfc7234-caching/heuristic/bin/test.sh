#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../../bootstrap.sh                                     

# This script runs the test cases of heuristic freshness lifetime.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
# Also set default_ttl to 5, because Varnish uses the value of default_ttl as
# heursitic freshness lifetime.
$service/php.start && $service/varnish.start "-p default_grace=0 -p default_ttl=5"

# wait for the php builtin server to start
sleep 1

# no-cache
tty_printf -f green "Test Case: heuristic freshness lifetime.\n"
tty_print_line -f green

tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php

tty_printf "Access index.php: receives a cached 200 response (hit)."
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php

tty_printf "Sleep for 6 seconds and test: receives a fresh 200 response (miss)."
sleep 6 && $app_vendor_zerustech_cli_bin/http/http.get -l /index.php

$service/php.stop && $service/varnish.stop
