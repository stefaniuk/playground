<?php

class Code4ge_CMF_Controller_Plugin_ModuleLoader extends Zend_Controller_Plugin_Abstract
{

	protected $modules;

	public function __construct()
	{
		$modules = Zend_Controller_Front::getInstance()->getControllerDirectory();
		$this->modules = $modules;
	}

	public function dispatchLoopStartup(Zend_Controller_Request_Abstract $request)
	{
		$logger = Zend_Registry::get('log');

		$module = $request->getModuleName();
		$controller = $request->getControllerName();
		$action = $request->getActionName();

		if(!isset($this->modules[$module])) {
			throw new Exception('Module does not exist');
		}

		$logger->log('Bootstrap module ' . $module, Zend_Log::DEBUG);

		if($module != 'default') {

			$application = new Zend_Application(
				APPLICATION_ENV,
				APPLICATION_PATH . '/modules/' . $module . '/configs/module.ini'
			);

			$path = $this->modules[$module];
			$class = ucfirst($module) . '_Bootstrap';
			if(Zend_Loader::loadFile('Bootstrap.php', dirname($path)) && class_exists($class)) {
				$bootstrap = new $class($application);
				$bootstrap->bootstrap();
			}
		}
	}

}
