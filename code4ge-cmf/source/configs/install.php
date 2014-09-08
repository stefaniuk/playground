<?php

return array_merge_recursive(array(
	'roles' => array(
		'guest' => null,
		'member' => 'guest'
	),
	'homes' => array(
		'guest' => '/',
		'member' => '/'
	),
	'permissions' => array(
		'guest' => array(
			'/' => array('read' => 'deny'),
			'/default/authentication' => array('read' => 'allow'),
			'/default/error' => array('read' => 'allow')
		)
	),
	'languages' => array(
		'en-GB' => array(
			'name' => Code4ge_CMF_Language::ENGLISH_UK,
			'isDefault' => 1
		)
	),
	'emailConfirmationTypes' => array(
		'User'
	)
), include dirname(__FILE__) . '/' . APPLICATION_ENV . '.install.php');
