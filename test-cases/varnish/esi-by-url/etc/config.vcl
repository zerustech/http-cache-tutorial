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
 * This script enables ESI support only for some specific URLs.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
*/
sub vcl_backend_response {
   
    // Enables ESI only for /index-esi.php.
    if (bereq.url == "/index-esi.php") {

        set beresp.do_esi = true;
    }
}
