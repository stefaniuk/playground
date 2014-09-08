<?php

class Code4ge_CMF_Navigation_Page_Menu extends Zend_Navigation_Page_Mvc
{

	private $translate;

	public function setTranslate($translate)
	{
		$this->translate = $translate;
	}

	public function getLabel()
	{
		$label = $this->_label;
		if(isset($this->translate)) {
			$locale = Zend_Registry::get('locale');
			$this->translate->setLocale($locale->getLanguage());
			// translate label
			$label = $this->translate->_($this->_label);
		}
		
		return $label;
	}

	public function getTitle()
	{
		$title = $this->_title;
		if(isset($this->translate)) {
			$locale = Zend_Registry::get('locale');
			$this->translate->setLocale($locale->getLanguage());
			// translate title
			$title = $this->translate->_($this->_title);
		}
		
		return $title;
	}

	public function getHref()
	{
		return 'javascript:void(0);';	
	}

}
