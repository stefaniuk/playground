<?php

class Module_IndexController extends Code4ge_CMF_Controller_Multilanguage
{

	public function indexAction()
	{
		$this->view->dojo()->enable();
	}

	public function serviceAction()
	{
		//$this->setService('');
	}

}
