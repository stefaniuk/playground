define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/form/_FormElement',
    'dojo/text!./templates/FormTextArea.html',
    'code4ge/form/TextArea'
], function(dojo, code4ge, declare, _FormElement, template) {

return declare('code4ge.form.FormTextArea', [ _FormElement ], {

    // module:
    //        code4ge/form/FormTextArea
    // summary:
    //        FormTextArea widget.

    templateString: template,

    inputClass: 'code4ge.form.TextArea',

    height: '',

    multiline: true,

    // do not use code4ge.form.TextReadOnly
    readOnlyInputClass: null,

    maxlength: 1000,

    postMixInProperties: function() {

        this.inherited(arguments);

        if(this.readOnly) {
            this.readOnly = 'readonly="true"';
        }

        this.value = code4ge.unescapeHTML(this.value);
    },

    postCreate: function() {

        this.inherited(arguments);

        // HACK: if IE remove dijitTextAreaCols class to allow to resize input area
        if(dojo.isIE) {
            dojo.removeClass(this._input.domNode, 'dijitTextAreaCols');
        }
    },

    resize: function() {

        this.inherited(arguments);

        if(this.height) {
            var h = parseInt(this.height);
            // set widget height
            dojo.style(this.domNode, 'height', h + 'px');
            if(this.labelOnTop) {
                h = h - dojo._getMarginSize(this._label).h; // substract lable height
            }
            if(h > 0) { // HACK: IE
                // set input height
                dojo.style(this._input.domNode, 'height', h - 6 + 'px'); // substract padding and border
            }
        }
    },

    isValid: function() {

        return !(this.required && !this._input.get('value'));
    },

    validate: function() {

        // validate
        var valid = this.isValid();
        if(!valid) {
            dojo.window.scrollIntoView(this._input.containerNode || this._input.domNode);
            this._input.focus();
        }

        return valid;
    },

    _setValueAttr: function(/*any*/value) {

        this._input.set('value', value.substr(0, this.maxlength));
    }

});

});
