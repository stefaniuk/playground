define("code4ge/jsf/Container", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.Container', [ code4ge.jsf._Widget, dijit._Templated ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/Container.html'),

	widgetsInTemplate: true,

	/* position */

	top: null,

	right: null,

	bottom: null,

	left: null,

	/* size */

	width: null,

	height: null,

	/* style */

	borderColor: null,

	borderOpacity: null,

	borderWidth: null,

	contentBackgroundColor: null,

	contentTextColor: null,

	contentOpacity: null,

	fixBorderOpacityOnWebkit: true, // HACK: see http://code.google.com/p/chromium/issues/detail?id=36475

	/* content */

	content: '',

	postMixInProperties: function() {

		this.inherited(arguments);

		// save size
		this.top = this.top ? this.top : (this.srcNodeRef ? this.srcNodeRef.style.top || null : null);
		this.right = this.right ? this.right : (this.srcNodeRef ? this.srcNodeRef.style.right || null : null);
		this.bottom = this.bottom ? this.bottom : (this.srcNodeRef ? this.srcNodeRef.style.bottom || null : null);
		this.left = this.left ? this.left : (this.srcNodeRef ? this.srcNodeRef.style.left || null : null);
		this.width = this.width ? this.width : (this.srcNodeRef ? this.srcNodeRef.style.width || null : null);
		this.height = this.height ? this.height : (this.srcNodeRef ? this.srcNodeRef.style.height || null : null);
	},

	startup: function() {

		this.inherited(arguments);

		// make sure that container dimension are set properly
		dojo.style(this.domNode, 'width', 'auto');
		dojo.style(this.domNode, 'height', 'auto');
		dojo.style(this.containerNode, 'width', this.width);
		dojo.style(this.containerNode, 'height', this.height);
	},

	_setTopAttr: function(/*string|int*/top) {

		dojo.style(this.domNode, { top: top });
	},

	_setRightAttr: function(/*string|int*/right) {

		dojo.style(this.domNode, { right: right });
	},

	_setBottomAttr: function(/*string|int*/bottom) {

		dojo.style(this.domNode, { bottom: bottom });
	},

	_setLeftAttr: function(/*string|int*/left) {

		dojo.style(this.domNode, { left: left });
	},

	_setWidthAttr: function(/*string|int*/width) {

		dojo.style(this.containerNode, 'width', width);
	},

	_setHeightAttr: function(/*string|int*/height) {

		dojo.style(this.containerNode, 'height', height);
	},

	_setBorderColorAttr: function(/*any*/color) {

		var c = dojo.colorFromString(color);
		c.a = this.borderOpacity;
		if(dojo.isIE < 9) {
			dojo.style(this.borderNode, 'borderColor', c.toCss());
		}
		else {
			if(this.fixBorderOpacityOnWebkit && dojo.isWebKit) {
				dojo.style(this.borderNode, 'borderColor', c.toCss(true));
				dojo.style(this.borderNode, 'borderRadius', this.borderWidth);
			}
			else {
				dojo.style(this.borderNode, 'borderColor', c.toCss(true));
			}
		}
	},

	_setBorderWidthAttr: function(/*string|int*/width) {

		dojo.style(this.borderNode, 'borderWidth', width);
	},

	_setContentBackgroundColorAttr: function(/*any*/color) {

		var c = dojo.colorFromString(color);
		c.a = this.contentOpacity;
		if(dojo.isIE < 9) {
			dojo.style(this.containerNode, 'backgroundColor', c.toCss());
			dojo.style(this.containerNode, 'filter', 'progid:DXImageTransform.Microsoft.Alpha(Opacity=' + (this.contentOpacity * 100) + ')');
		}
		else {
			dojo.style(this.containerNode, 'backgroundColor', c.toCss(true));
		}
	},

	_setContentTextColorAttr: function(/*any*/color) {

		var c = dojo.colorFromString(color);
		dojo.style(this.containerNode, 'color', c.toCss());
	},

	_setContentOpacityAttr: function(/*numeric*/opacity) {

		this._setContentBackgroundColorAttr(this.contentBackgroundColor);
	},

	_setContentAttr: function(/*any*/content) {

		this.containerNode.innerHTML = content.innerHTML;
	},

	_setChildAttr: function(/*domNode*/child) {

		this.containerNode.appendChild(child);
	}

});

return code4ge.jsf.Container;
});
