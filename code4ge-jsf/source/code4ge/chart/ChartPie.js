define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/chart/_Chart',
    'dojo/text!./templates/ChartPie.html',
    'dojox/charting/plot2d/Pie'
], function(dojo, code4ge, declare, _Chart, template, type) {

return declare('code4ge.chart.ChartPie', [ _Chart ], {

    // module:
    //        code4ge/chart/ChartPie
    // summary:
    //        ChartPie widget.

    templateString: template,

    type: type

});

});
