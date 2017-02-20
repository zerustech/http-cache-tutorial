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
 * The If-Unmodified-Since header field makes the request conditional on the 
 * selected representation's last modification date being earlier than or equal 
 * to the date provided in the field-value.
 *
 * If-Unmodified-Since is most often used with state-changing methods (POST in this 
 * tutorial) to prevent accidental overwrites when multiple user agents might be 
 * acting in parallel on the same resource (i.e., to prevent the "lost update" 
 * problem) that does not support entity tags.
 *
 * This script demonstrates the use of If-Unmodified-Since conditional for
 * updating the contents of a text file: asset.txt. Aside from asset.txt, another
 * metadata file, session.txt containing the session id of the last user agent
 * that has changed the contents, is also used.
 *
 * Note: To simplify the logic, the request always overwrites asset.txt.
 *
 * A user agent should include an If-Unmodified-Since header field with an 
 * HTTP-date as the field-value in the request. The user agent is expecting the 
 * last modification date of asset.txt is earlier than or equal to the 
 * provided date.
 *
 * This script handles the request as follows:
 *
 * - If the If-Unmodified-Since header field is not present or is lack of a
 * value, fail with a 412 response.
 *
 * - If asset.txt does not exists, fail with a 404 response.
 *
 * - If the request changes have already been applied, generate a 200 (OK) 
 * response, and if current session id matches the session id stored in 
 * session.txt, include the Last-Modified header field in the response.
 *
 * - If the If-Unmodified field value is earlier than the last modification date 
 * of asset.txt, fail with a 412 (Precondition Failed) response. 
 *
 * - Apply the changes to asset.txt, generate a 200 (OK) response, and include 
 * the Last-Modified header field in the response.
 *
 * NOTE: The If-Unmodified-Since headder field is not applicable to a stored
 * response, because the evaluation must be done between the provided date
 * in the request and the last modification date on the origin server. As a 
 * result, cache should forward If-Unmodified-Since requests to the origin 
 * server.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */
session_start();

$condition = isset($_SERVER['HTTP_IF_UNMODIFIED_SINCE']) ? $_SERVER['HTTP_IF_UNMODIFIED_SINCE'] : '';

$time = time();

$now = gmdate('D, d M Y H:i:s \G\M\T', $time);

// If-Unmodified-Since is not present.
if ('' === $condition) {

    http_response_code(412);

    printf("<h1>The If-Unmodified-Since header is not present!</h1>");

    printf("<h1>System Time: %s</h1>", $now);

    return;
}

$body = $_POST['body'];

$assetFile = __DIR__.'/asset.txt';

$sessionFile = __DIR__.'/session.txt';

// Asset.txt does not exist.
if (!file_exists($assetFile)) {

    http_response_code(404);

    printf("<h1>Asset.txt does not exist!</h1>");

    printf("<h1>System Time: %s</h1>", $now);

    return;
}

$modified = filemtime($assetFile);

$modifiedGMTDate = gmdate('D, d M Y H:i:s \G\M\T', $modified);

$condition = strtotime($condition);

$condition = $condition > $time ? $modified : $condition;

$conditionGMTDate = gmdate('D, d M Y H:i:s \G\M\T', $condition);

$asset = file_get_contents($assetFile);

$session = @file_get_contents($sessionFile);

// Precondition evaluates to true
if ( $modified <= $condition ) {

    file_put_contents($assetFile, $body);

    file_put_contents($sessionFile, session_id());

    header(sprintf("Last-Modified: %s", $modifiedGMTDate));

    printf("<h1>The contents of asset.txt have not been changed since %s</h1>", $conditionGMTDate);

    printf("<h1>The contents of asset.txt have been changed to %s</h1>", $body);

    printf("<h1>The last modification date of asset.txt is %s</h1>", $modifiedGMTDate);

    printf("<h1>System Time: %s</h1>", $now);

    http_response_code(200);

    return;

}

// The requested changes have already been applied.
if ($body === $asset) {

    if ($session === session_id()) {

        header(sprintf("Last-Modified: %s", $modifiedGMTDate));
    }

    printf("<h1>The contents of asset.txt have been changed since %s, so the condition evaluates to false.</h1>", $conditionGMTDate);

    printf("<h1>But the requested changes have already been applied to asset.txt.</h1>");

    printf("<h1>The contents of asset.txt: %s</h1>", $body);

    printf("<h1>The last modification date of asset.txt is %s</h1>", $modifiedGMTDate);

    printf("<h1>System Time: %s</h1>", $now);

    http_response_code(200);

    return;
}

http_response_code(412);

printf("<h1>The contents of asset.txt have been changed since %s, so the condition evaluates to false.</h1>", $conditionGMTDate);

printf("<h1>The last modification date of asset.txt is %s</h1>", $modifiedGMTDate);

printf("<h1>System Time: %s</h1>", $now);

return;
