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
 * This vcl implements a multiple virtual hosts setup.
 * 
 * @author Michael Lee <michael.lee@zerustech.com>
*/
backend server1 {

    .host = "server1.localhost";
    .port = "8000";
}

backend server2 {

    .host = "server2.localhost";
    .port = "8001";
}

sub vcl_recv {

    if (req.http.host ~ "server1.localhost") {

       set req.backend_hint = server1;

    } else if (req.http.host ~ "server2.localhost") {

       set req.backend_hint = server2;
    }
}
