define("code4ge/jsf/_Popup", [
	'dojo',
	'dijit',
	'code4ge/jsf/Overlay',
	'code4ge/jsf/Container',
	'code4ge/jsf/Icon',
	'dojo/fx'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf._Popup', [ code4ge.jsf.Container ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/Popup.html'),

	baseClass: 'popup',

	closeable: true,

	closeIcon: 'icon-close',

	onCloseAction: 'hide',

	centralise: true,

	overlay: null,

	overlayOpacity: null,

	overlayDuration: null,

	postMixInProperties: function() {

		this.inherited(arguments);

		// initialise overlay
		var props = {};
		if(this.overlayOpacity) { dojo.mixin(props, { opacity: this.overlayOpacity }); }
		if(this.overlayDuration) { dojo.mixin(props, { duration: this.overlayDuration }); }
		this.overlay = new code4ge.jsf.Overlay(props);

		if(!this.closeable) {
			this.closeIcon = '';
		}
	},

	buildRendering: function() {

		this.inherited(arguments);

		if(this.closeable) {
			dojo.connect(this.icon.domNode, 'onclick', this, this.onCloseAction);
		}
	},

	_relocate: function() {

		// make sure this runs only once for this widget
		if(this.__relocated) {
			return;
		}
		this.__relocated = true;

		// place popup as a last child of the body element
		var node = this.domNode;
		if(node.parentNode) {
			node.parentNode.removeChild(node);
		}
		dojo.place(node, dojo.body(), 'last');
	},

	_layout: function() {

		if(!this.width) {
			console.error('The width of a pop-up window has not been set.', this.domNode);
		}

		// centralise
		if(this.centralise) {

			var v = dijit.getViewport();
			var w = dojo._getMarginSize(this.domNode).w;
			var h = dojo._getMarginSize(this.domNode).h;

			this.top = v.h/2 - h/2 + 'px';
			this.set('top', this.top);
			this.left = v.w/2 - w/2 + 'px';
			this.set('left', this.left);
		}
	},

	show: function() {

		this._relocate();

		this.overlay.show();
		dojo.style(this.domNode, 'display', 'block');
		dojo.style(this.domNode, 'zIndex', 1000); // HACK: IE 6 & 7

		this._layout();
	},

	hide: function() {

		dojo.style(this.domNode, 'display', 'none');
		this.overlay.hide();
	},

	close: function() {

		this.hide();
		this.destroyRecursive();
	}

});

return code4ge.jsf._Popup;
});
