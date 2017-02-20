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
 * The cookies set by this page will be removed by varnish, therefore, this page 
 * will be cached for 5 seconds.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */
$now = gmdate('D, d M Y H:i:s \G\M\T');

header('Cache-Control: max-age=5');

header('Set-Cookie: cookie001=value001');

printf('<h1>System Time: %s</h1>', $now);
