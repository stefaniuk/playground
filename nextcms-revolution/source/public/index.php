<?php

// make everything relative to the application root
chdir(dirname(__DIR__));

// include autoloader
require 'autoloader.php';

// run the application
Zend\Mvc\Application::init(require 'config/application.config.php')->run();

