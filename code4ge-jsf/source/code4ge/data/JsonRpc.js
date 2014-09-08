define([
    'dojo',
    'code4ge/main',
    'dojo/_base/declare',
    'dojox/rpc/Service',
    'dojox/rpc/JsonRPC'
], function(dojo, code4ge, declare, Service) {

var JsonRpc = declare('code4ge.data.JsonRpc', [ Service ], {

    // module:
    //        code4ge/data/JsonRpc
    // summary:
    //        This is an extended class of dojox.rpc.Service, that allows to
    //        communicate with back-end application using JSON-RPC protocol.

    sync: false,

    _noTrailingSlash: true,

    preamble: function(args) {

        if(!dojo.isString(args)) {

            if(typeof(args.noTrailingSlash) != 'undefined') {
                this._noTrailingSlash = args.noTrailingSlash;
            }

            // add trailing slash to the url
            if(!this._noTrailingSlash && args.url.lastIndexOf('/') != args.url.length - 1) {
                args.url = args.url + '/';
            }

            this.sync = args.sync || false;

            if(dojo.isObject(args.smd)) {
                dojo.mixin(args.smd, {
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

/* create a registry of communication channels over JSON-RPC protocol */
JsonRpc.prototype.registry = {

    map: {},

    add: function(args) {
        var url = args.url || args;
        this.map[url] = new JsonRpc({
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
code4ge.set('jsonrpc.registry', JsonRpc.prototype.registry);

return JsonRpc;

});
