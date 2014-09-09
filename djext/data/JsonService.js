define([
    'dojo/_base/declare',
    'dojo/_base/lang',
    'dojox/rpc/Service',
    'dojox/rpc/JsonRPC',
    'djext/main'
], function(declare, lang, Service, JsonRPC, djext) {

var JsonService = declare('djext.data.JsonService', [ Service ], {

    // module:
    //        djext/data/JsonService
    // summary:
    //        This is an extended class of dojox/rpc/Service, that allows to
    //        communicate with back-end application using JSON-RPC protocol.

    sync: false,

    _noTrailingSlash: true,

    preamble: function(args) {

        if(!lang.isString(args)) {

            if(typeof(args.noTrailingSlash) != 'undefined') {
                this._noTrailingSlash = args.noTrailingSlash;
            }

            // add trailing slash to the url
            if(!this._noTrailingSlash && args.url.lastIndexOf('/') != args.url.length - 1) {
                args.url = args.url + '/';
            }

            this.sync = args.sync || false;

            if(lang.isObject(args.smd)) {
                lang.mixin(args.smd, {
                    target: args.url
                });
            }
        }

        return [ args.smd || args.url || args ];
    },

    _getRequest: function(method, args) {

        var request = this.inherited(arguments);

        request.sync = this.sync;

        return request;
    }

});

/* create a registry */
JsonService.prototype.registry = {

    map: {},

    add: function(args) {
        var url = args.url || args;
        this.map[url] = new JsonService({
            url: url,
            smd: args.smd,
            sync: args.sync || false,
            noTrailingSlash: typeof(args.noTrailingSlash) != 'undefined' ? args.noTrailingSlash : true
        });
    },

    get: function(args) {
        var url = args.url || args;
        if(!this.map[url]) {
            this.add(args);
        }
        return this.map[url];
    }

};
djext.set('jsonservice.registry', JsonService.prototype.registry);

return JsonService;

});
