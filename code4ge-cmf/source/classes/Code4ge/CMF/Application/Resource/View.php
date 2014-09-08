<?php

class Code4ge_CMF_Application_Resource_View extends Zend_Application_Resource_View
{

	public function getView()
	{
		if(null===$this->_view) {

			$view = parent::getView();

			$options = $this->getOptions();

			$view->addHelperPath('Zend/Dojo/View/Helper', 'Zend_Dojo_View_Helper');
			$view->addHelperPath('Zend/View/Helper/Navigation', 'Zend_View_Helper_Navigation');
			$view->addHelperPath('Code4ge/CMF/View/Helper', 'Code4ge_CMF_View_Helper');
			$view->addHelperPath('Code4ge/CMF/View/Helper/Navigation', 'Code4ge_CMF_View_Helper_Navigation');

			$view->setEncoding('UTF-8');
			$view->doctype('HTML5');
			$view->headTitle($options['title']);
			$view->headMeta()
				->appendHttpEquiv('Content-Type', 'text/html; charset=utf-8')
				->appendName('keywords', '') // TODO: store it in the database
				->appendName('description', ''); // TODO: store it in the database
			$view->headLink(array('rel' => 'shortcut icon',  'href' => $options['favicon']), 'PREPEND');

			$view->bootstrap()
				->setEnvironment(APPLICATION_ENV == 'production' ?
					Code4ge_CMF_UI_Bootstrap::ENVIRONMENT_BUILD : Code4ge_CMF_UI_Bootstrap::ENVIRONMENT_DEFAULT)
				->addTheme('code4ge.jsf.themes.default')
				->addTheme('code4ge.jsf.themes.default', true)
				->addTheme('code4ge.cmf.themes.default')
				->addDojoConfigOption('parseOnLoad', 'true')
				->addLayer('code4ge/jsf/code4ge-jsf-base.js')
				->addLayer('code4ge/cmf/code4ge-cmf-base.js')
				->requireClass('less.less')
				->requireClass('code4ge.jsf.base')
				->requireClass('code4ge.cmf.base');

			$this->_view = $view;
		}

		return $this->_view;
	}

}
