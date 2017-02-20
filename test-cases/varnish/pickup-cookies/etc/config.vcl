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
 * This vcl directly picks out cookies needed for every request.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
*/
sub vcl_recv {

    if (req.http.Cookie) {

        // Normalizes cookie header
        set req.http.X-Cookie-Buffer = regsuball(";" + req.http.Cookie, "; +", ";");

        // Resets req.http.Cookie to an empty string
        set req.http.Cookie = "";
        
        // Picks up cookie1
        set req.http.X-Temp = regsuball(req.http.X-Cookie-Buffer, "^.*?;cookie1=([^;]+).*+$", "\1");

        // If cookie1 exists, appends it to req.http.Cookie
        if (req.http.X-Temp != req.http.X-Cookie-Buffer) {

            set req.http.Cookie = req.http.Cookie + "cookie1=" + req.http.X-Temp;
        }

        // Picks up cookie3
        set req.http.X-Temp = regsuball(req.http.X-Cookie-Buffer, "^.*?;cookie3=([^;]+).*+$", "\1");

        // If cookie3 exists, appends it to req.http.Cookie
        if (req.http.X-Temp != req.http.X-Cookie-Buffer) {

            set req.http.Cookie = req.http.Cookie + ";cookie3=" + req.http.X-Temp;
        }

        // Unsets req.http.Cookie if it's empty
        if (req.http.Cookie == "") {

            unset req.http.Cookie;
        }

        unset req.http.X-Cookie-Buffer;
        unset req.http.X-Temp;
    }
}
