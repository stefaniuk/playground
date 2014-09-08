define("code4ge/jsf/Navigation", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated',
	'code4ge/jsf/NavigationItem',
	'code4ge/jsf/NavigationMenuItem',
	'code4ge/jsf/NavigationSubMenu'
], function(dojo, dijit) {

// FIXME: widget's startup process run twice
dojo.declare('code4ge.jsf.Navigation', [ code4ge.jsf._Widget, dijit._Templated ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/Navigation.html'),

	widgetsInTemplate: true,

	content: '',

	_contentHTML: null,

	_items: null,

	postMixInProperties: function() {

		this.inherited(arguments);

		// find all sub-menus
		dojo.query('ul', this.srcNodeRef).forEach(function(node, index, arr) {
			dojo.attr(node, 'dojoType', 'code4ge.jsf.NavigationSubMenu')
		});

		// save content
		this._contentHTML = this.srcNodeRef ? this.srcNodeRef.innerHTML : null;
	},

	buildRendering: function() {

		this.inherited(arguments);

		// set content
		if(this._contentHTML != null) {
			this.set('content', this._contentHTML);
		}

		// set container node
		this.containerNode = this.domNode;

		dojo.query('li', this.domNode).addClass('css3pie');

		this._items = this.getChildren();
		for(var i=0, len=this._items.length; i<len; i++) {
			var item = this._items[i];
			item.navigation = this;
			if(item.declaredClass == 'code4ge.jsf.NavigationMenuItem') {
				item.menu = this._items[i+1];
				if(dojo.hasClass(item.domNode.parentNode, 'active')) {
					item._showMenu();
				}
			}
		}
	},

	collapse: function() {

		/*for(var i=0, len=this._items.length; i<len; i++) {
			var item = this._items[i];
			if(item.collapse) {
				item.collapse();
			}
		}*/
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

return code4ge.jsf.Navigation;
});
