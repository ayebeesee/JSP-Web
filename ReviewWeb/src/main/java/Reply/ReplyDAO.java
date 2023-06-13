package Reply;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class ReplyDAO {

	private Connection conn;
    
    private ResultSet rs;

    public ReplyDAO() {
        try {
            String dbURL = "jdbc:h2:tcp://localhost/~/web";
            String dbID = "sa";
            String dbPassword = "1234";
            Class.forName("org.h2.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
	
	// 댓글 목록 가져오는 세션
    public ArrayList<Reply> getList(int story_id, int pageNumber){
		String SQL="SELECT * FROM COMMENT WHERE comment_id<? AND story_id=? ORDER BY comment_id DESC LIMIT 10";

		ArrayList<Reply> list=new ArrayList<Reply>();
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1,getNext()-(pageNumber-1)*10);
			pstmt.setInt(2, story_id);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				Reply reply=new Reply();
				reply.setComment_id(rs.getInt(1));
				reply.setContent(rs.getString(2));
				reply.setUser_id(rs.getInt(3));
				reply.setStory_id(story_id);
				reply.setCreated_date(rs.getString(5));
				//reply.setReplyAvailable(1); // rs.getInt(5) => out of index 오류
				list.add(reply);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	// 다음 댓글 가져오는 세션
	public int getNext() {
		String SQL="select COMMENT_ID FROM COMMENT ORDER BY COMMENT_ID DESC";
		try {
		
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				System.out.println(rs.getInt(1)); // select문에서 첫번째 값
				return rs.getInt(1)+1;  // 현재 인덱스(현재 게시글 개수) +1 반환
			}
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
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
	
	// 댓글 작성
	public int write(int story_id, String content, String user_id) {
		String SQL="INSERT INTO COMMENT(content, user_id, story_id, created_date) VALUES(?,?,?,?)";
		
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			
			pstmt.setString(1, content);
			pstmt.setInt(2, getUserId(user_id));
			pstmt.setInt(3, story_id);
			pstmt.setString(4, getDate());
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	// 댓글 가져오기
	public Reply getReply(int comment_id) {
		String SQL = "SELECT * FROM COMMENT WHERE comment_id = ?";
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, comment_id);
			rs = pstmt.executeQuery();								// sql 실행한 결과값 가져오기
				
			if (rs.next()) {
				Reply reply = new Reply();
				reply.setComment_id(rs.getInt(1));
				reply.setContent(rs.getString(2));
				reply.setUser_id(rs.getInt(3));
				reply.setStory_id(rs.getInt(4));
				reply.setCreated_date(rs.getString(5));

				return reply;
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return null; 
	}
	
	
	// 댓글 업데이트
	public int update(int story_id, int comment_id,String commentContent ) {
		String SQL="update comment set content = ? where story_id = ? and comment_id = ?"; 
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, commentContent);//물음표의 순서
			pstmt.setInt(2, story_id);
			pstmt.setInt(3, comment_id);
			return pstmt.executeUpdate();//insert,delete,update			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	// 댓글 삭제
	public int delete(int comment_id) {
		String SQL = "DELETE FROM comment WHERE comment_id = ?";
		
		try {
		    PreparedStatement pstmt = conn.prepareStatement(SQL);
		    pstmt.setInt(1, comment_id);
		    return pstmt.executeUpdate(); // DELETE 문 실행
		} catch (Exception e) {
		    e.printStackTrace();
		    // 삭제 중 오류 발생 시 예외 처리
		}
		return -1; // 데이터베이스 오류
	}
	
}