<?php

// application path, an absolute path to the root directory of the application
defined('APPLICATION_PATH') || define('APPLICATION_PATH', str_replace('\\', '/', realpath(__DIR__ . '/..')));

// application environment, can be either 'development' or 'production'
defined('APPLICATION_ENV') || define('APPLICATION_ENV', (getenv('APPLICATION_ENV') ? getenv('APPLICATION_ENV') : 'production'));

// application base URL
$path1 = explode('/', str_replace('\\', '/', dirname($_SERVER['SCRIPT_FILENAME'])));
$path2 = explode('/', str_replace('\\', '/', realpath(__DIR__)));
$path3 = explode('/', str_replace('\\', '/', dirname($_SERVER['PHP_SELF'])));
for($i = count($path2); $i < count($path1); $i++) {
	array_pop($path3);
}
if($path3[count($path3) - 1] == 'install.php') {
	unset($path3[count($path3) - 1]);
}
if(APPLICATION_ENV == 'production') {
	// production environment behind a proxy server
	define('APPLICATION_URL', '');
}
else {
	define('APPLICATION_URL', trim('http://' . $_SERVER['HTTP_HOST'] . implode('/', $path3), '/'));
}
unset($i, $path1, $path2, $path3);

// include path
set_include_path(implode(PATH_SEPARATOR, array(
	realpath(APPLICATION_PATH . '/classes'),
	get_include_path()
)));

// application configuration, can be modified later on only during the installation
require_once 'Zend/Config/Ini.php';
$config = new Zend_Config_Ini(
	APPLICATION_PATH . '/configs/application.ini',
	APPLICATION_ENV,
	array('allowModifications' => true)
);

// application resources base URL
define('APPLICATION_RESOURCES_URL', APPLICATION_URL . '/' . $config->resources->view->resources->dir);
