<!doctype html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>dojotoolkit-resourceservlet</title>
    <style type="text/css">
        @import "resources/custom/themes/custom/custom.css";
    </style>
    <script type="text/javascript">
        var dojoConfig = {
            async: true,
            parseOnLoad: true,
            locale: 'en',
            paths: {
                custom: '../../custom'
            }
        };
    </script>
    <script type="text/javascript" src="resources/dojotoolkit/dojo/dojo.js"></script>
    <script type="text/javascript">
        require([
            'dojo/ready',
            'custom/main'
        ], function(ready) {
            ready(function() {
                console.log('TADA!');
            });
        });
    </script>
</head>
<body class="claro">
    <div>dojotoolkit-resourceservlet</div>
</body>
</html>
