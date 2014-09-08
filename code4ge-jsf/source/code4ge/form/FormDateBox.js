define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/form/_FormDateTimeBox',
    'dojo/text!./templates/FormDateBox.html',
    'dijit/form/DateTextBox',
    'code4ge/date'
], function(dojo, code4ge, declare, _FormDateTimeBox, template) {

return declare('code4ge.form.FormDateBox', [ _FormDateTimeBox ], {

    // module:
    //        code4ge/form/FormDateBox
    // summary:
    //        FormDateBox widget.

    templateString: template,

    inputClass: 'dijit.form.DateTextBox',

    maxlength: 15,

    constraints: '{selector:\'date\',datePattern:\'yyyy-MM-dd\'}',

    postMixInProperties: function() {

        if(this.value) {
            // TODO: use code4ge.date.parse
            var v = this.value;
            v = v.replace(/-/g, '/');
            v = v.replace(/\.[\d]*$/i, '');
            this.value = new Date(v);
        }

        this.inherited(arguments);

        // set constraints
        this.constraints = dojo.mixin(
            { selector: 'date' }, // make sure only date is selected
            dojo.fromJson(this.constraints)
        );
        // format value
        if(this.value && this.readOnly && this.constraints) {
            this.value = dojo.date.locale.format(this.value, this.constraints);
        }
    }

});

});
