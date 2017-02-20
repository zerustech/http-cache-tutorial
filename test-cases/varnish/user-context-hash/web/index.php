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
 * This script generates different responses for different user-group and 
 * varnish keeps separate cache for each of them.
 *
 * The following headers are removed from the response:
 *     Vary: X-User-Context-Hash
 *     X-User-Context-Hash: xxxxxx 
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */

// In order to test the fact that Varnish will keep separate cache for different 
// X-User-Context-Hash, we allow this page to be cached for 5 seconds.
header('Cache-Control: max-age=5');

// Also adds the Vary header so that Varnish keeps separate cache for 
// X-User-Context-Hash.
//
// NOTE: this header is only used by Varnish, which means, varnish knows to
// separate cache based on X-User-Context-Hash, but it will unset the 
// Vary header after receiving the response, thus the other outbound cache or 
// proxy servers won't separate caches based on this header.
//
// And in fact, in this case, other cache or proxy servers won't cache anything
// due to the existence of cookie.
header('Vary: X-User-Context-Hash');

$now = gmdate('D, d M Y H:i:s \G\M\T');

$hash = isset($_SERVER['HTTP_X_USER_CONTEXT_HASH']) ? $_SERVER['HTTP_X_USER_CONTEXT_HASH'] : 'None';

printf('<h1>User Context Hash: %s</h1>', $hash);

printf('<h1>System Time: %s</h1>', $now);
