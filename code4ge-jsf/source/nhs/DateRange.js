define([
    'dojo',
    'dijit',
    'dojo/_base/declare',
    'dojo/aspect',
    'dojo/ready',
    'dijit/_WidgetBase',
    'dijit/_CssStateMixin',
    'dijit/_TemplatedMixin',
    'dijit/_WidgetsInTemplateMixin',
    'dojo/text!./templates/DateRange.html',
    // classes referenced in the template:
    'dojox/form/RangeSlider',
    'nhs/CalendarTextBox'
], function(dojo, dijit, declare, aspect, ready, _WidgetBase, _CssStateMixin, _TemplatedMixin, _WidgetsInTemplateMixin, template) {

var declaredWidget = declare('nhs.DateRange', [ _WidgetBase, _CssStateMixin, _TemplatedMixin, _WidgetsInTemplateMixin ], {

    // module:
    //        nhs/DateRange
    // summary:
    //        ?
    // features:
    //        ?

    widgetsInTemplate: true,

    templateString: template,

    name: '',

    label: '',

    parent: null,

    initialFromDate: null,

    initialToDate: null,

    _lock_slider: false,

    _lock_dates: false,

    buildRendering: function() {

        this.inherited(arguments);

        // range slider
        if(!this.initialFromDate) {
            this.initialFromDate = new Date((new Date()).getFullYear() - 1, 0, 1);
        }
        if(!this.initialToDate) {
            this.initialToDate = new Date();
        }

        var self = this;
        aspect.after(this.rangeSlider, 'onChange', function(arg1, arg2) {
            if(self._lock_dates) {
                return;
            }
            self._lock_slider = true;
            var pos = arg2[0];
            var d1 = new Date(self.initialFromDate);
            self.dateFrom.set('value', new Date(d1.setMonth(d1.getMonth() + pos[0])));
            var d2 = new Date(self.initialFromDate);
            self.dateTo.set('value', new Date(d2.setMonth(d2.getMonth() + pos[1])));
            self.onChange();
            self._lock_slider = false;
        });
        aspect.after(this.dateFrom, 'onChange', function(arg1, arg2) {
            if(self._lock_slider) {
                return;
            }
            self._lock_dates = true;
            var date = arg2[0];
            var cur = self.rangeSlider.get('value');
            self.rangeSlider.set('value', [self._getDateDiffMonths(self.initialFromDate, date), cur[1]]);
            self.onChange();
            self._lock_dates = false;
        });
        aspect.after(this.dateTo, 'onChange', function(arg1, arg2) {
            if(self._lock_slider) {
                return;
            }
            self._lock_dates = true;
            var date = arg2[0];
            var cur = self.rangeSlider.get('value');
            self.rangeSlider.set('value', [cur[0], self._getDateDiffMonths(self.initialFromDate, date)]);
            self.onChange();
            self._lock_dates = false;
        });
    },

    init: function(daterange) {

        // set values
        var count = this._getDateDiffMonths(this.initialFromDate, this.initialToDate);
        this.rangeSlider.set('minimum', 0);
        this.rangeSlider.set('maximum', count);
        this.rangeSlider.set('value', [0, count]);
        this.rangeSlider.set('discreteValues', count);
        this.dateFrom.constraints.min = this.initialFromDate;
        this.dateTo.constraints.max = this.initialToDate;
        this.set('value', {
            from: this.initialFromDate,
            to: this.initialToDate
        });
    },

    _setValueAttr: function(daterange) {

        /*
            data format:
            ============

            daterange = {
                from: date,
                to: date
            };
        */

        if(daterange.from) {
            this.dateFrom.set('value', new Date(daterange.from));
        }
        if(daterange.to) {
            this.dateTo.set('value', new Date(daterange.to));
        }
    },

    _getValueAttr: function() {

        /*
            data format:
            ============

            daterange = {
                from: date,
                to: date
            };
        */

        var daterange = {
            from: this.dateFrom.get('value'),
            to: this.dateTo.get('value')
        };

        return daterange;
    },

    _onFromDateChange: function() {

        this.dateTo.constraints.min = this.dateFrom.get('value');
    },

    _onToDateChange: function() {

        this.dateFrom.constraints.max = this.dateTo.get('value');
    },

    _getDateDiffMonths: function(date1, date2) {

        var months = (date2.getFullYear() - date1.getFullYear()) * 12;
        months -= date1.getMonth();
        months += date2.getMonth();

        return months;
    },

    getNumberOfMonths: function() {

        return this._getDateDiffMonths(this.dateFrom.get('value'), this.dateTo.get('value'));
    },

    onChange: function() {

        this.parent.onChange(this);
    }

});

return declaredWidget;

});
