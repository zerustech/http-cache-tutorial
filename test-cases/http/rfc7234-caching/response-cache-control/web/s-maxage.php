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
 * Test the 's-maxage' directive.
 *  
 * @author Michael Lee <michael.lee@zerustech.com>
 */

$now = gmdate('D, d M Y H:i:s \G\M\T');

header('Cache-Control: max-age=5, s-maxage=3');

header(sprintf('Last-Modified: %s', $now));

printf('<h1>System Time: %s</h1>', $now);
