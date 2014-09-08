define("code4ge/jsf/FormDateBox", [
	'dojo',
	'dijit',
	'code4ge/jsf/_FormDateTimeBox',
	'code4ge/jsf/date',
	'dijit/form/DateTextBox',
	'text!code4ge/jsf/templates/FormDateBox.html'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.FormDateBox', [ code4ge.jsf._FormDateTimeBox ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/FormDateBox.html'),

	inputClass: 'dijit.form.DateTextBox',

	maxlength: 15,

	constraints: '{selector:\'date\',datePattern:\'yyyy-MM-dd\'}',

	postMixInProperties: function() {

		if(this.value) {
			// TODO: use code4ge.jsf.date.parse
			var v = this.value;
			v = v.replace(/-/g, '/');
			v = v.replace(/\.[\d]*$/i, '');
			this.value = new Date(v);
		}

		this.inherited(arguments);

		// set constraints
		this.constraints = dojo.mixin(
			{ selector: 'date' }, // make sure it is only date
			dojo.fromJson(this.constraints)
		);
		// format value
		if(this.value && this.readOnly && this.constraints) {
			this.value = dojo.date.locale.format(this.value, this.constraints);
		}
	}

});

return code4ge.jsf.FormDateBox;
});
