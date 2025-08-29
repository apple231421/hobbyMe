package mvc.model; // DAO 클래스가 위치한 패키지

import java.sql.Connection; // DB 연결용 클래스
import java.sql.PreparedStatement; // SQL 실행용 클래스
import java.sql.ResultSet; // SQL 결과 처리용 클래스
import java.sql.Timestamp;
import java.sql.Date;
import java.util.ArrayList; // 리스트 자료구조


import mvc.database.DBConnection; // 사용자 정의 DB 연결 클래스

public class PaymentDAO {

    private static PaymentDAO instance; // 싱글톤 인스턴스

    private PaymentDAO() {
        // 외부에서 생성자 호출 방지
    }

    // 싱글톤 인스턴스 반환 메서드
    public static PaymentDAO getInstance() {
        if (instance == null)
            instance = new PaymentDAO();
        return instance;
    }
    
    // 아래에서 메서드로 추출한 정보를 sql에 담는 메서드
    public void insertPayment(PaymentDTO dto) {
    	
    	String sql = "INSERT INTO Payment(post_num, title, price, state, reservation_date, end_date, user_id, name, phone, email, deleted) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";



    	Connection conn = null;
    	PreparedStatement pstmt = null;

    	try {
    	    conn = DBConnection.getConnection();
    	    pstmt = conn.prepareStatement(sql);

    	    pstmt.setInt(1, dto.getPost_num());
    	    pstmt.setString(2, dto.getTitle());
    	    pstmt.setInt(3, dto.getPrice());
    	    pstmt.setString(4, dto.getState());
    	    pstmt.setString(5, dto.getReservation_date());
    	    pstmt.setString(6, dto.getEnd_date());
    	    pstmt.setString(7, dto.getUser_id());
    	    pstmt.setString(8, dto.getName());
    	    pstmt.setString(9, dto.getPhone());
    	    pstmt.setString(10, dto.getEmail());
    	    pstmt.setString(11, dto.getDeleted());
    	    
            pstmt.executeUpdate();
        } catch (Exception ex) {
            System.out.println("insertPayment(): " + ex);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                throw new RuntimeException(ex.getMessage());
            }
        }
    }
    
 // payment로 보낼 클래스 정보를 게시글번호로 찾아 클래스 정보객체를 보내는 메서드
 	public BoardDTO getBoardByNum(int post_num) {
 	    Connection conn = null;
 	    PreparedStatement pstmt = null;
 	    ResultSet rs = null;
 	    BoardDTO board = null;

 	    String sql = "SELECT * FROM post WHERE post_num = ?";

 	    try {
 	        conn = DBConnection.getConnection();
 	        pstmt = conn.prepareStatement(sql);
 	        pstmt.setInt(1, post_num);
 	        rs = pstmt.executeQuery();

 	        if (rs.next()) {
 	            board = new BoardDTO();
 	            board.setPost_num(rs.getInt("post_num"));
 	            board.setUser_id(rs.getString("user_id"));
 	            board.setTitle(rs.getString("title"));
 	            board.setContent(rs.getString("content"));
 	            board.setCategory(rs.getString("category"));
 	            board.setTag(rs.getString("tag"));
 	            board.setCreated_date(rs.getString("created_date"));
 	            board.setEnd_date(rs.getString("end_date"));
 	            board.setReservation_date(rs.getString("reservation_date"));
 	            board.setLocation(rs.getString("location"));
 	            board.setPeople(rs.getInt("people"));
 	            board.setPrice(rs.getInt("price"));
 	            board.setThumbnail(rs.getString("thumbnail"));
 	            board.setImages(rs.getString("images"));
 	            board.setDeleted(rs.getString("deleted"));

 	            // ✅ 좋아요 수 세팅
 	            board.setBoard_like(rs.getInt("board_like"));
 	        }
 	        return board;
 	    } catch (Exception ex) {
 	        System.out.println("getBoardByNum() : " + ex);
 	    } finally {
 	        try {
 	            if (rs != null) rs.close();
 	            if (pstmt != null) pstmt.close();
 	            if (conn != null) conn.close();
 	        } catch (Exception ex) {
 	            throw new RuntimeException(ex.getMessage());
 	        }
 	    }
 	    return null;
 	}

 	// payment로 보낼 로그인한 유저 아이디를 찾아 회원정보 객체 보내는 메서드
 	
 
 	public HobbyDTO getUserById(String userId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HobbyDTO user = null;

		String sql = "SELECT * FROM user WHERE user_id = ? AND deleted = 'N'";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				user = new HobbyDTO();
				user.setUserId(rs.getString("user_id"));
				user.setPassword(rs.getString("password"));
				user.setName(rs.getString("name"));
				user.setEmail(rs.getString("email"));
				user.setPhone(rs.getString("phone"));
				user.setAddress(rs.getString("address"));
				user.setGender(rs.getString("gender"));
				user.setBirthdate(rs.getDate("birthdate"));
				user.setClasses(rs.getString("classes"));
				user.setDeleted(rs.getString("deleted"));
			}
		} catch (Exception e) {
			System.out.println("getUserById() : " + e);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				throw new RuntimeException(e.getMessage());
			}
		}
		return user;
	}
 	
 	public PaymentDTO getPaymentByUserAndPost(String userId, int postNum) {
 	    PaymentDTO dto = null;
 	    String sql = "SELECT * FROM payment WHERE user_id = ? AND post_num = ? AND deleted = 'N'";

 	    try (Connection conn = DBConnection.getConnection();
 	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

 	        pstmt.setString(1, userId);
 	        pstmt.setInt(2, postNum);

 	        try (ResultSet rs = pstmt.executeQuery()) {
 	            if (rs.next()) {
 	                dto = new PaymentDTO();
 	                dto.setPayment_id(rs.getInt("payment_id"));
 	                dto.setPost_num(rs.getInt("post_num"));
 	                dto.setTitle(rs.getString("title"));
 	                dto.setPrice(rs.getInt("price"));
 	                dto.setState(rs.getString("state"));
 	                dto.setReservation_date(rs.getString("reservation_date"));
 	                dto.setEnd_date(rs.getString("end_date"));
 	                dto.setUser_id(rs.getString("user_id"));
 	                dto.setName(rs.getString("name"));
 	                dto.setPhone(rs.getString("phone"));
 	                dto.setEmail(rs.getString("email"));
 	                dto.setToday_date(rs.getString("today_date"));
 	                dto.setDeleted(rs.getString("deleted"));
 	            }
 	        }
 	    } catch (Exception e) {
 	        e.printStackTrace();
 	    }

 	    return dto;
 	}
 	
 	public PaymentDTO getPaymentByUserAndPostW(String userId, int postNum) {
 	    PaymentDTO dto = null;
 	    String sql = "SELECT * FROM payment WHERE user_id = ? AND post_num = ? AND state = 'W' AND deleted = 'N'";

 	    try (Connection conn = DBConnection.getConnection();
 	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

 	        pstmt.setString(1, userId);
 	        pstmt.setInt(2, postNum);

 	        try (ResultSet rs = pstmt.executeQuery()) {
 	            if (rs.next()) {
 	                dto = new PaymentDTO();
 	                dto.setPayment_id(rs.getInt("payment_id"));
 	                dto.setPost_num(rs.getInt("post_num"));
 	                dto.setTitle(rs.getString("title"));
 	                dto.setPrice(rs.getInt("price"));
 	                dto.setState(rs.getString("state"));
 	                dto.setReservation_date(rs.getString("reservation_date"));
 	                dto.setEnd_date(rs.getString("end_date"));
 	                dto.setUser_id(rs.getString("user_id"));
 	                dto.setName(rs.getString("name"));
 	                dto.setPhone(rs.getString("phone"));
 	                dto.setEmail(rs.getString("email"));
 	                dto.setToday_date(rs.getString("today_date"));
 	                dto.setDeleted(rs.getString("deleted"));
 	            }
 	        }
 	    } catch (Exception e) {
 	        e.printStackTrace();
 	    }

 	    return dto;
 	}
 	
 	public void ConfirmPaymentByUserAndPost(PaymentDTO confirmpayment) {
        
        String sql = "UPDATE payment SET state = 'S' WHERE user_id = ? AND post_num = ? AND state = 'C'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
        	pstmt.setString(1, confirmpayment.getUser_id());
	        pstmt.setInt(2, confirmpayment.getPost_num());
            pstmt.executeUpdate();
        } catch (Exception e) {
        	System.out.println("ConfirmPayment() 에러: " + e.getMessage());
            e.printStackTrace();
        }
     
    }
 	
 	public void paymentCompleteByUserAndPost(PaymentDTO dto) {
        
        String sql = "UPDATE payment SET state = 'C' WHERE user_id = ? AND post_num = ? AND (state = 'W' OR state = 'F') AND deleted = 'N'";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
        	pstmt.setString(1,dto.getUser_id());
	        pstmt.setInt(2,dto.getPost_num());
            pstmt.executeUpdate();
        } catch (Exception e) {
        	System.out.println("paymentCompleteByUserAndPost() 에러: " + e.getMessage());
            e.printStackTrace();
        }
     
    }
 	public int getConfirmedReservationCount(int postNum) {
 	    int count = 0;
 	    String sql = "SELECT COUNT(*) FROM payment WHERE post_num = ? AND state = 'S' AND deleted = 'N'";

 	    try (Connection conn = DBConnection.getConnection();
 	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
 	        pstmt.setInt(1, postNum);
 	        try (ResultSet rs = pstmt.executeQuery()) {
 	            if (rs.next()) {
 	                count = rs.getInt(1);
 	            }
 	        }
 	    } catch (Exception e) {
 	        e.printStackTrace();
 	    }
 	    return count;
 	}

}


