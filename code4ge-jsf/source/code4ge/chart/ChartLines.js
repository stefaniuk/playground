define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'code4ge/chart/_Chart',
    'dojo/text!./templates/ChartLines.html',
    'dojox/charting/plot2d/Lines'
], function(dojo, code4ge, declare, _Chart, template, type) {

return declare('code4ge.chart.ChartLines', [ _Chart ], {

    // module:
    //        code4ge/chart/ChartLines
    // summary:
    //        ChartLines widget.

    templateString: template,

    type: type

});

});
