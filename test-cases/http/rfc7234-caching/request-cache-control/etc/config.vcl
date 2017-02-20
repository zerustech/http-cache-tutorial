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

sub vcl_hit {

    // The max-age directive
    if (req.http.Cache-Control ~ "max-age=[0-9]+") {

        set req.http.tmp = req.http.Cache-Control; 

        set req.http.tmp = "," + req.http.Cache-Control + ",";

        set req.http.tmp = regsuball(req.http.tmp, "^.*,max-age=([0-9]+),.*$", "\1");

        if (obj.age > std.duration(req.http.tmp + "s", 0s)) {

            return(pass);
        }

        unset req.http.tmp;

    }

    // The max-stale directive
    if (obj.ttl < 0s && req.http.Cache-Control ~ "max-stale=[0-9]+") {

        set req.http.tmp = req.http.Cache-Control; 

        set req.http.tmp = "," + req.http.Cache-Control + ",";

        set req.http.tmp = regsuball(req.http.tmp, "^.*,max-stale=([0-9]+),.*$", "\1");

        // Fail with a 503 response when the stored response has exceeded its
        // freshness lifetime by more than the number of seconds specified by
        // the max-stale directive.
        if (obj.ttl + std.duration(req.http.tmp + "s", 0s) < 0s) {

            // return(synth(503, "The selected response has exceeded its freshness lifetime by more than " + req.http.tmp + " seconds"));
            return(pass);
        }

        unset req.http.tmp;

    }

    // The min-fresh Cache-Control directive
    if (req.http.Cache-Control ~ "min-fresh=[0-9]+") {

        set req.http.tmp = req.http.Cache-Control;

        set req.http.tmp = "," + req.http.Cache-Control + ",";

        set req.http.tmp = regsuball(req.http.tmp, "^.*,min-fresh=([0-9]+),.*$", "\1");

        // For demonstration purpose, fail with a 503 response when the TTL
        // (freshness lifetime minus current age) of the selected resopnse is
        // less than the number of seconds specified by the min-fresh directive.
        // In production environment, pass the request to the origin server,
        // instead of fail with a 503 error.
        if (obj.ttl < std.duration(req.http.tmp + "s", 0s)) {

            // return(synth(503, "The TTL of the selected response is less than " + req.http.tmp + " seconds")); 
            return(pass);
        }

        unset req.http.tmp;
    }

}

sub vcl_miss {

    // The if-only-cached directive
    if (req.http.Cache-Control ~ "only-if-cached") {

        return(synth(503, "No stored response is found!"));

    }
}

sub vcl_backend_response {

    // The no-transform directive
    if (bereq.http.Cache-Control !~ "no-transform") {

        set beresp.do_gzip = true;

    } else {

        set beresp.do_gzip = false;
    }

    // Because it's impossible to set obj.http.* explicitly, we should update
    // the bereq.url into beresp.http.X-Url, which will be copied to
    // obj.http.X-Url later.
    set beresp.http.X-Url = bereq.url;
}
