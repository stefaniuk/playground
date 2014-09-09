define([
    'dojo/_base/declare',
    'djext/_Widget',
    'dojox/dtl/_DomTemplated',
    'dojox/dtl/tag/logic'
], function(declare, _Widget, _DomTemplated) {

return declare('djext._WidgetTemplated', [ _Widget, _DomTemplated ], {

    // module:
    //        djext/_WidgetTemplated
    // summary:
    //        Base class for all templated widgets.
    // features:
    //        DTL support

    widgetsInTemplate: false

});

});
