define([
    'dojo',
    'dijit',
    'dojo/_base/declare',
    'dijit/_WidgetBase',
    'dijit/_CssStateMixin',
    'dijit/_TemplatedMixin',
    'dijit/_WidgetsInTemplateMixin',
    'dojo/text!./templates/FilterItem.html',
    // classes referenced in the template:
    'dijit/form/CheckBox'
], function(dojo, dijit, declare, _WidgetBase, _CssStateMixin, _TemplatedMixin, _WidgetsInTemplateMixin, template) {

var declaredWidget = declare('nhs.FilterItem', [ _WidgetBase, _CssStateMixin, _TemplatedMixin, _WidgetsInTemplateMixin ], {

    // module:
    //        nhs/FilterItem
    // summary:
    //        ?
    // features:
    //        ?

    widgetsInTemplate: true,

    templateString: template,

    name: '',

    label: '',

    parent: null,

    _setCheckedAttr: function(checked) {

        this.checkbox.set('checked', checked);
    },

    _getCheckedAttr: function() {

        return this.checkbox.get('checked');
    },

    _onClick: function() {

        this.parent.onChange(this);
    }

});

return declaredWidget;

});
