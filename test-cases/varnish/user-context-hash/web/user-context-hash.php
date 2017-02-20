<?php
/**
 *
 * This file is part of the ZerusTech HTTP Cache Tutorial package.
 * 
 * (c) Michael Lee <michael.lee@zerustech.com>
 *
 * For the full copyright and license information, please view the LICENSE file 
 * that was distributed with this source code.
 *
*/

/**
 * This script generates user context hash based on user-group cookie. The 
 * content of this script must not be cached.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */
header('Cache-Control: public, no-cache');

// Updates the Content-Type header.
header('Content-Type: application/vnd.fos.user-context-hash');

// Only generates user context hash if the client claims to accept 
// application/vnd.fos.user-context-hash content type.
if ($_SERVER['HTTP_ACCEPT'] == 'application/vnd.fos.user-context-hash') {

    // Parses user-group from cookie header and uses 'Default' as the default 
    // user-group, if it does not exist.
    $cookies = ';'.$_SERVER['HTTP_COOKIE'];

    preg_replace('/ */', '', $cookies);

    $group = 'Default';

    if (preg_match('/;user-group=([^;]+)/', $cookies, $matches)) {

        $group = $matches[1];
    }

    $hash = $group;

    // Sets user context hash as X-User-Context-Hash header.
    header("X-User-Context-Hash: $hash");
}
