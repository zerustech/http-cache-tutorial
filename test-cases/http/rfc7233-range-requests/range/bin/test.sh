#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../../bootstrap.sh                                     

# This script runs the test cases of range requests.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php.start && $service/varnish.start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# range
tty_printf -f green "Test Case: range requests'
response header.\n"
tty_print_line -f green

tty_printf "Reset asset.txt.\n"
echo "0123456789" > $web/asset.txt
tty_printf "Contents of asset.txt: 0123456789\n\n"

tty_printf "Initialize cache.\n"
$app_bin/http/get.sh -l /index.php

tty_printf "Include 'Range: 0-5' in the request and test: receives a cached 206
response (hit).\n"
$app_bin/http/get.sh -l /index.php "Range: bytes=0-5"

tty_printf "Change contents of asset.txt.\n"
echo "abcdefghij" > $web/asset.txt
tty_printf "Contents of asset.txt: abcdefghij\n\n"

tty_printf "Include 'Range: 0-5' in the request and test: receives a cached 206
response (hit).\n"
$app_bin/http/get.sh -l /index.php "Range: bytes=0-5"

tty_printf "Sleep for 6 second, include 'Range: 0-5' in the request and test:
receives a fresh 206 response (miss).\n"
sleep 6 && $app_bin/http/get.sh -l /index.php "Range: bytes=0-5"

$service/php.stop && $service/varnish.stop
