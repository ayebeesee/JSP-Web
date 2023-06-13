package likes;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LikesDAO {
	

	private Connection conn;
	private ResultSet rs;
	
	final String JDBC_DRIVER = "org.h2.Driver";
	final String JDBC_URL = "jdbc:h2:tcp://localhost/~/web";
	
	
	// 프로젝트 진행하면서 실제 데이터에 접근할때 사용하는 객체
	public LikesDAO() {
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
	
	
	public int like(String user_id, int story_id) {
		String SQL = "insert into likes values (?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_id);
			pstmt.setInt(2, story_id);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;// 추천 중복 오류
	}
	
	// 좋아요 해제
	public int unlike(String user_id, int story_id) {
		String SQL1 = "SELECT LIKE_CNT FROM STORY WHERE story_id = ?";			// 게시글의 좋아요 수를 가져오기 위한 sql
		String SQL2 = "DELETE FROM likes WHERE user_id = ? and story_id = ?";
		try {
			PreparedStatement pstmt1 = conn.prepareStatement(SQL1);
		    pstmt1.setInt(1, story_id);
		    rs = pstmt1.executeQuery();
		    
		    int likeCount = -1;
		    if (rs.next()) {
		    	likeCount = rs.getInt(1) - 1;
		    }
			
		    PreparedStatement pstmt2 = conn.prepareStatement(SQL2);
		    pstmt2.setString(1, user_id);
			pstmt2.setInt(2, story_id);

			likeUpdate(likeCount, story_id);
			
		    return pstmt2.executeUpdate(); // DELETE 문 실행
		} catch (Exception e) {
		    e.printStackTrace();
		    // 삭제 중 오류 발생 시 예외 처리
		}
		return -1; // 데이터베이스 오류
	}
	
	// 조회수 업데이트
	public int likeUpdate(int read_cnt, int story_id) {
		String SQL = "UPDATE story set LIKE_CNT = ? where story_id = ?";
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
	
	
	// 중복 좋아요 체크
	public int check_like(String user_id, int story_id) {
		String SQL = "SELECT COUNT(*) FROM likes WHERE user_id = ? AND story_id = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_id);
			pstmt.setInt(2, story_id);
			rs = pstmt.executeQuery();
			if (rs.next()) { 										// 실행해서 가져온 값이 있는 경우.
				//System.out.println("check_like() 결과 : " + rs.getInt(1));
				return rs.getInt(1);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
}
