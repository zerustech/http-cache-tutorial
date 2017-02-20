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
 * Since the date command on Mac OS X is not compatible with it on linux, this 
 * script is used to generate an HTTP-date adjusted by the offsets in seconds.
 *
 * Usage: php gmtdate.php [offset]
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */
$offset = isset($argv[1]) ? $argv[1] : 0;
$offset = intval($offset);
echo gmdate('D, d M Y H:i:s \G\M\T', time() + $offset);
