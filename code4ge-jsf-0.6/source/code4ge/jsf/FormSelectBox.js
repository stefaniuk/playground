define("code4ge/jsf/FormSelectBox", [
	'dojo',
	'dijit',
	'code4ge/jsf/_FormElement',
	'code4ge/jsf/FilteringSelect',
	'text!code4ge/jsf/templates/FormSelectBox.html'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.FormSelectBox', [ code4ge.jsf._FormElement ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/FormSelectBox.html'),

	inputClass: 'code4ge.jsf.FilteringSelect',

	maxlength: 20,

    // allows to accept a free text
    freeText: false,

    // see: dijit.form.ComboBoxMixin
    autoComplete: false,

    // see: dijit.form.ComboBoxMixin
    queryExpr: '*${0}*',

    // see: dijit.form.ComboBoxMixin
    highlightMatch: 'all',

	// options defined in the markup
	_options: '',

	postMixInProperties: function() {

		this.inherited(arguments);

		// get options
		this._options = this.srcNodeRef ? this.srcNodeRef.innerHTML : null;

		// parse options if this is a select box and replace value with text
		if(this.readOnly) {
			this._fixValue();
		}
	},

	buildRendering: function() {

		this.inherited(arguments);

        // set displayed value if select box is read-only
        if(this.readOnly) {
            this._input.set('displayedValue', this.__readOnlyDisplayedValue);
        }

		this._fixFocus('.dijitArrowButtonInner', this._input);
	},

	_fixValue: function() {

		var node = dojo.create('div', {
			innerHTML: '<select>' + this._options + '</select>'
		});
		var select = node.firstChild;
		for(var i=0; i < select.length; i++) {
			var option = select.options[i];
			if(this.value == option.value) {
                this.__readOnlyDisplayedValue = option.text;
				break;
			}
		}
		delete node;
	},

	_getValueAttr: function() {

        var value = this._input.get('value');

        // if the select is a free text filed get the displayed value
        if(!value && this.freeText && !this.readOnly) {
            var displayedValue = this._input.get('displayedValue');
            if(displayedValue) {
                value = displayedValue;
            }
        }

		return value;
	}

});

return code4ge.jsf.FormSelectBox;
});
