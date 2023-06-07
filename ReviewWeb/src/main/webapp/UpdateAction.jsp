<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Board.BoardDAO" %>
<%@ page import="Board.Board" %>
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
		if (story_id == 0)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')"); 
			script.println("location.href = 'bbs.jsp'"); 			 
			script.println("</script>");
		}
		
		Board board = new BoardDAO().getBbs(story_id);
		BoardDAO boardDAO = new BoardDAO();
		
		// 사진(파일) 관련 설정
		String realFolder = request.getServletContext().getRealPath("upload");
		//upload 폴더가 없는 경우 폴더를 만들기
		File dir = new File(realFolder);
		if (!dir.exists()) dir.mkdirs();
		System.out.println("업데이트에서 사진 경로 : " + dir);
								
		String encType = "utf-8";				//변환형식
		String map="";
		int maxSize=5*1024*1024;				//사진의 size
				
		MultipartRequest multi = null;
			
		//파일업로드를 직접적으로 담당		
		multi = new MultipartRequest(request,realFolder,maxSize,encType,new DefaultFileRenamePolicy());
				
		String fileName = multi.getFilesystemName("img");
		String bbsTitle = multi.getParameter("title");
		String bbsContent = multi.getParameter("content");
		String bbsCategory = multi.getParameter("category");
		board.setTitle(bbsTitle);
		board.setContent(bbsContent);
		board.setCategory(bbsCategory);
		if(story_id==1){
			map = multi.getParameter("map");
		}
		board.setImg(map);		
				
				
				
				
		
		// 로그인 한 사람과 글 작성자가 동일하지 않다면
		if( !id.equals( boardDAO.getUserNid( board.getUser_id() )) ) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('글을 수정할 권한이 없습니다.')"); 
			script.println("location.href = 'bbs.jsp'"); 			 
			script.println("</script>");
		} else
		{
			// 사용자 입력이 하나라도 비었는지 체크
			if( board.getTitle().equals("")|| board.getTitle() == null
				|| board.getContent().equals("") || board.getContent() == null ) 
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()"); 			
				script.println("</script>");
			}
			else
			{	
				int result = boardDAO.update(story_id, board.getTitle(), board.getContent(), board.getCategory());
				
				if (result == -1) // 글쓰기 실패
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 수정에 실패했습니다.')"); 
					script.println("history.back()"); 			 
					script.println("</script>");
				}
				else 
				{
					PrintWriter script = response.getWriter();
					// 사진 수정 관련
					if(fileName != null){
						//String real = "C:\\Temp\\img";
						File delFile = new File(realFolder+"\\"+story_id+"사진.jpg");
						if(delFile.exists()){
							delFile.delete();
						}
						File oldFile = new File(realFolder+"\\"+fileName);
						File newFile = new File(realFolder+"\\"+story_id+"사진.jpg");
						oldFile.renameTo(newFile);
						System.out.println(realFolder+"\\"+story_id+"사진.jpg");
					}
					
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'"); 
					script.println("</script>");
				}
			}
		}
	%>
	
</body>
</html>
