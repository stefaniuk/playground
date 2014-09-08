<?php

class Code4ge_CMF_Acl_Resource extends Zend_Acl_Resource
{

	const ACTION = 'action';

	private $name;

	private $type;

	private $custom = true;

	public function __construct($name, $type)
	{
		switch($type) {
			case self::ACTION:
				$this->custom = false;
		}

		$this->name = $name;
		$this->type = $type;

		if($this->custom) {
			$this->_resourceId = "$type:[$name]";
		}
		else {
			$this->_resourceId = "$name";
		}
	}

	public function getName()
	{
		return $this->name;
	}

	public function getType()
	{
		return $this->type;
	}

}

