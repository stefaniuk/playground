<?php

class Code4ge_CMF_Model_AclRoleHomeGateway extends Code4ge_CMF_Model_AbstractGateway
{

	protected $validators = array(
		'url' => 'Code4ge_CMF_Validate_Model_AclRoleHome_Url'
	);

	public static function getInstance()
	{
		if(!(self::$instance instanceof self))
		{
			self::$instance = new self();
		}

		return self::$instance;
	}

	public function getHomeByRoleName($role)
	{
		$db = $this->table->getAdapter();
		$stmt = $db->prepare('select rh.* from AclRoles r, AclRoleHomes rh where r.id = rh.idRole and r.name=?');
		$stmt->bindParam(1, $role, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT);
		$stmt->execute();
		$result = $stmt->fetchAll();

		$collection = new Code4ge_CMF_Model_Collection($result, $this);
		if($collection->count() > 0) {
			return $collection->current()->url;
		}
		else {
			return null;
		}
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

		return $data;
	}

}
