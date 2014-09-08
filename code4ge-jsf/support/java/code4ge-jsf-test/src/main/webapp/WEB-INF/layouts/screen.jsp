<%@taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@page import="com.code4ge.jsf.ui.Bootstrap"%>
<%@page import="com.code4ge.jsf.ui.Bootstrap.Dojo"%>
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
    <title><tiles:getAsString name="title" /> - ${subtitle}</title>
    <style type="text/css">
        html, body {
            overflow: visible !important;
        }
    </style>
    <%
        Bootstrap ui = (Bootstrap) request.getAttribute("Bootstrap");
        Dojo dojo = ui.getDojo();
        dojo.setEnvironment(Dojo.Environment.DEFAULT);
    %>
</head>
<body class="display-onready">
    <div class="screen-container">
        <div class="screen-top">
            <tiles:insertAttribute name="header" />
        </div>
        <div class="screen-center">
            <tiles:insertAttribute name="content" />
        </div>
    </div>
</body>
</html>
