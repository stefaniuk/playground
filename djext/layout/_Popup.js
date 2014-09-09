define([
    /* widget */
    'dojo/_base/declare',
    'djext/layout/Container',
    'dojo/text!./templates/_Popup.html',
    /* used programmatically */
    'djext/Overlay',
    'djext/Icon',
    'dojo/_base/lang',
    'dojo/aspect',
    'dojo/_base/window',
    'dojo/dom-construct',
    'dojo/dom-style',
    'dojo/window',
    'dojo/dom-geometry',
    'dojo/on'
], function(declare, Container, template, Overlay, Icon, lang, aspect, win, domConstruct, domStyle, win2, domGeom, on) {

return declare('djext.layout._Popup', [ Container ], {

    templateString: template,

    baseClass: 'djext-popup',

    closeable: true,

    closeIcon: 'djext-icon-close',

    onCloseAction: null,

    hideOnClick: true,

    centralise: true,

    overlay: null,

    overlayOpacity: null,

    overlayDuration: null,

    postMixInProperties: function() {

        this.inherited(arguments);

        // initialise overlay
        var props = {};
        if(this.overlayOpacity) { lang.mixin(props, { opacity: this.overlayOpacity }); }
        if(this.overlayDuration) { lang.mixin(props, { duration: this.overlayDuration }); }
        this.overlay = new Overlay(props);

        if(!this.closeable) {
            this.closeIcon = '';
        }
    },

    buildRendering: function() {

        this.inherited(arguments);

        var self = this;

        var action = function() {
            if(self.onCloseAction === 'hide') {
                self.onCloseAction = function() {
                    self.hide();
                }
            }
            else if(self.onCloseAction === 'close') {
                self.onCloseAction = function() {
                    self.close();
                }
            }
            else if(self.onCloseAction) {
                self.onCloseAction();
            }
            else {
                self.hide();
            }
        }

        if(this.closeable) {
            on(djext.Overlay.prototype.overlay, 'click', function(event) {
                action();
            });
            on(this.icon.domNode, 'click', function() {
                action();
            });
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
        domConstruct.place(node, win.body(), 'last');
    },

    _layout: function() {

        if(!this.width) {
            console.error('The width of a pop-up window has not been set.', this.domNode);
        }

        // centralise
        if(this.centralise) {

            var v = win2.getBox();
            var cs = domStyle.getComputedStyle(this.domNode);
            var ms = domGeom.getMarginSize(this.domNode, cs);

            this.top = v.h/2 - ms.h/2 + 'px';
            this.set('top', this.top);
            this.left = v.w/2 - ms.w/2 + 'px';
            this.set('left', this.left);
        }
    },

    show: function() {

        this._relocate();

        this.overlay.show();
        domStyle.set(this.domNode, 'display', 'block');
        domStyle.set(this.domNode, 'zIndex', 1000); // HACK: IE 6 & 7

        this._layout();
    },

    hide: function() {

        domStyle.set(this.domNode, 'display', 'none');
        this.overlay.hide();
    },

    close: function() {

        this.hide();
        this.destroyRecursive();
    }

});

});
