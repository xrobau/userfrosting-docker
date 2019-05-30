<?php

if (getenv('DEVMODE') == 'true') {
	$registration = [ 'captcha' => false, 'require_email_verification' => false, ];
} else {
	$registration = [];
}


return [ 
	'site' => [
		'registration' => $registration,
	],
	'session' => [
		'handler' => 'database',
	],
	'mail' => [
		'port'    => 25,
		'auth'    => false,
		'secure'  => 'none',
	]
];

