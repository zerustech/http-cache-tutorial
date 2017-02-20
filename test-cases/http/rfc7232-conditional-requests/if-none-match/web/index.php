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
 * Contents of this page will be cached for 5 seconds.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */

$time = time();

$now = gmdate('D, d M Y H:i:s \G\M\T', $time);

$assetFile = __DIR__.'/asset.txt';

$asset = file_get_contents($assetFile);

$entityTag = md5($asset);

header(sprintf("Cache-Control: max-age=5, must-revalidate"));

header(sprintf('Etag: "%s"', $entityTag));

printf("<h1>Contents of asset.txt: %s</h1>", $asset);

printf("<h1>System Time: %s</h1>", $now);
