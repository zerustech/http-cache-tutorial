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
 * This script does not include any header fields for resolving a freshness 
 * lifetime. Varnish will generate a heuristic freshness lifetime.
 *  
 * @author Michael Lee <michael.lee@zerustech.com>
 */
$now = gmdate('D, d M Y H:i:s \G\M\T');

header(sprintf('Last-Modified: %s', $now));

printf('<h1>System Time: %s</h1>', $now);
