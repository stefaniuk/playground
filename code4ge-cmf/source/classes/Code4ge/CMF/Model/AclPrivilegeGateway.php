<?php

class Code4ge_CMF_Model_AclPrivilegeGateway extends Code4ge_CMF_Model_AbstractGateway
{

	protected $validators = array(
		'name' => 'Code4ge_CMF_Validate_Model_AclPrivilege_Name'
	);

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
			'table' => 'AclPrivilegeDict',
			'primary' => 'name'
		));
	}

}
