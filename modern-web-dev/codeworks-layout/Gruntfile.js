'use strict';

module.exports = function (grunt) {

    require('load-grunt-tasks')(grunt, { pattern: [
        'grunt-*',
        '!grunt-build-lifecycle' // must be loaded after `grunt.initConfig`
    ]});
    require('time-grunt')(grunt);

    // configuration options
    var config = {
        src: require('./bower.json').appPath || 'src',
        test: 'test',
        dist: 'dist'
    };

    grunt.initConfig({

        config: config,

        // provide Maven-like project life cycle
        lifecycle: {
            clean: [],
            validate: [
                'jshint',
                'csslint',
                'lesslint'
            ],
            initialize: [],
            compile: [],
            test: [],
            package: [],
            verify: [],
            install: [],
            deploy: [],
            site: []
        },

        jshint: {
            options: {
                jshintrc: '.jshintrc'
            },
            src: [
                'Gruntfile.js',
                '<%= config.src %>/scripts/{,*/}*.js',
                '<%= config.test %>/scripts/{,*/}*.js'
            ]
        },
        csslint: {
            options: {
                csslintrc: '.csslintrc'
            },
            src: [
                '<%= config.src %>/styles/**/*.css',
                '!<%= config.src %>/styles/main.css',
            ]
        },
        lesslint: {
            options: {
                csslint: {
                    csslintrc: '.csslintrc'
                }
            },
            src: [
                '<%= config.src %>/styles/**/*.less',
            ]
        }

    });

    // must run after `grunt.initConfig`
    grunt.loadNpmTasks('grunt-build-lifecycle');

    // define default task
    grunt.registerTask('default', [
        'package'
    ]);

    /*grunt.registerTask('test', [
        'clean:server',
        'coffee',
        'less',
        'copy:server',
        'connect:test',
        'mocha'
    ]);

    grunt.registerTask('build', [
        'clean:dist',
        'copy:server',
        'useminPrepare',
        'concurrent',
        'cssmin',
        'concat',
        'uglify',
        'copy',
        'rev',
        'usemin'
    ]);

    grunt.registerTask('serve', function (target) {
        if(target === 'dist') {
            return grunt.task.run(['build', 'connect:dist:keepalive']);
        }
        grunt.task.run([
            'clean:server',
            'coffee',
            'less',
            'copy:server',
            'connect:livereload',
            'watch'
        ]);
    });*/

};
