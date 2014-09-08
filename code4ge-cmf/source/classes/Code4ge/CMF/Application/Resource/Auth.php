<?php

class Code4ge_CMF_Application_Resource_Auth extends Zend_Application_Resource_ResourceAbstract
{

	private $auth;

	public function init()
	{
		$options = $this->getOptions();

		$auth = Zend_Auth::getInstance();
		$auth->setStorage(new Zend_Auth_Storage_Session('auth'));

		$this->auth = new Zend_Auth_Adapter_DbTable(
			Zend_Registry::get('db'),
			$options['tableName'],
			$options['identityColumn'],
			$options['credentialColumn']
		);
		
		return $this->auth;
	}

	public function getAuth()
	{
		return $this->auth;
	}

}
