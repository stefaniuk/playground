define([
    'dojo'
], function(dojo) {

	// module:
	//		code4ge/_base/kernel
	// summary:
	//		This module is the foundational module of the code4ge boot sequence; it defines the code4ge object.

    // create code4ge
    var c = code4ge = {
        topic: {}
    };

	/*=====
		code4ge.version = function(){
			// summary:
			//		Version number of the Code4ge JSF library
			// major: Integer
			//		Major version. If total version is "0.7.276dev", will be 0
			// minor: Integer
			//		Minor version. If total version is "0.7.276dev", will be 7
			// revision: Integer
			//		Revision version. If total version is "0.7.276dev", will be 276
			// flag: String
			//		Descriptor flag. If total version is "0.7.276dev", will be "dev"
			this.major = 0;
			this.minor = 0;
			this.revision = 0;
			this.flag = 'dev';
		}
	=====*/
	c.version = {
        // version is set by the build script
		major: 0, minor: 0, revision: 0, flag: 'dev',
		toString: function() {
			with(c.version) {
				return major + '.' + minor + '.' + revision + flag;
			}
		}
	};

	// set base URL
	c.baseUrl = '/';

	// set resources URL
	var pos = dojo.baseUrl.lastIndexOf('/dojo/');
	c.resourcesUrl = dojo.baseUrl.substring(0, pos);

	return code4ge;
});
