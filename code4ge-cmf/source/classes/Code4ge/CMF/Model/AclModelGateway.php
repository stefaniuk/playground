<?php

class Code4ge_CMF_Model_AclModelGateway extends Code4ge_CMF_Model_AbstractGateway
{

	protected $validators = array(
		'name' => 'Code4ge_CMF_Validate_Model_AclModel_Name',
		'create' => 'Code4ge_CMF_Validate_Model_AclModel_Url',
		'read' => 'Code4ge_CMF_Validate_Model_AclModel_Url',
		'update' => 'Code4ge_CMF_Validate_Model_AclModel_Url',
		'delete' => 'Code4ge_CMF_Validate_Model_AclModel_Url'
	);

	public static function getInstance()
	{
		if(!(self::$instance instanceof self))
		{
			self::$instance = new self();
		}

		return self::$instance;
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

}
