#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../bootstrap.sh                                        

# This script runs the test cases for esi by surrogate header fields.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web 

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php-start && $service/varnish-start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# no-cache
tty_printf -f green "Test Case: esi by surrogate\n"
tty_print_line -f green

tty_printf "Access index-esi.php: esi is enabled.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /index-esi.php

tty_printf "Access index-no-esi.php: esi is disabled.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /index-non-esi.php

$service/php-stop && $service/varnish-stop
