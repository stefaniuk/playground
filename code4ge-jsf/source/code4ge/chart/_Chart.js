define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/_WidgetTemplate',
    'dojox/charting/DataChart',
    'dojox/charting/StoreSeries',
    'dojo/_base/xhr',
    'dojo/store/Memory',
    'dojo/store/Observable',
    'dojo/fx/easing',
    'code4ge/chart/themes/code4ge'
], function(dojo, code4ge, declare, _WidgetTemplate, DataChart, StoreSeries, xhr, Memory, Observable, easing, theme) {

return declare('code4ge.chart._Chart', [ _WidgetTemplate ], {

    // module:
    //        code4ge/chart/_Chart
    // summary:
    //        Base class for all chart widgets.

    templateString: null,

    type: null,

    chart: null,

    query: null,

    queryOptions: null,

    field: 'value',

    buildRendering: function() {

        this.inherited(arguments);

        this.chart = new DataChart(this._chart, {
            type: this.type,
            //yaxis:{ min: 0, max: 100, majorTickStep: 10 }
            //xaxis: { labelFunc: 'seriesLabels' },
            //scroll: false
        });
        this.chart.setTheme(theme);

        /*var chart = this.chart;
        var myLabelFunc = function(n) {
            var item = chart.items[n - 2];

            if(item) {
                return item.name;
            }
            else {
                return '-';
            }
        };*/

        this.chart.addAxis('x', { /*min: 0,*/ /*fixUpper: 'major', fixLower: 'major', labelFunc: myLabelFunc, minorLabels: false, includeZero: true*/ });
        this.chart.addAxis('y', { vertical: true, fixUpper: 'minor', includeZero: true });

        if(dojo.isString(this.store)) {
            var registry = code4ge.get('jsonrpcstore.registry');
            this.store = registry.get(this.store);
        }
        //this.store.labelAttribute = 'nsame';
        this.chart.setStore(this.store, this.query, this.field, this.queryOptions);
        //console.log(this.store);
        this.chart.render();

        //var self = this;
        /*if(dojo.isString(this.store)) {
            var registry = code4ge.get('jsonrpcstore.registry');
            var s = registry.get(this.store);
            s.fetch({
                onComplete:  function(result) {
                    self.store = Observable(new Memory({data:result}));
                    //self.store.labelAttribute = 'name';
                    //self.chart.setStore(self.store, self.query, self.field, self.queryOptions);
                    self.chart.addSeries('PCTs', new StoreSeries(self.store, {query: {}}, self.field));
                    console.warn(self.store);
                    self.chart.render();
                },
                onError: function() {
                    console.warn(arguments);
                }
            });
        }*/
    }

});

});
