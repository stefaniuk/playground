<?php

class Code4ge_CMF_Model_SessionGateway extends Code4ge_CMF_Model_AbstractGateway
{

	public static function getInstance()
	{
		if(!(self::$instance instanceof self))
		{
			self::$instance = new self();
		}

		return self::$instance;
	}

}
