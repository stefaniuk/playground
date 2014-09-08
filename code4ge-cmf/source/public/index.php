<?php

require 'common.php.inc';

define('ENTRY_POINT', 'application');

// check whether or not application was installed
if($config->app->installed) {

	// clear APC cache
	if(function_exists('apc_clear_cache') && APPLICATION_ENV == 'development') {
		apc_clear_cache();
		apc_clear_cache('user');
		apc_clear_cache('opcode');
	}

	// override default configuration by module configuration
	$path = APPLICATION_PATH . '/modules';
	$dir = opendir($path);
	while(false !== ($file = readdir($dir))) {
		if($file != '.' && $file != '..' && $file != '.gitignore') {
			$ini = "$path/$file/configs/application.ini";
			if(realpath($ini)) {
				$config->merge(new Zend_Config_Ini($ini, APPLICATION_ENV));
			}
		}
	}
	closedir($dir);

	// override default configuration by server configuration
	$ini = APPLICATION_PATH . '/configs/server.ini';
	if(realpath($ini)) {
		// FIXME: see http://zendframework.com/issues/browse/ZF-10905
		$config->merge(new Zend_Config_Ini($ini, APPLICATION_ENV));
	}

	//require_once 'Zend/Debug.php';
	//Zend_Debug::dump($config->toArray());
	//die();

	// mark configuration settings as read-only
	$config->setReadOnly();

	// initialize application
	require_once 'Zend/Application.php';
	$application = new Zend_Application(
		APPLICATION_ENV,
		$config
	);

	// clean up
	unset($config, $path, $dir, $file, $type, $ini);

	// bootstrap and run application
	$application->bootstrap();
	$application->run();
}
else {
	// redirect to installation script
	header('Location: ' . APPLICATION_URL . '/install');
}
