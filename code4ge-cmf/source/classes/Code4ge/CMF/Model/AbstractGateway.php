<?php

abstract class Code4ge_CMF_Model_AbstractGateway
{

	protected static $instance;

	protected $config;

	protected $model;

	protected $table;

	protected $validators = array();

	protected $validate;

	protected function __construct($options = null)
	{
		$class = get_class($this);
		$prefix = substr($class, 0, strpos($class, 'Model_', 0));

		// get model name
		$name = str_replace(array( $prefix . 'Model_', 'Gateway'), '', $class);

		// get model specyfic options
		$config = null;
		if($prefix == 'Code4ge_CMF_') {
			// set config for application
			$config = Zend_Registry::get('config');
			if(isset($config->model->$name)) {
				$config = $config->model->$name;
			}
		}
		else {
			// set config for module
			$config = Zend_Registry::get('mconfig');
			if(isset($config->model) && isset($config->model->$name)) {
				$config = $config->model->$name;
			}
		}

		// set model
		$this->model = $prefix . 'Model_' . $name;

		// set database
		$adapter = null;
		if(isset($options['adapter'])) {
			$adapter = $options['adapter'];
		}
		else if($prefix == 'Code4ge_CMF_') {
			// set adapter for application
			$adapter = Zend_Registry::get('db');
		}
		else {
			// set adapter for module
			$adapter = Zend_Registry::get('mdb');
		}
		$table = $name . 's';
		if(isset($options['table'])) {
			$table = $options['table'];
		}
		$primary = 'id';
		if(isset($options['primary'])) {
			$primary = $options['primary'];
		}
		$this->table = new Zend_Db_Table(array(
			Zend_Db_Table::ADAPTER => $adapter,
			Zend_Db_Table::NAME => $table,
			Zend_Db_Table::PRIMARY => $primary
		));

		// initialize validators
		foreach($this->validators as $name => $validator) {
			if(is_string($validator)) {
				$this->validators[$name] = new $validator();
			}
		}

		// set validate
		$this->validate = true;
		if(isset($options['validate'])) {
			$this->validate = $options['validate'];
		}
	}

	protected function setModel($model)
	{
		$this->model = $model;
	}

	public function getModel()
	{
		return $this->model;
	}

	protected function setTable($table)
	{
		$this->table = $table;
	}

	public function getTable()
	{
		return $this->table;
	}

	public function getValidators()
	{
		return $this->validators;
	}

	protected function setValidate($validate)
	{
		$this->validate = $validate;
	}

	public function getValidate()
	{
		return $validate;
	}

	protected function modelFactory($object)
	{
		if($object instanceof Code4ge_CMF_Model_AbstractModel) {
			return $object;
		}
		else {
			return new $this->model($object, $this);
		}
	}

	/* *** create methods *** */

	public function create($data)
	{
		// normalize data
		if(is_array($data)) {
			$data = $this->normalize($data);
		}

		// get model
		$model = $this->modelFactory($data);

		// validate properties
		if($this->validate && !$model->isValid()) {
			throw new Exception($model->getError());
		}

		// insert
		$table = $this->table;
		$result = $table->insert($model->toArray());

		// copy primary key values to the model
		$keys = $table->info(Zend_Db_Table::PRIMARY);
		foreach($keys as $key) {
			// set only if a primary key is a single column
			if(!is_array($result)) {
				if($key == 'id') {
					$model->$key = (int) $result;
				}
				else {
					$model->$key = $result;
				}
			}
		}

		return $model;
	}

	/* *** read methods *** */

	public function fetch($id)
	{
		$table = $this->getTable();

		// get primary key
		$keys = $table->info(Zend_Db_Table::PRIMARY);
		if(count($keys) != 1) {
			throw new Exception('There is none or there is a multi-column primary key');
		}
		$key = $keys[1];

		// fetch
		$result = $table->fetchRow(
			$table->select()->where($key . '=?', $id)
		);

		// return as model
		if(null !== $result) {
			$result = $this->modelFactory($result);
		}

		return $result;
	}

	public function fetchAll($where = null, $order = null, $count = null, $offset = null)
	{
		$table = $this->getTable();

		// fetch
		$result = $table->fetchAll($where, $order, $count, $offset);

		return new Code4ge_CMF_Model_Collection($result, $this);
	}

	/* *** update methods *** */

	public function update($data)
	{
		// normalize data
		if(is_array($data)) {
			$data = $this->normalize($data);
		}

		// get model
		$model = $this->modelFactory($data);

		// validate properties
		if($this->validate && !$model->isValid()) {
			throw new Exception($model->getError());
		}

		$table = $this->table;

		// get primary key
		$keys = $table->info(Zend_Db_Table::PRIMARY);
		if(count($keys) != 1) {
			throw new Exception('There is none or there is a multi-column primary key');
		}
		$key = $keys[1];

		// update
		$where = $table->getAdapter()->quoteInto($key . '=?', $model->id);
		$result = $table->update($model->toArray(), $where);

		return $result;
	}

	public function updateAll($data, $where = null)
	{
		// normalize data
		if(is_array($data)) {
			$data = $this->normalize($data);
		}

		// get model
		$model = $this->modelFactory($data);

		// update
		$table = $this->table;
		$result = $table->update($model->toArray(), $where);

		return $result;
	}

	/* *** delete methods *** */

	public function deleteById($id)
	{
		$table = $this->table;

		// get primary key
		$keys = $table->info(Zend_Db_Table::PRIMARY);
		if(count($keys) != 1) {
			throw new Exception('There is none or there is a multi-column primary key');
		}
		$key = $keys[1];

		// delete
		$where = $table->getAdapter()->quoteInto($key . '=?', $id);
		$result = $table->delete($where);

		return $result;
	}

	public function delete($data)
	{
		// normalize data
		if(is_array($data)) {
			$data = $this->normalize($data);
		}

		// get model
		$model = $this->modelFactory($data);

		$table = $this->table;

		// get primary key
		$keys = $table->info(Zend_Db_Table::PRIMARY);
		if(count($keys) != 1) {
			throw new Exception('There is none or there is a multi-column primary key');
		}
		$key = $keys[1];

		// delete
		$where = $table->getAdapter()->quoteInto($key . '=?', $model->id);
		$result = $table->delete($where);

		return $result;
	}

	public function deleteAll($where = null)
	{
		// delete
		$table = $this->table;
		$result = $table->delete($where);

		return $result;
	}

	/* *** normalize methods *** */

	protected function normalize($data)
	{
		return $data;
	}

}
