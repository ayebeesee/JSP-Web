<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Board.BoardDAO" %>
<%@ page import="Board.Board" %>
<%@ page import="Reply.Reply" %>
<%@ page import="Reply.ReplyDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->

<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>

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
		
		int comment_id = 0;
		if(request.getParameter("comment_id")!=null)
			comment_id = Integer.parseInt(request.getParameter("comment_id"));
		if(comment_id == 0){
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 댓글입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		
		// 여기서부터 수정
		BoardDAO bbsDAO = new BoardDAO();
		
		Reply comment = new ReplyDAO().getReply(comment_id);
		
		if(!id.equals(bbsDAO.getUserNid(comment.getUser_id()))){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('타인의 댓글을 수정할 권한이 없습니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else {
			if(request.getParameter("content") == null){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('입력이 안 된 사항이 있습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}else{
					ReplyDAO commentDAO = new ReplyDAO();//하나의 인스턴스
					int result = commentDAO.update(story_id, comment_id, request.getParameter("content"));
					if(result == -1){//데이터 베이스 오류가 날 때
						PrintWriter script=response.getWriter();
						script.println("<script>");
						script.println("alert('댓글 수정에 실패했습니다.')");
						script.println("history.back()");
						script.println("</script>");
					}
					else{
						PrintWriter script=response.getWriter();
						script.println("<script>");
						script.println("location.href= \'View.jsp?story_id="+story_id+"\'");
						script.println("</script>");
					}
			}
		
		}
		
	%>
	
</body>
</html>
