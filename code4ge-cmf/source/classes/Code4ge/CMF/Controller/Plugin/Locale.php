<?php

class Code4ge_CMF_Controller_Plugin_Locale extends Zend_Controller_Plugin_Abstract
{

	public function preDispatch(Zend_Controller_Request_Abstract $request)
	{
		$lang = $request->getParam('lang');
		$locale = Zend_Registry::get('locale');
		$defaultLang = $locale->getLanguage();
		
		// if language was not selected use default settings
		if($lang == null) {
			$lang = $defaultLang;
		}
		
		// set requested locale if diffrent than default
		if($lang != $defaultLang) {
			$locale->setLocale($lang);
		
		}
		
		// set Dojo Toolkit locale
		$view = Zend_Registry::get('view');
		$view->dojo()->setDjConfigOption('locale', $lang);
	}

}
