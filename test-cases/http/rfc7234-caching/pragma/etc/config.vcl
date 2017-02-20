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
 * This vcl adds support for request Cache-Control directives. By default,
 * Varnish ignores all Cache-Control directives.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
*/
sub vcl_recv {

    // The no-cache, no-store, private, max-age, and pragma directives.
    if (req.http.Cache-Control ~ "(no-cache|no-store|private|max-age=0)" || req.http.Pragma == "no-cache") {

        return(pass);
    }
}
