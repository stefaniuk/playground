define("code4ge/jsf/FormTimeBox", [
	'dojo',
	'dijit',
	'code4ge/jsf/_FormDateTimeBox',
	'code4ge/jsf/date',
	'code4ge/jsf/TimeBox',
	'text!code4ge/jsf/templates/FormTimeBox.html'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.FormTimeBox', [ code4ge.jsf._FormDateTimeBox ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/FormTimeBox.html'),

	inputClass: 'code4ge.jsf.TimeBox',

	maxlength: 5,

	constraints: '{selector:\'time\',formatLength:\'short\'}',

	postMixInProperties: function() {

		// parse value
		if(this.value) {
			this.value = code4ge.jsf.date.parse(this.value)
		}

		this.inherited(arguments);

		// set constraints
		this.constraints = dojo.mixin(
			{ selector: 'time' }, // make sure it is only time
			dojo.fromJson(this.constraints)
		);
		// format value
		if(this.value && this.readOnly && this.constraints) {
			this.value = dojo.date.locale.format(this.value, this.constraints);
		}
	}

});

return code4ge.jsf.FormTimeBox;
});
