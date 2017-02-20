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
 * This script generates a random token and stores it in X-Random-Token header.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */
$now = gmdate('D, d M Y H:i:s \G\M\T');

header('Cache-Control: public, no-cache');

$token = hash('md5', rand());

header('X-Random-Token: '.$token);

printf('<h1>Token: %s</h1>', $token);

printf('<h1>System Time: %s</h1>', $now);
