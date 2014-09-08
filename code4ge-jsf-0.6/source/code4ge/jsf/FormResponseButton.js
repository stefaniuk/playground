define("code4ge/jsf/FormResponseButton", [
	'dojo',
	'dijit',
	'code4ge/jsf/_FormControl',
	'dojox/form/BusyButton',
	'text!code4ge/jsf/templates/FormResponseButton.html'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.FormResponseButton', [ code4ge.jsf._FormControl ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/FormResponseButton.html'),

	response: null,

	messageOnSuccess: '',

	messageOnError: '',

	delay: 3000,

	postCreate: function() {

		this.inherited(arguments);

		this._control.busyLabel =  this.label;

		// call resize on ready
		dojo.connect(this, 'onReady', this, 'resize');
	},

	resize: function() {

		var w = dojo._getMarginSize(this.domNode).w;
		if(w <= 0) { // HACK: IE
			return;
		}

		// make sure there is enough space for busy icon
		var self = this;
		dojo.query('.dijitButtonText', this._control.domNode).forEach(function(node) {
			var lw = dojo._getMarginSize(node).w;
			if(w < lw + 20) {
				w += 20;
			}
			else if(2 * lw < w) { // HACK: width may not be set correctly for IE
				w = lw + 20;
			}
			dojo.style(self.domNode, 'width', w + 'px');
		});

		// set width of button node
		dojo.style(this._control.domNode, 'width', w + 'px');
		dojo.query('.dijitButtonNode', this._control.domNode).forEach(function(node) {
			dojo.style(node, 'width', w - 2 + 'px');
		});

		// set message position
		dojo.style(this._message, 'left', w + 10 + 'px');
	},

	_setResponseAttr: function(/*jsonrpc*/response) {

		// make sure there is no message displayed
		if(this.__timeoutId) {
			clearTimeout(this.__timeoutId);
		}

		if(response.result) {
			// set the success message
			dojo.style(this._message, 'color', '#008000');
			this.set('message', this.messageOnSuccess || response.result);
			// generate event
			this.onSuccess(response);
		}
		else if(response.error) {
			// set the error message
			dojo.style(this._message, 'color', '#FF0000');
			this.set('message', this.messageOnError || response.error.message);
			// generate event
			this.onError(response);
		}
		else {
			return;
		}

		// show message
		this._fadeInMessage();
		this._control.cancel();

		// hide message with a delay
		var self = this;
		this.__timeoutId = setTimeout(function() {
			self._fadeOutMessage();
		}, this.delay);
	},

	_setMessageAttr: function(/*string*/message) {

		this._message.innerHTML = message;
	},

	_onClick: function() {

		this._clearMessage();
	},

	_fadeInMessage: function() {

		dojo.fadeIn({
			node: this._message
		}).play();
	},

	_fadeOutMessage: function() {

		dojo.fadeOut({
			node: this._message
		}).play();
	},

	_clearMessage: function() {

		this.set('message', '');
		dojo.style(this._message, 'opacity', 0);
		dojo.style(this._message, 'color', '#000000');
	},

	onSuccess: function(/*jsonrpc*/response) {

	},

	onError: function(/*jsonrpc*/response) {

	}

});

return code4ge.jsf.FormResponseButton;
});
