<?php

class Code4ge_CMF_Model_AclPermissionGateway extends Code4ge_CMF_Model_AbstractGateway
{

	protected $validators = array(
		'privilege' => 'Code4ge_CMF_Validate_Model_AclPermission_Privilege',
		'access' => 'Code4ge_CMF_Validate_Model_AclPermission_Access'
	);

	public static function getInstance()
	{
		if(!(self::$instance instanceof self))
		{
			self::$instance = new self();
		}

		return self::$instance;
	}

	protected function __construct()
	{
		parent::__construct(array(
			'primary' => array('idRole', 'idResource', 'privilege')
		));
	}

	public function fetchPermissions($roleId, $resourceId)
	{
		$db = $this->table->getAdapter();
		$stmt = $db->prepare('select * from AclPermissionView where roleId=? and resourceId=?');
		$stmt->bindParam(1, $roleId, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT);
		$stmt->bindParam(2, $resourceId, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT);
		$stmt->execute();
		$result = $stmt->fetchAll();

		return new Code4ge_CMF_Model_Collection($result, $this);
	}

	public function getList()
	{
		$db = $this->table->getAdapter();
		$stmt = $db->prepare('select * from AclPermissionView');
		$stmt->execute();
		$result = $stmt->fetchAll();

		return new Code4ge_CMF_Model_Collection($result, $this);
	}

	protected function normalize($data)
	{
		if(isset($data['role'])) {
			$name = $data['role'];
			$roleGateway = new Code4ge_CMF_Model_AclRoleGateway();
			$result = $roleGateway->fetchAll(array(
				'name=?' => $name
			));
			if($result->count()==1) {
				$role = $result->current();
				$data['idRole'] = (int) $role->id;
				unset($data['role']);
			}
		}
		if(isset($data['resource'])) {
			$name = $data['resource'];
			$resourceGateway = new Code4ge_CMF_Model_AclResourceGateway();
			$result = $resourceGateway->fetchAll(array(
				'name=?' => $name
			));
			if($result->count()==1) {
				$resource = $result->current();
				$data['idResource'] = (int) $resource->id;
				unset($data['resource']);
			}
		}

		return $data;
	}

}
