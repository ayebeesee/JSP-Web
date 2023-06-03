<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- 건너오는 데이터를 utf-8로 받기위해 사용 (인코딩 관련) -->

<jsp:useBean id="user" class="user.User" scope="page" /><!-- 아래의 변수들이 여기 user에 저장됨. -->
<jsp:setProperty name="user" property="id" />			<!-- login.jsp 에서 받아온 userID 값을 user에 넣어줌. -->
<jsp:setProperty name="user" property="password" />		<!-- login.jsp 에서 받아온 pswd 값을 user에 넣어줌. -->
    
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
		// 중복 로그인 방지를 위한 코드
		if (id != null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')"); 
			script.println("location.href = 'MainPage.jsp'"); // 로그인 성공하면 main.jsp 페이지로 이동
			script.println("</script>");
		}
	
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(user.getId(), user.getPassword());
		
		if (result == 1) // 로그인 성공
		{
			session.setAttribute("id", user.getId()); // 정상적인 접근을 한 유저에게 session을 부여함. 
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'MainPage.jsp'"); // 로그인 성공하면 main.jsp 페이지로 이동
			script.println("</script>");
		}
		else if (result == 0) // 비밀번호 오류
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀립니다.')"); // 비밀번호 틀렸을 때.
			script.println("history.back()"); 			// 뒤로가기? 시켜서 다시 로그인 페이지로. 
			script.println("</script>");
		}
		else if (result == -1) // 아이디 오류
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if (result == -2) // DB 오류
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()"); 
			script.println("</script>");
		}
	%>
	
</body>
</html>
