<?php

class Code4ge_CMF_Reflection_Controller extends Zend_Reflection_File
{

	private $moduleName;

	private $controllerName;

	private $actionNames = array();

	public function __construct($file)
	{
		require_once $file;

		parent::__construct($file);

		$class = $this->getClass();
		$name = $class->getName();

		$parts = explode('_', $name);
		if(count($parts) == 2) {
			$this->moduleName = strtolower($parts[0]);
			$this->controllerName = strtolower(str_replace('Controller', '', $parts[1]));
		}
		else {
			$this->moduleName = 'default';
			$this->controllerName = strtolower(str_replace('Controller', '', $parts[0]));
		}

		$methods = $class->getMethods(ReflectionMethod::IS_PUBLIC);
		foreach($methods as $method) {
			if(preg_match('/Action$/', $method->getName())) {
				$this->actionNames[] = str_replace('Action', '', $method->getName());
			}
		}
	}

	public function getModuleName()
	{
		return $this->moduleName;
	}

	public function getControllerName()
	{
		return $this->controllerName;
	}

	public function getActionNames()
	{
		return $this->actionNames;
	}

}
