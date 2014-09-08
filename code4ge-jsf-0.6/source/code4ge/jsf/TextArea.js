define("code4ge/jsf/TextArea", [
	'dojo',
	'dijit',
	'dijit/form/SimpleTextarea',
	'dijit/form/ValidationTextBox'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.TextArea', [ dijit.form.SimpleTextarea, dijit.form.ValidationTextBox ], {

	templateString: '<textarea ${!nameAttrSetting} dojoAttachPoint="focusNode,containerNode,textbox" autocomplete="off"></textarea>',

	validator: function(/*anything*/value,/*dijit.form.ValidationTextBox.__Constraints*/constraints) {

		return (!this.required || !this._isEmpty(value)) &&
			(this._isEmpty(value) || this.parse(value, constraints) !== undefined);
	}

});

return code4ge.jsf.TextArea;
});
