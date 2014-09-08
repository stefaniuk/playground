define("code4ge/jsf/NavigationSubMenu", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated'
], function(dojo, dijit) {

// FIXME: widget's startup process run twice
dojo.declare('code4ge.jsf.NavigationSubMenu', [ code4ge.jsf._Widget, dijit._Templated ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/NavigationSubMenu.html'),

	widgetsInTemplate: true,

	navigation: null,

	content: '',

	_contentHTML: null,

	postMixInProperties: function() {

		this.inherited(arguments);

		// save content
		this._contentHTML = this.srcNodeRef ? this.srcNodeRef.innerHTML : null;
	},

	buildRendering: function() {

		this.inherited(arguments);

		// set content
		if(this._contentHTML != null) {
			this.set('content', this._contentHTML);
		}
	},

	// TODO: remove it, this widget do not have content attribute
	_setContentAttr: function(/*any*/content) {

		this.list.innerHTML = content;

		// parse content
		if(this.widgetsInTemplate) {
			dojo.parser.parse(this.list);
		}
	}

});

return code4ge.jsf.NavigationSubMenu;
});
