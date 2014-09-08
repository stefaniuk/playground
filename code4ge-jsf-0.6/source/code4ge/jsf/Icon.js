define("code4ge/jsf/Icon", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.Icon', [ code4ge.jsf._Widget, dijit._Templated ], {

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
			dojo.style(this.domNode, 'cursor', 'pointer');
		}
	}

});

return code4ge.jsf.Icon;
});
