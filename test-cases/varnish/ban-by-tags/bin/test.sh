#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../bootstrap.sh                                     

# This script runs the test cases for banning contents by tags.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php-start && $service/varnish-start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# ban by tags
tty_printf -f green "Test Case: ban by tags\n"
tty_print_line -f green

tty_printf "Access index.php to initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /index.php

tty_printf "Sleep for 1 second and access index.php: receives a cached 200
response (hit).\n"
sleep 1 && $app_vendor_zerustech_cli_bin/http/http-get -l /index.php

tty_printf "Ban by tag \"abc\" and test: receives a fresh 200 response (miss).\n"
$app_vendor_zerustech_cli_bin/http/http-ban -l /ban-by-tags -t '"abc"' && $app_vendor_zerustech_cli_bin/http/http-get -l /index.php

tty_printf "Access index.php to initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /index.php

tty_printf "Sleep for 1 second and access index.php: receives a cached 200
response (hit).\n"
sleep 1 && $app_vendor_zerustech_cli_bin/http/http-get -l /index.php

tty_printf "Ban by tag \"abc\",\"def\" and test: receives a fresh 200 response (miss).\n"
$app_vendor_zerustech_cli_bin/http/http-ban -l /ban-by-tags -t '"abc","def"' && $app_vendor_zerustech_cli_bin/http/http-get -l /index.php

$service/php-stop && $service/varnish-stop
