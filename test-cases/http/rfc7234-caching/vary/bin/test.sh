#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../../bootstrap.sh                                     

# This script runs the test cases of content negotiation.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php.start && $service/varnish.start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# content negotiation and vary
tty_printf -f green "Test Case: 'Vary' response header field.\n"
tty_print_line -f green

tty_printf "Include 'X-Accept-Content-Category: test001' in the reqeuest and
test: receives a fresh 200 response (miss).\n"
$app_bin/http/get.sh -l /index.php "X-Accept-Content-Category: test001"

tty_printf "Include 'X-Accept-Content-Category: test002' in the reqeuest and
test: receives a fresh 200 response (miss).\n"
$app_bin/http/get.sh -l /index.php "X-Accept-Content-Category: test002"

tty_printf "Include 'X-Accept-Content-Category: test001' in the reqeuest and
test: receives a cached 200 response (hit).\n"
$app_bin/http/get.sh -l /index.php "X-Accept-Content-Category: test001"

tty_printf "Include 'X-Accept-Content-Category: test002' in the reqeuest and
test: receives a cached 200 response (hit).\n"
$app_bin/http/get.sh -l /index.php "X-Accept-Content-Category: test002"

tty_printf "The selected responses for category 'test001' and 'test002' are
different, therefore we can confirm that the 'X-Accept-Content-Category' request
header field is used as the secondary cache key by varnish.\n"

tty_printf -f red "NOTE: There is no way to dump the cache keys.\n\n"

$service/php.stop && $service/varnish.stop
