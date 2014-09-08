define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/chart/_Chart',
    'dojo/text!./templates/ChartBars.html',
    'dojox/charting/plot2d/Bars'
], function(dojo, code4ge, declare, _Chart, template, type) {

return declare('code4ge.chart.ChartBars', [ _Chart ], {

    // module:
    //        code4ge/chart/ChartBars
    // summary:
    //        ChartBars widget.

    templateString: template,

    type: type

});

});
