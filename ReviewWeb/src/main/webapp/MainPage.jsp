<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->
<%@ page import="Board.BoardDAO" %>
<%@ page import="Board.Board" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<!--<link rel="stylesheet" href="css/bootstrap.css">--> <!-- 빠른 디자인을 위해 bootstrap.js 이용했음... 향후 수정 필요  -->
<link rel="stylesheet" href="css/main.css">
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
		
		// 파라미터 값이 넘어온게 있다면
		int pageNumber = 1;
		
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
		
		<div class="container">
			<div class="row">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd; border-radius:10px; ">
				<!--
				 <thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">이미지</th>						
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
						<th style="background-color: #eeeeee; text-align: center;">조회수</th>
						<th style="background-color: #eeeeee; text-align: center;">추천수👍</th>
					</tr>
				</thead>
				 -->
				<!-- 게시글 출력 부분 -->
				<tbody  style="text-align:left;">
								
				<%
				BoardDAO bbsDAO = new BoardDAO();
				ArrayList<Board> list = bbsDAO.getTopFiveByLikes();
				if(list.isEmpty()){
					System.out.println("비어있음");
				}else{
					System.out.println("들어있음");
				}
				for (int i = 0; i < list.size(); i++) {
					 
					
				%>
					<tr>
						<td><a href="View.jsp?story_id=<%= list.get(i).getStory_id() %>"><img src = "upload/<%= list.get(i).getStory_id() %>사진.jpg"  width="300px" height="300px"></a></td>
						<td><a href="View.jsp?story_id=<%= list.get(i).getStory_id() %>">제&nbsp&nbsp&nbsp목 : <%= list.get(i).getTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
  						<td><a href="userpage.jsp">작성자 : <%= userDAO.getUserName(list.get(i).getUser_id())%></a></td>
  						<td>작성일 : <%= list.get(i).getCreated_date().substring(0, 11) %></td>
						<td>조회수 : <%=list.get(i).getRead_cnt()%></td>
					</tr>
				<%
				}
				%>

				</tbody>
			</table>
			
			</div>
		</div>
		<div class="category-con">
			<div>
				<ul >
					<li><a href="bbs.jsp">전체보기</a></li>
					<li><a href="bbs_review.jsp?category=한식">맛집칼럼</a></li>
				</ul>						
			</div>
		</div>
		<table class="table-con">
			<thead>
				<tr>
					<th style="background-color: #80ff00; text-align: center;">번호</th>
					<th style="background-color: #80ff00; text-align: center;">제목</th>
					<th style="background-color: #80ff00; text-align: center;">유저</th>
					<th style="background-color: #80ff00; text-align: center;">작성일자</th>
					<th style="background-color: #80ff00; text-align: center;">조회수</th>
					<th style="background-color: #80ff00; text-align: center;">추천수</th>
				</tr>
			</thead>
			<tbody>
				<%
					
					ArrayList<Board> List = bbsDAO.getList(pageNumber);
					for(int i = 0; i < List.size(); i++) {
				%>
				<tr>
					<td><%= List.get(i).getStory_id() %></td>
					<th><a href="View.jsp?story_id=<%= List.get(i).getStory_id() %>"><%= List.get(i).getTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></th>
					<td><a href="userpage.jsp"><%= userDAO.getUserName(List.get(i).getUser_id())%></a></td>
					<th><%= List.get(i).getCreated_date().substring(0, 11) %></th>
					<th><%=List.get(i).getRead_cnt()%></th>
					<td><%=List.get(i).getLike_cnt()%></td>					
				</tr>					
				<%
					}
				%>
			</tbody>
		</table>
	
	
	
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

	<!-- Bootstrap JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
		
</body>
</html>
