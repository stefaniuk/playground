define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'dijit/_WidgetBase',
    'dijit/_CssStateMixin'
], function(dojo, code4ge, declare, _WidgetBase, _CssStateMixin) {

return declare('code4ge._Widget', [ _WidgetBase, _CssStateMixin ], {

    // module:
    //        code4ge/_Widget
    // summary:
    //        Base class for all widgets.
    // features:
    //        CSS state
    //        onReady function
    //        disabled

    disabled: false,

    postCreate: function() {

        this.inherited(arguments);

        // subscribe on ready topic
        dojo.subscribe(code4ge.topic.ready, this, 'onReady');
    },

    _setDisabledAttr: function(/*boolean*/value) {

        this.disabled = value;
    },

    _getDisabledAttr: function() {

        return this.disabled;
    },

    onReady: function() {

    }

});

});
