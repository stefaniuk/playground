dependencies = {
    "layers": [
        {
            "dependencies": [
                "dojo.parser",
                "dijit.layout.BorderContainer",
                "dijit.layout.ContentPane"
            ],
            "name": "dojo.js"
        },
        {
            "dependencies": ["code4ge.jsf.base"],
            "name": "code4ge.jsf.js"
        },
        {
            "dependencies": ["code4ge.cmf.base"],
            "layerDependencies": ["code4ge.jsf.js"],
            "name": "code4ge.cmf.js"
        }
    ],
    "prefixes": [
        [
            "code4ge.cmf",
            "../code4ge/cmf"
        ],
        [
            "dijit",
            "../dijit"
        ],
        [
            "dojox",
            "../dojox"
        ],
        [
            "code4ge.jsf",
            "../code4ge/jsf"
        ]
    ]
};
