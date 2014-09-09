define([
    './kernel',
    'dojo/ready',
    'dojo/dom-class',
    'dojo/_base/window',
    'dojo/query',
    'dojo/topic',
    'dojox/collections/ArrayList',
    // not referenced explicitly
    'dojo/NodeList-dom'
], function(kernel, ready, domClass, win, query, topic, ArrayList) {

    // module:
    //        djext/_base/ready
    // summary:
    //        This module provides an enhancement to the ready feature.

    // set topic to be published when toolkit is loaded
    kernel.topic.ready = 'ready';

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
            var al = new ArrayList(queue);
            al.sort(function(a, b) { return a.order - b.order; });
            al.forEach(function(task) {
                task.func();
            });
        };

        return t;

    })();

    // final initialisation
    ready(function() {
        // try to call initialisation code as late as possible
        ready(function() {
            // add initialisation code that has to be run last
            tasks.add(function() {
                // use claro as a base theme
                if(!domClass.contains(win.body(), 'claro')) {
                    domClass.add(win.body(), 'claro');
                }
                // display invisable nodes
                query('.display-onready').removeClass('display-onready');
                // publishe an event
                topic.publish(kernel.topic.ready);
            }, 999);
            tasks.run();
        });
    });

    // enhanced ready
    kernel.ready = function(func, order) {
        tasks.add(func, order);
    };

    return kernel;
});
