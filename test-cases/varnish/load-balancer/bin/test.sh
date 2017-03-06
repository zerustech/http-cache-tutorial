#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../bootstrap.sh                                        

# This script runs the load balancer test cases.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web 

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php.start -S "localhost:8000" && $service/php.start -S "localhost:8001" && $service/varnish.start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# no-cache
tty_printf -f green "Test Case: load balancer\n"
tty_print_line -f green

tty_printf "Access index.php: receives a 200 response from one of the back end server.\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php

sleep 2

tty_printf "Access index.php: receives a 200 response from one of the back end server.\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php

sleep 2

tty_printf "Access index.php: receives a 200 response from one of the back end server.\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php

sleep 2

tty_printf "Access index.php: receives a 200 response from one of the back end server.\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php

sleep 2

tty_printf "Access index.php: receives a 200 response from one of the back end server.\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php

sleep 2

tty_printf "Access index.php: receives a 200 response from one of the back end server.\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php

sleep 2

$service/php.stop -S "localhost:8000" && $service/php.stop -S "localhost:8001" && $service/varnish.stop
