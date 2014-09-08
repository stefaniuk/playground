<?php

class Code4ge_CMF_Controller_Action_Helper_Url extends Zend_Controller_Action_Helper_Url
{

	public function lang($action, $controller = null, $module = null, array $params = null)
	{
		$url = $this->buildUrl($action, $controller, $module, $params);
		
		// URL: language/module/controller/action
		$locale = Zend_Registry::get('locale');
		$lang = $locale->getLanguage();
		$defaultLang = $locale->getApplicationDefaultLanguage();
		if($lang != $defaultLang) {
			$url = "$lang/$url";
		}
		
		// URL: base/language/module/controller/action
		if('' !== ($baseUrl = $this->getFrontController()->getBaseUrl())) {
			$url = $baseUrl . '/' . $url;
		}
		
		// URL: /base/language/module/controller/action/
		$url = '/' . ltrim($url, '/');
		
		$url = $this->prettyUrl($url);
		
		return $url;
	}

	public function dummyLang($action, $controller = null, $module = null, array $params = null)
	{
		$url = $this->buildUrl($action, $controller, $module, $params);
		
		$url = '${lang}/' . $url;
		
		// URL: base/language/module/controller/action
		if('' !== ($baseUrl = $this->getFrontController()->getBaseUrl())) {
			$url = $baseUrl . '/' . $url;
		}
		
		// URL: /base/language/module/controller/action/
		$url = '/' . ltrim($url, '/');
		
		$url = $this->prettyUrl($url);
		
		return $url;
	}

	private function buildUrl($action, $controller = null, $module = null, array $params = null)
	{
		$request = $this->getRequest();
		if(null === $controller) {
			$controller = $request->getControllerName();
		}
		if(null === $module) {
			$module = $request->getModuleName();
		}
		
		// URL: module/controller/action
		$url = $controller . '/' . $action;
		if($module != $this->getFrontController()->getDispatcher()->getDefaultModule()) {
			$url = $module . '/' . $url;
		}
		
		// URL: module/controller/action/param1/param2...
		if(count($params) > 0) {
			$array = array();
			foreach($params as $key => $value) {
				$array[] = urlencode($value);
			}
			$url .= '/' . implode('/', $array);
		}
		
		return $url;
	}

	private function prettyUrl($url)
	{
		$defaultModule = Zend_Registry::get('defaultModule');
		$url = str_replace(array("/${defaultModule}", '/index'), '', $url);
		$url = '/' . trim($url, '/');
		
		return $url;
	}

}
