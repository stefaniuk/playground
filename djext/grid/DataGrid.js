define([
    'dojo/_base/declare',
    'djext/_Widget',
    'dojox/grid/EnhancedGrid',
    'dojo/has',
    'djext/main',
    'dojox/grid/enhanced/plugins/IndirectSelection',
    'dojox/grid/enhanced/plugins/Pagination',
    'dojox/grid/enhanced/plugins/Filter',
    'dojox/grid/enhanced/plugins/Selector',
    'djext/data/JsonServiceStore'
], function(declare, _Widget, EnhancedGrid, has, djext) {

return declare('djext.grid.DataGrid', [ _Widget, EnhancedGrid ], {

    postMixInProperties: function() {

        if(typeof this.store == 'string') {
            var registry = djext.get('jsonservicestore.registry');
            this.store = registry.get(this.store);
        }

        this.inherited(arguments);
    },

    buildRendering: function() {

        this.inherited(arguments);

        // IE<7 hack
        if(has('ie') <= 7) {
            var connects = this.focus._connects
            for(var i=0; i < connects.length; i++) {
                if(connects[i][1] == '_onFetchComplete') {
                    // remove a reference to _FocusManager._delayedCellFocus
                    delete connects[i];
                }
            }
        }
    },

    _render: function() {

        if(this.domNode.parentNode) {
            this.scroller.init(this.get('rowCount'), this.keepRows, this.rowsPerPage);
            // IE hack
            if(!has('ie')) {
                // with the following line included grid fails to render the content
                this.prerender();
            }
            this._fetch(0, true);
        }
    },

    _onFetchComplete: function() {

        this.inherited(arguments);

        // remove focus from grid
        this.focus._blurHeader();
    }

});

});
