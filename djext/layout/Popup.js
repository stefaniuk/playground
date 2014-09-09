define([
    /* widget */
    'dojo/_base/declare',
    'djext/_Widget',
    'dijit/_TemplatedMixin',
    'dijit/_WidgetsInTemplateMixin',
    /* used programmatically */
    'djext/layout/_Popup',
    'dojo/dom-construct',
    'dojo/_base/window',
    'dojo/aspect'
], function(declare, _Widget, _TemplatedMixin, _WidgetsInTemplateMixin, Popup, domConstruct, win, aspect) {

return declare('djext.layout.Popup', [ _Widget, _TemplatedMixin, _WidgetsInTemplateMixin ], {

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

        var self = this;
        if(!this.onCloseAction) {
            this.onCloseAction = function() {
                self.hide();
            }
        }
        else {
            if(this.onCloseAction === 'hide') {
                this.onCloseAction = function() {
                    console.debug('hide');
                    self.hide();
                }
            }
            if(this.onCloseAction === 'close') {
                this.onCloseAction = function() {
                    console.debug('close');
                    self.close();
                }
            }
        }
    },

    buildRendering: function() {

        this.inherited(arguments);

        var props = this._getProperties();
        this.popup = new Popup(props, domConstruct.create('div', {
            style: {
                top: this.top,
                right: this.right,
                bottom: this.bottom,
                left: this.left,
                width: this.width,
                height: this.height
            }
        }, win.body(), 'last'));
    },

    postCreate: function() {

        this.inherited(arguments);

        this.popup.set('child', this.domNode);

        aspect.after(this.popup, 'show', this.onShow);
        aspect.after(this.popup, 'hide', this.onHide);
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

});
