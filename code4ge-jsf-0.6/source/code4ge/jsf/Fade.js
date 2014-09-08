define("code4ge/jsf/Fade", [
	'dojo',
	'dijit',
	'code4ge/jsf/Overlay'
], function(dojo, dijit) {

// TODO: Removed code4ge.jsf.Fade in the 1.0 release.
dojo.declare('code4ge.jsf.Fade', [ code4ge.jsf.Overlay ], {

	constructor: function() {

		console.warn('code4ge.jsf.Fade is deprecated and will be removed in the 1.0 release.');
	}

});

return code4ge.jsf.Fade;
});
