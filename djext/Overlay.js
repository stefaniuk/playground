define([
    /* widget */
    'dojo/_base/declare',
    'djext/_Widget',
    'dijit/_TemplatedMixin',
    'dijit/_WidgetsInTemplateMixin',
    /* used programmatically */
    'dijit/registry',
    'dojo/_base/fx',
    'dojo/_base/window',
    'dojo/dom-class',
    'dojo/dom-construct',
    'dojo/dom-geometry',
    'dojo/dom-style',
    'dojo/fx/easing',
    'dojo/has',
    'dojo/on',
    'dojo/query',
    'dojo/window',
    /* dependencies */
    'dojo/_base/sniff'
], function(declare, _Widget, _TemplatedMixin, _WidgetsInTemplateMixin, registry, fx, win, domClass, domConstruct, domGeom, domStyle, easing, has, on, query, win2) {

return declare('djext.Overlay', [ _Widget, _TemplatedMixin, _WidgetsInTemplateMixin ], {

    templateString: '<div class="overlay"></div>',

    opacity: 0.5,

    duration: 750,

    hideOnClick: false,

    buildRendering: function() {

        this.inherited(arguments);

        this._init();

        if(!djext.Overlay.prototype.overlay) {

            var self = this;

            djext.Overlay.prototype.overlay = this.domNode;
            // on overlay click
            on(djext.Overlay.prototype.overlay, 'click', function(event) {
                if(self.hideOnClick) {
                    self.hide();
                }
            });
            // on window resize
            var _ch;
            on(window, 'resize', function(event) {
                if(_ch != document.documentElement.clientHeight) {
                    if(djext.Overlay.prototype.visible) {
                        self.resize();
                    }
                }
                _ch = document.documentElement.clientHeight;
            });

        }
        else {

            this.domNode = djext.Overlay.prototype.overlay;

        }
    },

    _init: function() {

        // make sure this runs only once
        if(!djext.Overlay.prototype.content) {

            // place overlay as child of the body element
            var node = this.domNode;
            if(node.parentNode) {
                node.parentNode.removeChild(node);
            }
            domConstruct.place(node, win.body(), 'first');

            // z-index of overlay-content
            var ie = has('ie');
            var zIndex = ie && ie!=7 ? -1 : 1;

            // place page content as a 1st child of the body element
            djext.Overlay.prototype.content = domConstruct.create('div', {
                'class': 'overlay-content',
                style: { zIndex: zIndex }
            }, win.body(), 'first');

            // move all elements except overlay and popup window inside the div.overlay-content
            query('body > *').forEach(function(node) {
                var widget = registry.byNode(node);
                if(!domClass.contains(node, 'overlay') && !domClass.contains(node, 'overlay-content')) {
                    node.parentNode.removeChild(node);
                    domConstruct.place(node, djext.Overlay.prototype.content, 'last');
                }
            });
        }
    },

    resize: function() {

        var cs = domStyle.getComputedStyle(djext.Overlay.prototype.content);
        var ch = domGeom.getMarginSize(djext.Overlay.prototype.content, cs).h;
        var vh = win2.getBox().h;
        var h = (vh > ch ? vh : ch) + 'px';
        domStyle.set(djext.Overlay.prototype.overlay, 'height', h);
    },

    show: function(/*int*/duration) {

        // lock on animation
        if(this.__animation) {
            return;
        }

        // mark overlay as visible
        djext.Overlay.prototype.visible = true;
        // remember the context
        djext.Overlay.prototype.context = this;

        this.resize();

        var opacity = this.opacity;
        this.set('opacity', 0);
        domStyle.set(this.get('node'), 'display', 'block');

        // fade in
        duration = duration ? duration : this.duration;
        var self = this;
        this.__animation = fx.animateProperty({
            node: this.get('node'),
            easing: easing.expoOut,
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

        var self = this;

        // lock on animation
        if(this.__animation) {
            on(this.__animation, 'end', function() {
                self.hide();
            });
            return;
        }

        // many overlays may exist - make sure the context is right
        var ctx = djext.Overlay.prototype.context;

        // fade out
        duration = duration ? duration : ctx.duration;
        var self = this;
        this.__animation = fx.animateProperty({
            node: self.get('node'),
            easing: easing.linear,
            duration: duration / 4,
            properties: {
                opacity: { start: ctx.opacity, end: 0 }
            },
            onEnd: function() {
                domStyle.set(self.get('node'), 'display', 'none');
                djext.Overlay.prototype.visible = false;
                self.__animation = null;
            }
        });
        this.__animation.play();
    },

    _setOpacityAttr: function(/*number*/opacity) {

        var overlay = this.get('node');
        if(overlay) {
            if(has('ie')) {
                domStyle.set(overlay, 'filter', 'progid:DXImageTransform.Microsoft.Alpha(Opacity=' + (opacity * 100) + ')');
            }
            domStyle.set(overlay, 'opacity', opacity);
        }
    },

    _getNodeAttr: function() {

        return djext.Overlay.prototype.overlay;
    }

});

});
