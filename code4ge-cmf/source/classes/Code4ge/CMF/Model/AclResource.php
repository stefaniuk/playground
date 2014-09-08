<?php

class Code4ge_CMF_Model_AclResource extends Code4ge_CMF_Model_AbstractModel implements Zend_Acl_Resource_Interface
{

	protected $properties = array (
		'id' => null,
		'idParent' => null,
		'name' => null,
		'type' => null
	);

	public function updateParent($name)
	{
		// update parent id in the database
		$this->gateway->update(array_merge($this->toArray(), array('parent' => $name)));
		// get updated record from the database
		$resource = $this->gateway->fetch($this->id);
		// set parent id of this object
		$this->idParent = $resource->idParent;
	}

	public function getResourceId()
	{
		return $this->name;
	}

}
