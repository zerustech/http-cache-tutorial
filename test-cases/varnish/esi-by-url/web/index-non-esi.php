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
 * This script renders esi block and its fallback message. The esi block will
 * not be processed by varnish, the fallback message will be displayed instead.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */
header('Cache-Control: max-age=100');

$now = gmdate('D, d M Y H:i:s \G\M\T');

printf('<h1>System Time: %s</h1>', $now);

echo '<esi:include src="/esi/index.php" />';

echo '<esi:remove><h1>You see this message because ESI has been disabled</h1></esi:remove>';
