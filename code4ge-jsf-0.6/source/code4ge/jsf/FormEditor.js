define("code4ge/jsf/FormEditor", [
	'dojo',
	'dijit',
	'code4ge/jsf/_FormElement',
	'dijit/form/Button',
	'code4ge/jsf/Editor',
	'dijit/layout/ContentPane',
	'text!code4ge/jsf/templates/FormEditor.html',
	'i18n!code4ge/jsf/nls/FormEditor'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.FormEditor', [ code4ge.jsf._FormElement ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/FormEditor.html'),

	inputClass: 'code4ge.jsf.Editor',

	readOnlyInputClass: 'code4ge.jsf.TextReadOnly',

	// semicolon (';') separated list of CSS files for the editing area
	styleSheets: '',

	loadedStyleSheets: {},

	height: '400',

	multiline: true,

	maxlength: 1024 * 512, // 0.5MB max. size

	// mode: editor, preview or read-only
	mode: 'editor',

	_value: null,

	postMixInProperties: function() {

		dojo.mixin(this, {
			localization: dojo.i18n.getLocalization('code4ge.jsf', 'FormEditor')
		});

		this.inherited(arguments);

		// get the content
		this._value = this.srcNodeRef ? this.srcNodeRef.innerHTML : null;

		if(this.readOnly) {
			this.mode = 'read-only';
		}

		// load CSS styles for the editing area
		if(this.styleSheets) {

			// FIXME: Applaying styles requires some more work as styles are
			//        global. This means that all preview mode and read-only
			//        widgets are afected by loaded styles.

			var sheets = this.styleSheets.split(';');
			for(var i=0; i < sheets.length; i++) {
				// check if stylesheet has already been loaded
				if(!this.loadedStyleSheets[sheets[i]]) {
					dojo.create('link', { rel: 'stylesheet', type:'text/css', href: sheets[i] }, document.head);
					this.loadedStyleSheets[sheets[i]] = true;
				}
			}
			if(!this.readOnly) {
				this.styleSheets = 'styleSheets="' + this.styleSheets + '"';
			}
		}
	},

	postCreate: function() {

		this.inherited(arguments);

		dojo.connect(this._editButton, 'onClick', this, function() {
			this.set('mode', 'editor');
		});
		dojo.connect(this._previewButton, 'onClick', this, function() {
			this.set('mode', 'preview');
		});

		// set the content
		this.set('value', this._value);
	},

	_setModeAttr: function(/*string*/mode) {

		this.mode = mode;

		if(this.mode == 'editor') {
			this.onEdit();
		}
		else if(this.mode == 'preview') {
			this.onPreview();
		}
	},

	_setValueAttr: function(/*string*/value) {

		this._input.set('value', value);

		// set the value also to the preview screen if in the preview mode
		if(this.mode == 'preview') {
			this._view.set('content', value);
		}
	},

	onEdit: function() {

		// hide view
		dojo.style(this._view.domNode, 'display', 'none');
		this._view.set('content', '');
		// show input
		dojo.style(this._input.domNode, 'visibility', 'hidden');
		dojo.style(this._input.domNode, 'display', 'block');
		this.resize();
	},

	onPreview: function() {

		// copy content
		var content = this._input.get('value');
		this._view.set('content', content);

		// hide input
		dojo.style(this._input.domNode, 'display', 'none');
		// show view
		dojo.style(this._view.domNode, 'visibility', 'hidden');
		dojo.style(this._view.domNode, 'display', 'block');
		this.resize();
	},

	resize: function() {

		if(!this.__isReady) {
			return;
		}

		var w;
		if(this.mode != 'preview') {
			w = this._input;
		}
		else {
			w = this._view;
		}

		// reference to the real _input has to be saved
		// and restored when the parent method is finished
		var tempWidget = this._input;
		this._input = w;
		this.inherited(arguments);
		this._input = tempWidget;

		// fix rounded corners for non-IE browsers
		if(!dojo.isIE && this.mode != 'read-only') {
			dojo.query('#' + this._input.domNode.id + ' > div').forEach(function(node, index) {
				if(index == 0) {
					dojo.addClass(node.firstChild, 'rct-small');
				}
				else if(index == 2) {
					dojo.addClass(node.lastChild, 'rcb-small');
				}
			});
		}

		// adjust height of the input
		var h = parseInt(this.height);

		if(this.mode != 'read-only') {
			h -= dojo._getMarginSize(this._control).h;
		}
		else if(this.mode == 'read-only') {
			h -= 4 + (this.labelOnTop ? dojo._getMarginSize(this._label).h : 0); // substract padding and label height
		}
		this._resize({ h: h });

		// set margin only once
		if(!this.__setMarginOnce && !this.labelOnTop && this.mode != 'read-only') {
			var marginLeft = dojo._getMarginSize(this._label).w;
			dojo.style(this._input.domNode, 'marginLeft',  marginLeft + 'px');
			if(this.mode != 'read-only') {
				dojo.style(this._view.domNode, 'marginLeft', marginLeft + 'px');
			}
			this.__setMarginOnce = true;
		}

		// minimize screen flickering - show
		dojo.style(w.domNode, 'visibility', 'visible');
	},

	_resize: function(/*object*/size) {

		if(this.mode != 'preview') {
			this._input.resize(size);
		}
		else if(size.h > 0) { // HACK: IE
			dojo.style(this._view.domNode, 'height', size.h + 'px');
		}
	},

	isValid: function() {

		// TODO: validate input

		return !(this.required && !this._input.get('value'));
	},

	validate: function() {

		return this.isValid();
	},

	onReady: function() {

		// minimize screen flickering
		dojo.style(this.domNode, 'display', 'block');

		// mark this widget as ready
		this.__isReady = true;
		this.resize();

		// minimize screen flickering
		dojo.style(this.domNode, 'visibility', 'visible');
	}

});

return code4ge.jsf.FormEditor;
});
