<?php

class Code4ge_CMF_View_Helper_Navigation_Menu extends Zend_View_Helper_Navigation_Menu
{

	protected function _renderMenu(Zend_Navigation_Container $container, $ulClass, $indent, $minDepth, $maxDepth, $onlyActive)
	{
		$html = parent::_renderMenu($container, $ulClass, $indent, $minDepth, $maxDepth, $onlyActive);
		
		// TODO: improve it
		$html = preg_replace('/<ul/', '<ul dojoType="code4ge.jsf.Navigation"', $html, 1);
		
		return $html;
	}

	public function htmlify(Zend_Navigation_Page $page)
	{
		$html = parent::htmlify($page);
		
		// TODO: improve it
		if($page instanceof Code4ge_CMF_Navigation_Page_Menu) {
			$html = preg_replace('/title=/', 'dojoType="code4ge.jsf.NavigationMenuItem" title=', $html, 1);
		}
		else {
			$html = preg_replace('/title=/', 'dojoType="code4ge.jsf.NavigationItem" title=', $html, 1);
		}
		
		return $html;
	}

}
