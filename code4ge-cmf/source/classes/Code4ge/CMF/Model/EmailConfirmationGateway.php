<?php

class Code4ge_CMF_Model_EmailConfirmationGateway extends Code4ge_CMF_Model_AbstractGateway
{

	const CHARS = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

	protected $validators = array(
		'email' => 'Zend_Validate_EmailAddress'
	);
	
	protected $confirmationLength = 50;

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
			'primary' => 'code'
		));
	}

	public function generateConfirmationCode($data)
	{
		// get model
		$confirm = $this->modelFactory($data);

		$code = '';
		for($i = 0; $i < $this->confirmationLength; $i++) {
			$code .= self::CHARS[mt_rand(0, strlen(self::CHARS) - 1)];
		}

		$confirm->code = $code;

		return $code;
	}

}
