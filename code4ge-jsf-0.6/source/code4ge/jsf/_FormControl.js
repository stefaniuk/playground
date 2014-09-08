define("code4ge/jsf/_FormControl", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf._FormControl', [ code4ge.jsf._Widget, dijit._Templated ], {

	widgetsInTemplate: true,

	name: '',

	label: '',

	tabindex: 0,

	_setDisabledAttr: function(/*boolean*/disabled) {

		this._control.set('disabled', disabled);
	},

	_getDisabledAttr: function() {

		return this._control.get('disabled');
	}

});

return code4ge.jsf._FormControl;
});
