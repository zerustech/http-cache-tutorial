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
header('Cache-Control: max-age=5');

echo '<h1>ESI response at: '.date('Y-m-d H:i:s').'</h1>';
