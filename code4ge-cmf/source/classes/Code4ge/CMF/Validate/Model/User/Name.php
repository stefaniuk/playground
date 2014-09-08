<?php

class Code4ge_CMF_Validate_Model_User_Name extends Zend_Validate
{

	public function __construct()
	{
		$this->addValidator(new Zend_Validate_StringLength(array( 'min' => 6, 'max' => 32 )));
	}

}
