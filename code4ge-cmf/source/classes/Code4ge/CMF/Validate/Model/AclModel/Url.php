<?php

class Code4ge_CMF_Validate_Model_AclModel_Url extends Zend_Validate
{

	public function __construct()
	{
		$this->addValidator(new Code4ge_CMF_Validate_Model_AclResource_Name());
	}

}
