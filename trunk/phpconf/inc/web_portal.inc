<?php
require_once("functions.inc");

// later, the sessions should be stored in multiple files for reducing effect of lock.
$lockfile = "{$g['varrun_path']}/cwebportal.lock";
$sessionfile = "{$g['vardb_path']}/cwebportal_session.db";

function webportal_lock() {
	global $lockfile;
	$starttime = time();
	do {
		/* open the lock file in append mode to avoid race condition */
		if ($fd = @fopen($lockfile, "x")) {
			/* succeeded */
			fclose($fd);
			return true; // return on time.
		} else {
			/* file locked, wait and try again */
			usleep(rand(200000,500000));

			$waittime = time() - $starttime;

			if ($waittime > 0 && ($waittime % 60) == 0) {
			}
				//captiveportal_syslog("LOCKWARNING: waited for lock for " . $waittime/60 ." minute(s)");
		}
	} while ($waittime < 24);

	return false; // return on timeout.
}

/* unlock captive portal information file */
function webportal_unlock() {
	global $lockfile;
	if (file_exists($lockfile))
		unlink($lockfile);
}

function session_read() {
	global $sessionfile;
	$sessions = array();

	$fd = @fopen($sessionfile, "r");
	if ($fd) {
		while (!feof($fd)) {
			$line = trim(fgets($fd));
			if ($line) {
				$sessions[] = explode(",", $line);
			}
		}

		fclose($fd);
	}

	return $sessions;
}

function session_save($sessions) {
	global $sessionfile;
	$fd = @fopen($sessionfile, "w");
	if ($fd) {
		foreach($sessions as $session) {
			fwrite($fd, join(",", $session) . "\n");
		}

		fclose($fd);
	}
}

/*
 * control on the internet visit by user.
 */

function webportal_connect($rule_no, $client_ip, $client_mac = NULL) {
	$cmd = "/sbin/ipfw add $rule_no set 2 skipto 50000 ip from $client_ip to any in";
	exec($cmd);
	//echo $cmd;
	$cmd = "/sbin/ipfw add $rule_no set 2 skipto 50000 ip from any to $client_ip out";
	exec($cmd);
	//echo $cmd;
}

function webportal_disconnect($rule_no, $client_ip = "", $client_mac = "") {
	$cmd = "/sbin/ipfw delete " . $rule_no . " " . ($rule_no + 10000);
	//echo $cmd;
	mwexec($cmd);
}

function webportal_disallow($client_ip, $user_name = "", $user_passwd = "", $client_mac = "") {
	if (true !=  webportal_lock()) {
		// can not lock it.
		return false;
	}

	$sessions = session_read();
	$now_time = time();

	$rule_no = "";
	for ($i = 0; $i < count($sessions); $i++) {
		if ($sessions[$i][2] == $client_ip) {
			// allow the ip pass through.
			webportal_disconnect($sessions[$i][1], $client_ip);
			unset($sessions[$i]);
			$i--;
		}
	}

	session_save($sessions);
	webportal_unlock();

	return true;
}

function webportal_allow($client_ip, $user_name = "", $user_passwd = "", $client_mac = NULL) {
	if (true !=  webportal_lock()) {
		// can not lock it.
		return false;
	}

	$sessions = session_read();
	$now_time = time();

	$rule_no = captiveportal_get_next_ipfw_ruleno();
	if ($rule_no == NULL) {
		webportal_unlock();
		return false;
	}
	// allow the ip pass through.
	webportal_connect($rule_no, $client_ip);

	// allowed timestamp, rule number, user ip, user name, user password, activity timestamp
	$sessions[] = array($now_time, $rule_no, $client_ip, $user_name, $user_passwd, $now_time);

	session_save($sessions);
	webportal_unlock();

	return true;
}


function session_heartbeat_check($client_ip) {
	if (true != webportal_lock()) {
		return -1;
	}

	$session_found = 0;

	$sessions = session_read();
	for ($i=0; $i < count($sessions); $i++) {
		if ($sessions[$i][2] == $client_ip) {
			$sessions[$i][5] = time(); // update the activity of the client on the service page.
			$session_found = 1;
			break;
		}
	}

	if ($session_found == 0) {
		// TODO.
	} else {
		session_save($sessions);
	}

	webportal_unlock();

	return $session_found;
}

/*
 * pay attention that: if the sessions is large, it should be splitted as multiple
 * parts for reducing latency of lock.
 */
function sessions_timing_check() {
	if (true != webportal_lock()) {
		return -1;
	}

	// the session_timeout should be set.
	$session_timeout = 120;
	if (isset($config['webportal']['session_timeout'])) {
		$session_timeout = intval($config['webportal']['session_timeout']);
	}

	$aged_num = 0;

	$now_time = time();
	$sessions = session_read();
	for ($i = 0; $i < count($sessions); $i++) {
		$interval_sec = $now_time - $sessions[$i][5];
		if ($interval_sec >= $session_timeout) {
			webportal_disconnect($sessions[$i][1]);
			unset($sessions[$i]);
			$i--;
			$aged_num++;
		}
	}

	session_save($sessions);

	webportal_unlock();

	return $aged_num;
}

?>
