<?php

abstract class Code4ge_CMF_Controller_Multilanguage extends Code4ge_CMF_Controller_Service
{

	protected $lang;

	public function init()
	{
		// get language
		$this->lang = Zend_Registry::get('locale')->getLanguage();

		$this->view->bootstrap()
			->addDojoConfigOption('locale', "'{$this->lang}'");
	}

	protected function loadTranslation()
	{
		$module = $this->getRequest()->getModuleName();
		$controller = $this->getRequest()->getControllerName();
		$action = $this->getRequest()->getActionName();

		$dir = APPLICATION_PATH . "/modules/$module/views/$controller";

		// load default english text
		$translate = new Zend_Translate(array(
			'adapter' => 'array',
			'content' => include "{$dir}/{$action}-en.php",
			'locale' => 'en'
		));
		// add translation
		if($this->lang != 'en') {
			$translate->addTranslation(array(
				'content' => include "{$dir}/{$action}-{$this->lang}.php",
				'locale' => $this->lang
			));
		}
		$translate->setLocale($this->lang);

		$this->view->translate = $translate;
	}

	protected function renderTranslation($name = null)
	{
		$action = $name != null ? $name : $this->_request->getActionName();
		$this->render("{$action}-{$this->lang}");
	}

}
