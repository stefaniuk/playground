<?php

class Code4ge_CMF_Validate_Model_AclRoleHome_Url extends Zend_Validate
{

	public function __construct()
	{
		$this->addValidator(new Zend_Validate_StringLength(array( 'min' => 1, 'max' => 200 )));
	}

}
