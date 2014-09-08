<?php

class Code4ge_CMF_Install
{

	private $params;

	private $modules;

	private $db;

	private $salt;

	public function __construct($params)
	{
		$this->params = $params;

		// get list of modules
		$application = new Code4ge_CMF_Reflection_Application();
		$modules = $application->getModules();
		unset($modules['default']);
		$this->modules = $modules;

		// create connection to the database server
		$this->db = new Zend_Db_Adapter_Pdo_Mysql(array(
			'host' => $params['host'],
			'username' => $params['username'],
			'password' => $params['password'],
			'dbname' => null
		));

		// create connection to the database
		Zend_Registry::set('db', new Zend_Db_Adapter_Pdo_Mysql(array(
			'host' => $params['host'],
			'username' => $params['username'],
			'password' => $params['password'],
			'dbname' => $params['dbname']
		)));

		// generate salt
		$this->salt = $this->generateSalt();
		$config = Zend_Registry::get('config');
		$config->app->password->salt = $this->salt;

		$this->preInstall();

		$this->populatePrivileges();
		$this->populateResourceTypes();
		$this->populateActionResources();

		$options = new Zend_Config(require APPLICATION_PATH . '/configs/install.php', array('allowModifications' => true));
		foreach($this->modules as $name => $module) {
			// merge configuration if file exists
			$path = APPLICATION_PATH . "/modules/$name/configs/install.php";
			if(realpath($path)) {
				$options->merge(new Zend_Config(require $path));
			}
		}
		$this->populateConfiguration($options);

		$this->postInstall();
	}

	private function preInstall()
	{
		$dbName = $this->params['dbname'];

		$fn = function($content) use ($dbName) {
			if($dbName != 'code4gecmf') {
				$content = str_replace('code4gecmf', $dbName, $content);
			}
			return $content;
		};

		// run application SQL script
		$this->runSQLScript(APPLICATION_PATH . '/database/install.sql', $fn);
		foreach($this->modules as $name => $module) {
			// run module SQL script if file exists
			$path = APPLICATION_PATH . "/modules/$name/database/install.sql";
			if(realpath($path)) {
				$this->runSQLScript($path, $fn);
			}
		}
	}

	private function populatePrivileges()
	{
		$pg = Code4ge_CMF_Model_AclPrivilegeGateway::getInstance();

		$pg->create(array('name' => 'create'));
		$pg->create(array('name' => 'read'));
		$pg->create(array('name' => 'update'));
		$pg->create(array('name' => 'delete'));
	}

	private function populateResourceTypes()
	{
		$rtg = Code4ge_CMF_Model_AclResourceTypeGateway::getInstance();

		$rtg->create(array('name' => 'action'));
	}

	private function populateActionResources()
	{
		$rg = Code4ge_CMF_Model_AclResourceGateway::getInstance();

		// action
		$application = new Code4ge_CMF_Reflection_Application();
		$rg->create(array('name' => '/', 'type' => 'action'));
		foreach($application->getModules() as $moduleName => $module) {
			$rg->create(array(
				'name' => "/$moduleName",
				'parent' => '/',
				'type' => 'action'
			));
			foreach($module->getControllers() as $controlerName => $controller) {
				$rg->create(array(
					'name' => "/$moduleName/$controlerName",
					'parent' => "/$moduleName",
					'type' => 'action'
				));
				foreach($controller->getActionNames() as $actionName) {
					$rg->create(array(
						'name' => "/$moduleName/$controlerName/$actionName",
						'parent' => "/$moduleName/$controlerName",
						'type' => 'action'
					));
				}
			}
		}
	}

	private function populateConfiguration($options)
	{
		if(isset($options->roles)) {
			$this->populateRoles($options->roles);
		}
		if(isset($options->homes)) {
			$this->populateRoleHomes($options->homes);
		}
		if(isset($options->permissions)) {
			$this->populatePermissions($options->permissions);
		}
		if(isset($options->models)) {
			$this->populateModels($options->models);
		}
		if(isset($options->languages)) {
			$this->populateLanguages($options->languages);
		}
		if(isset($options->emailConfirmationTypes)) {
			$this->populateEmailConfirmationTypes($options->emailConfirmationTypes);
		}
		if(isset($options->users)) {
			$this->populateUsers($options->users);
		}
	}

	private function populateRoles($roles)
	{
		$rg = Code4ge_CMF_Model_AclRoleGateway::getInstance();

		foreach($roles as $name => $parent) {
			if($parent === null) {
				$rg->create(array(
					'name' => $name
				));
			}
			else {
				$rg->create(array(
					'name' => $name,
					'parent' => $parent
				));
			}
		}
	}

