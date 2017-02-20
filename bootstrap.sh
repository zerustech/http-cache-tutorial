#!/bin/bash
#
# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.
#
# This script is the bootstrap of this package. It defines global path prefixes
# as well as other variant commonly used variables.

app_base=`dirname $BASH_SOURCE`
app_base=`cd "$app_base" && pwd`
app_bin=$app_base/bin
app_lib=$app_base/lib
app_var=$app_base/var
app_etc=$app_base/etc

php_home=/opt/php/5.6.14.mysql.5.6.27
varnish_home=/opt/varnish/5.0.0

source $app_lib/tty.sh
source $app_lib/http.sh
source $app_lib/php.sh
source $app_lib/varnish.sh
