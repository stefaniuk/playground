dependencies = {

	localeList: 'en,pl',

	layers: [
		/* Code4ge JSF */
		{
			// base
			name: '../code4ge/jsf/code4ge-jsf-base.js',
			dependencies: [
				'code4ge/jsf/base',
				'code4ge/jsf/Overlay',
				'code4ge/jsf/Container',
				'code4ge/jsf/Popup'
			]
		},
		{
			// form widgets
			name: '../code4ge/jsf/code4ge-jsf-form.js',
			layerDependencies: [ '../code4ge/jsf/code4ge-jsf-base.js' ],
			dependencies: [
				'code4ge/jsf/Form',
				'code4ge/jsf/FormDateBox',
				'code4ge/jsf/FormPassword',
				'code4ge/jsf/FormSelectBox',
				'code4ge/jsf/FormTextArea',
				'code4ge/jsf/FormTextBox',
				'code4ge/jsf/FormTimeBox',
				'code4ge/jsf/FormResponseButton'
			]
		},
		{
			// form layout
			name: '../code4ge/jsf/code4ge-jsf-form-layout.js',
			layerDependencies: [ '../code4ge/jsf/code4ge-jsf-form.js' ],
			dependencies: [
				'code4ge/jsf/FormWizard',
				'code4ge/jsf/FormGroup'
			]
		},
		{
			// form editor
			name: '../code4ge/jsf/code4ge-jsf-form-editor.js',
			layerDependencies: [ '../code4ge/jsf/code4ge-jsf-form.js' ],
			dependencies: [
				'code4ge/jsf/FormEditor'
			]
		},
		/* Code4ge CMF */
		{
			// base
			name: '../code4ge/cmf/code4ge-cmf-base.js',
			layerDependencies: [ '../code4ge/jsf/code4ge-jsf-form.js' ],
			dependencies: [
				'code4ge/cmf/base'
			]
		}
	],

	prefixes: [
		[ 'dijit', '../dijit' ],
		[ 'dojox', '../dojox' ],
		[ 'code4ge.jsf', '../code4ge/jsf' ],
		[ 'code4ge.cmf', '../code4ge/cmf' ]
	]

};
