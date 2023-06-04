<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->
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
	
	<div><h2>내 정보 페이지 기능은 구현중에있습니다.</h2></div>
	
		<div class="container">
		<div class="row">
			<ul>
				<li>유저명</li>
				<li>작성글</li>
				<li>작성댓글</li>
				<li>가입일</li>
				<li>기타정보</li>
				<li>회원탈퇴</li>
			</ul>
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
