<?php

class Code4ge_CMF_UI_Bootstrap
{

	const ENVIRONMENT_DEFAULT = '';

	//const ENVIRONMENT_DEVELOPMENT = 'development';

	const ENVIRONMENT_BUILD = 'build';

	const THEME_NONE = 'none';

	const THEME_CLARO = 'claro';

	/* ====================================================================== */

	private $environment = self::ENVIRONMENT_DEFAULT;

	private $theme = self::THEME_CLARO;

	/* ====================================================================== */

	private $stylesheetFiles = array();

	private $themes = array();

	private $dojoStyles = array();

	private $dojoConfig = array();

	private $layers = array();

	private $requiredClasses = array();

	private $onReady = array();

	private $javascriptFiles = array();

	/* ====================================================================== */

	private $css3pie;

	private $css960gs;

	/* ====================================================================== */

	private $view;

	/* ====================================================================== */

	private $settings = array();

	/* ====================================================================== */

	public static function getStyleSheetElement($file)
	{
		if(substr($file, -9) === '.less.css') {
			return '<link rel="stylesheet/less" type="text/css" href="' . $file . '" charset="utf-8" />';
		}
		else {
			return '<link rel="stylesheet" type="text/css" href="' . $file . '" charset="utf-8" />';
		}
	}

	public static function getJavaScriptElement($file)
	{
		return '<script type="text/javascript" src ="' . $file . '" charset="utf-8"></script>';
	}

	/* ====================================================================== */

	public function setEnvironment($environment)
	{
		$this->environment = $environment;

		return $this;
	}

	public function setBaseTheme($theme)
	{
		$this->theme = $theme;

		return $this;
	}

	/* ====================================================================== */

	public function addStylesheetFile($stylesheetFile)
	{
		$this->stylesheetFiles[$stylesheetFile] = $stylesheetFile;

		return $this;
	}

	public function addTheme($theme, $isLesscss = false)
	{
		$suffix = $isLesscss ? '.less.css' : '.css';
		$parts = explode('.', $theme);
		$theme = implode('/', $parts);
		$theme .= '/' . $parts[count($parts) - 1];

		$this->themes[$theme . $suffix] = APPLICATION_RESOURCES_URL . '/' . $theme . $suffix;

		return $this;
	}

	public function addDojoStyle($style)
	{
		$this->dojoStyles[$style] = $style;

		return $this;
	}

	public function addDojoConfigOption($name, $value)
	{
		$this->dojoConfig[$name] = $value;

		return $this;
	}

	public function addLayer($layer)
	{
		$this->layers[$layer] = $layer;

		return $this;
	}

	public function requireClass($clazz)
	{
		$this->requiredClasses[$clazz] = $clazz;

		return $this;
	}

	public function addOnReady($code)
	{
		$this->onReady[] = $code;

		return $this;
	}

	public function addJavaScriptFile($javascriptFile)
	{
		$this->javascriptFiles[$javascriptFile] = $javascriptFile;

		return $this;
	}

	/* ====================================================================== */

	public function set($key, $value)
	{
		$this->settings[$key] = $value;

		return $this;
	}

	/* ====================================================================== */

	private function getDojoConfig()
	{
		$config = '';
		foreach($this->dojoConfig as $key => $value) {
			$config .= $key . ':' . $value . ',';
		}
		$config = substr($config, 0, -1);

		return $config;
	}

	private function getDojoScriptElement()
	{
		$url = APPLICATION_RESOURCES_URL . '/dojo/dojo.js';

		return '<script type="text/javascript" src ="' . $url . '" charset="utf-8" data-dojo-config="' . $this->getDojoConfig() . '"></script>';
	}

	private function getLayerElement($name)
	{
		return self::getJavaScriptElement(APPLICATION_RESOURCES_URL . '/' . $name);
	}

	private function getRequiredClasses()
	{
		$src = '';
		foreach($this->requiredClasses as $clazz) {
			$src .= "\tdojo.require('" . $clazz . "');\n";
		}

		return $src;
	}

