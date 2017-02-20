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
 * The esi block will be cached for 5 seconds.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */
header('Cache-Control: public, s-maxage=5');

echo '<h1>ESI response at: ' . gmdate('D, d M Y H:i:s \G\M\T').'</h1>';
