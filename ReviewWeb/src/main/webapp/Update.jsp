<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->
<%@ page import="Board.Board" %> 
<%@ page import="Board.BoardDAO" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/main.css"> <!-- 빠른 디자인을 위해 bootstrap.js 이용했음... 향후 수정 필요  -->
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
		
		

		if (id == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.')"); 
			script.println("location.href = 'Login.jsp'"); 			 
			script.println("</script>");
		}
		
		// 게시판 id 파라메터
		int story_id = 0;
		if (request.getParameter("story_id") != null)
		{
			story_id = Integer.parseInt(request.getParameter("story_id"));
		}
		if (story_id == 0)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')"); 
			script.println("location.href = 'bbs.jsp'"); 			 
			script.println("</script>");
		}
		
		Board Board = new BoardDAO().getBbs(story_id);
		System.out.println("bbs : " + Board);
		BoardDAO BoardDAO = new BoardDAO();
		
		// 로그인 한 사람과 글 작성자가 동일하지 않다면
		if( !id.equals( BoardDAO.getUserNid( Board.getUser_id() )) ) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('글을 수정할 권한이 없습니다.')"); 
			script.println("location.href = 'bbs.jsp'"); 			 
			script.println("</script>");
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
				<a class="navbar-brand" href="MainPage.jsp">H-STORY</a>
		</div>
		
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<!-- class="active" 에 선택했다는 듯한 css 추가 필요 -->
				<li><a href="MainPage.jsp">메인</a></li> 
				<li class="active"><a href="bbs.jsp">게시판</a></li>
				<li><a href="bbs_review.jsp">맛집칼럼</a></li>
			</ul>
			
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


		</div>
	</nav>
	
	<!-- 게시판은 하나의 테이블 구조임 -->
	<div class="container">
		<div class="row">
		<!-- <form method="post" action="updateAction.jsp?story_id=<%= story_id %>"> -->
		<form method="post" encType = "multipart/form-data" action="UpdateAction.jsp?story_id=<%= story_id %>">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan ="2" style="background-color: #80ff00; text-align: center; color:#fff;">게시판 글 수정 양식</th>
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
						<input type="text" class="form-control" placeholder="글 제목" name="title" maxlength="50" value="<%= Board.getTitle() %>"></td>
					</tr>
					<tr>
						<td><input type="file" name="img" class="form-control"></td>
					</tr>
					<tr>
						<td><textarea class="form-control" placeholder="글 내용" name=content maxlength="2048" style="height: 350px; width:1080px;"><%= Board.getContent() %></textarea></td>
					</tr>
				</tbody>
			</table>
			<div class="input-box">
			<input type="submit" class="btn btn-primary pull-right" value="글수정">
			</div>
		</form>
		</div>
	</div>
	
	
	<!-- jQuery -->
	

	<!-- Bootstrap JavaScript -->
	
		
</body>
</html>
