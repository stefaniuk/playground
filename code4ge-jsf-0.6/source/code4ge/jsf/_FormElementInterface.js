define("code4ge/jsf/_FormElementInterface", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf._FormElementInterface', [ code4ge.jsf._Widget, dijit._Templated ], {

	widgetsInTemplate: true,

	name: '',

	value: '',

    displayedValue: '',

	required: true,

	readOnly: false,

	// ignoreForm: if true, code4ge.jsf.Form will omit this element
	ignoreForm: false,

	// forceSend: forces code4ge.jsf.Form to use the value despite readOnly and disabled flag
	forceSend: false,

	tabindex: 0

});

return code4ge.jsf._FormElementInterface;
});
