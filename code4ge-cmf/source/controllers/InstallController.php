<?php

class InstallController extends Zend_Controller_Action
{

	private $options;

	public function init()
	{
		$this->options = Zend_Registry::get('config');
		if($this->options->app->installed && (APPLICATION_ENV != 'development')) {
			// application has already been installed, redirect to the application url
			$this->getResponse()->setRedirect(APPLICATION_URL);
		}
	}

	public function indexAction()
	{
		$request = $this->getRequest();
		if($request->isGet()) { // display form

			// set layout
			$this->_helper->layout->setLayout('install');

			$view = $this->view;

			// bootstrap UI
			$view->bootstrap()
				->requireClass('dijit.form.TextBox')
				->requireClass('dijit.form.Button');

			// fulfil form with default values
			$params = $this->options->resources->db->params;
			$view->host = $params->host;
			$view->dbname = $this->getDbName($params->dbname);
			if(APPLICATION_ENV == 'development') {
				$view->username = $params->username;
				$view->password = $params->password;
			}
		}
		else { // run installation

			// do not render
			$this->_helper->layout->disableLayout();
			$this->_helper->viewRenderer->setNoRender(true);

			// get database connection details and install application
			$request = $this->getRequest();
			$params = $request->getPost();
			new Code4ge_CMF_Install($params);

			// redirect to the application url
			$this->getResponse()->setRedirect(APPLICATION_URL);
		}
	}

	private function getDbName($defaultName)
	{
		// get default module name
		$config = null;
		$path = APPLICATION_PATH . '/modules';
		$dir = opendir($path);
		while(false !== ($file = readdir($dir))) {
			if($file != '.' && $file != '..' && $file != '.gitignore') {
				$ini = "$path/$file/configs/application.ini";
				if(realpath($ini)) {
					if(isset($config)) {
						$config->merge(new Zend_Config_Ini($ini, APPLICATION_ENV));
					}
					else {
						$config = new Zend_Config_Ini($ini, APPLICATION_ENV, array('allowModifications' => true));
					}
				}
			}
		}
		closedir($dir);

		$dbName = '';
		if($config != null) {
			$dbName = $config->resources->frontController->defaultModule;
		}

		return empty($dbName) ? $defaultName : $dbName;
	}

}
