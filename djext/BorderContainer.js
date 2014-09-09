define([
    'dojo/_base/declare',
    'djext/_Widget',
    'dijit/layout/BorderContainer'
], function(declare, _Widget, BorderContainer) {

return declare('djext.BorderContainer', [ _Widget, BorderContainer ], {

    onReady: function() {

        this.resize();
    }

});

});
