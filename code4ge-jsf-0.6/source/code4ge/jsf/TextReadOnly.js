define("code4ge/jsf/TextReadOnly", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/_Templated'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.TextReadOnly', [ code4ge.jsf._Widget, dijit._Templated ], {

	templateString: '<div dojoAttachPoint="_text" style="overflow:auto"></div>',

    value: '',

    displayedValue: '',

	_setValueAttr: function(value) {

        this.value = value;

		if(!this.displayedValue || this._started) {
            this.set('displayedValue', value);
        }
	},

	_setDisplayedValueAttr: function(value) {

        this.displayedValue = value;

		this._text.innerHTML = value;
	},

	_getDisplayedValueAttr: function() {

		return this._text.innerHTML;
	},

	resize: function(size) {

		if(size.w) {
			dojo.style(this._text, 'width', size.w + 'px');
		}
		if(size.h) {
			dojo.style(this._text, 'height', size.h + 'px');
		}
	}

});

return code4ge.jsf.TextReadOnly;
});
