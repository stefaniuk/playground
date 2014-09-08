<?php

class Code4ge_CMF_Model_AclModel extends Code4ge_CMF_Model_AbstractModel implements Zend_Acl_Resource_Interface
{

	protected $properties = array (
		'id' => null,
		'name' => null,
		'create' => null,
		'read' => null,
		'update' => null,
		'delete' => null
	);

	public function getResourceId()
	{
		return $this->name;
	}

}
