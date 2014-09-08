var

	external = function(filename, mid) {
        var list = {
        };
        return (mid in list) || /^(less|960gs)\//.test(mid);
    },

	test = function(filename, mid) {
        var list = {
        };
        return (mid in list) || /^code4ge\/tests\//.test(mid);
    },

	copyOnly = function(filename, mid) {
        var list = {
            'code4ge/code4ge.profile.js': 1,
            'code4ge/config.js': 1,
            'code4ge/package.json': 1
        };
        return (mid in list) || /(png|jpg|jpeg|gif|ico)$/.test(filename);
    },

	miniExclude = function(filename, mid) {
        var list = {
        };
        return (mid in list);
    };

var profile = {

    basePath: '../',
    releaseDir: '.',
    releaseName: 'build',

    resourceTags: {
        test: function(filename, mid) {
            return test(filename, mid);
        },
        copyOnly: function(filename, mid) {
            return copyOnly(filename, mid);
        },
        amd: function(filename, mid) {
            return !external(filename, mid) && !test(filename, mid) && !copyOnly(filename, mid) && /\.js$/.test(filename);
        },
        miniExclude: function(filename, mid) {
            return miniExclude(filename, mid);
        }
    }

};
