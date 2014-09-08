<?php

class Code4ge_CMF_Locale extends Zend_Locale
{

	private $applicationDefaultLanguage;

	private $languages;

	private $langRegEx;

	public function __construct($locale = null, $languages = null)
	{
		parent::__construct($locale);
		
		$this->applicationDefaultLanguage = $this->getLanguage();
		$this->languages = $languages;
	}

	public function isMultilingual()
	{
		return 1 < count($this->languages);
	}

	public function getApplicationDefaultLanguage()
	{
		return $this->applicationDefaultLanguage;
	}

	public function getLanguages()
	{
		return $this->languages;
	}

	public function getLangRegEx()
	{
		if(!isset($this->langRegEx)) {
			$this->langRegEx = '';
			foreach($this->languages as $key => $value) {
				$this->langRegEx .= "|^${value}$";
			}
			$this->langRegEx = substr($this->langRegEx, 1);
		}
		
		return $this->langRegEx;
	}

	public function isValidLanguage($lang)
	{
		return 0 < preg_match('/' . $this->getLangRegEx() . '/', $lang);
	}

}
