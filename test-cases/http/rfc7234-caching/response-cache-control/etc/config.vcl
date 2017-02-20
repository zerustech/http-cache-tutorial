vcl 4.0;

/**
 * This file is part of the ZerusTech package.
 *
 * (c) Michael Lee <michael.lee@zerustech.com>
 *
 * For the full copyright and license information, please view the LICENSE file
 * that was distributed with this source code.
*/

import std;
include "../../../../default/etc/config.vcl";

/**
 * This vcl file adds support for those response Cache-Control directives not
 * supported by varnish by default.
 * 
 * @author Michael Lee <michael.lee@zerustech.com>
*/
sub vcl_hit {

    // By default, it obj.ttl + obj.grace > 0, varnish will serve stale
    // contents. The value of default_grace is 10 seconds.
    // The following code disables grace mode for responses that contain the 
    // "must-revalidate" Cache-Control directive.
    if (obj.ttl < 0s && obj.http.Cache-Control ~ "must-revalidate") {

        return(pass);

    }
}

sub vcl_backend_response {

    // Support for no-transform directive.
    if (beresp.http.Cache-Control !~ "no-transform") {

        set beresp.do_gzip = true;

    } else {

        set beresp.do_gzip = false;

    }

    // Because it's impossible to set obj.http.* explicitly, we should update
    // the bereq.url into beresp.http.X-Url, which will be copied to
    // obj.http.X-Url later.
    set beresp.http.X-Url = bereq.url;
}
