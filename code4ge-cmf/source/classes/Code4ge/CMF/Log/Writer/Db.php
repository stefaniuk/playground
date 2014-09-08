<?php

class Code4ge_CMF_Log_Writer_Db extends Zend_Log_Writer_Db
{

	protected function _write($event)
	{
		// get user name from session object
		$username = null;
		$session = Zend_Registry::get('session');
		if(isset($session->user)) {
			$username = $session->user->name;
		}

		// convert array to string
		if(is_array($event['message'])) {
			$event['message'] = implode(",", $event['message']);
		}

		// save log
		parent::_write(array_merge($event, array(
			'timestamp' => date('Y-m-d H:i:s'), // Zend_Log creates timestamps in an ISO-8601 format including the timezone, using date('c'), see ZF-8365
			'ip' => $_SERVER['REMOTE_ADDR'],
			'username' => $username,
			'useragent' => $_SERVER['HTTP_USER_AGENT'],
			'url' => Code4ge_CMF_Utils::getCurrentPageURL()
		)));
	}

}
