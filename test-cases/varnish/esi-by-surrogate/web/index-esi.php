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
 * This script generates an esi block and a Surrogate-Control response header 
 * field when the Surrogate-Capability request header field is present
 * (i.e., the cache claims to support esi) and its value matches abc=ESI/1.0 or
 * a replacement message, otherwise.
 *
 * The main body will be cached for 100 seconds, while the esi block will be 
 * cached for less number of seconds.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */
$now = gmdate('D, d M Y H:i:s \G\M\T');

header('Cache-Control: max-age=100');

$esi = isset($_SERVER['HTTP_SURROGATE_CAPABILITY']) && 1 === preg_match('#^[^=]+=ESI/[0-9]+(\.[0-9]*)?#', $_SERVER['HTTP_SURROGATE_CAPABILITY']);

if (true === $esi) {

    // Setting custom Surrogate-Control header to indicate that current page requires 
    // ESI support.
    header('Surrogate-Control: content=ESI/1.0');
}

printf('<h1>System Time: %s</h1>', $now);

if (true === $esi) {

    printf('<esi:include src="/esi/index.php" />');

} else {

    printf('<h1>You see this message because ESI has been disabled</h1>');
}
