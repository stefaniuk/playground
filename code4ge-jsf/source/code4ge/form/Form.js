define([
    'dojo',
    'dijit',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/_Widget',
    'dijit/form/Form',
    'code4ge/form/_FormElement'
], function(dojo, dijit, code4ge, declare, _Widget, Form, _FormElement) {

var declaredWidget = declare('code4ge.form.Form', [ _Widget, Form ], {

    // module:
    //        code4ge/form/Form
    // summary:
    //        Form widget.
    // features:
    //        TODO

    readOnly: false,

    // array of form elements
    elements: null,

    // hash of form elements, name => element
    _ref: null,

    // code4ge.form.FormChangeDetector
    //_cd: null,

    buildRendering: function() {

        if(this.readOnly) {
            var self = this;
            // set read-only flag on all form widgets, WARNING: form id has to be set
            dojo.query('[dojoType]', dojo.byId(this.id)).forEach(function(node) {
                var dojoType = node.getAttribute('dojoType');
                if(self._types[dojoType]) {
                    node.setAttribute('readOnly', true);
                }
            });
        }

        this.inherited(arguments);
    },

    startup: function() {

        var self = this;

        var _names = [];
        this.elements = new dojo.NodeList();
        // search for all form widgets
        dojo.query('[widgetId]', this.domNode).forEach(function(node) {
            var widget = dijit.byNode(node);
            if(self._types[widget.declaredClass] && !widget.ignoreForm) {
                // save a reference
                self.elements.push(widget);
                // save names to avoid duplicates
                _names.push(widget.get('name'));
                // connect to a widget event
                self.connect(widget, 'onEvent', function(type, event) {
                    self.onEvent(widget, type, event);
                });
            }
        });
        // search for all hidden inputs
        dojo.query('input[type="hidden"]', this.domNode).forEach(function(node) {
            var name = node.getAttribute('name');
            // only with a given name diffrent than widgets
            if(name && dojo.indexOf(_names, name) < 0) {
                self.elements.push(node);
            }
        });

        // create hash of form elements
        this._ref = {};
        this.elements.forEach(function(element) {
            if(element instanceof code4ge.form._FormElement) {
                self._ref[element.get('name')] = element;
            }
            else {
                self._ref[element.getAttribute('name')] = element;
            }
        });

        // track form changes if class FormChangeDetector was loaded
        if(code4ge.form.FormChangeDetector) {
            this._cd = new code4ge.form.FormChangeDetector({
                form: this
            });
        }

        this.inherited(arguments);
    },

    addElement: function(/*string|code4ge.form._FormElement*/element) {

        element = dijit.byId(element)
        if(this._types[element.declaredClass]) {
            this.elements.push(element);
            this._ref[element.get('name')] = element;
        }

        if(this._cd) {
            // refresh form change detector
            this._cd.refresh();
        }
    },

    _setValuesAttr: function(/*object*/values) {

        for(var name in values) {
            var element = this._ref[name];
            if(element instanceof code4ge.form._FormElement) {
                element.set('value', values[name]);
            }
            else {
                element.setAttribute('value', values[name]);
            }
        }
    },

    _getValuesAttr: function() {

        var data = {};
        this.elements.forEach(function(element) {
            if(element instanceof code4ge.form._FormElement) {
                if((!element.get('readOnly') && !element.get('disabled')) || element.get('forceSend')) {
                    data[element.get('name')] = element.get('value');
                }
            }
            else {
                data[element.getAttribute('name')] = element.value;
            }
        });

        return data;
    },

    _setDisabledAttr: function(/*boolean*/value) {

        for(var i=0; i<this.elements.length; i++) {
            var element = this.elements[i];
            if(element instanceof code4ge.form._FormElement) {
                element.set('disabled', value);
            }
            else {
                element.setAttribute('disabled', value);
            }
        }
    },

    _getChangeDetectorAttr: function() {

        if(this._cd) {
            return this._cd;
        }

        return null;
    },

    _getHiddenValuesAttr: function() {

        var data = {};
        this.elements.forEach(function(element) {
            if(!(element instanceof code4ge.form._FormElement)) {
                data[element.name] = element.value;
            }
        });

        return data;
    },

    validate: function() {

        var valid = true;

        var tabindex = 0xFFFF;
        var elemToFocus = null;

        for(var name in this._ref) {
            var element = this._ref[name];
            if(element.validate && !element.validate()) {
                valid = false;
                if(element.tabindex < tabindex) {
                    tabindex = element.tabindex;
                    elemToFocus = element;
                }
            }
        }

        // set focus to the first not valid element on the form
        if(!valid) {
            elemToFocus.focus();
        }

        return valid;
    },

    reset: function(){

        for(var i=0; i<this.elements.length; i++) {
            var element = this.elements[i];
            if(element.reset) {
                element.reset();
            }
        }
    },

    onEvent: function(/*code4ge.form._FormElement*/element, /*string*/type, /*object*/event) {

    }

});

declaredWidget.prototype._types = {
    'code4ge.form.FormDateBox': true,
    'code4ge.form.FormEditor': true,
    'code4ge.form.FormPassword': true,
    'code4ge.form.FormSelectBox': true,
    'code4ge.form.FormTextArea': true,
    'code4ge.form.FormTextBox': true,
    'code4ge.form.FormTimeBox': true
}

return declaredWidget;

});
