package mvc.model; // DAO 클래스가 위치한 패키지

import java.sql.Connection; // DB 연결용 클래스
import java.sql.PreparedStatement; // SQL 실행용 클래스
import java.sql.ResultSet; // SQL 결과 처리용 클래스
import java.sql.Timestamp;
import java.util.ArrayList; // 리스트 자료구조
import java.util.Arrays;
import java.util.List;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import mvc.database.DBConnection; // 사용자 정의 DB 연결 클래스

public class BoardDAO {

	private static BoardDAO instance; // 싱글톤 인스턴스

	private BoardDAO() {
		// 외부에서 생성자 호출 방지
	}

	// 싱글톤 인스턴스 반환 메서드
	public static BoardDAO getInstance() {
		if (instance == null)
			instance = new BoardDAO();
		return instance;
	}

	// 전체 게시글 수 반환 (검색 조건 고려)
	public int getListCount(String items, String text, String classes) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		boolean isAdmin = "A".equals(classes);
		String baseWhere = isAdmin ? "WHERE 1=1" : "WHERE deleted = 'N' AND expired = 'N'";

		String sql;
		if (items == null || text == null || items.isEmpty() || text.isEmpty()) {
			sql = "SELECT count(*) FROM post " + baseWhere;
		} else {
			// 태그 검색일 경우만 따로 처리
			if ("tag".equals(items)) {
				sql = "SELECT count(*) FROM post " + baseWhere + " AND tag LIKE ?";
			} else {
				sql = "SELECT count(*) FROM post " + baseWhere + " AND " + items + " LIKE ?";
			}
		}

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			if (items != null && text != null && !items.isEmpty() && !text.isEmpty()) {
				pstmt.setString(1, "%" + text + "%");
			}
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch (Exception ex) {
			System.out.println("getListCount() : " + ex);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}

