define([
    'dojo/_base/declare',
    'code4ge/_Widget',
    'dijit/_TemplatedMixin',
    'dijit/_WidgetsInTemplateMixin'
], function(declare, _Widget, _TemplatedMixin, _WidgetsInTemplateMixin) {

return declare('code4ge._WidgetTemplate', [ _Widget, _TemplatedMixin, _WidgetsInTemplateMixin ], {

    // module:
    //        code4ge/_WidgetTemplate
    // summary:
    //        Base class for all templated widgets.
    // features:
    //        widget template
    //        widgets in template
    //        name, tabindex

    widgetsInTemplate: true,

    name: '',

    tabindex: 0

});

});
