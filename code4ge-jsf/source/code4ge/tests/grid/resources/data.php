<?php

include_once 'Zend\Json\Server.php';
include_once 'Zend\Db\Adapter\Pdo\Mysql.php';

$db = new Zend_Db_Adapter_Pdo_Mysql(array(
	'host'     => 'localhost',
	'username' => 'root',
	'password' => 'connan',
	'dbname'   => 'test'
));

class JsonRpcStoreTest {
	public function select($options)
	{
		$sql = 'SELECT * FROM testtbl';
		global $db;
		$result = $db->fetchAll($sql);
		return $result;
	}
	public function update($key, $data)
	{
		$data = array(
			'name' => $data['name'],
			'message' => $data['message'],
			'date' => $data['date']
		);
		global $db;
		$result = $db->update('testtbl', $data, "id = $key");
		return $result;
	}
	public function insert($key, $data)
	{
		return 0;
	}
	public function delete($key)
	{
		global $db;
		$result = $db->delete('testtbl', "id = $key");
		return $result;
	}
}

$service = new Zend_Json_Server();
$service->setClass('JsonRpcStoreTest');
header('Content-Type: application/json');
$service->handle();
