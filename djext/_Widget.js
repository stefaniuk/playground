define([
    'dojo/_base/declare',
    'dijit/_WidgetBase',
    /*'dijit/_CssStateMixin', This kills IE! */
    'djext/main',
    'dojo/topic'
], function(declare, _WidgetBase/*, _CssStateMixin*/, djext, topic) {

return declare('djext._Widget', [ _WidgetBase/*, _CssStateMixin*/ ], {

    // module:
    //        djext/_Widget
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
        var self = this;
        topic.subscribe(djext.topic.ready, function() {
            self.onReady();
        });
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
