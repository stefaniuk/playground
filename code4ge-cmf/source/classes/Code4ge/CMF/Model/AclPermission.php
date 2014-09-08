<?php

class Code4ge_CMF_Model_AclPermission extends Code4ge_CMF_Model_AbstractModel
{

	protected $properties = array (
		'idRole' => null,
		'idResource' => null,
		'privilege' => null,
		'access' => 'deny'
	);

}
