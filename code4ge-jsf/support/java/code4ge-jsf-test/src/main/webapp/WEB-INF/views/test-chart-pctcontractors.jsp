<!--[if IE 7]>
<!DOCTYPE>
<html lang="en">
<head>
<![endif]-->
<!--[if IE 8]>
<!DOCTYPE>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<![endif]-->
<![if gte IE 9]>
<!DOCTYPE HTML>
<html lang="en">
<head>
<![endif]>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Code4ge JSF - Test: Chart Columns</title>
    <link rel="stylesheet" type="text/css" href="/code4ge-jsf-test/dojo/1.7.1/dojo/resources/dojo.css" />
    <link rel="stylesheet" type="text/css" href="/code4ge-jsf-test/dojo/1.7.1/dijit/themes/claro/claro.css" />
    <link rel="stylesheet" type="text/css" href="/code4ge-jsf-test/dojo/1.7.1/code4ge/themes/code4ge/code4ge.css" />
    <style type="text/css">
        html, body {
            overflow: visible !important;
        }
    </style>
    <script type="text/javascript"
        src="/code4ge-jsf-test/dojo/1.7.1/dojo/dojo.js"
        data-dojo-config="async: 1, parseOnLoad: true, locale: 'en'"
    ></script>
    <script type="text/javascript">
        require([
            'code4ge/main',
            'code4ge/chart/ChartColumns',
            'code4ge/data/JsonRpcStore'
        ]);
    </script>
</head>
<body>
    <div
        data-dojo-type="code4ge.chart.ChartColumns"
        data-dojo-props="store:'/code4ge-jsf-test/pctcontractors/store/pctcontractors',query:{pctCode:'*'},field:'percentageDulicate'"
    ></div>
</body>
</html>
