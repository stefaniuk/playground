<?php

abstract class Code4ge_CMF_Model_AbstractModel
{

	private $strict;

	protected $gateway;

	protected $properties;

	private $initialData;

	protected $error;

	public function __construct($data, $gateway, $strict = true)
	{
		// initialize
		if($data instanceof Zend_Db_Table_Row_Abstract) {
			// from instance of the Table Row
			$data = $data->toArray();
		}
		else if(is_object($data)) {
			// from object
			$data = (array) $data;
		}
		else if(is_array($data)) {
			// from array
			$data = $data;
		}

		$this->strict = $strict;
		$this->gateway = $gateway;
		$this->populate($data);
	}

	public function populate($data)
	{
		// copy default values from $properties to $this
        foreach($this->properties as $key => $value) {
            $this->$key = $value;
		}

		// save initial model's state (allow also to set properties that do not correspond to the model's definition)
        foreach($data as $key => $value) {
            $this->$key = $value;
			$this->initialData[$key] = $value;
		}
	}

	public function __set($name, $value)
	{
		// allow to set all properties even if they do not correspond to the model's definition if model is not strict
		if($this->strict && !array_key_exists($name, $this->properties)) {
			throw new Exception('Invalid property "' . $name . '"');
		}
		$this->$name = $value;
	}

	public function __get($name)
	{
		// allow to get all properties that have been set even if they do not correspond to the model's definition
		if(isset($this->$name)) {
			return $this->$name;
		}

		return null;
	}

	public function isStrict()
	{
		return $this->strict;
	}

	public function getModified()
	{
		$diff = array();
		foreach($this->properties as $key => $value) {
			$a = !isset($this->initialData[$key]);
			$b = !isset($this->$key);
			if($a || $b) {
				if($a && !$b) {
					// a value was assigned to an empty property
					$diff[$key] = array(null, $this->$key);
				}
				else if(!$a && $b) {
					// property was set to empty value
					$diff[$key] = array($this->initialData[$key], null);
				}
			}
			else if($this->initialData[$key] !== $this->$key) {
				// a value of a property was amended
				$diff[$key] = array($this->initialData[$key], $this->$key);
			}
		}

		return $diff;
	}

	public function isModified($property)
	{
		// get all modified properties first
		$modified = $this->getModified();

		return isset($modified[$property]);
	}

	public function isValid($elements = null, $revert = false)
	{
		// fix elements array if necessary
		if(is_string($elements)) {
			if(!empty($elements)) {
				$elements = array($elements);
			}
			else {
				$elements = array();
			}
		}

		// get form
		$validators = $this->gateway->getValidators();
		$form = new Zend_Form();
		if(null !== $elements && !empty($elements)) {
			if(!$revert) {
				// set to validate only NAMED properties
				foreach($elements as $name) {
					$element = $form->createElement('text', $name);
					$element->addValidator($validators[$name]);
					$form->addElement($element);
				}
			}
			else {
				// set to validate only NOT NAMED properties
				foreach($validators as $name => $instance) {
					$element = $form->createElement('text', $name);
					$element->addValidator($instance);
					$form->addElement($element);
				}
				foreach($elements as $name) {
					$form->removeElement($name);
				}
			}
		}
		else {
			// set to validate ALL properties
			foreach($validators as $name => $instance) {
				$element = $form->createElement('text', $name);
				$element->addValidator($instance);
				$form->addElement($element);
			}
		}

		// validate
		if(!$form->isValid($this->toArray())) {

			// set error message
			$array = array();
			foreach($form->getMessages() as $property) {
				foreach($property as $message) {
					array_push($array, $message);
				}
			}
			$this->error = implode(', ', $array);

			return false;
		}

		return true;
	}

	public function getError()
	{
		return $this->error;
	}

	public function toArray()
	{
		$array = array();

		// get all properties that are named in $this->properties array
		foreach($this->properties as $key => $value) {
			if(isset($this->$key) && null !== $this->$key) {
				$array[$key] = $this->$key;
			}
			else {
				$array[$key] = null;
			}
		}

		return $array;
	}

}