	private function getOnReady()
	{
		$src = '';
		foreach($this->onReady as $code) {
			$src .= "\tdojo.ready(function(){ " . $code . "});\n";
		}

		return $src;
	}

	/* ====================================================================== */

	public function enableCss3Pie()
	{
		$url = APPLICATION_RESOURCES_URL . '/css3pie/PIE.htc';

		$this->css3pie = '<!--[if IE]><style type="text/css">.css3pie{behavior:url(' . $url . ');}</style><![endif]-->' . PHP_EOL;

		return $this;
	}

	public function enableCss960gs()
	{
		$url = APPLICATION_RESOURCES_URL . '/960gs/960.css';

		$this->css960gs = self::getStyleSheetElement($url) . PHP_EOL;

		return $this;
	}

	/* ====================================================================== */

	public function __toString()
	{
		$this->prepare();

		$html = PHP_EOL . '<!-- === UI Bootstrap: BEGIN ================================================================================== -->' . PHP_EOL;

		// stylesheet files
		foreach($this->stylesheetFiles as $stylesheetFile) {
			$html .= self::getStyleSheetElement($stylesheetFile) . PHP_EOL;
		}

		// css3pie
		if(!empty($this->css3pie)) {
			$html .= $this->css3pie;
		}

		// 960gs
		if(!empty($this->css960gs)) {
			$html .= $this->css960gs;
		}

		if($this->theme != self::THEME_NONE) {
			// core style
			$html .= self::getStyleSheetElement(
				APPLICATION_RESOURCES_URL .
				'/dojo/resources/dojo.css') . PHP_EOL;
			// base theme
			$html .= self::getStyleSheetElement(
				APPLICATION_RESOURCES_URL .
				'/dijit/themes/' . $this->theme . '/' . $this->theme . '.css') . PHP_EOL;
		}

		// themes
		foreach($this->themes as $theme) {
			$html .= self::getStyleSheetElement($theme) . PHP_EOL;
		}

		// styles
		foreach($this->dojoStyles as $style) {
			$html .= self::getStyleSheetElement(
				APPLICATION_RESOURCES_URL . '/' . $style) . PHP_EOL;
		}

		// core script
		$html .= $this->getDojoScriptElement() . PHP_EOL;

		// layers
		if($this->environment == self::ENVIRONMENT_BUILD) {
			foreach($this->layers as $layer) {
				$html .= $this->getLayerElement($layer) . PHP_EOL;
			}
		}

		// required classes and on ready
		$bRequiredClasses = !empty($this->requiredClasses) && $this->environment != self::ENVIRONMENT_BUILD;
		$bOnReady = !empty($this->onReady);
		if($bRequiredClasses || $bOnReady) {
			$html .= '<script type="text/javascript">' . PHP_EOL;
		}
		if($bRequiredClasses) {
			$html .= $this->getRequiredClasses();
		}
		if($bOnReady) {
			$html .= $this->getOnReady();
		}
		if($bRequiredClasses || $bOnReady) {
			$html .= '</script>' . PHP_EOL;
		}

		// application settings
		if(count($this->settings) > 0 ) {
			$html .= '<script type="text/javascript">' . PHP_EOL . 'code4ge.ready(function() {' . PHP_EOL;
			foreach($this->settings as $key => $value) {
				$html .= "\tcode4ge.set('{$key}', '${value}');\n";
			}
			$html .= '});' . PHP_EOL . '</script>' . PHP_EOL;
		}

		// javascript files
		foreach($this->javascriptFiles as $javascriptFile) {
			$html .= self::getJavaScriptElement($javascriptFile) . PHP_EOL;
		}

		$html .= '<!-- === UI Bootstrap: END ==================================================================================== -->' . PHP_EOL;

		return $html;
	}

	/* ====================================================================== */

	public function setView(Zend_View_Interface $view)
	{
		$this->view = $view;
	}

	/* ====================================================================== */

	private function prepare()
	{
		if(Zend_Registry::isRegistered('session')) {
			$session = Zend_Registry::get('session');
			if(isset($session->user)) {
				$this->set('username', $session->user->name);
				$this->set('role', $session->user->role);
			}
		}
	}

}
