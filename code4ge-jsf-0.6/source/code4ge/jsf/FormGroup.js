define("code4ge/jsf/FormGroup", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated',
	'text!code4ge/jsf/templates/FormGroup.html'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.FormGroup', [ code4ge.jsf._Widget, dijit._Templated ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/FormGroup.html'),

	widgetsInTemplate: true,

	expanded: true,

	label: '',

	buildRendering: function() {

		this.inherited(arguments);

		this.expanded ? this.expand() : this.collapse();
	},

	resize: function() {

		this.getChildren().forEach(function(widget) {
			if(widget.resize) {
				widget.resize();
			}
		});
	},

	_onClick: function() {

		!this.expanded ? this.expand() : this.collapse();
	},

	expand: function() {

		// frame
		dojo.removeClass(this._fieldsetNode, 'form-group-icon-collapsed');
		this._makeRoundedCorners();
		// content
		dojo.style(this._wrapperNode, 'display', 'block');
		// icon
		dojo.removeClass(this._icon, 'form-group-icon-closed');
		dojo.addClass(this._icon, 'form-group-icon-opened');

		this.expanded = true;
		this.onExpand();
	},

	collapse: function() {

		// frame
		dojo.addClass(this._fieldsetNode, 'form-group-icon-collapsed');
		this._makeRoundedCorners('none');
		// content
		dojo.style(this._wrapperNode, 'display', 'none');
		// icon
		dojo.removeClass(this._icon, 'form-group-icon-opened');
		dojo.addClass(this._icon, 'form-group-icon-closed');

		this.expanded = false;
		this.onCollapse();
	},

	onExpand: function() {
	},

	onCollapse: function() {
	},

	_makeRoundedCorners: function(/*string*/value) {

		if(value == 'none') {
			dojo.removeClass(this._fieldsetNode, 'rca-small');
		}
		else {
			dojo.addClass(this._fieldsetNode, 'rca-small');
		}
	},

	_setLabelAttr: function(/*string*/label) {

		this._labelNode.innerHTML = label;
	},

	_setContentAttr: function(/*any*/content) {

		this.containerNode.set('content', content);
	}

});

return code4ge.jsf.FormGroup;
});
