<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="Board.Board" %>
<%@ page import="Reply.Reply" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>
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
			script.println("location.href = 'MainPage.jsp'"); // 로그인 성공하면 main.jsp 페이지로 이동
			script.println("</script>");
		}
		UserDAO userDAO = new UserDAO();
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
				<a class="navbar-brand" href="MainPage.jsp">H_STORY</a>
		</div>
		
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<!-- class="active" 에 선택했다는 듯한 css 추가 필요 -->
				
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
			<div><%= id %>님 환영합니다!&nbsp&nbsp&nbsp</div>
				<li class="dropdown">
					<a href="userinfo.jsp" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">마이페이지<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="userinfo.jsp">내정보</a></li>
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
	
<% 
	User user = userDAO.getUserInfo(id);
	ArrayList<Board> story_list = userDAO.getStories(id);
	ArrayList<Reply> reply_list = userDAO.getReplies(id);
%>
	
	<div class="mycontainer" >
		<table class="table table-striped" style="text-align: left; border: 1px solid #dddddd; border-radius:10px; margin:0 auto; font-size:1.5rem; margin-top:50px; ">
			<tbody>
				<tr>
					<td>내 이름: <%= user.getName() %></td>
					<td>이메일: <%= user.getEmail() %></td>
					<td>계정 생성 날짜: <%= user.getCreated_date().substring(0, 11) %></td>
				</tr>
			</tbody>
		</table>
			
		<div class="container">
			<div class="row">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd; border-radius:10px; ">
				
				<!-- 게시글 출력 부분 -->
				<tbody  style="text-align:left;">
								
				<%
				
				for (int i = 0; i < story_list.size(); i++) {
					 
					
				%>
					<tr>
						<td><a href="View.jsp?story_id=<%= story_list.get(i).getStory_id() %>"><img src = "upload/<%=story_list.get(i).getStory_id() %>사진.jpg"  width="300px" height="300px"></a></td>
						<td><a href="View.jsp?story_id=<%= story_list.get(i).getStory_id() %>">제&nbsp&nbsp&nbsp목 : <%= story_list.get(i).getTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
  						<td><a href="userpage.jsp">작성자 : <%= userDAO.getUserName(story_list.get(i).getUser_id())%></a></td>
  						<td>작성일 : <%= story_list.get(i).getCreated_date().substring(0, 11) %></td>
						<td>조회수 : <%=story_list.get(i).getRead_cnt()%></td>
						<td>좋아요 : <%=story_list.get(i).getLike_cnt()%></td>
					</tr>
				<%
				}
				%>

				</tbody>
			</table>
			
			</div>
			</div>
			<div class="text-box" style="text-align:center; margin-top:50px; font-size:2rem; font-weight: bold;">
				<span>내가 쓴 댓글</span>
			</div>
			<table class="table-con" style="text-align: center; border: 1px solid #dddddd; width:1440px; ">
				<thead>
					<tr>
						<th style="background-color: #80ff00; text-align: center; width:1000px;">댓글</th>
						<th style="background-color: #80ff00; text-align: center;">작성 날짜</th>
						
					</tr>
				</thead>
				<!-- 게시글 출력 부분 -->
				<tbody>
								
				<%
					for(int i = 0; i < reply_list.size(); i++) {

				%>
					<tr>
						<th><%= reply_list.get(i).getContent() %></th>
						<th><%= reply_list.get(i).getCreated_date().substring(0, 11).substring(0, 11) %></th>
					</tr>
				<%
					}
				%>
				</tbody>
			</table>
		</div>


	</div>
	
	<button type="button" class="navbar-toggle2 collapsed" onclick="goBack()">뒤로가기</button>
	<script>
		function goBack() {
		  window.history.back(); // 뒤로가기
		}
	</script>
	
	

		
</body>
</html>
