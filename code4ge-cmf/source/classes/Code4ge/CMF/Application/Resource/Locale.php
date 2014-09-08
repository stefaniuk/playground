<?php

class Code4ge_CMF_Application_Resource_Locale extends Zend_Application_Resource_Locale
{

	public function getLocale()
	{
		if(null === $this->_locale) {
			$options = $this->getOptions();
			if(!isset($options['default'])) {
				$this->_locale = new Code4ge_CMF_Locale('en');
			}
			else {
				if(!isset($options['translations'])) {
					$this->_locale = new Code4ge_CMF_Locale($options['default']);
				}
				else {
					$this->_locale = new Code4ge_CMF_Locale($options['default'], $options['translations']);
				}
			}
		}

		return $this->_locale;
	}

}
