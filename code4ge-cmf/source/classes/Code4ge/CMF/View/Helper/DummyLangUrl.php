<?php

class Code4ge_CMF_View_Helper_DummyLangUrl
{

	public function dummyLangUrl()
	{
		$fc = Zend_Controller_Front::getInstance();
		$request = $fc->getRequest();
		$module = $request->getModuleName();
		$controller = $request->getControllerName();
		$action = $request->getActionName();
		$params = $request->getParams();

		unset($params['module'], $params['controller'], $params['action'], $params['lang']);		

		$url = Zend_Controller_Action_HelperBroker::getStaticHelper('Url')->dummyLang($action, $controller, $module, $params);
		
		return $url;
	}

}
