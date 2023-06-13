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
		
		// story_id로 파라메터? 관리
		int story_id = 0;
		if (request.getParameter("story_id") != null)
		{
			story_id = Integer.parseInt(request.getParameter("story_id"));
		}
		
		// pageNumber로 파라메터? 관리
		int pageNumber=1;
		// pageNumber는 URL에서 가져온다.
		if(request.getParameter("pageNumber")!=null){
			pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
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
		UserDAO userDAO = new UserDAO();
		LikesDAO likesDAO = new LikesDAO();
		
		// 좋아요 한 상태인지 확인 0이면 x 1이면 좋아요상태
		int chk_like = 0;
		if (likesDAO.check_like(id, story_id) == 1)
		{
			chk_like = 1;
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
				<li><a href="bbs_review.jsp?category=한식">맛집칼럼</a></li>
			</ul>
			
			<!-- 로그인 하지 않은 경우 회원가입/로그인 가능하도록 -->
			<%
				if(id == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="Login.jsp">로그인</a></li>
						<li><a href="Join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			
			<!-- 로그인 된 경우에는 로그인 nav 페이지 -->
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">마이페이지<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="userinfo.jsp">내정보</a></li>
						<li><a href="Logout.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
			<!-- 여기까지 -->

		</div>
	</nav>
	
	<!-- 게시판은 하나의 테이블 구조임 -->
	<div class="view-con">
		<div class="row">
			<table class="table table-striped" style="text-align:center;   border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="width: 20%; background-color:#DBFDD4;">글 제목</th>
						<th colspan="3"><%= board.getTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></th>
					</tr>
				</thead>
				<tbody>
					
					<tr>
						<th style=" background-color:#DBFDD4;">[ 카테고리 ]</th>
						<th colspan="2"><%= board.getCategory() %></th>
					</tr>
					
					<tr>
						<th style=" background-color:#DBFDD4;">작성자</th>
						<!-- a href 안쪽 알아서 잘 수정해야함 -->
						<th colspan="2"><a href="userpage.jsp"><%= userDAO.getUserName(board.getUser_id()) %></a></th>
					</tr>
					<tr>
						<th style=" background-color:#DBFDD4;">작성일자</th>
						<th colspan="2"><%= board.getCreated_date().substring(0, 11) + board.getCreated_date().substring(11, 13) + "시" + board.getCreated_date().substring(14, 16) + "분" %></th>
					</tr>
					<tr>
						<th style=" background-color:#DBFDD4;">조회수</th>
						<th colspan="2"><%=board.getRead_cnt() + 1 %> 회</th>
					</tr>
					<tr>
						<th style=" background-color:#DBFDD4;">추천수</th>
						<th colspan="2"><%=board.getLike_cnt()  %> 개</th>
					</tr>
					
					<!-- 사진 추가 관련 -->
					<% 	
						String realFolder = request.getServletContext().getRealPath("upload");
						File viewFile = new File(realFolder+"\\" + story_id + "사진.jpg");
						if(viewFile.exists()){
					%>
					<tr>
						<th colspan="6" ><br><br><img src = "upload/<%=story_id %>사진.jpg"  width="300px" height="300px"><br><br>
					<% }
					else {%><th colspan="6"><br><br><%} %>
						<%= board.getContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>")%><br><br></th>
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
			<form class="form" method="post" action="ReplyAction.jsp?story_id=<%= story_id %>">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<%-- 홀,짝 행 구분 --%>
					<thead>
						<tr>
							<th colspan="3"
								style="background-color: #eeeeeee; text-align: left;">댓글</th>
						</tr>
					</thead>
					<tbody>
					
						<%
							ReplyDAO replyDAO=new ReplyDAO();
							ArrayList<Reply> list=replyDAO.getList(story_id, pageNumber);
							for(int i=list.size()-1;i>=0;i--){
						%>
						
						<% 
						
							if(id == null){ // 로그인 안한 경우 미리 빼줘야함.
						%>
								<tr>
								<td style="text-align: left; font-weight:bold;"><a href="userpage.jsp"><%= userDAO.getUserName(list.get(i).getUser_id()) %></a>
								<td style="text-align: left;"><%= list.get(i).getContent() %></td>								
								</tr>
						<%
							} else {
						
						%>
						
						<%
						// 관리자인 경우
							
							if(userDAO.chkAdmin(id) && id.equals("admin")) {
								
						%>
						
						<tr>
							<td style="text-align: left; font-weight:bold;"><a href="userpage.jsp"><%= userDAO.getUserName(list.get(i).getUser_id()) %></a>
							<td style="text-align: left;"><%= list.get(i).getContent() %></td>							
							<td><a onclick="return confirm('정말로 삭제하시겠습니까?')" href="commentDeleteAction.jsp?story_id=<%=story_id%>&comment_id=<%=list.get(i).getComment_id()%>" class="btn btn-admin">삭제</a></td>
						</tr>
						
						<%
							}
							// 자신이 작성한 댓글인 경우
							else if(id.equals(boardDAO.getUserNid( list.get(i).getUser_id() ))) {
						%>
						
						<tr>
							<td style="text-align: left; font-weight:bold;"><a href="userpage.jsp"><%= userDAO.getUserName(list.get(i).getUser_id()) %></a>
							<td style="text-align: left;"><%= list.get(i).getContent() %></td>							
							<td align="left"><a href="commentUpdate.jsp?story_id=<%=story_id%>&comment_id=<%=list.get(i).getComment_id()%>" class="btn btn-warning">수정</a>
							<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="commentDeleteAction.jsp?story_id=<%=story_id%>&comment_id=<%=list.get(i).getComment_id()%>" class="btn btn-danger">삭제</a></td>
							
							<td></td>
						</tr>
					
						<%
							// 자신이 작성 x
								} else {
						%>
						<tr>
							<td style="text-align: left; font-weight:bold;"><a href="userpage.jsp"><%= userDAO.getUserName(list.get(i).getUser_id()) %></a>
							<td style="text-align: left;"><%= list.get(i).getContent() %></td>							
						</tr>
						
						<%
								}
							}
							}
						%>
						<th><textarea type="text" class="form-control"
								placeholder="댓글을 입력하세요." name="content" maxlength="2048"></textarea></th>
						<td style="text-align: left; "></td>					
					</tbody>
				</table>
				<input type="submit" class="btn" style="background-color: #DBFDD4;" value="댓글입력">
			</form>
			<br>
			
			
			<div class="btn-box2">
			<!--  목록 -->
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<!-- 게시글 수정하기 세션 -->
			<%
				// 관리자인 경우
				if(userDAO.chkAdmin(id) && id.equals("admin")) {
			%>
					
				<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="DeleteAction.jsp?story_id=<%= story_id %>" class="btn btn-warning">삭제</a>
						
			<%
				}
				// 자신이 작성
				else if(id != null && id.equals( boardDAO.getUserNid( board.getUser_id() ))){
			%>
					<a href="Update.jsp?story_id=<%= story_id %>" class="btn btn-primary">수정</a>
					<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="DeleteAction.jsp?story_id=<%= story_id %>" class="btn btn-warning">삭제</a>
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