	private function populateRoleHomes($roleHomes)
	{
		$rhg = Code4ge_CMF_Model_AclRoleHomeGateway::getInstance();

		foreach($roleHomes as $role => $url) {
			$rhg->create(array(
				'role' => $role,
				'url' => $url
			));
		}
	}

	private function populatePermissions($permissions)
	{
		$pg = Code4ge_CMF_Model_AclPermissionGateway::getInstance();

		foreach($permissions as $role => $permission) {
			foreach($permission as $resource => $privileges) {
				foreach($privileges as $privilege => $access) {
					$pg->create(array(
						'role' => $role,
						'resource' => $resource,
						'privilege' => $privilege,
						'access' => $access
					));
				}
			}
		}
	}

	private function populateModels($models)
	{
		$mg = Code4ge_CMF_Model_AclModelGateway::getInstance();

		foreach($models as $name => $model) {
			$mg->create(array(
				'name' => $name,
				'create' => $model->create,
				'read' => $model->read,
				'update' => $model->update,
				'delete' => $model->delete
			));
		}
	}

	private function populateLanguages($languages)
	{
		$lg = Code4ge_CMF_Model_LanguageGateway::getInstance();

		foreach($languages as $code => $language) {
			$lg->create(array(
				'code' => $code,
				'name' => $language->name,
				'isDefault' => $language->isDefault
			));
		}
	}

	private function populateEmailConfirmationTypes($emailConfirmationTypes)
	{
		$ectg = Code4ge_CMF_Model_EmailConfirmationTypeGateway::getInstance();

		foreach($emailConfirmationTypes as $name) {
			$ectg->create(array(
				'name' => $name
			));
		}
	}

	private function populateUsers($users)
	{
		$ug = Code4ge_CMF_Model_UserGateway::getInstance();

		while ($users->valid()) {
			$name = $users->key();
			$user = $users->current();
			$ug->create(array(
				'name' => $name,
				'fullName' => $user->fullName,
				'password' => $user->password,
				'email' => $user->email,
				'role' => $user->role,
				'editable' => $user->editable
			), false);
			$users->next();
		}
	}

	private function postInstall()
	{
		$params = $this->params;

		// read config file
		$file = fopen(APPLICATION_PATH . '/configs/application.ini', 'rb');
		$content = fread($file, filesize(APPLICATION_PATH . '/configs/application.ini'));
		fclose($file);

		// mark the application as installed
		$content = preg_replace('/app.installed[[:space:]]*=[[:space:]]*false/', 'app.installed = true', $content);

		// save salt
		$content = preg_replace('/app.password.salt[[:space:]]*=[[:space:]]*\".*\"/', 'app.password.salt = "' .  $this->salt . '"', $content);

		// save database connection details
		$content = preg_replace('/resources.db.params.host[[:space:]]*=[[:space:]]*\".*\"/', 'resources.db.params.host = "' .  $params['host'] . '"', $content);
		$content = preg_replace('/resources.db.params.dbname[[:space:]]*=[[:space:]]*\".*\"/', 'resources.db.params.dbname = "' .  $params['dbname'] . '"', $content);
		$content = preg_replace('/resources.db.params.username[[:space:]]*=[[:space:]]*\".*\"/', 'resources.db.params.username = "' .  $params['username'] . '"', $content);
		$content = preg_replace('/resources.db.params.password[[:space:]]*=[[:space:]]*\".*\"/', 'resources.db.params.password = "' .  $params['password'] . '"', $content);

		// write config file
		$file = @fopen(APPLICATION_PATH . '/configs/application.ini', 'wb');
		if(!$file) {
			throw new Exception('Failed to modify the configuration file');
		}
		fputs($file, $content);
		fclose($file);
	}

	private function runSQLScript($filename, $fn = null)
	{
		$script = file_get_contents($filename);

		if(isset($fn)) {
			$script = $fn($script);
		}

		$queries = explode(";\n", $script);
		foreach($queries as $query) {
			$query = trim($query);
			if(strlen($query) > 0) {
				$this->db->getConnection()->exec($query);
			}
		}
	}

	private function generateSalt($length = 6)
	{
		$chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

		$salt = '';
		for($i = 0; $i < $length; $i++) {
			$salt .= $chars[mt_rand(0, strlen($chars) - 1)];
		}

		return $salt;
	}

}
