<?php

// Put your device token here (without spaces):
$deviceToken = '01144d36d8257797e3db34de9ed138396017edec4b10ff62ef0bd73868b829c5';

// Put your private key's passphrase here:
$passphrase = '12345';

// Put your alert message here:
$message = 'My first push notification!';

////////////////////////////////////////////////////////////////////////////////

$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'php_push_test.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
$fp = stream_socket_client(
	'ssl://gateway.sandbox.push.apple.com:2195', $err,
	$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

if (!$fp)
	exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body
$alertmessage = array('loc-key' => 'Remote Notification', 'loc-args' => Array('hello', 'world'));
$body['aps'] = array(
//	'alert' => $message,
//	'alert' => $alertmessage,
	'alert' => '',
//	'category' => 'Action',
	'badge' => 3,
	'sound' => 'default',
	'content-available' => 1
	);

// Encode the payload as JSON
$payload = json_encode($body);

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

if (!$result)
	echo 'Message not delivered' . PHP_EOL;
else
	echo 'Message successfully delivered' . PHP_EOL;

// Close the connection to the server
fclose($fp);
