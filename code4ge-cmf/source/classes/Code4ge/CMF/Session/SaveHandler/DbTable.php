<?php

class Code4ge_CMF_Session_SaveHandler_DbTable extends Zend_Session_SaveHandler_DbTable
{

	const IP = 'ip';

	const USERNAME = 'username';

	const USERAGENT = 'useragent';

	private $ipColumn;

	private $usernameColumn;

	private $useragentColumn;

	public function __construct($config)
	{
		if(isset($config[self::IP])) {
			$this->ipColumn = $config[self::IP];
		}
		if(isset($config[self::USERNAME])) {
			$this->usernameColumn = $config[self::USERNAME];
		}
		if(isset($config[self::USERAGENT])) {
			$this->useragentColumn = $config[self::USERAGENT];
		}

		parent::__construct($config);
	}

	public function write($id, $data)
	{
		$return = false;

		// get user name from session object
		$username = null;
		$session = Zend_Registry::get('session');
		if(isset($session->user)) {
			$username = $session->user->name;
		}

		// get session lifetime from config options
		$config = Zend_Registry::get('config');
		if(isset($session->user)) {
			$this->_lifetime = $config->plugin->session->rememberMe->auth;
		}
		else {
			$this->_lifetime = $config->plugin->session->rememberMe->guest;
		}

		// set columns
		$data = array(
			$this->ipColumn => $_SERVER['REMOTE_ADDR'],
			$this->usernameColumn => $username,
			$this->useragentColumn => $_SERVER['HTTP_USER_AGENT'],
			$this->_modifiedColumn => time(),
			$this->_lifetimeColumn => $this->_lifetime,
			$this->_dataColumn => (string) $data
		);

		$rows = call_user_func_array(array(&$this, 'find'), $this->_getPrimary($id));
		if(count($rows)) {
			// update
			if ($this->update($data, $this->_getPrimary($id, self::PRIMARY_TYPE_WHERECLAUSE))) {
				$return = true;
			}
		}
		else {
			// insert
			if ($this->insert(array_merge($this->_getPrimary($id, self::PRIMARY_TYPE_ASSOC), $data))) {
				$return = true;
			}
		}

		return $return;
	}

}
