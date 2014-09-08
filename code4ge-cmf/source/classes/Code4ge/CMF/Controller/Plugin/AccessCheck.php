<?php

class Code4ge_CMF_Controller_Plugin_AccessCheck extends Zend_Controller_Plugin_Abstract
{

	public function dispatchLoopStartup(Zend_Controller_Request_Abstract $request)
	{
		$logger = Zend_Registry::get('log');

		$acl = Zend_Registry::get('acl');
		$role = Zend_Registry::get('role');
		
		$module = $request->getModuleName();
		$controller = $request->getControllerName();
		$action = $request->getActionName();
		$url = '/' . $module . '/' . $controller . '/' . $action;

		if($acl->hasAction($url) && $acl->isActionAllowed($role, $url)) {

			$logger->log('Access granted to ' . $url . ' for role ' . $role, Zend_Log::DEBUG);

			$request->setModuleName($module);
			$request->setControllerName($controller);
			$request->setActionName($action);
		}
		else {

			$logger->log('Access denied to ' . $url . ' for role ' . $role, Zend_Log::DEBUG);

			$request->setModuleName('default');
			$request->setControllerName('error');
			$request->setActionName('permission');
		}
	}

}
