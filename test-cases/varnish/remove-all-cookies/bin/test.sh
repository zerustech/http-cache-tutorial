#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../bootstrap.sh                                        

# This script runs test cases for removing all cookies.
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
tty_printf -f green "Test Case: remove all cookies\n"
tty_print_line -f green

tty_printf "Include some cookies to access index.php: cookies are removed.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /index.php "Cookie: cookie0=value0; cookie1=value1; cookie2=value2; cookie3=value3; cookie4=value4  ;"

tty_printf "Include some cookies to access admin/index.php: cookies are kept.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /admin/index.php "Cookie: cookie0=value0; cookie1=value1; cookie2=value2; cookie3=value3; cookie4=value4  ;"

$service/php-stop && $service/varnish-stop
