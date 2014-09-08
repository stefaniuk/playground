define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/form/_FormDateTimeBox',
    'dojo/text!./templates/FormTimeBox.html',
    'code4ge/form/TimeBox',
    'code4ge/date'
], function(dojo, code4ge, declare, _FormDateTimeBox, template) {

return declare('code4ge.form.FormTimeBox', [ _FormDateTimeBox ], {

    // module:
    //        code4ge/form/FormTimeBox
    // summary:
    //        FormTimeBox widget.

    templateString: template,

    inputClass: 'code4ge.form.TimeBox',

    maxlength: 5,

    constraints: '{selector:\'time\',formatLength:\'short\'}',

    postMixInProperties: function() {

        // parse value
        if(this.value) {
            this.value = code4ge.date.parse(this.value)
        }

        this.inherited(arguments);

        // set constraints
        this.constraints = dojo.mixin(
            { selector: 'time' }, // make sure only time is selected
            dojo.fromJson(this.constraints)
        );
        // format value
        if(this.value && this.readOnly && this.constraints) {
            this.value = dojo.date.locale.format(this.value, this.constraints);
        }
    }

});

});
