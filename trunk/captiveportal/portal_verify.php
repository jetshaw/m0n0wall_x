#!/usr/local/bin/php
<?php
require_once("functions.inc");
require_once("json_lib.inc");

header("Expires: 0");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

$client_ip = $_ENV['REMOTE_ADDR'];

if (isset($config['webportal']['ac_url'])) {
	$request_url = $config['webportal']['ac_url'];
} else {
	$request_url = 'http://www.hotel.mili.com/ac.php';
}

/*
 * router process the authentication request from user browser.
 */
$request = $_REQUEST;
if (isset($request['act']) && $request['act'] == 'add') {
	if (empty($request['phone'])) {
		exit('phone_is_null');
	}
	if (empty($request['vcode'])) {
		exit('vcode_is_null');
	}

	$http = $request_url;
	$params = $request;
	// hostname represents the router, domain represents the hotel.
	$params['hotel_id'] = $config['system']['hostname'] . $config['system']['domain'];
	if (!isset($config['router_login_id'])) {
		// it should register itself to the yimi-server first.
		// $config['router_login_id'] = router_register($params['hotel_id']);
		//	if ($config['router_login_id'] == '-1') {
		//		allow the client visit the internet.
		//	}
	}
	$params['request_vcode'] = $config['router_login_id'];
	$http .= '?' . http_build_query($params);

	$wait_timeout = 3;
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $http);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_TIMEOUT, $wait_timeout);
	if (!empty($params)) {
		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $params);
	}
	/* the result is formated as json:
	 * {"return":"sucess", "user_id":"1234576543", "hotel_service_url":""} or
	 * {"return":"fail", "reason":"the phone is incorrect"}
	 */
	$json_result = curl_exec($ch);
	$result = json_decode($json_result);
	if (null == $result) {
		exit('server failed');
	}
	if ($result['return'] == 'fail') {
		exit($result['reason']);
	} elseif ($result['return'] == 'sucess') {
		// allow the user visit internet.
		webportal_allow($client_ip);
		exit($result['hotel_service_url']);
	} else {
		exit('server_failed');
	}
} else {
	exit('request_invalid');
}

?>
