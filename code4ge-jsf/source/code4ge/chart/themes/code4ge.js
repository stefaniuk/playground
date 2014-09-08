define([
    'dojo/_base/lang',
    'dojox/charting/themes/PlotKit/blue'
], function(lang, base) {

    var themes = lang.getObject('code4ge.chart.themes', true);

    var theme = themes.code4ge = base.clone();

    return theme;
});
