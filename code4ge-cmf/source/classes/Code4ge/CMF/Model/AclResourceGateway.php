<?php

class Code4ge_CMF_Model_AclResourceGateway extends Code4ge_CMF_Model_AbstractGateway
{

	protected $validators = array(
		'name' => 'Code4ge_CMF_Validate_Model_AclResource_Name',
		'type' => 'Code4ge_CMF_Validate_Model_AclResource_Type'
	);

	public static function getInstance()
	{
		if(!(self::$instance instanceof self))
		{
			self::$instance = new self();
		}

		return self::$instance;
	}

	public function fetchByName($name)
	{
		$table = $this->getTable();

		// fetch
		$result = $table->fetchRow(
			$table->select()->where('name=?', $name)
		);

		// return as model
		if(null !== $result) {
			$result = $this->modelFactory($result);
		}

		return $result;
	}

	public function fetchResourceTree($roleName)
	{
		$db = $this->table->getAdapter();
		$stmt = $db->prepare('call getResourceTree(?)');
		$stmt->bindParam(1, $roleName, PDO::PARAM_STR | PDO::PARAM_INPUT_OUTPUT);
		$stmt->execute();
		$result = $stmt->fetchAll();

		return new Code4ge_CMF_Model_Collection($result, $this);
	}

	public function getList()
	{
		$db = $this->table->getAdapter();
		$stmt = $db->prepare(
			'select t1.*, t2.name as nameParent, t2.type as typeParent from AclResources t1 ' .
			'left join AclResources t2 on t1.idParent = t2.id order by t1.id, t1.idParent'
		);
		$stmt->execute();
		$result = $stmt->fetchAll();

		return new Code4ge_CMF_Model_Collection($result, $this);
	}

	protected function normalize($data)
	{
		if(isset($data['parent'])) {
			$name = $data['parent'];
			$result = $this->fetchAll(array(
				'name=?' => $name
			));
			if($result->count()==1) {
				$resource = $result->current();
				$data['idParent'] = (int) $resource->id;
				unset($data['parent']);
			}
		}

		return $data;
	}

}
