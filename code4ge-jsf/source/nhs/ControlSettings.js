define([
    'dojo',
    'dijit',
    'dojo/_base/declare',
    'dojo/aspect',
    'dijit/_WidgetBase',
    'dijit/_CssStateMixin',
    'dijit/_TemplatedMixin',
    'dijit/_WidgetsInTemplateMixin',
    'dojo/text!./templates/ControlSettings.html',
    'nhs/Filter',
    'dojo/store/Memory',
    'dojo/json',
    // classes referenced in the template:
    'nhs/DateRange',
    'dijit/form/FilteringSelect',
    'dijit/form/Button',
    'dojo/dnd/Source'
], function(dojo, dijit, declare, aspect, _WidgetBase, _CssStateMixin, _TemplatedMixin, _WidgetsInTemplateMixin, template, Filter, Memory, json) {

var declaredWidget = declare('nhs.ControlSettings', [ _WidgetBase, _CssStateMixin, _TemplatedMixin, _WidgetsInTemplateMixin ], {

    // module:
    //        nhs/ControlSettings
    // summary:
    //        ?
    // features:
    //        ?

    _dijitTemplateCompat: true,

    widgetsInTemplate: true,

    templateString: template,

    name: '',

    label: '',

    dataPresentation: null,

    getDataFunc: null,

    _groupBy: null,

    _doNotGroupBy: null,

    _categories: null,

    _categoriesByName: null,

    _groupByCategories: null,

    slideShowDelay: 2000,

    buildRendering: function() {

        this.inherited(arguments);

        // create drag-and-drop containers
        this._groupBy = new dojo.dnd.Source(this.filtersNode1);
        this._doNotGroupBy = new dojo.dnd.Source(this.filtersNode2);

        var self = this;

        // on refresh button click
        aspect.after(this.refresh, 'onClick', function() {
            self.dataPresentation.setData(self.getDataFunc());
        });
        // on play button click
        aspect.after(this.play, 'onClick', function() {
            var numberOfMonths = self.daterange.getNumberOfMonths();
            var updateSeriesForMonth = function(startDate, month) {
                console.log('slideshow', startDate, month);
                self.dataPresentation.setData(self.getDataFunc(startDate, month));
            }
            var queue = [];
            for(var i=0; i<numberOfMonths+1; i++) {
                queue.push(function() { updateSeriesForMonth(self.daterange.get('value').from, i); });
            }
            var defer = function(queue){
                if (!queue.length) {
                    return;
                }
                queue.shift()();
                setTimeout(defer, self.slideShowDelay, queue);
            }
            defer(queue);
        });
    },

    _setSettingsAttr: function(settings) {

        /*
            data format:
            ============

            settings = {
                categories: [
                    { name: string, label: string, items: [
                        { name: string, label: string, checked: boolean },
                        ...
                    ]},
                    ...
                ],
                daterange: {
                    from: date,
                    to: date
                },
                daterangeCategory: string,
                groupByCategories: [ string, ... ]
            };
        */

        if(!this._categories) {

            // categories
            this._categories = [];
            this._categoriesByName = {};
            var daterangeCategoryOptions = [];
            for(var i=0; i < settings.categories.length; i++) {
                var data = settings.categories[i];
                var widget = new Filter({
                    parent: this,
                    name: data.name,
                    label: data.label,
                    items: data.items
                });
                this._categories.push(widget);
                this._categoriesByName[data.name] = widget;
                daterangeCategoryOptions.push({ id: data.name, name: data.label });
            }
            // date range
            this.daterange.parent = this;
            this.daterange.init(settings.daterange);
            // date range category
            var store = new Memory({
                data: daterangeCategoryOptions
            });
            this.daterangeCategory.set('store', store);
            this.daterangeCategory.set('value', settings.daterangeCategory);
            // grouping
            this._groupByCategories = settings.groupByCategories;
            for(var i=0; i<this._categories.length; i++) {
                var widget = this._categories[i];
                var done = false;
                for(var j=0; j<this._groupByCategories.length; j++) {
                    if(widget.name == this._groupByCategories[j]) {
                        this._groupBy.insertNodes(false, [ widget.domNode ]);
                        done = true;
                        break;
                    }
                }
                if(!done) {
                    this._doNotGroupBy.insertNodes(false, [ widget.domNode ]);
                }
            }
        }
        else {

            // categories
            for(var i=0; i < settings.categories.length; i++) {
                var data = settings.categories[i];
                var widget = this._categoriesByName[data.name];
                widget.set('items', data.items);
            }
            // date range
            this.daterange.set('value', settings.daterange);
            // date range category
            this.daterangeCategory.set('value', settings.daterangeCategory);
        }
    },

    _getSettingsAttr: function() {

        /*
            data format:
            ============

            settings = {
                categories: [
                    { name: string, items: [
                        { name: string, checked: boolean },
                        ...
                    ]},
                    ...
                ],
                daterange: {
                    from: date,
                    to: date
                },
                daterangeCategory: string,
                groupByCategories: [ string, ... ]
            };
        */

        var categories = [];
        for(var i=0; i < this._categories.length; i++) {
            var widget = this._categories[i];
            categories.push({ name: widget.get('name'), items: widget.get('items') });
        }

        var _groupByCategories = [];
        var count = 0;
        var nodesGroupBy = this._groupBy.getAllNodes();
        nodesGroupBy.forEach(function(node) {
            if(count < 2) {
                var filter = dijit.byNode(node);
                console.log('filter', filter.name);
                _groupByCategories.push(filter.name);
            }
            count++;
        });

        var settings = {
            categories: categories,
            daterange: this.daterange.get('value'),
            daterangeCategory: this.daterangeCategory.get('value'),
            groupByCategories: _groupByCategories
        };

        var str = json.stringify(settings);
        console.log(str);

        return settings;
    },

    onChange: function(widget) {

        console.log(this, 'onChange', widget);
    }

});

return declaredWidget;

});
