<?php

class Code4ge_CMF_Application_Module_Bootstrap extends Zend_Application_Module_Bootstrap
{

	protected $logger;

	public function __construct($application)
	{
		parent::__construct($application);

		$this->logger = Zend_Registry::get('log');
		$this->logger->log('Initialize module ' . strtolower($this->getModuleName()), Zend_Log::DEBUG);
	}

	protected function _initAutoload()
	{
		$name = $this->getModuleName();

		// add path to the module classes
		set_include_path(implode(PATH_SEPARATOR, array(
			realpath(APPLICATION_PATH . '/modules/' . strtolower($name) . '/classes'),
			get_include_path(),
		)));

		$this->logger->log('Include path ' . get_include_path(), Zend_Log::DEBUG);

		// add autoloader namespace
		$autoloader = Zend_Loader_Autoloader::getInstance();
		$autoloader->registerNamespace(ucfirst($name) . '_');
	}

	protected function _initComponents()
	{
		// module configuration settings
		$config = new Zend_Config($this->_options);
		Zend_Registry::set('mconfig', $config);

		if(isset($config->resources) && isset($config->resources->db)) {
			// module database resource
			$this->bootstrap('db');
			$db = $this->getPluginResource('db');
			Zend_Registry::set('mdb', $db->getDbAdapter());
		}
		else {
			// if module database has not been defined use default one
			Zend_Registry::set('mdb', Zend_Registry::get('db'));
		}
	}

	protected function _initView()
	{
		$name = strtolower($this->getModuleName());

		// view resource
		$view = Zend_Registry::get('view');
		$view->addScriptPath(APPLICATION_PATH . "/modules/$name/views/");

		// layout resource
		$this->bootstrap('layout');
		$layout = $this->getPluginResource('layout')->getLayout();
		$layout->setViewScriptPath(array(
			APPLICATION_PATH . "/layouts/",
			APPLICATION_PATH . "/modules/$name/layouts/"
		));
		Zend_Registry::set('layout', $layout);		
	}

}
