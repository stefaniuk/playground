define("code4ge/jsf/FormMessageBox", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated',
	'text!code4ge/jsf/templates/FormMessageBox.html'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.FormMessageBox', [ code4ge.jsf._Widget, dijit._Templated ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/FormMessageBox.html')

});

return code4ge.jsf.FormMessageBox;
});
