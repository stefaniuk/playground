define("code4ge/jsf/NavigationMenuItem", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated'
], function(dojo, dijit) {

// FIXME: widget's startup process run twice
dojo.declare('code4ge.jsf.NavigationMenuItem', [ code4ge.jsf._Widget, dijit._Templated ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/NavigationMenuItem.html'),

	widgetsInTemplate: true,

	navigation: null,

	href: '',

	content: '',

	menu: null,

	_contentHTML: null,

	_height: '',

	_collapsed: true,

	postMixInProperties: function() {

		this.inherited(arguments);

		// extend attribute map
		dojo.mixin(this.attributeMap, { href: '' });

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

		dojo.connect(this.anchor, 'onmouseover', this, this._showMenu);
	},

	startup: function() {

		this._height = dojo.style(this.domNode.parentNode, 'height');
	},

	collapse: function() {

		this._hideMenu();
	},

	_onMouseOver: function() {

		if(this._collapsed) {
			this.navigation.collapse();
		}
	},

	_onMouseOut: function() {
	},

	_showMenu: function() {

		if(!this._collapsed) {
			return;
		}
		this._collapsed = false;

		dojo.removeClass(this.domNode, 'vco');
		dojo.animateProperty({
			node: this.domNode.parentNode,
			properties: {
				height: { start: this._height, end: 170 }
			}
		}).play();
		var self = this;
		setTimeout(function() {
			if(!self._collapsed) {
				dojo.style(self.menu.domNode, 'display', 'block');
			}
		}, 200);
	},

	_hideMenu: function() {

		if(this._collapsed) {
			return;
		}
		this._collapsed = true;

		dojo.animateProperty({
			node: this.domNode.parentNode,
			properties: {
				height: { start: 170, end: 36 }
			}
		}).play()
		dojo.style(this.menu.domNode, 'display', 'none');
		var self = this;
		setTimeout(function() {
			dojo.addClass(self.domNode, 'vco');
		}, 150);
	},


	// TODO: remove it, this widget do not have content attribute
	_setContentAttr: function(/*any*/content) {

		this.anchor.innerHTML = content;
	}

});

return code4ge.jsf.NavigationMenuItem;
});
