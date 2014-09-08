define("code4ge/jsf/FormChangeDetector", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.FormChangeDetector', [ code4ge.jsf._Widget ], {

	// code4ge.jsf.Form
	form: null,

	// hash of form values, name => value
	_data: null,

	postMixInProperties: function() {

		this.inherited(arguments);

		this.refresh();
	},

	refresh: function() {

		var data = this.form.get('values');
		this._data = {};
		for(var name in data) {
			this._data[name] = data[name];
		}
	},

	getInitialValues: function() {

		var values = {};
		var data = this._data;
		for(var name in data) {
			values[name] = data[name];
		}

		return values;
	},

	getCurrentValues: function() {

		var values = {};
		var data = this.form.get('values');
		for(var name in data) {
			values[name] = data[name];
		}

		return values;
	},

	getChangedValues: function() {

		var values = {};
		var data = this.form.get('values');
		for(var name in data) {
			if(data[name] != this._data[name]) {
				values[name] = data[name];
			}
		}

		return values;
	},

	getChangedFromToValues: function() {

		var values = {};
		var data = this.form.get('values');
		for(var name in data) {
			if(data[name] != this._data[name]) {
				values[name] = {
					from: this._data[name],
					to: data[name]
				};
			}
		}

		return values;
	},

	isDirty: function() {

		var data = this.form.get('values');
		for(var name in data) {
			if(data[name] != this._data[name]) {
				return true;
			}
		}

		return false;
	}

});

return code4ge.jsf.FormChangeDetector;
});
