define("code4ge/cmf/base", [
	'dojo',
	'dojox/rpc/JsonRPC',
	'dojox/rpc/Service'
], function(dojo) {

(function() {

	var c = code4ge;

	// set URL's
	c.url = {
		login: c.baseUrl + '/authentication/login',
		logout: c.baseUrl + '/authentication/logout',
		services: {
			authentication: c.baseUrl + '/authentication/service'
		}
	};

	// authentication service
	var authService = null;
	var connect = function() {
		authService = new dojox.rpc.Service(c.url.services.authentication);
	};

	// authentication login
	c.login = function(username, password) {
		if(authService == null) {
			connect();
		}
		authService.login(username, password)
			.addCallback(function(result) {
				c.set('username', result ? username : null);
				c.onLogin(result);
			});
	};
	c.onLogin = function(result) {
	};

	// authentication logout
	c.logout = function() {
		if(authService == null) {
			connect();
		}
		var self = this;
		authService.logout()
			.addCallback(function(result) {
				c.set('username', null);
				c.onLogout(result);
			});
	};
	c.onLogout = function(result) {
	};

	// is authenticated
	c.isLoggedIn = function() {
		return c.get('username') && c.get('username') != 'guest';
	};

})();

return code4ge.cmf.base;
});
