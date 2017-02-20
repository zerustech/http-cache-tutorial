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
 * The If-Match header field makes the request method conditional on the 
 * recipient origin server either having at least one current representation of 
 * the target resource, when the field-value is '*', or having a current 
 * representation of the target resource that has an entity-tag matching a 
 * member of the list of entity-tags provided in the field-value.
 *
 * If-Match is most often used with state-changing methods (POST in this 
 * tutorial) to prevent accidental overwrites when multiple user agents might be 
 * acting in parallel on the same resource (i.e., to prevent the "lost update" 
 * problem).
 *
 * This script demonstrates the use of If-Match conditional for updating the
 * contents of a text file: asset.txt. Aside from asset.txt, the other two
 * metadata files, version.txt containing current version of asset.txt and
 * session.txt containing the session id of the last user agent that has changed
 * the contents, are also used.
 *
 * We simply use the version number as the Etag value, because the algorithm for 
 * generating Etag values is trivial to the this tutorial, it is better to keep
 * it as simple as possible as long as the Etag value is a strong validator.
 *
 * Note: To simplify the logic, the request always overwrites asset.txt.
 *
 * A user agent should include an If-Match header field in its request. The
 * value of the If-Match header field should be either an entity tag that
 * indicates the version of asset.txt where the changes are to be applied or an
 * '*' that indicates the changes will be applied if at least one version of 
 * asset.txt exists.
 *
 * This script handles the request as follows:
 *
 * - If the If-Match header field is not present or is lack of a value, fail
 * with a 412 response.
 *
 * - If no version of asset.txt exists, fail with a 404 response.
 *
 * - If the request changes have already been applied, generate a 200 (OK) 
 * response, and if current session id matches the session id stored in 
 * session.txt, include an Etag header in the response.
 *
 * - If the If-Match field value does not match current version number of 
 * asset.txt, fail with a 412 (Precondition Failed) response. 
 *
 * - Apply the changes to asset.txt, update session.txt, increase the version
 * number, and generate a 200 (OK) response.
 *
 * NOTE: The If-Match headder field is not applicable to a stored response,
 * because the comparison of Etag values must be done between the provided value
 * in the request and the current value on the origin server. As a result, cache
 * should forward If-Match requests to the origin server.
 *
 * @author Michael Lee <michael.lee@zerustech.com>
 */
session_start();

$condition = isset($_SERVER['HTTP_IF_MATCH']) ? explode(',', $_SERVER['HTTP_IF_MATCH']) : ['""'];

array_walk($condition, function(&$item, $key){ $item = trim(trim($item), '"');});

$conditionString = implode(',', $condition);

$now = date('Y-m-d H:i:s', time());

// If-Match is not present.
if ([''] === $condition) {

    http_response_code(412);

    printf("<h1>If-Match is not present!</h1>");

    printf("<h1>Current Time: %s</h1>", $now);

    return;
}

$body = $_POST['body'];

$assetFile = __DIR__.'/asset.txt';

$versionFile = __DIR__.'/version.txt';

$sessionFile = __DIR__.'/session.txt';

// No version of asset.txt found.
if (!file_exists($assetFile)) {

    http_response_code(404);

    printf("<h1>Asset.txt does not exist!</h1>");

    printf("<h1>Current Time: %s</h1>", $now);

    return;
}

$version = @file_get_contents($versionFile);

$version = $version === '' || $version === false ? 0 : $version;

$asset = file_get_contents($assetFile);

$session = @file_get_contents($sessionFile);

// Precondition evaluates to true
if ( $condition === ['*'] || in_array($version, $condition, true)) {

    $oldVersion = $version;

    $version++;

    file_put_contents($versionFile, $version);

    file_put_contents($sessionFile, session_id());

    file_put_contents($assetFile, $body);

    header(sprintf('Etag: "%s"', $version));

    printf("<h1>The original entity tag (%s) matches at least one of the provided values (%s)</h1>", $oldVersion, $conditionString);

    printf("<h1>Contents of asset.txt have been changed to %s</h1>", $body);

    printf("<h1>Current entity tag has been changed to %s</h1>", $version);

    printf("<h1>Current Time: %s</h1>", $now);

    http_response_code(200);

    return;
}

// The requested changes have already been applied.
if ($body === $asset) {

    if ($session === session_id()) {

        header(sprintf('Etag: "%s"', $version));
    }

    printf("<h1>The original entity tag (%s) does not match any of the provided values (%s)</h1>", $version, $conditionString);

    printf("<h1>But the contents of asset.txt have already been changed to %s</h1>", $body);

    printf("<h1>Current entity tag remains as %s</h1>", $version);

    printf("<h1>Current Time: %s</h1>", $now);

    http_response_code(200);

    return;
}

printf("<h1>Current entity tag (%s) does not match any of the provided values (%s)</h1>", $version, $conditionString);

printf("<h1>Current entity tag remains as %s</h1>", $version);

printf("<h1>Current Time: %s</h1>", $now);

http_response_code(412);

return;
