define([
    'dojo',
    './kernel'
], function(dojo, code4ge) {

	// module:
	//		code4ge/_base/registry
	// summary:
	//		This module provides an internal registry for the library.

	// create internal registry
	var registry = {};

	code4ge.set = function(name, value) {
		registry[name.toLowerCase()] = value;
	};
	code4ge.get = function(name) {
		return registry[name.toLowerCase()];
	};
	code4ge.has = function(name) {
		return typeof(registry[name.toLowerCase()]) != 'undefined';
	};
	code4ge.unset = function(name) {
		delete registry[name.toLowerCase()];
	};

    return code4ge;
});
