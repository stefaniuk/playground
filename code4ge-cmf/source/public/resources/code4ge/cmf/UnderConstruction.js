define("code4ge/cmf/UnderConstruction", [
	'dojo',
	'dijit',
	'code4ge/jsf/Popup',
	'text!code4ge/cmf/templates/UnderConstruction.html',
	'i18n!code4ge/cmf/nls/UnderConstruction'
], function(dojo, dijit) {

dojo.declare('code4ge.cmf.UnderConstruction', [ code4ge.jsf.Popup ], {

	templateString: dojo.cache('code4ge.cmf', 'templates/UnderConstruction.html'),

	widgetsInTemplate: false,

	postMixInProperties: function() {

		dojo.mixin(this, {
			localization: dojo.i18n.getLocalization('code4ge.cmf', 'UnderConstruction')
		});

		this.inherited(arguments);
	}

});

return code4ge.cmf.UnderConstruction;
});
