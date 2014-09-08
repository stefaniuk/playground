define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/_WidgetTemplate',
    'dojo/text!./templates/FormLabel.html'
], function(dojo, code4ge, declare, _WidgetTemplate, template) {

return declare('code4ge.form.FormLabel', [ _WidgetTemplate ], {

    // module:
    //        code4ge/form/FormLabel
    // summary:
    //        FormLabel widget.

    templateString: template,

    label: '',

    labelWidth: '',

    labelColor: '',

    labelAlign: '',

    buildRendering: function() {

        this.inherited(arguments);

        // set label text color
        if(this.labelColor) {
            dojo.style(this._label, 'color', this.labelColor);
        }

        // set label aligin
        if(this.labelAlign) {
            dojo.style(this._label, 'textAlign', this.labelAlign);
        }
    },

    postCreate: function() {

        this.inherited(arguments);

        // call resize onReady
        dojo.connect(this, 'onReady', this, 'resize');
    },

    resize: function() {

        // set label width
        if(this.labelWidth) {
            dojo.style(this._label, 'width', parseInt(this.labelWidth) - 4 + 'px');
        }
    },

    _setLabelAttr: function(/*any*/value) {

        this.label = value;

        this._label.innerHTML = value;
    },

    _getLabelAttr: function() {

        return this.label;
    }

});

});
