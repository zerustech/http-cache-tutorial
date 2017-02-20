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
 * This vcl removes all, but the specified, cookies from every request.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
*/
sub vcl_recv {

    if (req.http.Cookie) {

        // Prepends a ";" to the Cookie header so that every cookie has a
        // leading ";".
        set req.http.Cookie = ";" + req.http.Cookie; 

        // Normalizes the cookie header by removing any spaces that come after
        // the ";".
        set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");

        // Tries to match Cookie1 and Cookie3 and mark them up by inserting an
        // extral space between the leading ";" and the cookie name.
        set req.http.Cookie = regsuball(req.http.Cookie, ";(cookie1|cookie3)=", "; \1=");

        // Now, removes other cookies that don't have the extral space.
        set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");

        // Clean up the leading "; " from the cookie string, if at least one
        // cookie has been matched and retained, or any " ;" from the end of the
        // cookie header.
        // For example, we are going to keep cookie 'c1' and 'c2', and remove
        // other cookies from the following cookie header:
        //     
        //     Original cookie header: a=b;c1=d1;  e=f  ;c2=d2  ;
        //     Normalized cookie header: ;a=b;c1=d1;e=f  ;c2=d2  ;
        //     After the mark up: ;a=b; c1=d1;e=f  ; c2=d2  ;
        //     After the replacement: ; c1=d1; c2=d2  ;
        //     After the cleanup: c1=d1; c2=d2
        // 
        set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");

        if (req.http.Cookie == "") {
            
            unset req.http.Cookie;
        }
    }
}
