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
 * This vcl decides whether or not to enable ESI support by checking the
 * following custom headers:
 *     request: Surrogate-Capability
 *     response: Surrogate-Control
 *
 * @author Michael Lee <michael.lee@zerustech.com>
*/
sub vcl_recv {
  
    // Add a Surrogate-Capability header to announce ESI support.
    set req.http.Surrogate-Capability = "abc=ESI/1.0";  
}

sub vcl_backend_response {

    // The backend server responses with a Surrogate-Control header to indicate
    // that it has ESI blocks to be processed.
    if (beresp.http.Surrogate-Control ~ "ESI/1.0") {

        // We should unset the beresp.http.Surrogate-Control header, otherwise,
        // it will override the beresp.http.Cache-Control header.
        // Refer to https://www.w3.org/TR/edge-arch/ for details.
        unset beresp.http.Surrogate-Control;

        set beresp.do_esi = true;
    }
}
