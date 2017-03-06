#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../../bootstrap.sh                                     

# This script runs the freshness lifetime test cases.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php.start && $service/varnish.start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# s-maxage
tty_printf -f green "Test Case: response 's-maxage' Cache-Control directive as freshness lifetime\n"
tty_print_line -f green

tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /s-maxage.php

tty_printf "Access s-maxage.php: receives a cached 200 response (hit).\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /s-maxage.php

tty_printf "Sleep for 6 seconds and test: receives a fresh 200 response (miss).\n"
sleep 6 && $app_vendor_zerustech_cli_bin/http/http.get -l /s-maxage.php

# max-age
tty_printf -f green "Test Case: response 'max-age' Cache-Control directive as freshness lifetime\n"
tty_print_line -f green

tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /max-age.php

tty_printf "Access max-age.php: receives a cached 200 response (hit).\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /max-age.php

tty_printf "Sleep for 6 seconds and test: receives a fresh 200 response (miss).\n"
sleep 6 && $app_vendor_zerustech_cli_bin/http/http.get -l /max-age.php

# expires
tty_printf -f green "Test Case: response 'Expires' header field as freshness lifetime\n"
tty_print_line -f green

tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /expires.php

tty_printf "Access expires.php: receives a cached 200 response (hit).\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /expires.php

tty_printf "Sleep for 6 seconds and test: receives a fresh 200 response (miss).\n"
sleep 6 && $app_vendor_zerustech_cli_bin/http/http.get -l /expires.php


$service/php.stop && $service/varnish.stop
