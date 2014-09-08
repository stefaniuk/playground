define("code4ge/jsf/FormTextBox", [
	'dojo',
	'dijit',
	'code4ge/jsf/_FormElement',
	'dijit/form/ValidationTextBox',
	'dojox/validate/regexp',
	'text!code4ge/jsf/templates/FormTextBox.html'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.FormTextBox', [ code4ge.jsf._FormElement ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/FormTextBox.html'),

	inputClass: 'dijit.form.ValidationTextBox',

	maxlength: 50,

	// if this is used, do not use regExpGen
	regExp: '',

	// if this is used, do not use regExp
	regExpGen: '',

	placeholder: '',

	postMixInProperties: function() {

		this.inherited(arguments);

		if(this.regExp) {
			this.regExp = 'regExp="' + this.regExp + '"';
		}
		else if(this.regExpGen) {
			this.regExpGen = 'regExpGen="' + this.regExpGen + '"';
		}
	},

	buildRendering: function() {

		this.inherited(arguments);

		this._fixFocus('.dijitValidationInner', this._input);

		// show placeholder
		if(this.placeholder) {
			var self = this;
			dojo.query('div.dijitInputField', this.domNode).forEach(function(node) {
				// create placeholder
				var p = dojo.create('div', {
					'class': 'form-textbox-placeholder',
					innerHTML: self.placeholder
				}, node, 'first');
				// store here font size for later use
				var pfs;
				// show/hide placeholder
				dojo.query('input', node).connect('onkeydown', function(event) {
					// save font size
					if(!pfs) {
						pfs = parseInt(dojo.style(p, 'fontSize'));
					}
					dojo.animateProperty({node: p, properties: {
						fontSize: 0,
						opacity: 0
					}}).play();
				}).connect('onblur', function(event) {
					if(dojo.trim(event.target.value).length == 0){
						dojo.animateProperty({node: p, properties: {
							fontSize: pfs,
							opacity: 1
						}}).play();
					}
				});
			});
		}
	}

});

return code4ge.jsf.FormTextBox;
});
