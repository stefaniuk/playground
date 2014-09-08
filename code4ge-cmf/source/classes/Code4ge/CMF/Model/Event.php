<?php

class Code4ge_CMF_Model_Event extends Code4ge_CMF_Model_AbstractModel
{

	protected $properties = array (
		'id' => null,
		'date' => null,
		'module' => null,
		'ip' => null,
		'username' => null,
		'type' => null,
		'message' => null
	);

	public function __construct($data, $gateway)
	{
		$config = Zend_Registry::get('config');
		$date = Zend_Date::now();
		$this->properties['date'] = $date->toString($config->app->datetime->format);

		parent::__construct($data, $gateway);
	}

}
