define("code4ge/jsf/NavigationItem", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated',
	'dojox/widget/FisheyeLite'
], function(dojo, dijit) {

// FIXME: widget's startup process run twice
dojo.declare('code4ge.jsf.NavigationItem', [ code4ge.jsf._Widget, dijit._Templated ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/NavigationItem.html'),

	widgetsInTemplate: false,

	navigation: null,

	href: '',

	content: '',

	_contentHTML: null,

	postMixInProperties: function() {

		this.inherited(arguments);

		// extend attribute map
		dojo.mixin(this.attributeMap, { href: "" });

		// save content
		this._contentHTML = this.srcNodeRef ? this.srcNodeRef.innerHTML : null;
	},

	buildRendering: function() {

		this.inherited(arguments);

		// set content
		if(this._contentHTML != null) {
			this.set('content', this._contentHTML);
		}

		new dojox.widget.FisheyeLite({
			properties: {
				fontSize: 1.5
			},
			durationIn: 200,
			durationOut: 1000
		}, this.anchor);
	},

	// TODO: remove it, this widget do not have content attribute
	_setContentAttr: function(/*any*/content) {

		this.anchor.innerHTML = content;
	},

	_onMouseOver: function() {

		/*if(this.navigation) {
			this.navigation.collapse();
		}*/
	},

	_onMouseOut: function() {
	}

});

return code4ge.jsf.NavigationItem;
});
