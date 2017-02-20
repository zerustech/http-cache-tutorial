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
 * This script does not generate Surrogate-Control response header field, 
 * therefore the varnish cache will replace the esi block with the content 
 * enclosed by the <esi:remove> tags.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */

$now = gmdate('D, d M Y H:i:s \G\M\T');

header('Cache-Control: max-age=100');

printf('<h1>System Time: %s</h1>', $now);

printf('<esi:include src="/esi/index.php" />');

printf('<esi:remove><h1>You see this message because ESI has been disabled</h1></esi:remove>');
