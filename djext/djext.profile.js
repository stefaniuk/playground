var

    test = function(filename, mid) {
        var list = {
        };
        return (mid in list) || /^djext\/tests\//.test(mid);
    },

    copyOnly = function(filename, mid) {
        var list = {
            'djext/djext.profile.js': 1,
            'djext/package.json': 1
        };
        return (mid in list) || /(png|jpg|jpeg|gif|ico)$/.test(filename);
    },

    miniExclude = function(filename, mid) {
        var list = {
        };
        return (mid in list);
    };

var profile = (function() {

    return {

        // relative to this file
        basePath: '..',

        // relative to base path
        releaseDir: './build',

        packages: [{
            name: 'dojo',
            location: './dojo'
        },
        {
            name: 'dijit',
            location: './dijit'
        },
        {
            name: 'dojox',
            location: './dojox'
        },
        {
            name: 'djext',
            location: './djext'
        }],

        action: 'clean,release',

        cssOptimize: 'comments',

        mini: true,

        //optimize: 'closure',

        layerOptimize: 'closure',

        stripConsole: 'all',

        selectorEngine: 'acme',

        defaultConfig:{
            hasCache:{
                'dojo-built': 1,
                'dojo-loader': 1,
                'dom': 1,
                'host-browser': 1,
                'config-selectorEngine': 'acme'
            },
            async: 1
        },

        layers: {
            'dojo/dojo': {
                include: [
                    'dojo/main',
                    'dojo/domReady'
                ],
                boot: true,
                customBase: true
            },
            'djext/djext': {
                include: [
                    'djext/main'
                ]
            },
            'djext/djext-widget': {
                include: [
                    'djext/djext',
                    'djext/_Widget',
                    'djext/_WidgetTemplated'
                ],
                exclude: [
                    'djext/djext'
                ]
            }
        },

        resourceTags: {
            test: function(filename, mid) {
                return test(filename, mid);
            },
            copyOnly: function(filename, mid) {
                return copyOnly(filename, mid);
            },
            amd: function(filename, mid) {
                return !test(filename, mid) && !copyOnly(filename, mid) && /\.js$/.test(filename);
            },
            miniExclude: function(filename, mid) {
                return miniExclude(filename, mid);
            }
        }

    };

})();

