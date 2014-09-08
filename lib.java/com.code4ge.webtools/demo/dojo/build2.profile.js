dependencies = {

	layers: [
		{
			name: 'dojo.js',
			dependencies: [
				'dojo.parser',
				'dijit.layout.BorderContainer',
				'dijit.layout.ContentPane'
			]
		},
		{
			name: 'code4ge.jsf.js',
			dependencies: [
				'code4ge.jsf.base'
			]
		}
	],

	prefixes: [
		[ 'dijit', '../dijit' ],
		[ 'code4ge.jsf', '../code4ge/jsf' ]
	]

};
