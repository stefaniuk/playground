<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.code4ge.jsf.ui.Bootstrap"%>
<%
    Bootstrap ui = (Bootstrap) request.getAttribute("Bootstrap");
%>
<%= ui.toString() %>

<table>
<c:forEach var="item" items="${earthquakes}">
	<tr>
		<td>${item.year}</td>
		<td>${item.month}</td>
		<td>${item.day}</td>
		<td>${item.country}</td>
    </tr>
</c:forEach>
</table>
