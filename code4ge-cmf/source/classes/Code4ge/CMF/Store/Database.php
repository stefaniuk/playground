<?php

class Code4ge_CMF_Store_Database {

	protected $gateway;

	public function __construct($gateway)
	{
		$this->gateway = $gateway;
	}

	public function select($options)
	{
		$result = $this->gateway->fetchAll();

		return $result->toArray();
	}

	public function update($key, $data)
	{
		$result = $this->gateway->update($data);

		return $result;
	}

	public function insert($key, $data)
	{
		/* TODO */
	}

	public function delete($key)
	{
		$result = $this->gateway->deleteAll("id=$key");

		return $result;
	}

}
