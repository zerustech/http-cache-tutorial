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
 * Start server with: php -S localhost:8000 and tries to access the following 
 * URLs: 
 *     http://localhost/index.php
 *
 * And confirms the fact that X-Random-Token header is generated and passed to
 * this script.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */
header('Cache-Control: max-age=0');

$token = isset($_SERVER['HTTP_X_RANDOM_TOKEN']) ? $_SERVER['HTTP_X_RANDOM_TOKEN'] : 'None';

$now = gmdate('D, d M Y H:i:s \G\M\T');

printf('<h1>Random Token: %s</h1>', $token);

printf('<h1>System Time: %s</h1>', $now);
