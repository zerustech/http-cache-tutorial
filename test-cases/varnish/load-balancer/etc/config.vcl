vcl 4.0;

/**
 * This file is part of the ZerusTech package.
 *
 * (c) Michael Lee <michael.lee@zerustech.com>
 *
 * For the full copyright and license information, please view the LICENSE file
 * that was distributed with this source code.
*/

import directors;

include "../../../default/etc/config.vcl";

/**
 * This vcl implements a load-balancing setup with two backends.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
*/

backend server1 {

    .host = "localhost";
    .port = "8000";
    .probe = {
        .url = "/health.php";
        .timeout = 1s;
        .interval = 5s;
        .window = 5;
        .threshold = 3;
    }
}

backend server2 {

    .host = "localhost";
    .port = "8001";
    .probe = {
        .url = "/health.php";
        .timeout = 1s;
        .interval = 5s;
        .window = 5;
        .threshold = 3;
    }
}

sub vcl_init {

    new loadBalancer = directors.round_robin();
    loadBalancer.add_backend(server1);
    loadBalancer.add_backend(server2);
}

sub vcl_recv {

    set req.backend_hint = loadBalancer.backend();
}
