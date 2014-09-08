define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/form/_FormElement',
    'dojo/text!./templates/FormTextBox.html',
    'dijit/form/ValidationTextBox',
    'dojox/validate/regexp'
], function(dojo, code4ge, declare, _FormElement, template) {

return declare('code4ge.form.FormTextBox', [ _FormElement ], {

    // module:
    //        code4ge/form/FormTextBox
    // summary:
    //        TextBox widget.
    // features:
    //        single line text
    //        validation using regular expression
    //        text placeholder

    templateString: template,

    inputClass: 'dijit.form.ValidationTextBox',

    // if this is used, do not use regExpGen
    regExp: '',

    // if this is used, do not use regExp
    regExpGen: '',

    // input element text placeholder
    placeholder: '',

    postMixInProperties: function() {

        this.inherited(arguments);

        // set regular expression to validate input
        if(this.regExp) {
            this.regExp = 'regExp="' + this.regExp + '"';
        }
        else if(this.regExpGen) {
            this.regExpGen = 'regExpGen="' + this.regExpGen + '"';
        }
    },

    buildRendering: function() {

        this.inherited(arguments);

        this._fixFocus('.dijitValidationInner', this._input);

        // show placeholder
        if(this.placeholder) {
            var self = this;
            dojo.query('div.dijitInputField', this.domNode).forEach(function(node) {
                // create placeholder
                var p = dojo.create('div', {
                    'class': 'form-textbox-input-placeholder',
                    innerHTML: self.placeholder
                }, node, 'first');
                // store here font size for later use
                var pfs;
                // show/hide placeholder
                dojo.query('input', node).connect('onkeydown', function(event) {
                    // save font size
                    if(!pfs) {
                        pfs = parseInt(dojo.style(p, 'fontSize'));
                    }
                    dojo.animateProperty({node: p, properties: {
                        fontSize: 0,
                        opacity: 0
                    }}).play();
                }).connect('onblur', function(event) {
                    if(dojo.trim(event.target.value).length == 0){
                        dojo.animateProperty({node: p, properties: {
                            fontSize: pfs,
                            opacity: 1
                        }}).play();
                    }
                });
            });
        }
    }

});

});
