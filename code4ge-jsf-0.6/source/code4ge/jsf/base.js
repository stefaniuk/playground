define("code4ge/jsf/base", [
	'dojo',
	'dojox/collections/ArrayList'
], function(dojo) {

(function() {

	var c = code4ge;

	// version is set by the build script
	c.version = {
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

	// set topics
	c.topic = {
		ready: 'ready' // to be published when toolkit is loaded
	};

	// tasks to run on ready
	var tasks = (function() {
		var t = {}, queue = [];

		t.add = function(func, order) {
			queue.push({
				func: func,
				order: order || 0
			});
		};

		t.run = function() {
			var al = new dojox.collections.ArrayList(queue);
			al.sort(function(a, b) { return a.order - b.order; });
			al.forEach(function(task) {
				task.func();
			});
		};

		return t;
	})();

	// final initialisation
	dojo.ready(function() {
		// try to call initialisation code as late as possible
		dojo.ready(function() {
			// add initialisation code that has to be run last
			tasks.add(function() {
				// use claro as a base theme
				if(!dojo.hasClass(dojo.body(), 'claro')) {
					dojo.addClass(dojo.body(), 'claro');
				}
				// display invisable nodes
				dojo.query('.displayOnReady').removeClass('displayOnReady');
				// warn widgets
				dojo.publish(c.topic.ready);
			}, 999);
			tasks.run();
		});
	});

	// dojo.ready replacement
	c.ready = function(func, order) {
		tasks.add(func, order);
	};

	// dojo.hasClass replacement
	c.hasClass = function(node, clazz) {
		var classes = dojo.attr(dojo.byId(node), 'class');
		var attrs = classes.split(' ');
		for(var i = 0; i < attrs.length; i++) {
			if(attrs[i].indexOf(clazz) == 0) {
				return attrs[i];
			}
		}
	};

	// internal registry
	var registry = {};
	c.set = function(name, value) {
		registry[name.toLowerCase()] = value;
	};
	c.get = function(name) {
		return registry[name.toLowerCase()];
	};
	c.has = function(name) {
		return typeof(registry[name.toLowerCase()]) != 'undefined';
	};
	c.unset = function(name) {
		delete registry[name.toLowerCase()];
	};

    // escape HTML
    c.escapeHTML = function(str) {
        str = str.replace(/&/g, '&amp;');
        str = str.replace(/</g, '&lt;');
        str = str.replace(/>/g, '&gt;');
        str = str.replace(/"/g, '&quot;');
        return str;
    };
    // unescape HTML
    c.unescapeHTML = function(str) {
        var node = document.createElement('div');
        node.innerHTML = str;
        if(node.innerText !== undefined) { // IE
            return node.innerText;
        }
        return node.textContent;
    };

})();

return code4ge.jsf.base;
});
