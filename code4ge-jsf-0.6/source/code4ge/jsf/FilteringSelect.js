define("code4ge/jsf/FilteringSelect", [
    'dojo',
    'dijit',
    'dijit/form/FilteringSelect'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.FilteringSelect', [ dijit.form.FilteringSelect ], {

    // allows to accept a free text
    freeText: false,

    // see: dijit.form.ComboBoxMixin
    autoComplete: false,

    // see: dijit.form.ComboBoxMixin
    queryExpr: '*${0}*',

    // see: dijit.form.ComboBoxMixin
    highlightMatch: 'all',

    isValid: function() {

        return (this.item && !(this.required && this.get('displayedValue')==''))
            || (!this.required && this.get('displayedValue') == '')
            || (this.freeText == true && this.get('displayedValue') != '');
    }

});

return code4ge.jsf.FilteringSelect;
});
