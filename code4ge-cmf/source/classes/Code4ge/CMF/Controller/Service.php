<?php

abstract class Code4ge_CMF_Controller_Service extends Zend_Controller_Action
{

	protected $logger; 

	private $service;

	public function __construct(Zend_Controller_Request_Abstract $request, Zend_Controller_Response_Abstract $response, array $invokeArgs = array())
	{
		parent::__construct($request, $response, $invokeArgs);

		$this->logger = Zend_Registry::get('log');
	}

	public function preDispatch()
	{
		$request = $this->getRequest();
		$module = $request->getModuleName();
		$controller = $request->getControllerName();
		$action = $request->getActionName();

		$this->logger->log(
			'Dispatch to ' . $module . '/' . $controller . '/' . $action . ' by ' . $request->getMethod() . ' method', 
			Zend_Log::DEBUG
		);

		if($action == 'service') {
			// disable error handler
			$front = Zend_Controller_Front::getInstance();
			$front->setParam('noErrorHandler', true);
			// disable layout
			$this->_helper->layout->disableLayout();
			// disable view
			$this->_helper->viewRenderer->setNoRender(true);
			// initialize service
			$this->service = new Code4ge_CMF_Json_Server();
		}
	}

	protected function setService($class)
	{
		$this->service->setClass($class);
	}

	abstract public function serviceAction();

	public function postDispatch()
	{
		$request = $this->getRequest();
		if($request->getActionName() == 'service') {
			header('Content-Type: application/json');
			if($request->getMethod() == 'GET') {
				// return SMD
				$this->service->setEnvelope(Zend_Json_Server_Smd::ENV_JSONRPC_2);
				$smd = $this->service->getServiceMap();
				echo Zend_Json::prettyPrint($smd);
			}
			else {
				// invoke a method 
				$this->service->handle();
			}
		}
	}

}
