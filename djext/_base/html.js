define([
    './kernel',
    'dojo/dom-attr',
    'dojo/dom'
], function(kernel, domAttr, dom) {

    // module:
    //        djext/_base/html
    // summary:
    //        This module provides additional functions to manipulate HTML code.

    // improved dojo/dom-class::contains()
    kernel.hasClass = function(node, clazz) {
        var classes = domAttr.get(dom.byId(node), 'class');
        var attrs = classes.split(' ');
        for(var i = 0; i < attrs.length; i++) {
            if(attrs[i].indexOf(clazz) == 0) {
                return attrs[i];
            }
        }
    };

    // escape HTML
    kernel.escapeHTML = function(str) {
        str = str.replace(/&/g, '&amp;');
        str = str.replace(/</g, '&lt;');
        str = str.replace(/>/g, '&gt;');
        str = str.replace(/"/g, '&quot;');
        return str;
    };
    // unescape HTML
    kernel.unescapeHTML = function(str) {
        var node = document.createElement('div');
        node.innerHTML = str;
        if(node.innerText !== undefined) { // IE
            return node.innerText;
        }
        return node.textContent;
    };

    return kernel;
});
