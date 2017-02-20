vcl 4.0;

/**
 * This file is part of the ZerusTech package.
 *
 * (c) Michael Lee <michael.lee@zerustech.com>
 *
 * For the full copyright and license information, please view the LICENSE file
 * that was distributed with this source code.
*/

/**
 * This the default varnish configuration file for all test cases. It is always
 * included by the vcl files of other test cases.
 * 
 * This file supports the following features:
 * - one backend server
 * - banning connects
 * - acl for banning
 * - cache debugging
 * 
 * @author Michael Lee <michael.lee@zerustech.com>
 * 
*/

backend default {
    .host = "localhost";
    .port = "8000";
}


/**
 * Enables ban-lurker friendly object by updating bereq.url into
 * beresp.http.X-Url, which in turn will be updated into obj.http.X-Url subsequently.
 * 
 * When banning objects, make sure to use ban obj.http.X-Url ~ <pattern> to
 * generate lurker-ready bans.
 * 
 * Refer to for https://www.varnish-cache.org/docs/5.0/users-guide/purging.html details.
 *
 * Besides setting obj.http.X-Url, this vcl also implemented a simple solution for
 * supporting the "BAN" custom method, so that it will be also possible to ban
 * objects via http request.
 * 
*/

// The acl that is allowed to ban or purge objects from the cache.
acl purge {
    "localhost";
    "192.168.1.0"/24;
}

sub vcl_backend_response {
    
    // Because it's impossible to set obj.http.* explicitly, we should update
    // the bereq.url into beresp.http.X-Url, which will be copied to
    // obj.http.X-Url later.
    set beresp.http.X-Url = bereq.url;
}

sub vcl_recv {

    if (req.method == "BAN") {

        if (!client.ip ~ purge) {

            return(synth(403, "Not allowed."));
        }

        if (req.url !~ "^/ban-by-tags") {

            set req.http.tmp = "obj.http.host == " + req.http.host + " && obj.http.X-Url ~ " + regsub(req.url, "^/", "");

            ban(req.http.tmp);

            return(synth(200, "Objects banned by the following criteria: " + req.http.tmp));
        }
    }

}

// debugging
sub vcl_deliver {
    
    if (obj.hits > 0) {

        set resp.http.X-Cache = "HIT";

    } else {

        set resp.http.X-Cache = "MISS";
    }
}
