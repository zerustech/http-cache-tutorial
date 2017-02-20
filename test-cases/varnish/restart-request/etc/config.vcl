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
 * This vcl demonstrates the best practice for making use of restarted requests:
 *
 *     1. User visits page A;
 *
 *     2. Varnish changes the request's URL to /token.php, backups the
 *     original URL in a http header and forwards it to the backend server.
 * 
 *     3. When varnish receives the token, as a http header, from /token.php, it
 *     restarts the request.
 *
 *     4. When varnish receives the restarted request, it restores the original
 *     URL and forwards the request to the backend server. Now the token is
 *     passed to the server as a http header.
 * 
 * This process is useful for some scenarios such as the user-context-hash and
 * etc.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 * 
*/
sub vcl_recv {

    // Current request is a fresh request.
    // It has not been restarted.
    if (req.restarts == 0) {

        // Backups the original url
        set req.http.X-Original-Url = req.url;

        // Modify the request url.
        set req.url = "/token.php";

        // Passes the request to the backend server, because we MUST NOT to
        // cache the token.
        return(pass);
    }

    // Current request is a restarted request.
    if (req.restarts > 0) {

        // Restores the original url.
        set req.url = req.http.X-Original-Url;

        unset req.http.X-Original-Url;

        // And now the request contains the token
    }
}

sub vcl_deliver {

    // Current request is fresh, which has not been restarted.
    // And in this setup, if this method is called by a fresh request,
    // the url must be "/token.php", so we should copy the random token from
    // the response's http header.
    if (req.restarts == 0) {

        // Copies token from the response's http header.
        set req.http.X-Random-Token = resp.http.X-Random-Token; 

        // Restarts current request, which will access the original url.
        return(restart);
    }
}
