define("code4ge/jsf/FormPassword", [
	'dojo',
	'dijit',
	'code4ge/jsf/_FormElement',
	'dijit/form/ValidationTextBox',
	'text!code4ge/jsf/templates/FormPassword.html',
	'i18n!code4ge/jsf/nls/FormPassword'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.FormPassword', [ code4ge.jsf._FormElement ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/FormPassword.html'),

	inputClass: 'dijit.form.ValidationTextBox',

	maxlength: 50,

	trim: false,

	confirm: '',

	postMixInProperties: function() {

		dojo.mixin(this, {
			localization: dojo.i18n.getLocalization('code4ge.jsf', 'FormPassword')
		});

		this.inherited(arguments);
	},

	buildRendering: function() {

		this.inherited(arguments);

		this._fixFocus('.dijitValidationInner', this._input);

		var self = this;
		dojo.mixin(this._input, {
			getErrorMessage: function() {
				if(self.confirm && self.get('value') != self.confirm.get('value')) {
					return self.localization.passwordsAreDiffrent;
				}
				return (this.required && this._isEmpty(this.textbox.value)) ? this.missingMessage : this.invalidMessage;
			},
			isValid: function() {
				return this.validator(this.textbox.value, this.constraints) &&
					(self.confirm == '' || (dojo.isObject(self.confirm) && self.get('value') == self.confirm.get('value')));
			}
		});
	},

	startup: function() {

		this.inherited(arguments);

		if(dojo.isString(this.confirm)) {
			// get reference to the other widget
			this.confirm = dijit.byId(this.confirm);
			// set reference of the other widget
			this.confirm.confirm = this;
		}
	},

	onEvent: function(type, event) {

		if(this.confirm && type == 'onkeyup') {
			this.validate();
			this.confirm.validate();
		}
	},

	onBlur: function() {

		if(this.confirm) {
			this.validate();
			this.confirm.validate();
		}
	}

});

return code4ge.jsf.FormPassword;
});