		return count;
	}

	// 게시글 보기
	public ArrayList<BoardDTO> getBoardList(int page, int limit, String items, String text, String sort,
			String classes) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int start = (page - 1) * limit;
		String sql;

		// 기본 정렬 기준
		String orderBy = " ORDER BY post_num DESC";

		if ("like_desc".equals(sort)) {
			orderBy = " ORDER BY board_like DESC";
		} else if ("like_asc".equals(sort)) {
			orderBy = " ORDER BY board_like ASC";
		} else if ("comment_desc".equals(sort)) {
			orderBy = " ORDER BY (SELECT COUNT(*) FROM Comment WHERE Comment.post_num = post.post_num) DESC";
		} else if ("comment_asc".equals(sort)) {
			orderBy = " ORDER BY (SELECT COUNT(*) FROM Comment WHERE Comment.post_num = post.post_num) ASC";
		} else if ("oldest".equals(sort)) {
			orderBy = " ORDER BY post_num ASC";
		}

		// SQL Injection 방지
		List<String> allowedFields = Arrays.asList("title", "content", "user_id", "category", "tag");
		if (items != null && !items.isEmpty() && !allowedFields.contains(items)) {
			throw new IllegalArgumentException("허용되지 않은 검색 항목입니다.");
		}

		// 권한에 따른 WHERE 조건
		boolean isAdmin = "A".equals(classes);
		String whereClause = isAdmin ? "WHERE 1=1" : "WHERE deleted = 'N' AND expired = 'N'";

		// 검색 조건 포함 여부
		if (items == null || text == null || items.isEmpty() || text.isEmpty()) {
			sql = "SELECT * FROM post " + whereClause + orderBy + " LIMIT ?, ?";
		} else {
			sql = "SELECT * FROM post " + whereClause + " AND " + items + " LIKE ? " + orderBy + " LIMIT ?, ?";
		}

		ArrayList<BoardDTO> list = new ArrayList<>();

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);

			if (items != null && text != null && !items.isEmpty() && !text.isEmpty()) {
				pstmt.setString(1, "%" + text + "%");
				pstmt.setInt(2, start);
				pstmt.setInt(3, limit);
			} else {
				pstmt.setInt(1, start);
				pstmt.setInt(2, limit);
			}

			rs = pstmt.executeQuery();
			while (rs.next()) {
				BoardDTO board = new BoardDTO();
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
				board.setLat(rs.getDouble("lat"));
				board.setLng(rs.getDouble("lng"));
				board.setPeople(rs.getInt("people"));
				board.setPrice(rs.getInt("price"));
				board.setThumbnail(rs.getString("thumbnail"));
				board.setImages(rs.getString("images"));
				board.setDeleted(rs.getString("deleted"));
				board.setBoard_like(rs.getInt("board_like"));
				board.setExpired(rs.getString("expired"));

				// ✅ 예약 인원 수 추가
				board.setReserved(getReservedCount(board.getPost_num()));

				// ✅ D-day 계산
				try {
					String endDateStr = rs.getString("end_date");
					if (endDateStr != null && !endDateStr.isEmpty()) {
						LocalDate endDate = LocalDate.parse(endDateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
						LocalDate today = LocalDate.now();
						int dday = (int) ChronoUnit.DAYS.between(today, endDate);
						board.setDday(dday);
					} else {
						board.setDday(Integer.MIN_VALUE);
					}
				} catch (Exception e) {
					board.setDday(Integer.MIN_VALUE);
				}

				list.add(board);
			}

		} catch (Exception ex) {
			System.out.println("getBoardList(sort) 오류: " + ex.getMessage());
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}

		return list;
	}

	// 자동삭제
	public void setExpiredPosts(String todayDate) {
		String sql = "UPDATE post SET expired = 'Y' WHERE end_date < ? AND expired = 'N'";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, todayDate);
			int affected = pstmt.executeUpdate();
			System.out.println("✅ 마감된 게시글 자동 삭제 처리 수: " + affected);
		} catch (Exception ex) {
			System.out.println("deleteExpiredPosts() 오류: " + ex.getMessage());
		}
	}

	// 특정 ID의 사용자 이름 조회
	public String getLoginNameById(String id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String name = null;

		String sql = "SELECT name FROM user WHERE user_id = ? AND deleted = 'N'";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				name = rs.getString("name");
			}
		} catch (Exception ex) {
			System.out.println("getLoginNameById() : " + ex);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}
		return name;
	}

	// 게시글 등록
	public void insertBoard(BoardDTO board) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		String sql = "INSERT INTO post (user_id, title, content, category, tag, created_date, end_date, reservation_date, location, lat, lng, people, price, thumbnail, images, deleted, expired) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'N', 'N')";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, board.getUser_id());
			pstmt.setString(2, board.getTitle());
			pstmt.setString(3, board.getContent());
			pstmt.setString(4, board.getCategory());
			pstmt.setString(5, board.getTag());
			pstmt.setString(6, board.getCreated_date());
			pstmt.setString(7, board.getEnd_date());
			pstmt.setString(8, board.getReservation_date());
			pstmt.setString(9, board.getLocation());
			pstmt.setDouble(10, board.getLat());
			pstmt.setDouble(11, board.getLng());
			pstmt.setInt(12, board.getPeople());
			pstmt.setInt(13, board.getPrice());
			pstmt.setString(14, board.getThumbnail());
			pstmt.setString(15, board.getImages());

			pstmt.executeUpdate();
		} catch (Exception ex) {
			System.out.println("insertBoard() : " + ex);
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}
	}

	// 마감일 기준으로 자동 삭제 (오늘 날짜보다 이전인 게시글 삭제 처리)
	public void autoExpirePosts() {
		String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		setExpiredPosts(today);
	}

	// 게시글 번호로 상세 조회
	public BoardDTO getBoardByNum(int post_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BoardDTO board = null;

		String sql = "SELECT * FROM post WHERE post_num = ? AND deleted = 'N'";

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
				board.setLat(rs.getDouble("lat"));
				board.setLng(rs.getDouble("lng"));
				board.setImages(rs.getString("images"));
				board.setDeleted(rs.getString("deleted"));
				board.setExpired(rs.getString("expired")); // ✅ 마감 상태 설정

				board.setBoard_like(rs.getInt("board_like"));

				// ✅ D-day 계산 추가
				String endDateStr = rs.getString("end_date");
				if (endDateStr != null && !endDateStr.isEmpty()) {
					LocalDate endDate = LocalDate.parse(endDateStr);
					LocalDate today = LocalDate.now();
					int dday = (int) ChronoUnit.DAYS.between(today, endDate);
					board.setDday(dday);
				} else {
					board.setDday(Integer.MIN_VALUE); // D-day 계산 불가능한 경우
				}
			}
			return board;
		} catch (Exception ex) {
			System.out.println("getBoardByNum() : " + ex);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}
		return null;
	}

