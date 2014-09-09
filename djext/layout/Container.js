define([
    /* widget */
    'dojo/_base/declare',
    'djext/_Widget',
    'dijit/_TemplatedMixin',
    'dijit/_WidgetsInTemplateMixin',
    'dojo/text!./templates/Container.html',
    /* used programmatically */
    'dojo/dom-style',
    'dojo/_base/Color',
    'dojo/has',
    /* dependencies */
    'dojo/_base/sniff'
], function(declare, _Widget, _TemplatedMixin, _WidgetsInTemplateMixin, template, domStyle, color, has) {

return declare('djext.layout.Container', [ _Widget, _TemplatedMixin, _WidgetsInTemplateMixin ], {

    templateString: template,

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
        domStyle.set(this.domNode, 'width', 'auto');
        domStyle.set(this.domNode, 'height', 'auto');
        domStyle.set(this.containerNode, 'width', this.width);
        domStyle.set(this.containerNode, 'height', this.height);
    },

    _setTopAttr: function(/*string|int*/top) {

        domStyle.set(this.domNode, { top: top });
    },

    _setRightAttr: function(/*string|int*/right) {

        domStyle.set(this.domNode, { right: right });
    },

    _setBottomAttr: function(/*string|int*/bottom) {

        domStyle.set(this.domNode, { bottom: bottom });
    },

    _setLeftAttr: function(/*string|int*/left) {

        domStyle.set(this.domNode, { left: left });
    },

    _setWidthAttr: function(/*string|int*/width) {

        domStyle.set(this.containerNode, 'width', width);
    },

    _setHeightAttr: function(/*string|int*/height) {

        domStyle.set(this.containerNode, 'height', height);
    },

    _setBorderColorAttr: function(/*any*/value) {

        var c = color.fromString(value);
        c.a = this.borderOpacity;
        if(has('ie') < 9) {
            domStyle.set(this.borderNode, 'borderColor', c.toCss());
        }
        else {
            if(this.fixBorderOpacityOnWebkit && has('webkit')) {
                domStyle.set(this.borderNode, 'borderColor', c.toCss(true));
                domStyle.set(this.borderNode, 'borderRadius', this.borderWidth);
            }
            else {
                domStyle.set(this.borderNode, 'borderColor', c.toCss(true));
            }
        }
    },

    _setBorderWidthAttr: function(/*string|int*/width) {

        domStyle.set(this.borderNode, 'borderWidth', width);
    },

    _setContentBackgroundColorAttr: function(/*any*/value) {

        var c = color.fromString(value);
        c.a = this.contentOpacity;
        if(has('ie') < 9) {
            domStyle.set(this.containerNode, 'backgroundColor', c.toCss());
            domStyle.set(this.containerNode, 'filter', 'progid:DXImageTransform.Microsoft.Alpha(Opacity=' + (this.contentOpacity * 100) + ')');
        }
        else {
            domStyle.set(this.containerNode, 'backgroundColor', c.toCss(true));
        }
    },

    _setContentTextColorAttr: function(/*any*/value) {

        var c = color.fromString(value);
        domStyle.set(this.containerNode, 'color', c.toCss());
    },

    _setContentOpacityAttr: function(/*numeric*/opacity) {

        if(this.contentBackgroundColor) {
            this._setContentBackgroundColorAttr(this.contentBackgroundColor);
        }
    },

    _setContentAttr: function(/*any*/content) {

        this.containerNode.innerHTML = content.innerHTML;
    },

    _setChildAttr: function(/*domNode*/child) {

        this.containerNode.appendChild(child);
    }

});

});
