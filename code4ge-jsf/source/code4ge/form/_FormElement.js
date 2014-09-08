define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/_WidgetTemplate',
    'dojo/text!./templates/_FormElementReadOnly.html',
    'code4ge/form/_TextBoxReadOnly'
], function(dojo, code4ge, declare, _WidgetTemplate, template) {

return declare('code4ge.form._FormElement', [ _WidgetTemplate ], {

    // module:
    //        code4ge/form/_FormElement
    // summary:
    //        Base class for all form elements.
    // features:
    //        form widget integration support
    //        value, input, validation, read-only, label

    //
    // *** form ***
    //

	// ignoreForm: if true, code4ge.form.Form will ignore this element
	ignoreForm: false,

	// forceSend: forces code4ge.form.Form to use the element despite disabled or read-only state
	forceSend: false,

    //
    // *** value ***
    //

	value: '',

    displayedValue: '',

	required: true,

    //
    // *** read-only ***
    //

    // template used while in read-only state
    readOnlyTemplateString: template,

    // class that represents a widget to be used in place of a default input widget while in read-only state
    readOnlyInputClass: 'code4ge.form._TextBoxReadOnly',

	readOnly: false,

    //
    // *** label ***
    //

    labelOnTop: true,

    labelAlign: '',

    label: '',

    labelWidth: '',

    labelColor: '',

    //
    // *** input ***
    //

    // defined in the markup as dojoAttachPoint="_input"
    _input: null,

    inputClass: '',

    inputWidth: '',

    inputColor: '',

    multiline: false,

    promptMessage: '',

    invalidMessage: '',

    selectOnClick: true,

    trim: true,

    maxlength: 50,

    //
    // *** other properties ***
    //

    // HTML code used if labelOnTop property equals true to move input to the next line
    _linebreak: '<div class="form-break-line"></div>',

    postMixInProperties: function() {

        // check for a value/content inside of the HTML node
        if(!this.value && this.srcNodeRef.innerHTML) {
            this.value = this.srcNodeRef.innerHTML;
        }

        this.inherited(arguments);

        // value
        if(this.trim && dojo.isString(this.value)) {
            this.value = dojo.trim(this.value);
        }
        if(this.trim && dojo.isString(this.displayedValue)) {
            this.displayedValue = dojo.trim(this.displayedValue);
        }

        // read-only
        if(this.readOnly && this.readOnlyInputClass) {
            this.inputClass = this.readOnlyInputClass;
            this.templateString = this.readOnlyTemplateString;
        }

        // label
        if(!this.labelOnTop) {
            this._linebreak = '';
        }

        // input
        if(this.promptMessage) {
            this.promptMessage = 'promptMessage="' + this.promptMessage + '"';
        }
        if(this.invalidMessage) {
            this.invalidMessage = 'invalidMessage="' + this.invalidMessage + '"';
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

        // set label text color
        if(this.labelColor) {
            dojo.style(this._label, 'color', this.labelColor);
        }

        // set input text color
        if(this.inputColor) {
            // TODO: more effort is required as this does not work with all widgets
            dojo.style(this._input._text ? this._input._text : this._input.domNode, 'color', this.inputColor);
        }

    },

    postCreate: function() {

        this.inherited(arguments);

        // call resize onReady
        dojo.connect(this, 'onReady', this, 'resize');

        // wire some keyboard events
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
        if(this._input.onChange) {
            dojo.connect(this._input, 'onChange', this, function(event) {
                this.onEvent('onchange', event);
            });
        }
    },

    resize: function() {

        // *************************************
        // this function is a source of all evil
        // *************************************

        // *** EVIL BEGINS ***

        // search for a grid class (960gs support)
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

        // set width
        if(gridClass || this.inputWidth) {

            var w = dojo._getMarginSize(this.domNode).w;
            var lw = dojo._getMarginSize(this._label).w;
            var iw = w - (this.labelOnTop ? 0 : lw); // substract label

            // *** grid element class was set (no input width) ***
            if(gridClass && !this.inputWidth) {
                // substract prefix and suffix
                iw = iw - dojo.style(this.domNode, 'paddingLeft') - dojo.style(this.domNode, 'paddingRight');
                // add 2px for single line read-only widget
                iw = iw + (this.readOnly && !this.multiline ? 2 : 0);
                // substract margin, border and padding from inside of an input node
                iw = iw - 22 - 2 * dojo.style(this._input.domNode, 'paddingLeft');
            }

            // *** input element width was set (no grid class) ***
            if(!gridClass && this.inputWidth) {
                // calculate input width
                iw = parseInt(this.inputWidth);
                // substract padding from inside of an input node
                iw = iw - 2 * dojo.style(this._input.domNode, 'paddingLeft');
                // substract border
                iw = iw - dojo.style(this._input.domNode, 'borderLeftWidth') - dojo.style(this._input.domNode, 'borderRightWidth');
            }

            // set widget width
            w = parseInt(this.inputWidth) + (this.labelOnTop ? 0 : lw);
            if(w > 0) { // HACK: IE
                dojo.style(this.domNode, 'width', w + 'px');
            }
            // set widget input element width
            if(iw > 0) { // HACK: IE
                dojo.style(this._input.domNode, 'width', iw + 'px');
            }
        }

        // *** EVIL ENDS ***
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

    focus: function() {

        this._input.focus();
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

});
