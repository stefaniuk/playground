define("code4ge/jsf/FormMoveFromToList", [
	'dojo',
	'dojox',
	'code4ge/jsf/_FormElementInterface',
	'dijit/form/MultiSelect',
	'dijit/form/Button',
	'text!code4ge/jsf/templates/FormMoveFromToList.html'
], function(dojo, dojox) {

dojo.declare('code4ge.jsf.FormMoveFromToList', [ code4ge.jsf._FormElementInterface ], {

	templateString: dojo.cache('code4ge.jsf', 'templates/FormMoveFromToList.html'),

	labelLeft: '',

	labelRight: '',

	// variable defined in the template as dojoAttachPoint="_selectLeft"
	_selectLeft: null,

	// variable defined in the template as dojoAttachPoint="_selectRight"
	_selectRight: null,

	// variable defined in the template as dojoAttachPoint="_btnLeft"
	_btnLeft: null,

	// variable defined in the template as dojoAttachPoint="_btnRight"
	_btnRight: null,

	_optionsLeft: null,

	_optionsRight: null,

	postMixInProperties: function() {

		this.inherited(arguments);

		var self = this;
		// save options defined in the markup
		this._optionsLeft = [];
		dojo.query('select[name="from"] > option', this.srcNodeRef).filter(function(node) {
			self._optionsLeft.push(node);
		});
		this._optionsRight = [];
		dojo.query('select[name="to"] > option', this.srcNodeRef).filter(function(node) {
			self._optionsRight.push(node);
		});
	},

	postCreate: function() {

		this.inherited(arguments);

		dojo.connect(this._btnLeft, 'onClick', this, '_moveSelectedLeft');
		dojo.connect(this._btnRight, 'onClick', this, '_moveSelectedRight');

		// set options defined in the markup
		var scnl = this._selectLeft.containerNode;
		for(var i=0; i<this._optionsLeft.length; i++) {
			scnl.appendChild(this._optionsLeft[i]);
		}
		scnl.selectedIndex = -1;
		var scnr = this._selectRight.containerNode;
		for(var i=0; i<this._optionsRight.length; i++) {
			scnr.appendChild(this._optionsRight[i]);
		}
		scnr.selectedIndex = -1;
	},

	_getLeftValuesAttr: function() {

		var values = {};
		var cn = this._selectLeft.containerNode;
		dojo.query('option', cn).filter(function(option) {
			values[option.value] = option.text;
		});

		return values;
	},

	_getRightValuesAttr: function() {

		var values = {};
		var cn = this._selectRight.containerNode;
		dojo.query('option', cn).filter(function(option) {
			values[option.value] = option.text;
		});

		return values;
	},

	_moveSelectedLeft: function() {

		this._selectLeft.addSelected(this._selectRight);
	},

	_moveSelectedRight: function() {

		this._selectRight.addSelected(this._selectLeft);
	},

	_setValueAttr: function(/*any*/value) {

		// TODO

	},

	_getValueAttr: function() {

		return {
			left: this._getLeftValuesAttr(),
			right: this._getRightValuesAttr()
		};

	}

});

return code4ge.jsf.FormMoveFromToList;
});
