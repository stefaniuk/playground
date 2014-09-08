define("code4ge/jsf/JsonRpc", [
	'dojo',
	'dojox/rpc/Service',
	'dojox/rpc/JsonRPC'
], function(dojo) {

dojo.declare('code4ge.jsf.JsonRpc', [ dojox.rpc.Service ], {

	sync: false,

	preamble: function(args) {

		if(!dojo.isString(args)) {

			// add trailing slash to the url
			if(args.url.lastIndexOf('/') != args.url.length - 1) {
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
code4ge.jsf.JsonRpc.prototype.registry = {
	map: {},
	add: function(args) {
		var url = args.url || args;
		this.map[url] = new code4ge.jsf.JsonRpc({
			url: url,
			smd: args.smd,
			sync: args.sync || false
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
code4ge.set('jsonrpc.registry', code4ge.jsf.JsonRpc.prototype.registry);

return code4ge.jsf.JsonRpc;
});