//관리자용
	public BoardDTO getBoardByNum(int post_num, boolean isAdmin) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BoardDTO board = null;

		String sql = "SELECT * FROM post WHERE post_num = ?";
		if (!isAdmin) {
			sql += " AND deleted = 'N'";
		}

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
				board.setLat(rs.getDouble("lat"));
				board.setLng(rs.getDouble("lng"));
				board.setImages(rs.getString("images"));
				board.setDeleted(rs.getString("deleted"));
				board.setExpired(rs.getString("expired"));
				board.setBoard_like(rs.getInt("board_like"));

				// ✅ D-day 계산
				String endDateStr = rs.getString("end_date");
				if (endDateStr != null && !endDateStr.isEmpty()) {
					LocalDate endDate = LocalDate.parse(endDateStr);
					LocalDate today = LocalDate.now();
					int dday = (int) ChronoUnit.DAYS.between(today, endDate);
					board.setDday(dday);
				}
			}
		} catch (Exception ex) {
			System.out.println("getBoardByNum(isAdmin) 오류: " + ex);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}
		return board;
	}

	// 게시글 수정
	public void updateBoard(BoardDTO board) {
		String sql = "UPDATE post SET user_id = ?, title = ?, content = ?, category = ?, tag = ?, created_date = ?, end_date = ?, reservation_date = ?, location = ?, lat = ?, lng = ?, people = ?, price = ?, thumbnail = ?, images = ?, deleted = ? WHERE post_num = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, board.getUser_id()); // 올바르게 설정된 user_id 사용
			pstmt.setString(2, board.getTitle());
			pstmt.setString(3, board.getContent());
			pstmt.setString(4, board.getCategory());
			pstmt.setString(5, board.getTag());
			pstmt.setString(6, board.getCreated_date());
			pstmt.setString(7, board.getEnd_date()); // 위치 수정
			pstmt.setString(8, board.getReservation_date());
			pstmt.setString(9, board.getLocation());
			pstmt.setDouble(10, board.getLat());
			pstmt.setDouble(11, board.getLng());
			pstmt.setInt(12, board.getPeople());
			pstmt.setInt(13, board.getPrice());
			pstmt.setString(14, board.getThumbnail());
			pstmt.setString(15, board.getImages());
			pstmt.setString(16, board.getDeleted());
			pstmt.setInt(17, board.getPost_num());

			pstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("updateBoard() 에러: " + e.getMessage());
			e.printStackTrace();
		}
	}

	// 카테고리 목록 조회 (삭제되지 않은 항목만)
	public ArrayList<String> getAllCategories() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> categories = new ArrayList<>();

		String sql = "SELECT category_name FROM category WHERE deleted = 'N' ORDER BY category_name ASC";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				categories.add(rs.getString("category_name"));
			}
		} catch (Exception ex) {
			System.out.println("getAllCategories() 에러: " + ex.getMessage());
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}

		return categories;
	}

	// 게시글 삭제
	public void deleteBoard(int post_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		String sql = "UPDATE post SET deleted = 'Y' WHERE post_num = ?";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_num);
			pstmt.executeUpdate();
		} catch (Exception ex) {
			System.out.println("deleteBoard() : " + ex);
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}
	}

	// 게시글 복구
	public void restoreBoard(int post_num) {
		String sql = "UPDATE post SET deleted = 'N' WHERE post_num = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, post_num);
			pstmt.executeUpdate();
		} catch (Exception ex) {
			System.out.println("restoreBoard() : " + ex);
		}
	}

	// 게시글의 좋아요 수 증가
	public void increaseLike(int post_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		String sql = "UPDATE post SET board_like = board_like + 1 WHERE post_num = ?";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_num);
			pstmt.executeUpdate();
		} catch (Exception ex) {
			System.out.println("increaseLike() : " + ex);
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}
	}

	// 게시글의 좋아요 수 감소
	public void decreaseLike(int post_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		String sql = "UPDATE post SET board_like = board_like - 1 WHERE post_num = ?";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_num);
			pstmt.executeUpdate();
		} catch (Exception ex) {
			System.out.println("decreaseLike() : " + ex);
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}
	}

	// 사용자가 해당 게시글에 좋아요를 눌렀는지 확인
	public boolean isLikedByUser(String user_id, int post_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT * FROM post_like WHERE user_id = ? AND post_num = ?";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);
			pstmt.setInt(2, post_num);
			rs = pstmt.executeQuery();

			return rs.next();
		} catch (Exception ex) {
			System.out.println("isLikedByUser() : " + ex);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}
		return false;
	}

	// 좋아요 추가
	public void likePost(String user_id, int post_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		if (isLikedByUser(user_id, post_num)) {
			return;
		}

		String sql = "INSERT INTO post_like (user_id, post_num) VALUES (?, ?)";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);
			pstmt.setInt(2, post_num);
			pstmt.executeUpdate();

			increaseLike(post_num);
		} catch (Exception ex) {
			System.out.println("likePost() : " + ex);
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}
	}

	// 좋아요 취소
	public void unlikePost(String user_id, int post_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		if (!isLikedByUser(user_id, post_num)) {
			return;
		}

		String sql = "DELETE FROM post_like WHERE user_id = ? AND post_num = ?";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);
			pstmt.setInt(2, post_num);
			pstmt.executeUpdate();

			decreaseLike(post_num);
		} catch (Exception ex) {
			System.out.println("unlikePost() : " + ex);
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}
	}

	// 총 좋아요 수 조회
	public int getLikeCount(int post_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		// ✅ 테이블명 수정
		String sql = "SELECT COUNT(*) FROM post_like WHERE post_num = ?";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_num);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch (Exception ex) {
			System.out.println("getLikeCount() : " + ex);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}

		return count;
	}

	// 좋아요 토글 처리
	public boolean toggleLike(int post_num, String user_id) {
		if (isLikedByUser(user_id, post_num)) {
			unlikePost(user_id, post_num);
			return false;
		} else {
			likePost(user_id, post_num);
			return true;
		}
	}

