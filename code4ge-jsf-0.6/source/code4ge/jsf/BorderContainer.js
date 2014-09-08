define("code4ge/jsf/BorderContainer", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/layout/BorderContainer'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.BorderContainer', [ code4ge.jsf._Widget, dijit.layout.BorderContainer ], {

	onReady: function() {

		this.resize();
	}

});

return code4ge.jsf.BorderContainer;
});
