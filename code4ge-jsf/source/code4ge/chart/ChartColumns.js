define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/chart/_Chart',
    'dojo/text!./templates/ChartColumns.html',
    'dojox/charting/plot2d/Columns'
], function(dojo, code4ge, declare, _Chart, template, type) {

return declare('code4ge.chart.ChartColumns', [ _Chart ], {

    // module:
    //        code4ge/chart/ChartColumns
    // summary:
    //        ChartBars widget.

    templateString: template,

    type: type

});

});
