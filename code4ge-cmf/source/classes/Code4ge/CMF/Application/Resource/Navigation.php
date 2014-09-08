<?php

class Code4ge_CMF_Application_Resource_Navigation extends Zend_Application_Resource_Navigation
{

	public function init()
	{
		if(!$this->_container) {
			
			$options = $this->getOptions();
			$name = $options['name'];
			
			$fc = Zend_Controller_Front::getInstance();
			$directories = $fc->getControllerDirectory();
			
			// merge all navigation files
			$navigation = include APPLICATION_PATH . "/configs/${name}.php";
			foreach($directories as $module => $directory) {
				// load navigation if file exists
				$file = APPLICATION_PATH . "/modules/${module}/configs/${name}.php";
				if(realpath($file)) {
					$navigation = array_merge($navigation, include $file);
				}
			}
			
			// translate navigation
			$translate = null;
			$locale = Zend_Registry::get('locale');
			if($locale->isMultilingual()) {
				
				// english translation first
				$translate = new Zend_Translate(array(
					'adapter' => 'array',
					'content' => $this->getTranslation($name, 'en'),
					'locale' => 'en'
				));
				
				$languages = $locale->getLanguages();
				foreach($languages as $key => $lang) {
					
					// english translation has already been loaded
					if($lang == 'en') {
						continue;
					}

					// add translation
					$translate->addTranslation(array(
						'content' => $this->getTranslation($name, $lang),
						'locale' => $lang
					));
				}
			}

			$this->_container = new Code4ge_CMF_Navigation($navigation, $translate);
		}
		
		$this->store();
		
		return $this->_container;
	}

	private function getTranslation($name, $lang)
	{
		$translation = array();
		$file = APPLICATION_PATH . "/configs/${name}-${lang}.php";
		if(realpath($file)) {
			$translation = include $file;
		}
		$fc = Zend_Controller_Front::getInstance();
		$directories = $fc->getControllerDirectory();		
		foreach($directories as $module => $directory) {
			// load translation if file exists
			$file = APPLICATION_PATH . "/modules/${module}/configs/${name}-${lang}.php";
			if(realpath($file)) {
				$translation = array_merge($translation, include $file);
			}
		}
		
		return $translation;
	}

}
