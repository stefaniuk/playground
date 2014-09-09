define([
    'dojo/_base/declare',
    'dojo/_base/lang',
    'dojo/_base/json',
    'dojox/data/ClientFilter',
    'dojox/data/JsonRestStore',
    'djext/data/JsonService',
    'djext/main'
], function(declare, lang, json, ClientFilter, JsonRestStore, JsonService, djext) {

var JsonServiceStore = declare('djext.data.JsonServiceStore', null, {

    // module:
    //        djext/data/JsonServiceStore
    // summary:
    //        This class acts as a glue between dojox/data/ServiceStore and
    //        dojox/rpc/Service allowing to communicate with back-end
    //        application using JSON-RPC protocol.

    _service: null,

    _noTrailingSlash: true,

    constructor: function(args) {

        var smd = {
            SMDVersion: '2.0',
            additionalParameters: 'false',
            contentType: 'application/json',
            envelope: 'JSON-RPC-2.0',
            transport: 'POST',
            services: {
                select: {
                    parameters: [{ type: 'object' }],
                    returns: { type: 'any' }
                },
                update: {
                    parameters: [{ type: 'string' }, { type: 'object' }],
                    returns: { type: 'object' }
                },
                insert: {
                    parameters: [{ type: 'object' }],
                    returns: { type: 'object' }
                },
                'delete': {
                    parameters: [{ type: 'string' }],
                    returns: { type: 'object' }
                }
            }
        };

        if(lang.isString(args)) {
            var pos = args.lastIndexOf('/');
            var obj = {
                url: args.substring(0, pos),
                target: args.substring(pos + 1)
            }
            args = obj;
        }

        if(args.smd) {
            lang.mixin(args.smd, smd);
        }
        else {
            args.smd = smd;
        }

        if(typeof(args.noTrailingSlash) != 'undefined') {
            this._noTrailingSlash = args.noTrailingSlash;
        }

        this._service = new JsonService({
            url: args.url + '/' + args.target,
            smd: args.smd,
            noTrailingSlash: this._noTrailingSlash
        });

        var self = this;
        var service = function(query, data) {
            for(var name in data) {
                // amend undefined to null
                if(typeof(data[name]) == 'undefined') {
                    data[name] = null;
                }
            }
            var handle = self._service.select(data);
            handle.then(function(result) {
                self.onEvent('select', result);
            });
            return handle;
        }
        service['put'] = function(key, data) {
            var handle = self._service.update(key, json.fromJson(data));
            handle.then(function(result) {
                self.onEvent('update', result);
            });
            return handle;
        }
        service['post'] = function(key, data) {
            var handle = self._service.insert(json.fromJson(data));
            handle.then(function(result) {
                self.onEvent('insert', result);
            });
            return handle;
        }
        service['delete'] = function(key) {
            var handle = self._service['delete'](key);
            handle.then(function(result) {
                self.onEvent('delete', result);
            });
            return handle;
        }

        lang.mixin(this, new JsonRestStore({
            target: args.target,
            service: service
        }));
    },

    onEvent: function(event, result) {
    }

});

/* create a registry */
JsonServiceStore.prototype.registry = {

    map: {},

    add: function(args) {
        if(lang.isString(args)) {
            this.map[args] = new JsonServiceStore(args);
        }
        else {
            this.map[args.url + '/' + args.target] = new JsonServiceStore({
                url: args.url,
                target: args.target,
                smd: args.smd,
                noTrailingSlash: typeof(args.noTrailingSlash) != 'undefined' ? args.noTrailingSlash : true
            });
        }
    },

    get: function(args) {
        var url = lang.isObject(args) ? args.url + '/' + args.target : args;
        if(!this.map[url]) {
            this.add(args);
        }
        return this.map[url];
    }

};
djext.set('jsonservicestore.registry', JsonService.prototype.registry);

return JsonServiceStore;

});
