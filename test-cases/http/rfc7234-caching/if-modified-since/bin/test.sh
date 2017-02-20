#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../../bootstrap.sh 

# This script runs the test cases of 'If-Modified-Since' conditional requests.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service
web=$base/../web

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php.start && $service/varnish.start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# if-none-match
tty_printf -f green "Test Case: 'If-Modified-Since' conditional requests\n"
tty_print_line -f green

tty_printf "Reset asset.txt.\n\n"
printf "a001" > $web/asset.txt

tty_printf "Initialize cache.\n"
$app_bin/http/get.sh -l /index.php

tty_printf "Access index.php without the 'If-Modified-Since' header field: receives
a cached 200 response (hit).\n"
$app_bin/http/get.sh -l /index.php

tty_printf "Sleep for 1 second and use current date as the value of
'If-Modified-Since' header field: receives a 304 response.\n"
$app_bin/http/get.sh -l /index.php "If-Modified-Since: `http_gmt_date`"

tty_printf "Change contents of asset.txt.\n\n"
printf "a002" > $web/asset.txt

tty_printf "Sleep for 1 second and use a date of 1 second ago as
the value of 'If-Modified-Since' header field: receives a 304 response.\n"
tty_printf -f red "NOTE: still receives a 304 response, because the cached
object has not expired.\n"
sleep 1 && $app_bin/http/get.sh -l /index.php "If-Modified-Since: `http_gmt_date \"-1\"`"

tty_printf "Sleep for 5 seconds and test with a date of 10 seconds ago:
receives a fresh 200 response (miss).\n"
sleep 5 && $app_bin/http/get.sh -l /index.php "If-Modified-Since: `http_gmt_date \"-10\"`"

$service/php.stop && $service/varnish.stop
