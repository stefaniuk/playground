<?php

class Code4ge_CMF_Validate_Model_User_FullName extends Zend_Validate
{

	public function __construct()
	{
		$this->addValidator(new Zend_Validate_StringLength(array( 'min' => 0, 'max' => 256 )));
	}

}
