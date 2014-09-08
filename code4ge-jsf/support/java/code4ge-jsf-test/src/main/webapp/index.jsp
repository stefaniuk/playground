<%@page import="com.code4ge.jsf.ui.Bootstrap"%>
<%@page import="com.code4ge.jsf.ui.Bootstrap.Dojo"%>
<!doctype html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>code4ge-jsf-test</title>
<%
    Bootstrap bootstrap = new Bootstrap();
    Dojo dojo = new Dojo()
        .addDojoConfig("async", "1")
        .requireModule("dojo", "dojo")
        .requireModule("code4ge/main", "code4ge")
        .addReady("console.log(code4ge.version);")
    ;
    bootstrap.setDojo(dojo);
%>
<%= bootstrap.toString() %>
</head>
<body>
    This is the main screen.
</body>
</html>
