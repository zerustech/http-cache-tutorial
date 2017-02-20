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
 * This vcl removes Set-Cookie header from every response.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
*/
sub vcl_backend_response {

    if (beresp.http.Set-Cookie) {

       unset beresp.http.Set-Cookie;
    }
}
