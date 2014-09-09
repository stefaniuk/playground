define([
    './kernel'
], function(kernel) {

    // module:
    //        djext/_base/registry
    // summary:
    //        This module provides an internal registry for the library.

    // create internal registry
    var registry = {};

    kernel.set = function(name, value) {
        registry[name.toLowerCase()] = value;
    };
    kernel.get = function(name) {
        return registry[name.toLowerCase()];
    };
    kernel.has = function(name) {
        return typeof(registry[name.toLowerCase()]) != 'undefined';
    };
    kernel.unset = function(name) {
        delete registry[name.toLowerCase()];
    };

    return kernel;
});
