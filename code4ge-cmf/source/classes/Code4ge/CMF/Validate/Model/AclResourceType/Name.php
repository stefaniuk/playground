<?php

class Code4ge_CMF_Validate_Model_AclResourceType_Name extends Zend_Validate
{

	public function __construct()
	{
		$this->addValidator(new Zend_Validate_StringLength(array( 'min' => 1, 'max' => 50 )));
	}

}
