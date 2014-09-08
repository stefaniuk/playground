<?php

require 'common.php.inc';

define('ENTRY_POINT', 'install');

// clear APC cache
if(function_exists('apc_clear_cache')) {
	apc_clear_cache();
	apc_clear_cache('user');
	apc_clear_cache('opcode');
}

// initialize application
require_once 'Zend/Application.php';
$application = new Zend_Application(
	APPLICATION_ENV,
	$config
);

// clean up
unset($config);

// bootstrap and run application
$application->bootstrap(array('defaults', 'view', 'layout'));
$application->run();
