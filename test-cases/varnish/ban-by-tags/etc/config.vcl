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
 * This vcl implements cache tags by making use of the X-Cache-Tags header, so
 * that cached objects can be banned by tags.
 * Multiple tags are delimited by commas.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
*/
sub vcl_recv {

    if (req.method == "BAN") {

        if (req.url ~ "^/ban-by-tags") {

            ban("obj.http.host == " + req.http.host + " && obj.http.X-Cache-Tags ~ " + req.http.X-Cache-Tags);

            return(synth(200, "Objects banned for the following tags: " + req.http.X-Cache-Tags));
        }
    }
}
