define("code4ge/jsf/Form", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/form/Form',
	'code4ge/jsf/_FormElementInterface'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.Form', [ code4ge.jsf._Widget, dijit.form.Form ], {

	readOnly: false,

	// array of form elements
	elements: null,

	// hash of form elements, name => element
	_ref: null,

	// code4ge.jsf.FormChangeDetector
	_cd: null,

	buildRendering: function() {

		if(this.readOnly) {
			var self = this;
			// set read-only flag on all form widgets, WARNING: form id has to be set
			dojo.query('[dojoType]', dojo.byId(this.id)).forEach(function(node) {
				var dojoType = node.getAttribute('dojoType');
				if(self._types[dojoType]) {
					node.setAttribute('readOnly', true);
				}
			});
		}

		this.inherited(arguments);
	},

	startup: function() {

		var self = this;

		var _names = [];
		this.elements = new dojo.NodeList();
		// search for all form widgets
		dojo.query('[widgetId]', this.domNode).forEach(function(node) {
			var widget = dijit.byNode(node);
			if(self._types[widget.declaredClass] && !widget.ignoreForm) {
				// save a reference
				self.elements.push(widget);
				// save names to avoid duplicates
				_names.push(widget.get('name'));
				// connect to a widget event
				self.connect(widget, 'onEvent', function(type, event) {
					self.onEvent(widget, type, event);
				});
			}
		});
		// search for all hidden inputs
		dojo.query('input[type="hidden"]', this.domNode).forEach(function(node) {
			var name = node.getAttribute('name');
			// only with a given name diffrent than widgets
			if(name && dojo.indexOf(_names, name) < 0) {
				self.elements.push(node);
			}
		});

		// create hash of form elements
		this._ref = {};
		this.elements.forEach(function(element) {
			if(element instanceof code4ge.jsf._FormElementInterface) {
				self._ref[element.get('name')] = element;
			}
			else {
				self._ref[element.getAttribute('name')] = element;
			}
		});

		// track form changes if class FormChangeDetector was loaded
		if(code4ge.jsf.FormChangeDetector) {
			this._cd = new code4ge.jsf.FormChangeDetector({
				form: this
			});
		}

		this.inherited(arguments);
	},

	addElement: function(/*string|code4ge.jsf._FormElementInterface*/element) {

		element = dijit.byId(element)
		if(this._types[element.declaredClass]) {
			this.elements.push(element);
			this._ref[element.get('name')] = element;
		}

		if(this._cd) {
			// refresh form change detector
			this._cd.refresh();
		}
	},

	_setValuesAttr: function(/*object*/values) {

		for(var name in values) {
			var element = this._ref[name];
			if(element instanceof code4ge.jsf._FormElementInterface) {
				element.set('value', values[name]);
			}
			else {
				element.setAttribute('value', values[name]);
			}
		}
	},

	_getValuesAttr: function() {

		var data = {};
		this.elements.forEach(function(element) {
			if(element instanceof code4ge.jsf._FormElementInterface) {
				if((!element.get('readOnly') && !element.get('disabled')) || element.get('forceSend')) {
					data[element.get('name')] = element.get('value');
				}
			}
			else {
				data[element.getAttribute('name')] = element.value;
			}
		});

		return data;
	},

	_setDisabledAttr: function(/*boolean*/value) {

		for(var i=0; i<this.elements.length; i++) {
			var element = this.elements[i];
			if(element instanceof code4ge.jsf._FormElementInterface) {
				element.set('disabled', value);
			}
			else {
				element.setAttribute('disabled', value);
			}
		}
	},

	_getChangeDetectorAttr: function() {

		if(this._cd) {
			return this._cd;
		}

		return null;
	},

	_getHiddenValuesAttr: function() {

		var data = {};
		this.elements.forEach(function(element) {
			if(!(element instanceof code4ge.jsf._FormElementInterface)) {
				data[element.name] = element.value;
			}
		});

		return data;
	},

	validate: function() {

		var valid = true;

		var tabindex = 0xFFFF;
		var elemToFocus = null;

		for(var name in this._ref) {
			var element = this._ref[name];
			if(element.validate && !element.validate()) {
				valid = false;
				if(element.tabindex < tabindex) {
					tabindex = element.tabindex;
					elemToFocus = element;
				}
			}
		}

		// set focus to the first not valid element on the form
		if(!valid) {
			elemToFocus.focus();
		}

		return valid;
	},

	reset: function(){

		for(var i=0; i<this.elements.length; i++) {
			var element = this.elements[i];
			if(element.reset) {
				element.reset();
			}
		}
	},

	onEvent: function(/*code4ge.jsf._FormElementInterface*/element, /*string*/type, /*object*/event) {

	}

});

code4ge.jsf.Form.prototype._types = {
	'code4ge.jsf.FormDateBox': true,
	'code4ge.jsf.FormEditor': true,
	'code4ge.jsf.FormPassword': true,
	'code4ge.jsf.FormSelectBox': true,
	'code4ge.jsf.FormTextArea': true,
	'code4ge.jsf.FormTextBox': true,
	'code4ge.jsf.FormTimeBox': true,
	'code4ge.jsf.FormMoveFromToList': true
}

return code4ge.jsf.Form;
});
