<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- 건너오는 데이터를 utf-8로 받기위해 사용 (인코딩 관련) -->

<jsp:useBean id="user" class="user.User" scope="page" /> <!-- 아래의 변수들이 여기 user에 저장됨. -->
<jsp:setProperty name="user" property="id" />			<!-- login.jsp 에서 받아온 userID 값을 user에 넣어줌. -->
<jsp:setProperty name="user" property="password" />		<!-- login.jsp 에서 받아온 pswd 값을 user에 넣어줌. -->
<jsp:setProperty name="user" property="name" />		<!-- login.jsp 에서 받아온 name 값을 user에 넣어줌. -->
<jsp:setProperty name="user" property="email" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hstory Main Page</title>
</head>
<body>
	<!-- 로그인 세션 -->
	<%
		// 유저 세션 확인용 변수 null 값이 아니면 로그인 중임.
		String id = null;
		if(session.getAttribute("id") != null)
		{
			id = (String) session.getAttribute("id");
		}
		// 로그인중에 회원가입 시도 방지를 위한 코드
		if (id != null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')"); 
			script.println("location.href = 'MainPage.jsp'"); // 로그인 성공하면 main.jsp 페이지로 이동
			script.println("</script>");
		}

		// 사용자 입력이 하나라도 비었는지 체크
		if( user.getId() == null || user.getPassword() == null || user.getName() == null || user.getEmail() == null ) 
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()"); 			
			script.println("</script>");
			
		}
		else
		{
			UserDAO userDAO = new UserDAO();
			int result = userDAO.join(user);
			
			if (result == -1) // 회원가입 실패
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')"); // id email 값이 pk기 때문에 이미 존재하는 경우가 됨.
				script.println("history.back()"); 			// 뒤로가기? 시켜서 다시 회원가입 페이지로. 
				script.println("</script>");
			}
			else // 회원가입 성공시
			{
				session.setAttribute("id", user.getId()); // 정상적인 접근을 한 유저에게 session을 부여함. 
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'MainPage.jsp'"); // main.jsp 로 이동.
				script.println("</script>");
			}
		}
	%>
	
</body>
</html>
