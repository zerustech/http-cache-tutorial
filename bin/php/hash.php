<?php
/**
 * This file is part of the ZerusTech package.
 *
 * (c) Michael Lee <michael.lee@zerustech.com>
 *
 * For the full copyright and license information, please view the LICENSE file 
 * that was distributed with this source code.
*/

/**
 *
 * This scripts generates a key that can be used for varnish http authentication 
 * challenge.
 *
 * According to the varnish document at https://www.varnish-cache.org/docs/trunk/reference/varnish-cli.html#ref-psk-auth,
 * The auth key consists of the sha256 of the random challenge token and the 
 * secrete.
 *
 * Usage: php hash.php <challenge> <secret>
 */
$challenge = $argv[1];

$secret = $argv[2];

echo hash("sha256", "$challenge\n$secret\n$challenge\n")."\n";
