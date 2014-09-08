<?php

class Code4ge_CMF_Reflection_Application
{

	private $modules = array();

	public function __construct()
	{
		$fc = Zend_Controller_Front::getInstance();
		$directories = $fc->getControllerDirectory();
		foreach($directories as $name => $directory) {

			if(realpath(APPLICATION_PATH . '/modules/' . $name . '/classes')) {

				// add path to the module's classes
				set_include_path(implode(PATH_SEPARATOR, array(
					realpath(APPLICATION_PATH . '/modules/' . $name . '/classes'),
					get_include_path(),
				)));

				// add autoloader namespace
				$autoloader = Zend_Loader_Autoloader::getInstance();
				$autoloader->registerNamespace(ucfirst($name) . '_');
			}

			$this->modules[$name] = new Code4ge_CMF_Reflection_Module($name, $directory);
		}
	}

	public function getModules()
	{
		return $this->modules;
	}

}
