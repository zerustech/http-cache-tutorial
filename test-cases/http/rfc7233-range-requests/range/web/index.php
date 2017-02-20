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
 * Contents will be cached for 5 seconds and the 'Accept-Ranges' response header 
 * advertises that the server supports range request.
 *
 * NOTE: this script does not directly support the range request, but Varnish has 
 * builtin support for range request.
 *  
 * @author Michael Lee <michael.lee@zerustech.com>
 */
$assetFile = __DIR__.'/asset.txt';

$asset = file_get_contents($assetFile);

$entityTag = md5(file_get_contents($assetFile));

$modified = filemtime($assetFile);

header(sprintf("Cache-Control: max-age=5, must-revalidate"));

header(sprintf("Etag: %s", $entityTag));

header(sprintf("Last-Modified: %s", gmdate('D, d M Y H:i:s \G\M\T', $modified)));

header(sprintf("Content-Length: %s", strlen($asset)));

header(sprintf("Accept-Ranges: bytes"));

printf("%s", $asset);
