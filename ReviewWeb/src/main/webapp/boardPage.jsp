<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page import="java.io.PrintWriter" %>
<%@ page import="Board.BoardDAO" %>
<%@ page import="Board.Board" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>리뷰 관리 사이트 - 한식</title>
<link rel="stylesheet" href="css/ReviewPage.css?after">
</head>
<body>
	<div class="container">
		<%
		String id = null;
		if (session.getAttribute("id") != null) {
			id = (String) session.getAttribute("id");
		}
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	<nav>
		<a href="MainPage.jsp">기말 프로젝트 테스트</a>
		<ul>
			<li><a href="MainPage.jsp">메인</a></li>
			<li class="active"><a href="boardPage.jsp">게시판</a></li>
		</ul>
		<%
			if (id == null) {
		%>
		<ul>
			<li><a href="Login.jsp">로그인</a></li>
			<li><a href="Join.jsp">회원가입</a></li>
		</ul>
		<%
			} else {
		%>
		<ul>
			<li><a href="Logout.jsp" onclick="alert('로그아웃 되었습니다.');">로그아웃</a></li>
		</ul>
		<%
			}
		%>
		</nav>
		<nav class="category-box">
			<ul>
				<li class="korea">한식</li>
				<li class="america">양식</li>
				<li class="japanese">일식</li>
				<li class="chinese">중식</li>
				<li class="other">그 외</li>
				<li class="go-to-all-review">전체보기</li>
			</ul>
		</nav>
		
		<div class="pages">
				<ul>
					<li class="firstpage">＜</li>
					<li>1</li>
					<li>2</li>
					<li>3</li>
					<li>4</li>
					<li>5</li>
					<li>6</li>
					<li>7</li>
					<li>8</li>
					<li>9</li>
					<li>10</li>
					<li class="nextpage">＞</li>
				</ul>
			</div>
			<div class="go-write">
			<a href="Write.jsp">글쓰기</a>
		</div>
	</div>
</body>
</html>