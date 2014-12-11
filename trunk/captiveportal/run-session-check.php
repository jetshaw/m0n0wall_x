#!/usr/local/bin/php -f
<?php
set_include_path(get_include_path() . ":" . "/etc/inc");
require_once("globals.inc");
require_once("config.inc");
require_once("web_portal.inc");

$scan_file = '/var/run/session_check.log';
$fd = @fopen($scan_file, 'w');
if (!$fd) {
	exit("open $scan_file failed");
}

while (1) {
	$aged_num = 0;
	if (($aged_num =  sessions_timing_check()) == -1) {
		fwrite($fd, time() . ":session check failed\n");
	}
	$val = 10;
	if (isset($config['webportal']['session_check_interval'])) {
		$val = intval($config['webportal']['session_check_interval']);
	} else {
	}
	fwrite($fd, time() . ": $aged_num clients aged. and wait $val seconds\n");
	sleep($val);
}

fclose($fd);

?>
