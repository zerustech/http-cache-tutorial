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
 * This vcl enables gzip compression if the client announces to accept gzip
 * content encoding.
 * 
 * @author Michael Lee <michael.lee@zerustech.com>
*/
sub vcl_backend_response {

    if (beresp.http.content-type ~ "text/html") {

        set beresp.do_gzip = true;
    }
}
