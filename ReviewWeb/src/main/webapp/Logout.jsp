<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 리뷰 관리 사이트</title>
</head>
<body>
		<%
		session.invalidate();	
	%>
	<script>
		location.href  = "MainPage.jsp";
	</script>
</body>
</html>