define([
    'dojo/_base/kernel',
    'dojo/_base/lang',
    'dojo/_base/array',
    'dojo/_base/declare',
    'dojo/_base/html',
    'dojo/dom',
    'dojo/dom-construct',
    'dojo/dom-class',
    'dojo/_base/window',
    'dijit/_Widget'
], function(
    dojo,
    lang,
    arr,
    declare,
    html,
    dom,
    domConstruct,
    domClass,
    win,
    _Widget
) {

return declare('code4ge.geo.Legend', [ _Widget ], {

    horizontal: true,

    legendBody: null,

    swatchSize: 10,

    map: null,

    buildRendering: function() {

        this.inherited(arguments);

        var legend = domConstruct.create('table', {
            role: 'group',
            'class': 'dojoxLegendNode'
        }, this.domNode);
        this.legendBody = domConstruct.create('tbody', null, legend);
    },

    postCreate: function() {

        if(!this.map) {
            return;
        }

        this.series = this.map.series;
        this.refresh();
    },

    refresh: function() {

        while(this.legendBody.lastChild) {
            domConstruct.destroy(this.legendBody.lastChild);
        }

        if(this.horizontal) {
            domClass.add(this.domNode, 'dojoxLegendHorizontal');
            this._tr = win.doc.createElement('tr');
            this.legendBody.appendChild(this._tr);
        }

        var s = this.series;
        if(s.length == 0) {
            return;
        }

        arr.forEach(s,function(x) {
            this._addLabel(x.color, x.name);
        }, this);
    },

    _addLabel: function(color,label) {

        var icon = win.doc.createElement('td');
        var text = win.doc.createElement('td');
        var div = win.doc.createElement('div');
        domClass.add(icon, 'dojoxLegendIcon');
        domClass.add(text, 'dojoxLegendText');
        div.style.width  = this.swatchSize + 'px';
        div.style.height = this.swatchSize + 'px';
        icon.appendChild(div);

        if(this.horizontal) {
            this._tr.appendChild(icon);
            this._tr.appendChild(text);
        }
        else {
            var tr = win.doc.createElement('tr');
            this.legendBody.appendChild(tr);
            tr.appendChild(icon);
            tr.appendChild(text);
        }

        div.style.background = color;
        text.innerHTML = String (label);
    }

});

});
