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
 * Default server side test script.
 *  
 * @author Michael Lee <michael.lee@zerustech.com>
 */
$now = gmdate('D, d M Y H:i:s \G\M\T');

$category = isset($_SERVER['HTTP_X_ACCEPT_CONTENT_CATEGORY']) ? $_SERVER['HTTP_X_ACCEPT_CONTENT_CATEGORY'] : 'default';

header('Cache-Control: max-age=5');

header('X-Cache-Tags: "abc","def","ghi"');

header('Vary: Accept-Encoding, X-Accept-Content-Category');

printf('<h1>Regular response from %s:%s</h1>', $_SERVER['HTTP_HOST'], $_SERVER['SERVER_PORT']);

printf('<h1>Cookie: %s</h1>', (isset($_SERVER['HTTP_COOKIE']) ? $_SERVER['HTTP_COOKIE'] : ''));

printf('<h1>System Time: %s</h1>', $now);
