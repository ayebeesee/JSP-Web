<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Reply.ReplyDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="reply" class="Reply.Reply" scope="page" />
<jsp:setProperty name="reply" property="content" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		int story_id = 0;
		if (request.getParameter("story_id") != null)
		{
			story_id = Integer.parseInt(request.getParameter("story_id"));
			System.out.println("story_id : " + story_id);
		}

		String id=null;
		if(session.getAttribute("id")!=null){
			id=(String)session.getAttribute("id");
		}
		if(id==null){
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.')");
			script.println("location.href='Login.jsp'");
			script.println("</script>");	
		}
		else{
			if(reply.getContent()==null){
				PrintWriter script= response.getWriter();
				script.println("<script>");
				script.println("alert('댓글을 입력해주세요.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else{
				ReplyDAO replyDAO=new ReplyDAO();
				int result = replyDAO.write(story_id, reply.getContent(), id);
				if(result==-1){
					PrintWriter script= response.getWriter();
					script.println("<script>");
					script.println("alert('댓글쓰기에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else{
					String url="View.jsp?story_id="+story_id;
					PrintWriter script= response.getWriter();
					script.println("<script>");
					script.println("location.href='"+url+"'");
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>