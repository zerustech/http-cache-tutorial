#!/bin/bash
base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../bootstrap.sh                                        
service=$base/../service                                                                                                 
web=$base/../web 

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php-start && $service/varnish-start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# no-cache
tty_printf -f green "Test Case: remove other cookies\n"
tty_print_line -f green

tty_printf "Include cookies to access index.php: cookies other than 'cookie1' and 'cookie3' are removed.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /index.php "Cookie: cookie0=value0; cookie1=value1; cookie2=value2; cookie3=value3; cookie4=value4  ;" 

$service/php-stop && $service/varnish-stop
