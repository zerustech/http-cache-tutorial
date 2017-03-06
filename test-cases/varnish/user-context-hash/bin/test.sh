#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../bootstrap.sh                                        

# This script runs the user context test cases.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web 

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php.start && $service/varnish.start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# user context hash
tty_printf -f green "Test Case: user context hash\n"
tty_print_line -f green

tty_printf "Include 'user=user001;user-group=group001' cookie in the request and test:
receives a fresh 200 response (miss).\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php "Cookie: user=user001;user-group=group001"

tty_printf "Include 'user=user002;user-group=group002' cookie in the request and test:
receives a fresh 200 response (miss).\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php "Cookie: user=user002;user-group=group002"

tty_printf "Include 'user=user003;user-group=group001' cookie in the request and test:
receives a cached 200 response (hit).\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php "Cookie: user=user003;user-group=group001"

tty_printf "Include 'user=user004;user-group=group002' cookie in the request and test:
receives a cached 200 response (hit).\n"
$app_vendor_zerustech_cli_bin/http/http.get -l /index.php "Cookie: user=user004;user-group=group002"


$service/php.stop && $service/varnish.stop
