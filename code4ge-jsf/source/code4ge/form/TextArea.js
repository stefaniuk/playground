define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'dijit/form/SimpleTextarea',
    'dijit/form/ValidationTextBox'
], function(dojo, code4ge, declare, SimpleTextarea, ValidationTextBox) {

return declare('code4ge.form.TextArea', [ SimpleTextarea, ValidationTextBox ], {

    // module:
    //        code4ge/form/TextArea
    // summary:
    //        TextArea widget.

    templateString: '<textarea ${!nameAttrSetting} dojoAttachPoint="focusNode,containerNode,textbox" autocomplete="off"></textarea>',

    validator: function(/*anything*/value,/*dijit.form.ValidationTextBox.__Constraints*/constraints) {

        return (!this.required || !this._isEmpty(value)) &&
            (this._isEmpty(value) || this.parse(value, constraints) !== undefined);
    }

});

});
