<?php

class Code4ge_CMF_Application_Resource_Router extends Zend_Application_Resource_Router
{

	public function getRouter()
	{
		if (null === $this->_router) {
			$bootstrap = $this->getBootstrap();
			$bootstrap->bootstrap('FrontController');
			$this->_router = $bootstrap->getContainer()->frontcontroller->getRouter();

			$options = $this->getOptions();
			$file = $options['file'];

			// merge all route files
			$routes = include APPLICATION_PATH . '/configs/' . $file;
			$fc = Zend_Controller_Front::getInstance();
			$directories = $fc->getControllerDirectory();
			foreach($directories as $name => $directory) {
				// load routes if file exists
				$path = APPLICATION_PATH . "/modules/$name/configs/$file";
				if(realpath($path)) {
					$routes = array_merge($routes, include $path);
				}
			}

			$this->_router->addRoutes($routes);
		}

		return $this->_router;
	}

}
