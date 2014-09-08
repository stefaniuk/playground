define("code4ge/jsf/Popup", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated',
	'code4ge/jsf/_Popup'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.Popup', [ code4ge.jsf._Widget, dijit._Templated ], {

	/* container */

	top: null,

	right: null,

	bottom: null,

	left: null,

	width: null,

	height: null,

	borderColor: null,

	borderOpacity: null,

	borderWidth: null,

	contentBackgroundColor: null,

	contentTextColor: null,

	contentOpacity: null,

	/* popup */

	closeable: null,

	closeIcon: null,

	onCloseAction: null,

	centralise: null,

	overlayOpacity: null,

	overlayDuration: null,

	popup: null,

	postMixInProperties: function() {

		this.inherited(arguments);

		this.top = this.top ? this.top : (this.srcNodeRef ? this.srcNodeRef.style.top || null : null);
		this.right = this.right ? this.right : (this.srcNodeRef ? this.srcNodeRef.style.right || null : null);
		this.bottom = this.bottom ? this.bottom : (this.srcNodeRef ? this.srcNodeRef.style.bottom || null : null);
		this.left = this.left ? this.left : (this.srcNodeRef ? this.srcNodeRef.style.left || null : null);
		this.width = this.width ? this.width : (this.srcNodeRef ? this.srcNodeRef.style.width || null : null);
		this.height = this.height ? this.height : (this.srcNodeRef ? this.srcNodeRef.style.height || null : null);
	},

	buildRendering: function() {

		this.inherited(arguments);

		var props = this._getProperties();
		this.popup = new code4ge.jsf._Popup(props, dojo.create('div', {
			style: {
				top: this.top,
				right: this.right,
				bottom: this.bottom,
				left: this.left,
				width: this.width,
				height: this.height
			}
		}, dojo.body(), 'last'));
	},

	postCreate: function() {

		this.inherited(arguments);

		this.popup.set('child', this.domNode);

		dojo.connect(this.popup, 'show', this, 'onShow');
		dojo.connect(this.popup, 'hide', this, 'onHide');
	},

	show: function() {

		this.popup.show();
	},

	onShow: function() {

	},

	hide: function() {

		this.popup.hide();
	},

	onHide: function() {

	},

	close: function() {

		this.popup.close();
	},

	_getProperties: function() {

		var props = {};

		if(this.borderColor!=null) { props['borderColor'] = this.borderColor; };
		if(this.borderOpacity!=null) { props['borderOpacity'] = this.borderOpacity; };
		if(this.borderWidth!=null) { props['borderWidth'] = this.borderWidth; };
		if(this.contentBackgroundColor!=null) { props['contentBackgroundColor'] = this.contentBackgroundColor; };
		if(this.contentTextColor!=null) { props['contentTextColor'] = this.contentTextColor; };
		if(this.contentOpacity!=null) { props['contentOpacity'] = this.contentOpacity; };
		if(this.closeable!=null) { props['closeable'] = this.closeable; };
		if(this.closeIcon!=null) { props['closeIcon'] = this.closeIcon; };
		if(this.onCloseAction!=null) { props['onCloseAction'] = this.onCloseAction; };
		if(this.centralise!=null) { props['centralise'] = this.centralise; };
		if(this.overlayOpacity!=null) { props['overlayOpacity'] = this.overlayOpacity; };
		if(this.overlayDuration!=null) { props['overlayDuration'] = this.overlayDuration; };

		return props;
	}

});

return code4ge.jsf.Popup;
});
