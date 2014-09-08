define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/form/_FormElement'
], function(dojo, code4ge, declare, _FormElement) {

return declare('code4ge.form._FormDateTimeBox', [ _FormElement ], {

    // module:
    //        code4ge/form/_FormDateTimeBox
    // summary:
    //        Base functionality provided for date/time form widgets.

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

});
