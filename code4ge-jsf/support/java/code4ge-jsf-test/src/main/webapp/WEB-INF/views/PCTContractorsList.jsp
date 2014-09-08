<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.code4ge.jsf.ui.Bootstrap"%>
<%
    Bootstrap ui = (Bootstrap) request.getAttribute("Bootstrap");
%>
<%= ui.toString() %>

<table>
<c:forEach var="item" items="${pctcontractors}">
	<tr>
		<td>${item.pctCode}</td>
		<td>${item.pctName}</td>
		<td>${item.percentageDulicate}</td>
    </tr>
</c:forEach>
</table>
