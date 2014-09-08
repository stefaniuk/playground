<?php

class Code4ge_CMF_Model_EmailConfirmation extends Code4ge_CMF_Model_AbstractModel
{

	protected $properties = array (
		'code' => null,
		'type' => null,
		'language' => null,
		'email' => null,
		'dateCreated' => null,
		'dateConfirmed' => null,
		'dateExpiry' => null
	);

	public function __construct($data, $gateway)
	{
		$config = Zend_Registry::get('config');
		$date = Zend_Date::now();
		$this->properties['dateCreated'] = $date->toString($config->app->datetime->format);

		parent::__construct($data, $gateway);
		
		if(!isset($this->properties['code'])) {
			$this->gateway->generateConfirmationCode($this);
		}
	}

}
