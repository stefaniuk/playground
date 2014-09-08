define("code4ge/jsf/_Widget", [
	'dojo',
	'dijit',
	'dijit/_Widget',
	'dijit/_CssStateMixin'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf._Widget', [ dijit._Widget, dijit._CssStateMixin ], {

	disabled: false,

	postCreate: function() {

		this.inherited(arguments);

		// subscribe on ready topic
		this.subscribe(code4ge.topic.ready, this.onReady);
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

return code4ge.jsf._Widget;
});
