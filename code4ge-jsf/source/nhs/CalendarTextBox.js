define([
    'dojo/_base/declare',
    'dijit/form/_DateTimeTextBox',
    'dojox/widget/_CalendarBase',
    'dojox/widget/_CalendarMonth',
    'dojox/widget/_CalendarYear'
], function(declare, _DateTimeTextBox, _CalendarBase, _CalendarMonth, _CalendarYear) {

var CustomCalendar = declare('nhs.CustomCalendar', [
    _CalendarBase,
    _CalendarMonth,
    _CalendarYear
], {
    _adjustDisplay: function(part, amount, noSlide) {
        var child = this._children[this._currentChild];
        var date = this.displayMonth = child.adjustDate(this.displayMonth, amount);
        this._slideTable(child, amount, function() {
            child.set('value', date);
        });
        this.value = date;
    }
});

var declaredWidget = declare('nhs.CalendarTextBox', _DateTimeTextBox, {

    // module:
    //        nhs/CalendarTextBox
    // summary:
    //        This is a calendar widget with custom display.
    // features:
    //        Shows month and year only.

    baseClass: 'dijitTextBox dijitComboBox dijitDateTextBox',

    popupClass: CustomCalendar,

    _selector: 'date',

    value: new Date(''),

    postCreate: function() {

        this.inherited(arguments);

        this.constraints = {
            selector: 'date',
            datePattern: 'MMM yyyy',
            strict: true
        };
    }

});

return declaredWidget;

});
