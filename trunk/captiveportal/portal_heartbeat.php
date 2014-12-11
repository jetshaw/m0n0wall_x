#!/usr/local/bin/php
<?php
require_once("web_portal.inc");

header("Expires: 0");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

$client_ip = $_ENV['REMOTE_ADDR'];

session_heartbeat_check($client_ip);
exit("ok");

?>
