define("code4ge/jsf/_FormDateTimeBox", [
	'dojo',
	'dijit',
	'code4ge/jsf/_FormElement'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf._FormDateTimeBox', [ code4ge.jsf._FormElement ], {

	constraints: '',

	_constraints: '',

	postMixInProperties: function() {

		this.inherited(arguments);

		if(this.value == '') {
			this.value = null;
		}

		if(!this.readOnly && this.constraints) {
			this._constraints = 'constraints="' + this.constraints + '"';
		}
	},

	buildRendering: function() {

		this.inherited(arguments);

		this._fixFocus('.dijitValidationInner', this._input);
	},

	resize: function() {

		this.inherited(arguments);

		var ih = dojo._getMarginSize(this._input.domNode).h;
		if(ih > 0) { // HACK: IE
			// set arrow button container height
			dojo.query('.dijitArrowButtonContainer', this._input.domNode).forEach(function(node) {
				dojo.style(node, 'height', ih - 4 + 'px');
			});
		}
	},

	_getValueAttr: function() {

		var value = this._input.get('value');

		if(value && !dojo.isString(value)) {
			// return formatted string by the defult pattern
			value = dojo.date.locale.format(
				value,
				dojo.fromJson(this.constructor.prototype.constraints)
			);
		}

		return value;
	},

	_getFormattedValueAttr: function() {

		var value = this._input.get('value');

		if(value && !dojo.isString(value) && this.constraints) {
			// return formatted string by custom pattern
			value = dojo.date.locale.format(value, this.constraints);
		}

		return value;
	},

	_getDateAttr: function() {

		return this._input.get('value');
	}

});

return code4ge.jsf._FormDateTimeBox;
});
