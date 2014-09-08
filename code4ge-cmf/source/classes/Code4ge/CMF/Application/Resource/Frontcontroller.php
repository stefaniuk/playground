<?php

class Code4ge_CMF_Application_Resource_Frontcontroller extends Zend_Application_Resource_Frontcontroller
{

	public function init()
	{
		foreach($this->getOptions() as $key => $value) {
			
			switch($key) {
			
				// defaultModule is used to produce pretty URL addresses by action helper Code4ge_CMF_Controller_Action_Helper_Url
				case 'defaultModule':
					$module = $this->_options[$key];
					Zend_Registry::set('defaultModule', $module);
					$this->_options[$key] = 'default';

					if(ENTRY_POINT != 'install') {
						$logger = Zend_Registry::get('log');
						$logger->log('Default module is ' . $module, Zend_Log::DEBUG);
					}

					break;
			}
		}

		return parent::init();
	}

}
