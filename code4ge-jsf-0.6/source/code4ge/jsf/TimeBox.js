define("code4ge/jsf/TimeBox", [
	'dojo',
	'dijit',
	'dijit/form/TimeTextBox'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.TimeBox', [ dijit.form.TimeTextBox ], {

	serialize: function(val, options) {

		var time = this.inherited(arguments);

		return time.substring(1);
	}

});

return code4ge.jsf.TimeBox;
});
