<?php

class Code4ge_CMF_Model_UserGateway extends Code4ge_CMF_Model_AbstractGateway
{

	protected $validators = array(
		'name' => 'Code4ge_CMF_Validate_Model_User_Name',
		'fullName' => 'Code4ge_CMF_Validate_Model_User_FullName',
		'password' => 'Code4ge_CMF_Validate_Model_User_Password',
		'email' => 'Zend_Validate_EmailAddress',
		'role' => 'Code4ge_CMF_Validate_Model_User_Role'
	);

	protected $salt;

	public static function getInstance()
	{
		if(!(self::$instance instanceof self))
		{
			self::$instance = new self();
		}

		return self::$instance;
	}

	protected function __construct()
	{
		parent::__construct(array(
			'validate' => APPLICATION_ENV == 'production'
		));

		$config = Zend_Registry::get('config');
		$this->salt = $config->app->password->salt;
	}

	public function hashPassword($data)
	{
		// get model
		$user = $this->modelFactory($data);

		$hash = hash('sha256', substr($user->name, 0, 3) . $user->password . $this->salt, false);
		$user->password = $hash;

		return $hash;
	}

	public function login($username, $password)
	{
		$user = $this->modelFactory(array(
			'name' => $username,
			'password' => $password
		));
		$this->hashPassword($user);
		$user->login();

		return $user;
	}

	public function logout()
	{
		return Code4ge_CMF_Model_User::logoutAny();
	}

	public function getCurrentUser()
	{
		if(Zend_Auth::getInstance()->hasIdentity()) {
			$name = Zend_Auth::getInstance()->getIdentity();
			$user = $this->fetchByName($name);

			return $user->makeSafe();
		}

		return null;
	}

	public function fetchByName($name)
	{
		$table = $this->getTable();

		// fetch
		$result = $table->fetchRow(
			$table->select()->where('name=?', $name)
		);

		// return as model
		if(null !== $result) {
			$result = $this->modelFactory($result);
		}

		return $result;
	}

	public function create($data, $validate = true)
	{
		// get model
		$user = $this->modelFactory($data);

		// check if user already exists
		$validator = new Zend_Validate_Db_NoRecordExists(array(
			'table' => 'Users',
			'field' => 'name',
			'adapter' => Zend_Registry::get('db')
		));
		if(!$validator->isValid($user->name)) {
			throw new Exception(implode(', ', $validator->getMessages()));
		}

		// validate properties
		if($validate && !$user->isValid()) {
			throw new Exception($user->getError());
		}

		// hash password
		$this->hashPassword($user);

		$user = parent::create($user);

		return $user;
	}

	public function update($data, $validate = true)
	{
		$user = null;
		
		// id must be set
		if(!isset($data['id'])) {
			$user = $this->fetchByName($data['name']);
		}

		// set data to update
		foreach($data as $key => $value) {
			$user->$key = $value;
		}

		$modified = $user->isModified('password');
		$element = null;
		if(!$modified) {
			// do not validate password
			$element = 'password';
		}

		// validate properties
		if($validate && !$user->isValid($element, true)) {
			throw new Exception($user->getError());
		}

		if($modified) {
			// hash new password
			$this->hashPassword($user);
			
			$logger = Zend_Registry::get('log');
			$logger->log('User password has been changed.', Zend_Log::NOTICE);
		}

		return parent::update($user);
	}

}
