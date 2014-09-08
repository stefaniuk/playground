<?php

class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{

	protected function _initModules()
	{
		// call to prevent ZF from loading all modules
	}

	protected function _initDefaults()
	{
		// time zone
		$options = $this->_options;
		if(function_exists('date_default_timezone_set')) {
			date_default_timezone_set($options['app']['date']['timezone']);
		}

		// locale resource
		$this->bootstrap('locale');
		Zend_Registry::set('locale', $this->getResource('locale'));

		// configuration settings
		$config = new Zend_Config($this->_options, ENTRY_POINT == 'install');
		Zend_Registry::set('config', $config);
	}

	protected function _initResources()
	{
		// database resource
		$this->bootstrap('db');
		Zend_Registry::set('db', $this->getResource('db'));

		// session resource
		$this->bootstrap('session');
		Zend_Registry::set('session', $this->getResource('session'));

		// logger resource
		$this->bootstrap('log');
		$logger = $this->getResource('log');
		Zend_Registry::set('log', $logger);
		$logger->log('Bootstrap application', Zend_Log::DEBUG);

		// authentication resource
		$this->bootstrap('auth');
		Zend_Registry::set('auth', $this->getResource('auth'));

		// user name and role
		$username = 'guest';
		$role = 'guest';
		$auth = Zend_Auth::getInstance();
		if($auth->hasIdentity()) {
			$session = Zend_Registry::get('session');
			if(isset($session->user)) {
				$username = $session->user->name;
				$role = $session->user->role;
			}
		}
		Zend_Registry::set('username', $username);
		Zend_Registry::set('role', $role);
		$logger->log('User name is ' . $username, Zend_Log::DEBUG);
		$logger->log('User role is ' . $role, Zend_Log::DEBUG);

		// view resource
		$this->bootstrap('view');
		$view = $this->getResource('view');
		Zend_Registry::set('view', $view);

		// layout resource
		$this->bootstrap('layout');
		Zend_Registry::set('layout', $this->getResource('layout'));

		// acl
		$acl = new Code4ge_CMF_Acl();
		Zend_Registry::set('acl', $acl);

		// router resource
		$this->bootstrap('router');
		Zend_Registry::set('router', $this->getResource('router'));

		// navigation resource
		$this->bootstrap('navigation');
		Zend_Registry::set('navigation', $this->getResource('navigation'));
		$view->navigation()
			->setAcl($acl)
			->setRole($role);

		// user-agent resource
		$this->bootstrap('useragent');
		Zend_Registry::set('useragent', $this->getResource('useragent'));
	}

	protected function _initPlugins()
	{
		// front controller resource
		$this->bootstrap('frontcontroller');
		$front = $this->getResource('frontcontroller');

		// session plugin
		$front->registerPlugin(new Code4ge_CMF_Controller_Plugin_Session());

		// access check plugin
		$front->registerPlugin(new Code4ge_CMF_Controller_Plugin_AccessCheck());

		// language plugin
		$front->registerPlugin(new Code4ge_CMF_Controller_Plugin_Locale());

		// module loader plugin
		$front->registerPlugin(new Code4ge_CMF_Controller_Plugin_ModuleLoader());
	}

}
