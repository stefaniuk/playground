<?php

return array(
	'confirm' => new Zend_Controller_Router_Route(
		'confirm/:type/:code',
		array(
			'module' => 'default',
			'controller' => 'confirm',
			'action' => 'index'
		)
	)
);
