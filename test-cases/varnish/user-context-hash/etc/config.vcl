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
 * This vcl implements the user context hash feature which keeps separate cache
 * for different user context hash, event if the user cookie exists.
 * Refer to http://foshttpcache.readthedocs.io/en/stable/varnish-configuration.html#varnish-user-contextfor details.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
*/
sub vcl_recv {

    // Prevents tampering attacks on the hash mechanism
    if (req.restarts == 0 && (req.http.Accept ~ "application/vnd.fos.user-context-hash" || req.http.X-User-Context-Hash)) {

        return(synth(400));
    }

    // Only tries to generate the user context hash when current request is
    // fresh (not restarted) and cookie exists (from user who has signed in)
    if (req.restarts == 0 && req.http.Cookie) {

       // Sets the Accept header to application/vnd.fos.user-context-hash so
       // that the user hash script will answer it with a hash
       set req.http.Accept = "application/vnd.fos.user-context-hash";

       // Backs up the original url
       set req.http.X-Fos-Original-Url = req.url;

       // Updates url to the user context hash script.
       set req.url = "/user-context-hash.php";

       // Passes the request to the backend server, because this script must not
       // be cached.
       return(pass);
    }

    // If current request is a restarted one and it previously asked for a user
    // context hash, restores its original url and performs a lookup.
    // 
    // NOTE: It's very important to peform a "lookup" here, otherwise, varnish
    // won't cache anything, not to mention user context hash dependent caches.
    // 
    // When performs a "lookup", if a "miss" happends, varnish will retrieve
    // response from the backend server and keep a cache for the user context
    // hash in the response.
    if (req.restarts > 0 && req.http.Accept == "application/vnd.fos.user-context-hash") {

        set req.url = req.http.X-Fos-Original-Url;

        unset req.http.X-Fos-Original-Url;

        unset req.http.Accept;

        return(hash);
    }
}

sub vcl_deliver {

    // Only tries to retrive the user context hash from the backend response,
    // when current request is fresh and the response's content-type is
    // application/vnd.fos.user-context-hash, which matches the content-type
    // claimed by the original request.
    if (req.restarts == 0 && resp.http.Content-Type ~ "application/vnd.fos.user-context-hash") {

        // Copies the user context hash from the backend response into current
        // request object.
        set req.http.X-User-Context-Hash = resp.http.X-User-Context-Hash;

        // Now, the user context hash has been generated and it's ok to restart
        // current request to access the original url.
        return(restart);
    }

    // The process arrives here because current request has been restarted or
    // the backend response is not an answer to the user context hash.
    // 
    // In either case, the user context hash should be removed from the vary
    // header.
    set resp.http.Vary = regsub(resp.http.Vary, "(?i),? *X-User-Context-Hash *", "");
    set resp.http.Vary = regsub(resp.http.Vary, "^, *", "");
    if (resp.http.Vary == "") {

        unset resp.http.Vary;
    }

    // The user context hash header should be removed as well, of course,
    // because it's only used between varnish and the backend server.
    unset resp.http.X-User-Context-Hash;
}
