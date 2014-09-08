define("code4ge/jsf/_FormElement", [
	'dojo',
	'dijit',
	'code4ge/jsf/_FormElementInterface',
	'code4ge/jsf/TextReadOnly'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf._FormElement', [ code4ge.jsf._FormElementInterface ], {

	readOnlyTemplateString: dojo.cache('code4ge.jsf', 'templates/FormTextReadOnly.html'),

	labelOnTop: true,

	labelAlign: '',

	label: '',

	// defined in the markup as dojoAttachPoint="_input"
	_input: null,

	inputClass: '',

	labelWidth: '',

	inputWidth: '',

	multiline: false,

	labelColor: '',

	textColor: '',

	promptMessage: '',

	invalidMessage: '',

	readOnlyInputClass: 'code4ge.jsf.TextReadOnly',

	selectOnClick: true,

	trim: true,

	maxlength: 50,

	_linebreak: '<div class="form-break-line"></div>',

	postMixInProperties: function() {

        // check for a value/content inside of the HTML node
        if(!this.value && this.srcNodeRef.innerHTML) {
            this.value = this.srcNodeRef.innerHTML;
        }

		this.inherited(arguments);

		if(this.promptMessage) {
			this.promptMessage = 'promptMessage="' + this.promptMessage + '"';
		}

		if(this.invalidMessage) {
			this.invalidMessage = 'invalidMessage="' + this.invalidMessage + '"';
		}

		if(this.readOnly && this.readOnlyInputClass) {
			this.inputClass = this.readOnlyInputClass;
			this.templateString = this.readOnlyTemplateString;
		}

		if(!this.labelOnTop) {
			this._linebreak = '';
		}

		if(this.trim && dojo.isString(this.value)) {
			this.value = dojo.trim(this.value);
		}
		if(this.trim && dojo.isString(this.displayedValue)) {
			this.displayedValue = dojo.trim(this.displayedValue);
		}
	},

	buildRendering: function() {

		this.inherited(arguments);

		// set label location class
		dojo.addClass(this.domNode, this.labelOnTop ? 'form-widget-labelontop' : 'form-widget-labelonleft');

		// set label aligin
		if(!this.labelOnTop && this.labelAlign) {
			dojo.style(this._label, 'textAlign', this.labelAlign);
		}

		// do not wrap value if this is single line read-only widget
		if(this.readOnly && !this.multiline) {
			dojo.style(this._input._text, {
				'whiteSpace': 'nowrap',
				'overflow': 'hidden'
			});
		}

		if(this.labelColor) {
			dojo.style(this._label, 'color', this.labelColor);
		}
		if(this.textColor) {
			/* TODO: more work required as not all widgets work with this */
			dojo.style(this._input._text ? this._input._text : this._input.domNode, 'color', this.textColor);
		}

	},

	postCreate: function() {

		this.inherited(arguments);

		// call resize on ready
		dojo.connect(this, 'onReady', this, 'resize');

		// wire keyboard events
		if(this._input.onKeyPress) {
			dojo.connect(this._input, 'onKeyPress', this, function(event) {
				this.onEvent('onkeypress', event);
			});
		}
		if(this._input.onKeyUp) {
			dojo.connect(this._input, 'onKeyUp', this, function(event) {
				this.onEvent('onkeyup', event);
			});
		}
		if(this._input.onKeyUp) {
			dojo.connect(this._input, 'onChange', this, function(event) {
				this.onEvent('onchange', event);
			});
		}
	},

	resize: function() {

		// search for a grid class
		var gridClass = code4ge.hasClass(this.domNode, 'grid_');

		// set label width
		if(this.labelWidth) {
			dojo.style(this._label, 'width', parseInt(this.labelWidth) - 4 + 'px');
		}
		// set widget width
		if(this.inputWidth && !gridClass) {
			var w = dojo._getMarginSize(this._label).w + parseInt(this.inputWidth);
			if(w > 0) { // HACK: IE
				dojo.style(this.domNode, 'width', w + 'px');
			}
		}
		// set input width
		if(gridClass || this.inputWidth) {
			var w = dojo._getMarginSize(this.domNode).w;
			var lw = dojo._getMarginSize(this._label).w;
			var iw = w - (this.labelOnTop ? 0 : lw); // substract label
			// grid
			if(gridClass && !this.inputWidth) {
				// substract prefix and suffix
				iw = iw - dojo.style(this.domNode, 'paddingLeft') - dojo.style(this.domNode, 'paddingRight');
				// add 2px for single line read-only widget
				iw = iw + (this.readOnly && !this.multiline ? 2 : 0);
				// substract margin, border and padding from inside of an input node
				iw = iw - 22 - 2 * dojo.style(this._input.domNode, 'paddingLeft');
			}
			// no grid
			if(!gridClass && this.inputWidth) {
				iw = iw - (this.readOnly ? 0 : 2); // substract border
			}

			if(iw > 0) { // HACK: IE
				dojo.style(this._input.domNode, 'width', iw + 'px');
			}
		}
	},

	focus: function() {

		this._input.focus();
	},

	isValid: function() {

		var v = true;
		if(this._input.isValid) {
			v = this._input.isValid();
		}

		return v;
	},

	validate: function(/*boolean*/isFocused) {

		var valid = true;
		if(!this.disabled && this._input.validate) {
			// validate
			valid = this._input.validate(isFocused);
			if(!valid) {
				dojo.window.scrollIntoView(this._input.containerNode || this._input.domNode);
				this._input.focus();
			}
			// close pop-up box
			if(this._input._close) {
				var self = this;
				setTimeout(function() { self._input._close(); }, 10);
			}
		}

		return valid;
	},

	reset: function() {

		this._input.reset();
	},

	_fixFocus: function(/*string*/query,/*domNode*/node) {

		if(dojo.isFF) {
			// HACK: in FF focus is lost after validation
			dojo.query(query, this.domNode).forEach(function(item) {
				dojo.connect(item, 'onfocus', function() {
					node.focusNode.focus();
				})
			});
		}
	},

	_setValueAttr: function(/*any*/value) {

        this.value = value;

		this._input.set('value', value);
	},

	_getValueAttr: function() {

		return this._input.get('value');
	},

	_setDisplayedValueAttr: function(/*any*/value) {

        this.displayedValue = value;

		this._input.set('displayedValue', value);
	},

	_getDisplayedValueAttr: function() {

		return this._input.get('displayedValue');
	},

	_setDisabledAttr: function(/*boolean*/disabled) {

		this.inherited(arguments);

		this._input.set('disabled', disabled);
	},

	onEvent: function(type, event) {

	}

});

return code4ge.jsf._FormElement;
});
