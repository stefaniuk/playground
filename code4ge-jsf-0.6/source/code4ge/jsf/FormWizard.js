define("code4ge/jsf/FormWizard", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dojox/widget/Wizard',
	'code4ge/jsf/Form',
	'text!code4ge/jsf/templates/FormWizard.html',
	'i18n!code4ge/jsf/nls/FormWizard'
], function(dojo, dijit) {

// TODO: validate each pane before continue
dojo.declare('code4ge.jsf.FormWizard', [ code4ge.jsf._Widget, dojox.widget.Wizard ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/FormWizard.html'),

	title: '',

	postMixInProperties: function() {

		this.localization = dojo.i18n.getLocalization('code4ge.jsf', 'FormWizard');

		this.inherited(arguments);
	},

	startup: function() {

		this.inherited(arguments);

		// wire onEvent
		dojo.connect(this.form, 'onEvent', this, 'onEvent');
		// wire onSend
		dojo.connect(this.doneButton, 'onClick', this, function() {
			this.onSend(this.form);
		});

		// set title
		var title = this.selectedChildWidget.get('title');
		if(title) {
			this.set('title', title);
		}
	},

	_setTitleAttr: function(/*string*/title) {

		this.titleNode.innerHTML = title;
	},

	_transition: function(/*dijit._Widget*/newWidget, /*dijit._Widget*/oldWidget, /*boolean*/animate) {

		if(oldWidget) {
			this._hideChild(oldWidget);
		}

		var d = this._showChild(newWidget);

		if(newWidget.resize) {
			// HACK: in IE size of the content is established after a while
			setTimeout(function() { newWidget.resize(); }, dojo.isIE ? 10 : 0);
		}

		// set title
		var title = newWidget.get('title')
		this.set('title', title ? title : this.title);

		this.onChange(newWidget);

		return d;
	},

	_checkButtons: function() {

		// previous button
		this.previousButton.set('disabled', !this.selectedChildWidget.canGoBack);
		this._setButtonClass(this.previousButton);

		// next button
		this.nextButton.set('disabled', this.selectedChildWidget.isLastChild);
		this._setButtonClass(this.nextButton);

		// send button
		this.doneButton.set('disabled', !this.form.isValid());
	},

	reset: function() {

		this.form.reset();

		// activate the first child
		this.selectChild(this.getChildren()[0]);
	},

	onEvent: function(/*dijit._Widget*/element, /*string*/type, /*object*/event) {

		// send button
		this.doneButton.set('disabled', !this.form.isValid());
	},

	onChange: function(/*dijit._Widget*/active) {

	},

	onSend: function(/*code4ge.jsf.Form*/form) {

	}

});

return code4ge.jsf.FormWizard;
});
