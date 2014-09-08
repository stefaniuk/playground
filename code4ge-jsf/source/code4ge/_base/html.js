define([
    'dojo',
    './kernel'
], function(dojo, code4ge) {

	// module:
	//		code4ge/_base/html
	// summary:
	//		This module provides additional functions to manipulate HTML code.

	// improved dojo.hasClass
	code4ge.hasClass = function(node, clazz) {
		var classes = dojo.attr(dojo.byId(node), 'class');
		var attrs = classes.split(' ');
		for(var i = 0; i < attrs.length; i++) {
			if(attrs[i].indexOf(clazz) == 0) {
				return attrs[i];
			}
		}
	};

    // escape HTML
    code4ge.escapeHTML = function(str) {
        str = str.replace(/&/g, '&amp;');
        str = str.replace(/</g, '&lt;');
        str = str.replace(/>/g, '&gt;');
        str = str.replace(/"/g, '&quot;');
        return str;
    };
    // unescape HTML
    code4ge.unescapeHTML = function(str) {
        var node = document.createElement('div');
        node.innerHTML = str;
        if(node.innerText !== undefined) { // IE
            return node.innerText;
        }
        return node.textContent;
    };

    return code4ge;
});
