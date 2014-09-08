<?php

class ErrorController extends Zend_Controller_Action
{

	public function init()
	{
		// set layout
		$this->_helper->layout->setLayout('error');
	}

	public function errorAction()
	{
		$errors = $this->_getParam('error_handler');

		switch($errors->type) {
			case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
			case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
			case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:
				$this->getResponse()->setHttpResponseCode(404);
				$this->view->message = 'Page not found';
				break;
			default:
				$this->getResponse()->setHttpResponseCode(500);
				$this->view->message = 'Application error';
				break;
		}

		if($log = $this->getLog()) {
			$log->crit($this->view->message, $errors->exception);
		}

		if(ENTRY_POINT == 'install' || $this->getInvokeArg('displayExceptions') == true) {
			$this->view->exception = $errors->exception;
		}

		$this->view->request = $errors->request;
	}

	public function permissionAction()
	{
		$this->getResponse()->setHttpResponseCode(404);

		$urlHome = APPLICATION_URL . '/';
		if(Zend_Auth::getInstance()->hasIdentity()) {
			$rhg = Code4ge_CMF_Model_AclRoleHomeGateway::getInstance();
			$url = $rhg->getHomeByRoleName(Zend_Registry::get('role'));
			$urlHome = APPLICATION_URL . $url;
		}
		$this->view->urlHome = $urlHome;
	}

	private function getLog()
	{
		$bootstrap = $this->getInvokeArg('bootstrap');
		if(!$bootstrap->hasPluginResource('log')) {
			return false;
		}
		$log = $bootstrap->getResource('log');

		return $log;
	}

}
