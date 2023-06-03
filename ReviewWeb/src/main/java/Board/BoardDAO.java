package Board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

public class BoardDAO {

	private Connection conn;
	private ResultSet rs;
	
	final String JDBC_DRIVER = "org.h2.Driver";
	final String JDBC_URL = "jdbc:h2:tcp://localhost/~/project";
	
	
	// 프로젝트 진행하면서 실제 데이터에 접근할때 사용하는 객체
	public BoardDAO() {
		try {
			// db 접속하는 세션
			Class.forName(JDBC_DRIVER);
			conn = DriverManager.getConnection(JDBC_URL, "sa", "1234");
			
			System.out.println("드라이버 불러오기 성공");
			System.out.println("conn : " + conn);
			
		} catch (Exception e) {
			e.printStackTrace();
			
			throw new IllegalStateException("드라이버 불러오기 실패", e);
			
		}
	}
	
	// 날짜를 가져오는 함수
	public String getDate() {
		String SQL = "SELECT NOW()";
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();								// sql 실행한 결과값 가져오기
			if (rs.next()) { 										// 실행해서 가져온 값이 있는 경우.
				return rs.getString(1);
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류
	}
	
	// 날짜를 가져오는 함수
	public int getNext() {
		String SQL = "SELECT story_id FROM STORY ORDER BY story_id DESC"; // 제일 마지막에 쓰인 스토리 id 가져오기
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();								// sql 실행한 결과값 가져오기
			if (rs.next()) { 										// 실행해서 가져온 값이 있는 경우.
				return rs.getInt(1) + 1;							// 마지막 story_id + 1 값 반환
			}
			return 1; // 첫 번째 게시물인 경우
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	// 유저 아이디 가져오는 함수
	public int getUserId(String user_id) {
		String SQL = "SELECT user_id FROM USERS WHERE ID=?"; // 접속한 유저의 id 가져오기
		try
		{
			// System.out.println("유저 id : " + user_id);
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_id);				// 유저 아이디
			rs = pstmt.executeQuery();								// sql 실행한 결과값 가져오기
			if (rs.next()) { 										// 실행해서 가져온 값이 있는 경우.
				// System.out.println("반환된 유저 id : " + rs.getInt(1));
				return rs.getInt(1);							
			}
			return -99; // 아무튼 에러
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return -99; // 아무튼 에러
	}
	
	public String getUserNid(int user_nid) {
		String SQL = "SELECT id FROM USERS WHERE USER_ID=?"; // 접속한 유저의 id 가져오기
		try
		{
			// System.out.println("유저 nid : " + user_nid);
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, user_nid);				// 유저 아이디
			rs = pstmt.executeQuery();								// sql 실행한 결과값 가져오기
			if (rs.next()) { 										// 실행해서 가져온 값이 있는 경우.
				// System.out.println("반환된 유저 nid : " + rs.getString(1));
				return rs.getString(1);							
			}
			return ""; // 아무튼 에러
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return ""; // 아무튼 에러
	}
	
	// 스토리 작성 세션
	public int write(String img, String title, String user_id, String content, String category) {
		String SQL = "insert into story( title, content, user_id, like_cnt, read_cnt, created_date, img, user_name, category) values(?,?,?,?,?,?,?,?,?)";
		try
		{
			// System.out.println("유저 id : " + user_id);
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			
			pstmt.setString(1, title);				// 제목
			
			pstmt.setString(2, content);			// 내용
			pstmt.setInt(3, getUserId(user_id));				// 유저id 
			pstmt.setInt(4, 0);						// 좋아요
			pstmt.setInt(5, 0);						// 조회수
			pstmt.setString(6, getDate());			// 작성날짜
			pstmt.setString(7, img);				// 이미지
			pstmt.setString(8, user_id);
			pstmt.setString(9, category);
			
			return pstmt.executeUpdate(); // 게시글 작성 성공
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	
	public ArrayList<Board> getList(int pageNumber) {
		String SQL = "SELECT * FROM STORY WHERE story_id < ? ORDER BY story_id DESC LIMIT 10";
		ArrayList<Board> list = new ArrayList<Board>();
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - ((pageNumber - 1) * 10));
			rs = pstmt.executeQuery();								// sql 실행한 결과값 가져오기
			
			while(rs.next()) {
				Board bbs = new Board();
				bbs.setStory_id(rs.getInt(1));				
				bbs.setTitle(rs.getString(2));
				bbs.setContent(rs.getString(3));
				bbs.setUser_id(rs.getInt(4));
				bbs.setLike_cnt(rs.getInt(5));
				bbs.setRead_cnt(rs.getInt(6));
				bbs.setCreated_date(rs.getString(7));
				bbs.setImg(rs.getString(8));
				bbs.setUser_name(rs.getString(9));
				list.add(bbs);
				
			}
			
			
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return list; // 데이터베이스 오류
	}
	
	public ArrayList<Board> getTopFiveByLikes() {
	    String SQL = "SELECT * FROM STORY ORDER BY like_cnt DESC, read_cnt DESC, created_date ASC LIMIT 5";
	    ArrayList<Board> list = new ArrayList<>();
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        rs = pstmt.executeQuery();
	       
	        while (rs.next()) {
	            Board bbs = new Board();
	            bbs.setStory_id(rs.getInt(1));				
				bbs.setTitle(rs.getString(2));
				bbs.setContent(rs.getString(3));
				bbs.setUser_id(rs.getInt(4));
				bbs.setLike_cnt(rs.getInt(5));
				bbs.setRead_cnt(rs.getInt(6));
				bbs.setCreated_date(rs.getString(7));
				bbs.setImg(rs.getString(8));
				bbs.setUser_name(rs.getString(9));
	            list.add(bbs);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public ArrayList<Board> getrecently() {
	    String SQL = "SELECT * FROM STORY WHERE created_date < ? ORDER BY created_date DESC LIMIT 10";
	    ArrayList<Board> list = new ArrayList<Board>();
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, getDate());
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            Board bbs = new Board();
	            bbs.setStory_id(rs.getInt(1));
	            bbs.setImg(rs.getString(2));
	            bbs.setTitle(rs.getString(3));
	            bbs.setContent(rs.getString(4));
	            bbs.setUser_id(rs.getInt(5));
	            bbs.setLike_cnt(rs.getInt(6));
	            bbs.setRead_cnt(rs.getInt(7));
	            bbs.setCreated_date(rs.getString(8));
	            bbs.setUser_name(rs.getString(9));
	            list.add(bbs);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public ArrayList<Board> getCategory(String category, int pageNumber) {
	    String SQL = "SELECT * FROM STORY WHERE story_id < ? AND CATEGORY = ? ORDER BY STORY_ID DESC LIMIT 10";
	    ArrayList<Board> list = new ArrayList<Board>();
	    
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        
	        pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
	        pstmt.setString(2, category);
	        System.out.println("conn : " + pstmt);
	        ResultSet rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            Board bbs = new Board();
	            bbs.setStory_id(rs.getInt(1));	            
	            bbs.setTitle(rs.getString(2));
	            bbs.setContent(rs.getString(3));
	            bbs.setUser_id(rs.getInt(4));
	            bbs.setLike_cnt(rs.getInt(5));
	            bbs.setRead_cnt(rs.getInt(6));
	            bbs.setCreated_date(rs.getString(7));
	            bbs.setImg(rs.getString(8));
	            bbs.setUser_name(rs.getString(9));
	            bbs.setCategory(rs.getString(10));
	            list.add(bbs);
	        }
	        rs.close(); // ResultSet 닫기
	        pstmt.close(); // PreparedStatement 닫기
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}



	
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM STORY WHERE story_id < ? ORDER BY story_id DESC LIMIT 10";
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - ((pageNumber - 1) * 10));
			rs = pstmt.executeQuery();								// sql 실행한 결과값 가져오기
			
			if (rs.next()) {
				return true; // 개시글이 11 개이면 다음 페이지 있음.
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return false; 
	}
	
	
	// 게시글 뷰 세션
	public Board getBbs(int story_id) {
		String SQL = "SELECT * FROM STORY WHERE story_id = ?";
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, story_id);
			rs = pstmt.executeQuery();								// sql 실행한 결과값 가져오기
			
			if (rs.next()) {
				Board bbs = new Board();
				bbs.setStory_id(rs.getInt(1));
				
				bbs.setTitle(rs.getString(2));
				bbs.setContent(rs.getString(3));
				bbs.setUser_id(rs.getInt(4));
				bbs.setLike_cnt(rs.getInt(5));
				int bbsCount=rs.getInt(6);
				bbs.setRead_cnt(bbsCount);
				bbsCount++;
				countUpdate(bbsCount, story_id);
				bbs.setCreated_date(rs.getString(7));
				bbs.setImg(rs.getString(8));
				bbs.setUser_name(rs.getString(9));
				bbs.setCategory(rs.getString(10));
				return bbs;
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return null; 
	}
	
	// 조회수 업데이트
	public int countUpdate(int read_cnt, int story_id) {
		String SQL = "UPDATE story set READ_CNT = ? where story_id = ?";
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, read_cnt); // 좋아요 수
			pstmt.setInt(2, story_id); // 게시글 번호
			return pstmt.executeUpdate();			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	// 게시글 업데이트
	public int update(int story_id, String title, String content, String category) {
		String SQL = "UPDATE story SET title = ?, content = ? WHERE story_id = ?" ;
		try
		{
			// System.out.println("유저 id : " + user_id);
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			// pstmt.setString(1, img);				// 이미지도 바꿔줘야하는데 일단 보류...
			pstmt.setString(1, title);				// 제목
			pstmt.setString(2, content);			// 내용
			pstmt.setString(3, category);
			pstmt.setInt(4, story_id);				
			return pstmt.executeUpdate(); // 게시글 수정 성공
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	// 게시글 수정
	// Avaulable 함수를 추가해서 글을 삭제해도 글은 남아있도록 하면 좋을듯??
	// 하지만 일단 delete로 삭제하는걸로 구현.
	public int delete(int story_id) {
		String SQL = "DELETE FROM story WHERE story_id = ?";
		
		try {
		    PreparedStatement pstmt = conn.prepareStatement(SQL);
		    pstmt.setInt(1, story_id);
		    return pstmt.executeUpdate(); // DELETE 문 실행
		} catch (Exception e) {
		    e.printStackTrace();
		    // 삭제 중 오류 발생 시 예외 처리
		}
		return -1; // 데이터베이스 오류
	}
	
	// 좋아요
	public int like(int story_id) {
		String SQL = "UPDATE story SET LIKE_CNT = LIKE_CNT + 1 WHERE STORY_ID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, story_id);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} 
		return -1;
	}
	// 검색을 위한 sql
		public ArrayList<Board> getSearch(String searchField, String searchText){//특정한 리스트를 받아서 반환
		      ArrayList<Board> list = new ArrayList<Board>();
		      String SQL ="select * from story WHERE "+searchField.trim();
		      
		      //System.out.println("searchField.trim() : " + searchField.trim());
		      
		      try {
		    	  	if(searchField.trim().equals("title") || searchField.trim().equals("user_name") )
		    	  	{
		    	  		System.out.println("title 실행 " + searchText.trim());
		    	  		SQL +=" LIKE '%"+ searchText.trim() +"%' order by story_id desc limit 10";
		    	  	}
		    	  	else
		    	  	{
		    	  		//order by story_id desc limit 10
		    	  		SQL = "SELECT * FROM story WHERE user_name LIKE '%" + searchText.trim() + "%' OR title LIKE '%" + searchText.trim() + "%'";
		    	  	}
		            
		            PreparedStatement pstmt=conn.prepareStatement(SQL);
					rs=pstmt.executeQuery();//select
		         while(rs.next()) {
		        	 Board bbs = new Board();
		            bbs.setStory_id(rs.getInt(1));					
					bbs.setTitle(rs.getString(2));
					bbs.setContent(rs.getString(3));
					bbs.setUser_id(rs.getInt(4));
					bbs.setLike_cnt(rs.getInt(5));
					bbs.setRead_cnt(rs.getInt(6));
					bbs.setCreated_date(rs.getString(7));
					bbs.setImg(rs.getString(8));
					bbs.setUser_name(rs.getString(9));
					list.add(bbs);
		            
		         }         
		      } catch(Exception e) {
		         e.printStackTrace();
		      }
		      return list;//게시글 리스트 반환
		   }
	
	
		
	
}
