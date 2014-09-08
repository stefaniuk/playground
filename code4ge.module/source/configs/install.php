<?php

return array_merge_recursive(array(
	'permissions' => array(
		'guest' => array(
			'/module/index/index' => array('read' => 'allow')
		)
	)
), include dirname(__FILE__) . '/' . APPLICATION_ENV . '.install.php');
