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
            name: 'less',
            location: './less'
        },
        {
            name: '960gs',
            location: './960gs'
        },
        {
            name: 'code4ge',
            location: './code4ge'
        }
    ],

    build : {

        basePath: '../',
        releaseDir: '.',
        releaseName: 'build',

        layers : {
            'code4ge/code4ge': {
                include: [
                    'code4ge/main'
                ]
            },
            'code4ge/code4ge-encryption': {
                include: [
                    'code4ge/code4ge',
                    'code4ge/encryption/main'
                ],
                exclude: [
                    'code4ge/code4ge'
                ]
            },
            'code4ge/code4ge-form': {
                include: [
                    'code4ge/code4ge',
                    'code4ge/form/Form',
                    'code4ge/form/FormDateBox',
                    'code4ge/form/FormLabel',
                    'code4ge/form/FormTextArea',
                    'code4ge/form/FormTextBox',
                    'code4ge/form/FormTimeBox'
                ],
                exclude: [
                    'code4ge/code4ge'
                ]
            },
            'code4ge/code4ge-chart': {
                include: [
                    'code4ge/code4ge',
                    'code4ge/chart/ChartBars',
                    'code4ge/chart/ChartLines',
                    'code4ge/chart/ChartPie'
                ],
                exclude: [
                    'code4ge/code4ge'
                ]
            }
        },

        //optimize: 'closure', // with this option it takes ages to build
        cssOptimize: 'comments',
        layerOptimize: 'closure'
    }

};
