define([
    'dojo',
    'dijit',
    'dojo/_base/declare',
    'dijit/_WidgetBase',
    'dijit/_CssStateMixin',
    'dijit/_TemplatedMixin',
    'dijit/_WidgetsInTemplateMixin',
    'dojo/text!./templates/Filter.html',
    'nhs/FilterItem',
    // classes referenced in the template:
    'dijit/form/TextBox'
], function(dojo, dijit, declare, _WidgetBase, _CssStateMixin, _TemplatedMixin, _WidgetsInTemplateMixin, template, FilterItem) {

var declaredWidget = declare('nhs.Filter', [ _WidgetBase, _CssStateMixin, _TemplatedMixin, _WidgetsInTemplateMixin ], {

    // module:
    //        nhs/Filter
    // summary:
    //        ?
    // features:
    //        ?

    widgetsInTemplate: true,

    templateString: template,

    name: '',

    label: '',

    parent: null,

    expanded: false,

    _items: null,

    _itemsByName: null,

	buildRendering: function() {

		this.inherited(arguments);

		this.expanded ? this.expand() : this.collapse();
	},

    _setItemsAttr: function(items) {

        /*
            data format:
            ============

            items = [
                { name: string, label: string, checked: boolean },
                ...
            ];
        */

        if(!this._items) {
            this._items = [];
            this._itemsByName = {};
            for(var i=0; i < items.length; i++) {
                var item = items[i];
                var widget = new FilterItem({
                    parent: this,
                    name: item.name,
                    label: item.label,
                    checked: item.checked
                });
                dojo.place(widget.domNode, this.itemsNode);
                this._items.push(widget);
                this._itemsByName[item.name] = widget;
            }
        }
        else {
            for(var i=0; i < items.length; i++) {
                var item = items[i];
                var widget = this._itemsByName[item.name];
                widget.set('checked', item.checked);
            }
        }
    },

    _getItemsAttr: function() {

        /*
            data format:
            ============

            items = [
                { name: string, checked: boolean },
                ...
            ];
        */

        var items = [];
        for(var i=0; i < this._items.length; i++) {
            var widget = this._items[i];
            items.push({ name: widget.get('name'), checked: widget.get('checked') });
        }

        return items;
    },

    onChange: function(item) {

        this.parent.onChange(this);
    },

	expand: function() {

		// frame
		dojo.removeClass(this._fieldsetNode, 'nhs-filter-group-icon-collapsed');
        this._makeRoundedCorners();
		// content
		dojo.style(this._wrapperNode, 'display', 'block');
		// icon
		dojo.removeClass(this._icon, 'nhs-filter-group-icon-closed');
		dojo.addClass(this._icon, 'nhs-filter-group-icon-opened');

		this.expanded = true;
	},

	collapse: function() {

		// frame
		dojo.addClass(this._fieldsetNode, 'nhs-filter-group-icon-collapsed');
        this._makeRoundedCorners('none');
		// content
		dojo.style(this._wrapperNode, 'display', 'none');
		// icon
		dojo.removeClass(this._icon, 'nhs-filter-group-icon-opened');
		dojo.addClass(this._icon, 'nhs-filter-group-icon-closed');

		this.expanded = false;
	},

    _makeRoundedCorners: function(/*string*/value) {

        if(value == 'none') {
            dojo.removeClass(this._fieldsetNode, 'br-small');
        }
        else {
            dojo.addClass(this._fieldsetNode, 'br-small');
        }
    },

	_onClick: function() {

		!this.expanded ? this.expand() : this.collapse();
	},

	resize: function() {

		this.getChildren().forEach(function(widget) {
			if(widget.resize) {
				widget.resize();
			}
		});
	}

});

return declaredWidget;

});
