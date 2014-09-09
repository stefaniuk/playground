define([
    'dojo/_base/declare',
    'djext/_Widget',
    'dijit/form/FilteringSelect'
], function(declare, _Widget, FilteringSelect) {

return declare('djext.form.FilteringSelect', [ _Widget, FilteringSelect ], {

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

});
