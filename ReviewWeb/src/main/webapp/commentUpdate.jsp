<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- js 사용을 위한 import -->
<%@ page import="Board.Board" %> 
<%@ page import="Board.BoardDAO" %> 
<%@ page import="user.UserDAO" %> 
<%@ page import="Reply.Reply" %>
<%@ page import="Reply.ReplyDAO" %>
<%@ page import="likes.LikesDAO" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/main.css"> <!-- 빠른 디자인을 위해 bootstrap.js 이용했음... 향후 수정 필요  -->
<title>Hstory Main Page</title>
</head>
<body>
	<%
		// 로그인 된 경우 그 정보를 담음
		String id = null;
		if (session.getAttribute("id") != null)
		{
			id = (String) session.getAttribute("id");
		}
		
		

		if (id == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.')"); 
			script.println("location.href = 'Login.jsp'"); 			 
			script.println("</script>");
		}
		
		// 게시판 id 파라메터
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
		
		int comment_id = 0;
		if(request.getParameter("comment_id")!=null)
			comment_id=Integer.parseInt(request.getParameter("comment_id"));
		Reply comment = new ReplyDAO().getReply(comment_id);
		
		// pageNumber로 파라메터? 관리
		int pageNumber=1;
		// pageNumber는 URL에서 가져온다.
		if(request.getParameter("pageNumber")!=null){
			pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
		}
		
		Board bbs = new BoardDAO().getBbs(story_id);
		System.out.println("bbs : " + bbs);
		BoardDAO bbsDAO = new BoardDAO();
		UserDAO userDAO = new UserDAO();
		LikesDAO likesDAO = new LikesDAO();
		
		// 좋아요 한 상태인지 확인 0이면 x 1이면 좋아요상태
		int chk_like = 0;
		if (likesDAO.check_like(id, story_id) == 1)
		{
			chk_like = 1;
		}
		
		// 로그인 한 사람과 글 작성자가 동일하지 않다면
		if( !id.equals( bbsDAO.getUserNid( comment.getUser_id() )) ) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('댓글을 수정할 권한이 없습니다.')"); 
			script.println("history.back()"); 
			script.println("</script>");
		}
	%>



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
				
				<li class="active"><a href="bbs.jsp">게시판</a></li>
				<li><a href="bbs_review.jsp">맛집칼럼</a></li>
			</ul>
			
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">마이페이지<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="Logout.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>


		</div>
	</nav>
	
	<!-- 게시판은 하나의 테이블 구조임 -->
	<div class="view-con">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan ="3"  style=" background-color:#DBFDD4;" text-align: center;">작성글 보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th style="width: 20%; background-color:#DBFDD4;" >글 제목</th>
						<th colspan="2"><%= bbs.getTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></th>
					</tr>
					<tr>
						<th style=" background-color:#DBFDD4;">카테고리</th>
						<th colspan="2"><%= bbs.getCategory() %></th>
					</tr>
					<tr>
						<th style=" background-color:#DBFDD4;">작성자</th>
						<!-- a href 안쪽 알아서 잘 수정해야함 -->
						<th colspan="2"><a href="userpage.jsp"><%= userDAO.getUserName(bbs.getUser_id()) %></a></th>
					</tr>
					<tr>
						<th style=" background-color:#DBFDD4;">작성일자</th>
						<th colspan="2"><%= bbs.getCreated_date().substring(0, 11) + bbs.getCreated_date().substring(11, 13) + "시" + bbs.getCreated_date().substring(14, 16) + "분" %></th>
					</tr>
					<tr>
						<th style=" background-color:#DBFDD4;">조회수</th>
						<th colspan="2"><%=bbs.getRead_cnt() + 1 %></th>
					</tr>
					<tr>
						<th style=" background-color:#DBFDD4;">추천수</th>
						<th colspan="2"><%=bbs.getLike_cnt()  %></th>
					</tr>
					
					<!-- 사진 추가 관련 -->
					<% 	
						String realFolder = request.getServletContext().getRealPath("upload");
						File viewFile = new File(realFolder+"\\" + story_id + "사진.jpg");
						if(viewFile.exists()){
					%>
					<tr>
						<th colspan="6"><br><br><img src = "upload/<%=story_id %>사진.jpg" width="300px" height="300px"><br><br>
					<% }
					else {%><th colspan="6"><br><br><%} %>
						<%= bbs.getContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>")%><br><br></th>
					</tr>
					<!-- 사진 추가 관련 끝 -->

				</tbody>
			</table>
			
			<div class="like-box">
			<!-- 좋아요 버튼 -->
			<%
				if(chk_like == 0) {
			%>
			<a onclick="return confirm('추천하시겠습니까?')"href="likeAction.jsp?story_id=<%= story_id %>" class="btn btn-success pull-right">👍</a> 
			<%
				}else {			
			%>
				<a onclick="return confirm('추천을 해제 하시겠습니까?')"href="unlikeAction.jsp?story_id=<%= story_id %>" class="btn btn-danger pull-right">추천해제</a> 
			<%
				}
			%>
			</div>
			
			<!-- 좋아요 눌럿는지 안눌럿는지 -->
			
			<!-- 이전글 다음글 -->
			
			<div class="btn-box">
			    <a href="View.jsp?story_id=<%= story_id - 1 %>"  class="btn btn-primary">이전 글</a>
			    <a href="View.jsp?story_id=<%= story_id + 1%>"  class="btn btn-primary">다음 글</a>
			</div>

			
			
			
			
			<!-- 댓글 세션 -->
			
				<table class="table-comment table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<tbody>
					<tr>
                  		<th align="left">댓글</th>
               		</tr>
						<div class="container" >
							<div class="row" style="border:1px solid red;">
								<form method="post" action="commentUpdateAction.jsp?story_id=<%=story_id%>&comment_id=<%=comment_id%>">
									<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
										<tbody>
											<tr>
												<td><input type="text" class="form-control" placeholder="댓글 쓰기" name="content" maxlength="300" value=<%=comment.getContent() %>></td>
											</tr>
										</tbody>
									</table>
								<input type="submit" style="width:1440px; background-color:#DBFDD4; margin:0 auto;" class="btn btn-success pull-right" value="댓글수정">
								</form>
							</div>
						</div>
					</tbody>
				</table>
			
			<br>
			
			
			<div class="btn-box2">
			<!--  목록 -->
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<!-- 게시글 수정하기 세션 -->
			<%
				if(id != null && id.equals( bbsDAO.getUserNid( bbs.getUser_id() ))){
			%>
					<a href="Update.jsp?story_id=<%= story_id %>" class="btn btn-primary">수정</a>
					<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="DeleteAction.jsp?story_id=<%= story_id %>" class="btn btn-primary">삭제</a>
			<%
				}
			%>
			</div>
		</div>
	</div>
	
	
	
	
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

	<!-- Bootstrap JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
		
</body>
</html>
