<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>

<jsp:useBean id="user" class="user.User" scope="page" /> <!-- 아래의 변수들이 여기 user에 저장됨. -->
<jsp:setProperty name="user" property="name" />		<!-- login.jsp 에서 받아온 name 값을 user에 넣어줌. -->
<jsp:setProperty name="user" property="email" />		<!-- login.jsp 에서 받아온 email 값을 user에 넣어줌. -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/main.css"> <!-- 빠른 디자인을 위해 bootstrap.js 이용했음... 향후 수정 필요  -->

<title>Hstory Main Page</title>
</head>
<body>
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
		</div>
	</nav>
	
	<!-- 아이디 찾은 화면 -->
	<form name="idsearch" method="post">
      <%
      	UserDAO dao = new UserDAO();
      	String user_id = dao.findId(user.getName(), user.getEmail());
       if (user_id != null) {
      %>
      
      <div class = "container-find">
      	<div class = "found-success">
	      <h4>  회원님의 아이디는 </h4>  
	      <div class ="found-id"><%=user_id%></div>
	      <h4>  입니다 </h4>
	     </div>
	     <p><a href="Login.jsp">로그인 하러 가기</a></p>
       </div>
      <%
  } else {
 %>
        <div class = "container-find">
      	<div class = "found-fail">
	      <h4>  등록된 정보가 없습니다 </h4>  
	     </div>
	     <div class = "found-login">
 		    <input type="button" id="btnback" value="다시 찾기" onClick="history.back()"/>
 		    <p><a href="Join.jsp">회원가입 하러 가기</a></p>
       	</div>
       </div>
       
       <%
  }
 %> 
      </form>
	
	
</body>
</html>