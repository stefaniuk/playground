<?php

class Code4ge_CMF_Application_Resource_Log extends Zend_Application_Resource_Log
{

	public function getLog()
	{
		if(null === $this->_log) {

			$log = new Zend_Log();

			if(ENTRY_POINT != 'install') {
				// database writer
				$options = array_change_key_case($this->getOptions(), CASE_LOWER);
				$db = Zend_Registry::get('db');
				$column = $options['db']['column'];
				$writer = new Code4ge_CMF_Log_Writer_Db($db, $options['db']['table'], array(
					$column['date'] => 'timestamp',
					$column['ip'] => 'ip',
					$column['username'] => 'username',
					$column['useragent'] => 'useragent',
					$column['url'] => 'url',
					$column['priority'] => 'priority',
					$column['message'] => 'message'
				));
				$log->addWriter($writer);
			}

			if(APPLICATION_ENV == 'development') {
				// firebug writer
				$log->addWriter(new Zend_Log_Writer_Firebug());
			}

			$this->setLog($log);
		}

		return $this->_log;
	}

}
