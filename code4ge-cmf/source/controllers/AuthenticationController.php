<?php

class AuthenticationController extends Code4ge_CMF_Controller_Service
{
	
	public function loginAction()
	{
		$this->_helper->layout->disableLayout();
		$this->_helper->viewRenderer->setNoRender(true);

		// TODO
	}

	public function logoutAction()
	{
		$this->_helper->layout->disableLayout();
		$this->_helper->viewRenderer->setNoRender(true);

		$userGateway = Code4ge_CMF_Model_UserGateway::getInstance();
		$userGateway->logout();
	}

	public function serviceAction()
	{
		$this->setService('Code4ge_CMF_Service_Authentication');
	}

}
