<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->
<%@ page import="Board.Board" %>
<%@ page import="Board.BoardDAO" %>
<%@ page import="user.User" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<!-- <link rel="stylesheet" href="css/bootstrap.css"> <!-- 빠른 디자인을 위해 bootstrap.js 이용했음... 향후 수정 필요  -->
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
		int pageNumber = 1; // 기본 페이지 1
		// 파라미터 값이 넘어온게 있다면
		if (request.getParameter("pageNumber") != null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
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
			
			<div class="search-container">
					<div class="row">
						<form method="post" name="search" action="bbsSearch.jsp">
							<table class="pull-right">
								<tr>
									<td><select class="form-control" name="searchField">
											<option value="0">전체</option>
											<option value="title">제목</option>
											<option value="user_name">작성자</option>
									</select></td>
									<td><input type="text" class="form-control"
										placeholder="검색어를 입력해주세요" name="searchText" maxlength="100"></td>
									<!-- <td><button type="submit" class="btn btn-success"><i class="fa fa-search"></i></button></td> -->
								</tr>
			
							</table>
						</form>
					</div>
				</div>
			
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
				
			
	<div class="category-con">
		<div>
			<ul >
        		<li><a href="bbs_review.jsp?category=한식">한식</a></li>
        		<li><a href="bbs_review.jsp?category=중식">중식</a></li>
        		<li><a href="bbs_review.jsp?category=일식">일식</a></li>
        		<li><a href="bbs_review.jsp?category=양식">양식</a></li>
        		<li><a href="bbs_review.jsp?category=기타">기타</a></li>
        	</ul>
    	</div>
	</div>
<div class="container-categry">
    <div class="row">
        <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
          
  			<thead>
    			<tr>
      				<th style="background-color: #80ff00; text-align: center;">번호</th>
      				<th style="background-color: #80ff00; text-align: center;">제목</th>
      				<th style="background-color: #80ff00; text-align: center;">작성자</th>
      				<th style="background-color: #80ff00; text-align: center;">작성일</th>
      				<th style="background-color: #80ff00; text-align: center;">조회수</th>
      				<th style="background-color: #80ff00; text-align: center;">추천수👍</th>
    			</tr>
  			</thead>
  			<tbody>
    		<% 
        		String category = request.getParameter("category");
        		if (category == null) {
            	category = "1"; // 기본 카테고리 설정
        		}
        
        		BoardDAO boardDAO = new BoardDAO();
		        
        		ArrayList<Board> list = boardDAO.getCategory(category, pageNumber); // getCategory() 함수로 카테고리 별 게시글 목록을 가져옴
        		System.out.println(list);
        		for (int i = 0; i < list.size(); i++) {
    		%>
    			<tr>
      				<th><%= list.get(i).getStory_id() %></th>
      				<th><a href="View.jsp?story_id=<%= list.get(i).getStory_id() %>"><%= list.get(i).getTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></th>
      				<th><a href="userpage.jsp"><%= userDAO.getUserName(list.get(i).getUser_id())%></a></th>
      				<th><%= list.get(i).getCreated_date().substring(0, 11) %></th>
      				<th><%=list.get(i).getRead_cnt()%></th>
      				<th><%=list.get(i).getLike_cnt()%></th>
    			</tr>
    		<% } %>
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
	
	
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

	<!-- Bootstrap JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
		
</body>
</html>
