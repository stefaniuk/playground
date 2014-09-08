define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'dijit/form/TimeTextBox'
], function(dojo, code4ge, declare, TimeTextBox) {

return declare('code4ge.form.TimeBox', [ TimeTextBox ], {

    // module:
    //        code4ge/form/TimeBox
    // summary:
    //        TimeBox widget.

    serialize: function(val, options) {

        var time = this.inherited(arguments);

        return time.substring(1);
    }

});

});
