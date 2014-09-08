<?php

class Code4ge_CMF_View_Helper_Bootstrap
{

	protected $container;

	public function __construct()
	{
		$registry = Zend_Registry::getInstance();
		if(!isset($registry[__CLASS__])) {
			$registry[__CLASS__] = new Code4ge_CMF_UI_Bootstrap();
		}
		$this->container = $registry[__CLASS__];		
	}

	public function bootstrap()
	{
		return $this->container;
	}

    public function setView(Zend_View_Interface $view)
    {
        $this->container->setView($view);
    }

    public function __call($method, $args)
    {
        return call_user_func_array(array($this->container, $method), $args);
    }

}
