package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	final String JDBC_DRIVER = "org.h2.Driver";
	final String JDBC_URL = "jdbc:h2:tcp://localhost/~/project";
	
	
	// 프로젝트 진행하면서 실제 데이터에 접근할때 사용하는 객체
	public UserDAO() {
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
	
	// 로그인 세션
	public int login(String id, String password) {
		String SQL = "SELECT password FROM USERS WHERE id = ?";
		try
		{
			pstmt = conn.prepareStatement(SQL); // pstmt는 SQL 문을 이후에 완성함으로써 해킹을 방어하는 기법중 하나
			pstmt.setString(1, id);				// 이곳에서 위의 SQL 문의 ? 부분을 마저 체움으로써 SQL문을 완성시킨다. 
			rs = pstmt.executeQuery();			// rs (result) 는 완성된 pstmt를 어떤 방식으로 처리할지? 같은 느낌. (이 경우엔 쿼리 요청)
			
			// 로그인 시도 하는 부분
			if (rs.next()) {
				if(rs.getString(1).equals(password)) { // sql을 통해 받아온 내용과 유저 비밀번호가 같은지
					return 1; // 로그인 성공
				}
				else
					return 0; // 비밀번호 불일치
			}
			
			return -1; // 아이디가 없음.
			
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류
	}
	
	
	// 회원가입 세션
	public int join(User user) {
		// INSERT INTO USERS (ID, PASSWORD, NAME, CREATED_DATE)
		// VALUES ('john123', 'password123', 'John Doe', CURRENT_TIMESTAMP);
		String SQL = "INSERT INTO USERS (ID, PASSWORD, NAME, CREATED_DATE, EMAIL) VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?)";
		try
		{
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getId());
			pstmt.setString(2, user.getPassword());
			pstmt.setString(3, user.getName());
			pstmt.setString(4, user.getEmail());
			return pstmt.executeUpdate();
		} // insert 구문의 경우 성공하면 0 이상의 값이 반환됨 
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return -1; // 0 미만이면 데이터베이스 오류
	}
	
	
	// 유저 아이디 가져오는 함수
	public String getUserName(int user_id) {
		String SQL = "SELECT id FROM USERS WHERE USER_ID=?"; // 접속한 유저의 id 가져오기
		try
		{
			// System.out.println("유저 id : " + user_id);
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, user_id);				// 유저 아이디
			rs = pstmt.executeQuery();								// sql 실행한 결과값 가져오기
			if (rs.next()) { 										// 실행해서 가져온 값이 있는 경우.
				// System.out.println("반환된 유저 id : " + rs.getInt(1));
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
	
	public String findId(String member_name, String member_email) {
		String SQL = "select id from users where name=? and email=?";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, member_name);
			pstmt.setString(2, member_email);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getString(1);
			}
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public String findPwd(String member_id, String member_email) {
		String SQL = "select password from users where id=? and email=?";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, member_id);
			pstmt.setString(2, member_email);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getString(1);
			}
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public String getOldPwd(String member_email) {
		String SQL = "select password from users where email=?";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, member_email);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getString(1);
			}
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	
	public int updatePwd(String member_password, String member_email) {
		String SQL = "UPDATE users set password = ? where email = ?";
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, member_password); // 
			pstmt.setString(2, member_email); // 
			return pstmt.executeUpdate();			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	public boolean chkAdmin(String user_name) {
		String SQL = "SELECT user_id FROM USERS WHERE id = ?";
		try
		{
			pstmt = conn.prepareStatement(SQL); // pstmt는 SQL 문을 이후에 완성함으로써 해킹을 방어하는 기법중 하나
			pstmt.setString(1, user_name);				// 이곳에서 위의 SQL 문의 ? 부분을 마저 체움으로써 SQL문을 완성시킨다. 
			rs = pstmt.executeQuery();			// rs (result) 는 완성된 pstmt를 어떤 방식으로 처리할지? 같은 느낌. (이 경우엔 쿼리 요청)
			
			// 로그인 시도 하는 부분
			if (rs.next()) {
				if(rs.getInt(1) == (0)) { // sql을 통해 받아온 내용과 유저 비밀번호가 같은지
					return true; // 어드민임
				}
				else
					return false; //
			}
			
			return false; // 
			
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return false; // 데이터베이스 오류
	}

}
