<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="Board.BoardDAO" %>
<%@ page import="Board.Board" %>
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
		// 로그인중에 회원가입 시도 방지를 위한 코드
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
		
		Board board = new BoardDAO().getBbs(story_id);
		System.out.println("bbs : " + board);
		BoardDAO boardDAO = new BoardDAO();
		UserDAO userDAO = new UserDAO();
		
		// 어드민이라면 그냥 삭제
				if(userDAO.chkAdmin(id)){
					int result = boardDAO.delete(story_id);
					
					if (result == -1) // 글삭제 실패
					{
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('글 삭제에 실패했습니다.')"); 
						script.println("history.back()"); 			 
						script.println("</script>");
					}
					else 
					{
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("location.href = 'bbs.jsp'"); 
						script.println("</script>");
					}
				}
		
		// 로그인 한 사람과 글 작성자가 동일하지 않다면
		if( !id.equals( boardDAO.getUserNid( board.getUser_id() )) ) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('글을 수정할 권한이 없습니다.')"); 
			script.println("location.href = 'bbs.jsp'"); 			 
			script.println("</script>");
		} else{
			
			int result = boardDAO.delete(story_id);
				
			if (result == -1) // 글삭제 실패
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글 삭제에 실패했습니다.')"); 
				script.println("history.back()"); 			 
				script.println("</script>");
			}
			else 
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'bbs.jsp'"); 
				script.println("</script>");
			}
		}
	%>
	
</body>
</html>
