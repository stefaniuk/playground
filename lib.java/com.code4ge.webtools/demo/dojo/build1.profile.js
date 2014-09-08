dependencies = {

	layers: [
		{
			name: 'code4ge.cmf.js',
			layerDependencies: [
				'code4ge.jsf.js'
			],
			dependencies: [
				'code4ge.cmf.base'
			]
		}
	],

	prefixes: [
		[ 'dijit', '../dijit' ],
		[ 'dojox', '../dojox' ],
		[ 'code4ge.cmf', '../code4ge/cmf' ]
	]

};
