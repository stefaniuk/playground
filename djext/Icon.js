define([
    /* widget */
    'dojo/_base/declare',
    'djext/_Widget',
    'dijit/_TemplatedMixin',
    'dijit/_WidgetsInTemplateMixin',
    'dijit/_CssStateMixin',
    /* used programmatically */
    'dojo/dom-style'
], function(declare, _Widget, _TemplatedMixin, _WidgetsInTemplateMixin, _CssStateMixin, domStyle) {

return declare('djext.Icon', [ _Widget, _TemplatedMixin, _WidgetsInTemplateMixin, _CssStateMixin ], {

    templateString: '<div></div>',

    baseClass: '',

    actionIcon: true,

    postMixInProperties: function() {

        this.inherited(arguments);

        // set the base class - required by dijit._CssStateMixin
        if(!this.baseClass) {
            this.baseClass = this.srcNodeRef.getAttribute('baseClass');
        }
        if(!this.baseClass) {
            this.baseClass = this.srcNodeRef.getAttribute('class');
        }
        if(!this.baseClass) {
            this.baseClass = this['class'];
        }
    },

    buildRendering: function() {

        this.inherited(arguments);

        if(this.actionIcon) {
            domStyle.set(this.domNode, 'cursor', 'pointer');
        }
    }

});

});
