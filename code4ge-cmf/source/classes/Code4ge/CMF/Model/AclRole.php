<?php

class Code4ge_CMF_Model_AclRole extends Code4ge_CMF_Model_AbstractModel implements Zend_Acl_Role_Interface
{

	protected $properties = array (
		'id' => null,
		'idParent' => null,
		'name' => null
	);

	public function updateParent($name)
	{
		// update parent id in the database
		$this->gateway->update(array_merge($this->toArray(), array('parent' => $name)));
		// get updated record from the database
		$role = $this->gateway->fetch($this->id);
		// set parent id of this object
		$this->idParent = $role->idParent;
	}

	public function getRoleId()
	{
		return $this->name;
	}

}
