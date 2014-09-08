<?php

class Code4ge_CMF_Model_Collection implements Iterator, Countable
{

	private $result;

	private $gateway;

	public function __construct($result, $gateway)
	{
		$this->result = $result;
		$this->gateway = $gateway;
	}

	public function count()
	{
		$value = null;
		if($this->result instanceof Countable) {
			$value = $this->result->count();
		}
		else {
			$value = count($this->result);
		}

		return $value;
	}

	public function current()
	{
		$key = $this->key();
		$value = $this->result[$key];
		if(!$value instanceof Code4ge_CMF_Model_Abstract) {
			$model = $this->gateway->getModel();
			// allow to set additional data fields by not using strict model's definition
			$value = new $model($value, $this->gateway, false);
			$this->result[$key] = $value;
		}

		return $value;
	}

	public function key()
	{
		$value = null;
		if($this->result instanceof Iterator) {
			$value = $this->result->key();
		}
		else {
			$value = key($this->result);
		}

		return $value;
	}

	public function next()
	{
		$value = null;
		if($this->result instanceof Iterator) {
			$value = $this->result->next();
		}
		else {
			$value = next($this->result);
		}

		return $value;
	}

	public function rewind()
	{
		$value = null;
		if($this->result instanceof Iterator) {
			$value = $this->result->rewind();
		}
		else {
			$value = reset($this->result);
		}

		return $value;
	}

	public function valid()
	{
		$value = null;
		if($this->result instanceof Iterator) {
			$value = $this->result->valid();
		}
		else {
			$value = null !== key($this->result);
		}

		return $value;
	}

	public function toArray()
	{
		$array = array();
		foreach($this as $model) {
			array_push($array, $model->toArray());
		}

		return $array;
	}

}
