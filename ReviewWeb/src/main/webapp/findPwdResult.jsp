<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>

<jsp:useBean id="user" class="user.User" scope="page" /> <!-- 아래의 변수들이 여기 user에 저장됨. -->
<jsp:setProperty name="user" property="id" />		<!-- login.jsp 에서 받아온 id 값을 user에 넣어줌. -->
<jsp:setProperty name="user" property="email" />		<!-- login.jsp 에서 받아온 email 값을 user에 넣어줌. -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css"> <!-- 빠른 디자인을 위해 bootstrap.js 이용했음... 향후 수정 필요  -->

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
				<li><a href="MainPage.jsp">메인</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
				<li><a href="bbs_review.jsp">맛집칼럼</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li class="active"><a href="Login.jsp">로그인</a></li>
						<li><a href="Join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	
	<!-- 아이디 찾은 화면 -->
      <%
      	UserDAO dao = new UserDAO();
      	String user_pwd = dao.findPwd(user.getId(), user.getEmail());

       if (user_pwd != null) {
      %>

	    <div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top: 20px;">
				<form method="post" action="pwdUpdateAction.jsp">
					<h3 style="text-align: center;"> 비밀번호를 재설정해야 합니다. </h3>
					<h3 style="text-align: center;"> 비밀번호 재설정 </h3>
					<div class="form-group">
						<% String emailValue = user.getEmail(); %>
						<input type="hidden" name="email" value="<%= emailValue %>">
						<input type="text" class="form-control" placeholder="새로운 비밀번호" name="password" maxlength="20">
					</div>
					<input type="submit" class="btn btn-primary form-control" value="적용">
				</form>
			</div>
		</div>
		<div class="col-lg-4"></div>
	</div>
	     
	     <div>
	     <p><a href="Login.jsp">로그인 하러 가기</a></p>
       	</div>
      <%
  } else {
 %>
        <div class = "container">
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
	
	
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

	<!-- Bootstrap JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
		
</body>
</html>