<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css"> <!-- 빠른 디자인을 위해 bootstrap.js 이용했음... 향후 수정 필요  -->
<title>Hstory Main Page</title>
</head>
<body>
	<%
		// 로그인 된 경우 그 정보를 담음
		String id = null;
		if (session.getAttribute("id") != null)
		{
			id = (String) session.getAttribute("id");
		}
		
		int story_id = 0;
		if (request.getParameter("boardID") != null){
			story_id = Integer.parseInt(request.getParameter("story_id"));
		}
	%>



	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="MainPage.jsp">JSP 게시판 웹 사이트</a>
		</div>
		
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<!-- class="active" 에 선택했다는 듯한 css 추가 필요 -->
				<li><a href="MainPage.jsp">메인</a></li> 
				<li class="active"><a href="bbs.jsp">게시판</a></li>
				<li><a href="bbs_review.jsp?category=한식">맛집칼럼</a></li>
			</ul>
			
			<!-- 로그인 하지 않은 경우 회원가입/로그인 가능하도록 -->
			<%
				if(id == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="Login.jsp">로그인</a></li>
						<li><a href="Join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			
			<!-- 로그인 된 경우에는 로그인 nav 페이지 -->
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">마이페이지<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="Logout.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
			<!-- 여기까지 -->

		</div>
	</nav>
	
	<!-- 게시판은 하나의 테이블 구조임 -->
	<div class="container">
		<div class="row">
		<!-- <form method="post" action="writeAction.jsp"> -->
		<form method="post" encType = "multipart/form-data" action="WriteAction.jsp?story_id=<%= story_id %>">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan ="2" style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
						<label for="category">게시판:</label>
						<select name="category">
								  <option value="한식">한식</option>
								  <option value="일식">일식</option>
								  <option value="중식">중식</option>
								  <option value="양식">양식</option>
								  <option value="기타">기타</option>
						</select>
						<input type="text" class="form-control" placeholder="글 제목" name="title" maxlength="50"></td>
					</tr>
					<tr>
						<td><input type="file" name="img" class="form-control"></td>
					</tr>
					<tr>
						<td><textarea class="form-control" placeholder="글 내용" name=content maxlength="2048" style="height: 350px;"></textarea></td>
					</tr>
				</tbody>
			</table>
			<input type="submit" class="btn btn-primary pull-right" value="글쓰기">
		</form>
		</div>
	</div>
	
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

	<!-- Bootstrap JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
		
</body>
</html>
