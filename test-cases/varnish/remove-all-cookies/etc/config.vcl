vcl 4.0;

/**
 * This file is part of the ZerusTech package.
 *
 * (c) Michael Lee <michael.lee@zerustech.com>
 *
 * For the full copyright and license information, please view the LICENSE file
 * that was distributed with this source code.
*/

include "../../../default/etc/config.vcl";

/**
 * This vcl removes all cookies from every request, except for the requests to
 * the admin area.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
*/
sub vcl_recv {

    if (req.url !~ "^/admin/") {

        unset req.http.Cookie;
    }
}
