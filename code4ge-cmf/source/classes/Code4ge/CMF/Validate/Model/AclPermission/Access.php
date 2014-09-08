<?php

class Code4ge_CMF_Validate_Model_AclPermission_Access extends Zend_Validate
{

	public function __construct()
	{
		$this->addValidator(new Zend_Validate_InArray(array('allow', 'deny')));
	}

}
