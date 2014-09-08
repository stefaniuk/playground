<?php

class Code4ge_CMF_Navigation extends Zend_Navigation
{

	public function __construct($pages = null, $translate = null)
	{
		parent::__construct($pages);
		
		if(isset($translate)) {
			$pages = $this->getPages();
			// set translator to each page and its sub-pages
			foreach($pages as $page) {
				$this->setTranslate($page, $translate);
			}
		}
	}

	private function setTranslate($page, $translate)
	{
		// set translator to the current page
		$page->setTranslate($translate);
		
		// set translator to each sub-page
		$pages = $page->getPages();
		foreach($pages as $p) {
			$this->setTranslate($p, $translate);
		}
	}

}
