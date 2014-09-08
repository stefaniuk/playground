define("code4ge/jsf/Editor", [
	'dojo',
	'dijit',
	'code4ge/jsf/_Widget',
	'dijit/form/ValidationTextBox',
	'dijit/Editor',
	//'dijit/_editor/plugins/FontChoice',
	'dijit/_editor/plugins/FullScreen',
	//'dijit/_editor/plugins/Print',
	'dijit/_editor/plugins/TabIndent',
	//'dijit/_editor/plugins/TextColor',
	'dijit/_editor/plugins/ViewSource',
	//'dojox/editor/plugins/AutoUrlLink',
	'dojox/editor/plugins/Breadcrumb',
	//'dojox/editor/plugins/FindReplace',
	//'dojox/editor/plugins/NormalizeIndentOutdent',
	//'dojox/editor/plugins/NormalizeStyle',
	//'dojox/editor/plugins/PageBreak',
	/*'dojox/editor/plugins/PrettyPrint',*/ /* this plugin is unable to produce strict XHTML code */
	'dojox/editor/plugins/Preview',
	'dojox/editor/plugins/StatusBar',
	'dojox/editor/plugins/ToolbarLineBreak'
], function(dojo, dijit) {

dojo.declare('code4ge.jsf.Editor', [ code4ge.jsf._Widget, /*dijit.form.ValidationTextBox, - causes problem with select boxes */ dijit.Editor ], {

	postMixInProperties: function() {

		this.inherited(arguments);

		// TODO: allow to switch on/off plugins
		this.plugins = [
			// utilities
			//{ name: 'prettyprint', indentBy: 2, lineLength: 120, entityMap: dojox.html.entities.html.concat(dojox.html.entities.latin) },
			//{ name: 'dijit._editor.plugins.EnterKeyHandling', blockNodeForEnter: 'br' },
			//'normalizeindentoutdent', { name: 'normalizestyle', mode: 'semantic' }, 'autourllink',
            //'statusbar',
			// visible
			'undo', 'redo', /*'findreplace',*/ '|',
			'bold', 'italic', 'underline', /*'strikethrough',*/ '|',
			'insertOrderedList', 'insertUnorderedList', 'indent', 'outdent', 'tabIndent', /*'pagebreak',*/ '|',
			'justifyLeft', 'justifyRight', 'justifyCenter', 'justifyFull', '|',
			{ name: 'preview', stylesheets: null }, /*'print',*/ '|',
			'fullscreen', //'||',
			//'fontName', 'fontSize', 'foreColor', 'hiliteColor', '|',
			{ name: 'viewSource', stripScripts: true, stripComments: true }
		];

        if(!dojo.isIE) {
            this.plugins.push('breadcrumb');
        }
	},

	resize: function(size) {

		// HACK: always resize/layout editor
		dijit.layout._LayoutWidget.prototype.resize.apply(this, arguments);
	},

	addPlugin: function(/*string|object*/plugin,/*int*/index) {

		this.inherited(arguments);

		if(plugin == 'fullscreen') {
			// HACK: editor has to be resized while full screen is turned off
			var marginLeft;
			var fs = this._plugins[index], self = this;
			fs.button.onChange = function(fullScreen) {
				dijit._editor.plugins.FullScreen.prototype._setFullScreen.apply(fs, arguments);
				if(fullScreen) {
					marginLeft = dojo.style(self.domNode, 'marginLeft');
					dojo.style(self.domNode, 'marginLeft', '0');
				}
				else {
					dojo.style(self.domNode, 'marginLeft', marginLeft + 'px');
				}
				setTimeout(function() {
					self.resize();
				}, 100);
			};
		}
	}

});

return code4ge.jsf.Editor;
});
