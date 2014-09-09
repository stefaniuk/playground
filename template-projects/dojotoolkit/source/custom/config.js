var dojoConfig = {

    packages:[
        {
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
            name: 'xstyle',
            location: './xstyle'
        },
        {
            name: 'put-selector',
            location: './put-selector'
        },
        {
            name: 'dgrid',
            location: './dgrid'
        },
        {
            name: 'custom',
            location: './custom'
        }
    ],

    build : {

        basePath: '../',
        releaseDir: '.',
        releaseName: 'build',

        layers : {
            'custom/custom': {
                include: [
                    'custom/main'
                ]
            }
        },

        //optimize: 'closure', // with this option it takes long time to build
        cssOptimize: 'comments',
        layerOptimize: 'closure'
    }

};
