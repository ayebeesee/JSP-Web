<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Board.BoardDAO" %>
<%@ page import="Board.Board" %>
<%@ page import="likes.LikesDAO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->

<% request.setCharacterEncoding("UTF-8"); %> <!-- 건너오는 데이터를 utf-8로 받기위해 사용 (인코딩 관련) -->

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
		// 로그인중에만 좋아요 가능
		if (id == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.')"); 
			script.println("location.href = 'Login.jsp'"); // 로그인 성공하면 main.jsp 페이지로 이동
			script.println("</script>"); 
		}
		
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
		BoardDAO BoardDAO = new BoardDAO();
		LikesDAO likesDAO = new LikesDAO();
		UserDAO userDAO = new UserDAO();
				
		
		// 추천해제는 다른거 체크 안해도 상관x
		likesDAO.unlike(id, story_id);
		
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('추천해제가 완료되었습니다.')");
		script.println("location.href= \'View.jsp?story_id="+story_id+"\'");
		script.println("</script>");
	%>
	
</body>
</html>
