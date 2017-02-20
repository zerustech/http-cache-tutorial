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
 * Test the 'private' directive.
 *  
 * @author Michael Lee <michael.lee@zerustech.com>
 */
$now = gmdate('D, d M Y H:i:s \G\M\T');

header('Cache-Control: private');

header(sprintf('Last-Modified: %s', $now));

printf('<h1>System Time: %s</h1>', $now);
