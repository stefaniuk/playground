define([
    'dojo/_base/declare',
    'code4ge/_Widget',
    'dijit/layout/BorderContainer'
], function(declare, _Widget, BorderContainer) {

return declare('code4ge.BorderContainer', [ _Widget, BorderContainer ], {

	onReady: function() {

		this.resize();
	}

});

});
