define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/_WidgetTemplate'
], function(dojo, code4ge, declare, _WidgetTemplate) {

return declare('code4ge.form._TextBoxReadOnly', [ _WidgetTemplate ], {

    // module:
    //        code4ge/form/_TextBoxReadOnly
    // summary:
    //        This widget should be used as an input replacement when a form element is read-only.

    templateString: '<div dojoAttachPoint="_text" style="overflow:auto"></div>',

    value: '',

    displayedValue: '',

    _setValueAttr: function(value) {

        this.value = value;

        if(!this.displayedValue || this._started) {
            this.set('displayedValue', value);
        }
    },

    _setDisplayedValueAttr: function(value) {

        this.displayedValue = value;

        this._text.innerHTML = value;
    },

    _getDisplayedValueAttr: function() {

        return this._text.innerHTML;
    },

    resize: function(size) {

        if(size.w) {
            dojo.style(this._text, 'width', size.w + 'px');
        }
        if(size.h) {
            dojo.style(this._text, 'height', size.h + 'px');
        }
    }

});

});
