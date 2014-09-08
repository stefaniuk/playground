<?php

class Code4ge_CMF_Controller_Plugin_Session extends Zend_Controller_Plugin_Abstract
{

	public function preDispatch(Zend_Controller_Request_Abstract $request)
	{
		Zend_Session::start();
	}

	public function postDispatch(Zend_Controller_Request_Abstract $request)
	{
		// regenerate session id only if this is a production environemnt
		// FIXME: this is a causes of many problems !!!
		/*if('production' == APPLICATION_ENV) {
			$config = Zend_Registry::get('config');
			$session = Zend_Registry::get('session');
			if(isset($session->user)) {
				Zend_Session::rememberMe($config->plugin->session->rememberMe->auth);
			}
			else {
				Zend_Session::rememberMe($config->plugin->session->rememberMe->guest);
			}
		}*/
	}

}
