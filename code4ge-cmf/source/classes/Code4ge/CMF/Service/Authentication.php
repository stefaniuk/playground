<?php

class Code4ge_CMF_Service_Authentication
{

	public function login($username, $password)
	{
		$userGateway = Code4ge_CMF_Model_UserGateway::getInstance();
		$user = $userGateway->login($username, $password);

		return $user->isLoggedIn();
	}

	public function logout()
	{
		$userGateway = Code4ge_CMF_Model_UserGateway::getInstance();

		return $userGateway->logout();
	}

}
