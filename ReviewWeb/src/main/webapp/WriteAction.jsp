<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Board.BoardDAO" %>

<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->

<!-- 사진 관련하여 import -->
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>

<jsp:useBean id="Board" class="Board.Board" scope="page" />   <!-- 아래의 변수들이 여기 bbs에 저장됨. -->
<jsp:setProperty name="Board" property="title" />			<!-- write.jsp 에서 받아온 title 값을 bbs에 넣어줌. -->
<jsp:setProperty name="Board" property="content" />		<!-- write.jsp 에서 받아온 content 값을 bbs에 넣어줌. -->
<jsp:setProperty name="Board" property="img" />


<% request.setCharacterEncoding("UTF-8"); %> <!-- 건너오는 데이터를 utf-8로 받기위해 사용 (인코딩 관련) -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hstory Main Page</title>
</head>
<body>
	<!-- 사진 경로 설정 & 로그인 세션 -->
	<%
	
	int story_id = 0;
	if (request.getParameter("story_id") != null)
	{
		story_id = Integer.parseInt(request.getParameter("story_id"));
	}

	// 사진(파일) 관련 설정
	String realFolder = request.getServletContext().getRealPath("upload");
	//upload 폴더가 없는 경우 폴더를 만들기
	File dir = new File(realFolder);
	if (!dir.exists()) dir.mkdirs();
									
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
	Board.setTitle(bbsTitle);
	Board.setContent(bbsContent);
	Board.setCategory(bbsCategory);
	if(story_id==1){
		map = multi.getParameter("map");
	}
	Board.setImg(map);		
	
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
	else
	{
		// 사용자 입력이 하나라도 비었는지 체크
		if( Board.getTitle() == null || Board.getContent() == null) 
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()"); 			
			script.println("</script>");
		}
		else
		{
			BoardDAO bbsDAO = new BoardDAO();
			
			int result = bbsDAO.write(Board.getImg(), Board.getTitle(), id, Board.getContent(), Board.getCategory());
			int get_sid = bbsDAO.getNext() - 1;
			
			if (result == -1) // 글쓰기 실패
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글쓰기에 실패했습니다.')"); 
				script.println("history.back()"); 			 
				script.println("</script>");
			}
			else{
		 		PrintWriter script = response.getWriter();
				if(fileName != null){
					
					File oldFile = new File(realFolder+"\\"+fileName);
					File newFile = new File(realFolder+"\\"+(get_sid)+"사진.jpg");

					System.out.println("get_sid : " + get_sid);
					System.out.println("작성에서 사진 경로 : " + realFolder+"\\"+(get_sid)+"사진.jpg");
					oldFile.renameTo(newFile);
					
				}
		 		script.println("<script>");
				script.println("location.href= \'bbs.jsp?boardID="+story_id+"\'");
		 		script.println("</script>");
		 	}
			
		}
	}

		
	%>
	
</body>
</html>
