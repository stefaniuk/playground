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
            name: 'nhs',
            location: './nhs'
        }
    ],

    build : {

        basePath: '../',
        releaseDir: '.',
        releaseName: 'build',

        layers : {
            'nhs/nhs': {
                include: [
                    'dijit/layout/BorderContainer',
                    'dijit/layout/ContentPane',
                    'dojox/layout/ExpandoPane',
                    'nhs/ControlSettings',
                    'dojox/widget/DataPresentation',
                    'dojox/charting/themes/Claro'
                ]
            }
        },

        //optimize: 'closure', // with this option it takes ages to build
        cssOptimize: 'comments',
        layerOptimize: 'closure'
    }

};
