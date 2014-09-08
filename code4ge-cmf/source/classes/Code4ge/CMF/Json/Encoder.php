<?php

class Code4ge_CMF_Json_Encoder extends Zend_Json_Encoder
{

	public static function encode($value, $cycleCheck = false, $options = array())
	{
		$encoder = new self(($cycleCheck) ? true : false, $options);

		return $encoder->_encodeValue($value);
	}

    protected function _encodeDatum(&$value)
    {
		$result = null;

		if(is_string($value)) {
			$result =  $this->_encodeString($value);
		}
		else if(is_int($value) || is_float($value) || is_bool($value)) {
			$result = $value;
		}

		return $result;
    }

	 protected function _encodeString(&$value)
	 {
	 	return "'$value'";
	 }

}
