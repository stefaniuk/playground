<?php

class Code4ge_CMF_Model_User extends Code4ge_CMF_Model_AbstractModel
{

	protected $properties = array (
		'id' => null,
		'name' => null,
		'fullName' => null,
		'password' => null,
		'email' => null,
		'role' => 'guest',
		'dateCreated' => null,
		'dateConfirmed' => null,
		'dateLastLogin' => null,
		'banned' => 0,
		'editable' => 1,
		'defaultLanguage' => null
	);

	public function __construct($data, $gateway)
	{
		$config = Zend_Registry::get('config');
		$date = Zend_Date::now();
		$this->properties['dateCreated'] = $date->toString($config->app->datetime->format);

		parent::__construct($data, $gateway);
	}

	public function hashPassword()
	{
		$this->gateway->hashPassword($this);
	}

	public function makeSafe()
	{
		unset($this->password);

		return $this;
	}

	public function login()
	{
		self::logoutAny();

		$auth = Zend_Registry::get('auth');
		$auth->setIdentity($this->name);
		$auth->setCredential($this->password);

		$logger = Zend_Registry::get('log');

		$result = Zend_Auth::getInstance()->authenticate($auth)->getCode();
		switch($result) {
			case Zend_Auth_Result::SUCCESS:
				$user = $this->gateway->fetchByName($this->name);
				$this->populate($user->toArray());
				// store information about logged in user in the session
				$session = Zend_Registry::get('session');
				$session->user = $this;
				// save event in the application log
				$logger->info("log in {$this->name}");
				break;
			case Zend_Auth_Result::FAILURE:
			case Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND:
			case Zend_Auth_Result::FAILURE_IDENTITY_AMBIGUOUS:
			case Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID:
			case Zend_Auth_Result::FAILURE_UNCATEGORIZED:
			default:
				$this->error = 'Bad username or password';
				// save event in the application log
				$logger->warn('unsuccessful attempt to login');
				break;
		}

		return Zend_Auth::getInstance()->hasIdentity();
	}

	public static function logoutAny()
	{
		if(Zend_Auth::getInstance()->hasIdentity()) {
			$auth = Zend_Auth::getInstance();
			// save event in the application log
			$logger = Zend_Registry::get('log');
			$logger->info("log out {$auth->getIdentity()}");
			// clear identity
			Zend_Auth::getInstance()->clearIdentity();
			// clear session variables
			$session = Zend_Registry::get('session');
			$session->unsetAll();

			return true;
		}

		return false;
	}

	public function logout()
	{
		if($this->isLoggedIn()) {
			$auth = Zend_Auth::getInstance();
			// save event in the application log
			$logger = Zend_Registry::get('log');
			$logger->info("log out {$auth->getIdentity()}");
			// clear identity
			$auth->clearIdentity();
			// clear session variables
			$session = Zend_Registry::get('session');
			$session->unsetAll();

			return true;
		}

		return false;
	}

	public function isLoggedIn()
	{
		$auth = Zend_Auth::getInstance();
	
		if($auth->hasIdentity()) {
			return $this->name == $auth->getIdentity();
		}

		return false;
	}

}
