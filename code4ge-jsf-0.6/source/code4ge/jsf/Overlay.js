define("code4ge/jsf/Overlay", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated',
	'dojo/fx/easing'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.Overlay', [ code4ge.jsf._Widget, dijit._Templated ], {

	templateString: '<div class="overlay"></div>',

	opacity: 0.5,

	duration: 750,

	hideOnClick: false,

	buildRendering: function() {

		this.inherited(arguments);

		this._init();

		if(!code4ge.jsf.Overlay.prototype.overlay) {

			code4ge.jsf.Overlay.prototype.overlay = this.domNode;
			// on overlay click
			dojo.connect(code4ge.jsf.Overlay.prototype.overlay, 'onclick', this, function(event) {
				if(this.hideOnClick) {
					this.hide();
				}
			});
			// on window resize
			var _ch;
			dojo.connect(window, 'onresize', this, function(event) {
				if(_ch != document.documentElement.clientHeight) {
					if(code4ge.jsf.Overlay.prototype.visible) {
						this.resize();
					}
				}
				_ch = document.documentElement.clientHeight;
			});

		}
		else {

			this.domNode = code4ge.jsf.Overlay.prototype.overlay;

		}
	},

	_init: function() {

		// make sure this runs only once
		if(!code4ge.jsf.Overlay.prototype.content) {

			// place overlay as child of the body element
			var node = this.domNode;
			if(node.parentNode) {
				node.parentNode.removeChild(node);
			}
			dojo.place(node, dojo.body(), 'first');

			// z-index of overlay-content
			var ie = dojo.isIE;
			var zIndex = ie && ie!=7 ? -1 : 1;

			// place page content as a 1st child of the body element
			code4ge.jsf.Overlay.prototype.content = dojo.create('div', {
				'class': 'overlay-content',
				style: { zIndex: zIndex }
			}, dojo.body(), 'first');

			// move all elements except overlay and popup window inside the div.overlay-content
			dojo.query('body > *').forEach(function(node) {
				var widget = dijit.byNode(node);
				if(!dojo.hasClass(node, 'overlay') && !dojo.hasClass(node, 'overlay-content')) {
					node.parentNode.removeChild(node);
					dojo.place(node, code4ge.jsf.Overlay.prototype.content, 'last');
				}
			});
		}
	},

	resize: function() {

		var ch = dojo._getMarginSize(code4ge.jsf.Overlay.prototype.content).h;
		var vh = dijit.getViewport().h;
		var h = (vh > ch ? vh : ch) + 'px';
		dojo.style(code4ge.jsf.Overlay.prototype.overlay, 'height', h);
	},

	show: function(/*int*/duration) {

		// lock on animation
		if(this.__animation) {
			return;
		}

		// mark overlay as visible
		code4ge.jsf.Overlay.prototype.visible = true;
		// remember the context
		code4ge.jsf.Overlay.prototype.context = this;

		this.resize();

		var opacity = this.opacity;
		this.set('opacity', 0);
		dojo.style(this.get('node'), 'display', 'block');

		// fade in
		duration = duration ? duration : this.duration;
		var self = this;
		this.__animation = dojo.animateProperty({
			node: this.get('node'),
			easing: dojo.fx.easing.expoOut,
			duration: duration,
			properties: {
				opacity: { start: 0, end: opacity }
			},
			onEnd: function() {
				self.set('opacity', opacity);
				self.__animation = null;
			}
		});
		this.__animation.play();
	},

	hide: function(/*int*/duration) {

		// lock on animation
		if(this.__animation) {
			dojo.connect(this.__animation, 'onEnd', this, function() {
				this.hide();
			});
			return;
		}

		// many overlays may exist - make sure the context is right
		var ctx = code4ge.jsf.Overlay.prototype.context;

		// fade out
		duration = duration ? duration : ctx.duration;
		var self = this;
		this.__animation = dojo.animateProperty({
			node: self.get('node'),
			easing: dojo.fx.easing.linear,
			duration: duration / 4,
			properties: {
				opacity: { start: ctx.opacity, end: 0 }
			},
			onEnd: function() {
				dojo.style(self.get('node'), 'display', 'none');
				code4ge.jsf.Overlay.prototype.visible = false;
				self.__animation = null;
			}
		});
		this.__animation.play();
	},

	_setOpacityAttr: function(/*number*/opacity) {

		var overlay = this.get('node');
		if(overlay) {
			if(dojo.isIE) {
				dojo.style(overlay, 'filter', 'progid:DXImageTransform.Microsoft.Alpha(Opacity=' + (opacity * 100) + ')');
			}
			dojo.style(overlay, 'opacity', opacity);
		}
	},

	_getNodeAttr: function() {

		return code4ge.jsf.Overlay.prototype.overlay;
	}

});

return code4ge.jsf.Overlay;
});