//	댓글수 구하기
	public int getCommentCount(int postNum) {
		int count = 0;
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM Comment WHERE post_num = ?")) {
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

	// 메인 게시판 좋아요순 상위 게시글 4개
	public List<BoardDTO> getTopLikedBoards(int limit) {
		List<BoardDTO> list = new ArrayList<>();
		String sql = "SELECT * FROM post WHERE deleted = 'N' AND expired = 'N' ORDER BY board_like DESC LIMIT ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, limit);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					BoardDTO board = new BoardDTO();
					int postNum = rs.getInt("post_num");

					board.setPost_num(postNum);
					board.setTitle(rs.getString("title"));
					board.setThumbnail(rs.getString("thumbnail"));
					board.setBoard_like(rs.getInt("board_like"));
					board.setPrice(rs.getInt("price"));
					board.setCreated_date(rs.getString("created_date"));
					board.setEnd_date(rs.getString("end_date"));
					board.setDeleted(rs.getString("deleted"));
					board.setExpired(rs.getString("expired"));
					board.setUser_id(rs.getString("user_id"));
					board.setTag(rs.getString("tag")); // ✅ 태그 추가
					board.setPeople(rs.getInt("people")); // ✅ 사람 수 설정
					board.setReserved(getReservedCount(postNum)); // ✅ 현재 예약 인원 수 설정
					board.setCategory(rs.getString("category")); // ✅ 추가
					// ✅ 댓글 수 가져오기
					int commentCount = getCommentCount(postNum);
					board.setComment_count(commentCount);

					// ✅ D-day 계산
					String endDateStr = rs.getString("end_date");
					if (endDateStr != null && !endDateStr.isEmpty()) {
						try {
							DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
							LocalDate endDate = LocalDate.parse(endDateStr, formatter);
							LocalDate today = LocalDate.now();
							int dday = (int) ChronoUnit.DAYS.between(today, endDate);
							board.setDday(dday);
						} catch (Exception e) {
							board.setDday(Integer.MIN_VALUE);
						}
					}

					list.add(board);
				}
			}

			if (list.isEmpty()) {
				System.out.println("⚠️ getTopLikedBoards(): 게시글이 존재하지 않습니다.");
			}

		} catch (Exception ex) {
			System.out.println("getTopLikedBoards() 예외: " + ex.getMessage());
			ex.printStackTrace();
		}

		return list;
	}

	// 메인 게시판 최신순 게시글 4개
	public List<BoardDTO> getRecentBoards(int limit) {
		List<BoardDTO> list = new ArrayList<>();
		String sql = "SELECT * FROM post WHERE deleted = 'N' AND expired = 'N' ORDER BY created_date DESC LIMIT ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, limit);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					BoardDTO board = new BoardDTO();
					int postNum = rs.getInt("post_num");

					board.setPost_num(postNum);
					board.setUser_id(rs.getString("user_id")); // ✅ 추가
					board.setTitle(rs.getString("title"));
					board.setThumbnail(rs.getString("thumbnail"));
					board.setCreated_date(rs.getString("created_date"));
					board.setBoard_like(rs.getInt("board_like"));
					board.setPrice(rs.getInt("price"));
					board.setEnd_date(rs.getString("end_date"));
					board.setDeleted(rs.getString("deleted"));
					board.setExpired(rs.getString("expired"));
					board.setTag(rs.getString("tag")); // ✅ 태그 추가
					board.setPeople(rs.getInt("people")); // ✅ 사람 수 설정
					board.setReserved(getReservedCount(postNum)); // ✅ 현재 예약 인원 수 설정
					board.setCategory(rs.getString("category")); // ✅ 추가
					// ✅ 댓글 수
					int commentCount = getCommentCount(postNum);
					board.setComment_count(commentCount);

					// ✅ D-day 계산
					String endDateStr = rs.getString("end_date");
					if (endDateStr != null && !endDateStr.isEmpty()) {
						try {
							DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
							LocalDate endDate = LocalDate.parse(endDateStr, formatter);
							LocalDate today = LocalDate.now();
							int dday = (int) ChronoUnit.DAYS.between(today, endDate);
							board.setDday(dday);
						} catch (Exception e) {
							board.setDday(Integer.MIN_VALUE);
						}
					}

					list.add(board);
				}
			}
			if (list.isEmpty()) {
				System.out.println("⚠️ getRecentBoards(): 게시글이 존재하지 않습니다.");
			}

		} catch (Exception ex) {
			System.out.println("getRecentBoards() 예외: " + ex.getMessage());
			ex.printStackTrace();
		}

		return list;
	}

	// 해당 게시글의 현재 예약 인원 수 조회
	public int getReservedCount(int post_num) {
		String sql = "SELECT COUNT(*) FROM payment WHERE post_num = ? AND state = 'S'";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, post_num);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		} catch (Exception ex) {
			System.out.println("getReservedCount() 오류: " + ex.getMessage());
		}
		return 0;
	}

}