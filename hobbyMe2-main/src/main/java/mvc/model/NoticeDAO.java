package mvc.model;

import java.sql.*;
import java.sql.Date;
import java.util.*;
import mvc.database.DBConnection;

public class NoticeDAO {

    private static NoticeDAO instance;

    public static NoticeDAO getInstance() {
        if (instance == null) {
            instance = new NoticeDAO();
        }
        return instance;
    }

    public NoticeDAO() {}

    // ✅ 공지사항 등록 시 Coupon 테이블에서 추가 정보 자동 채워넣기
    public int insertNoticeReturnKey(NoticeDTO dto) {
        int generatedKey = -1;

        String sql = "INSERT INTO Notice (title, content, category, date, deleted, coupon_content, start_date, end_date, coupon_type, coupon_value) " +
                     "VALUES (?, ?, ?, NOW(), 'N', ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setString(3, dto.getCategory());
            pstmt.setString(4, dto.getCoupon_content());

            if (dto.getStartDate() != null && !dto.getStartDate().isEmpty()) {
                pstmt.setDate(5, Date.valueOf(dto.getStartDate()));
            } else {
                pstmt.setNull(5, Types.DATE);
            }
            if (dto.getEndDate() != null && !dto.getEndDate().isEmpty()) {
                pstmt.setDate(6, Date.valueOf(dto.getEndDate()));
            } else {
                pstmt.setNull(6, Types.DATE);
            }
            if(dto.getCoupon_type()!=null && !dto.getCoupon_type().isEmpty()) {
            	pstmt.setString(7, dto.getCoupon_type());
            } else {
            	pstmt.setString(7, null);
            }
            if(dto.getCoupon_value() != 0) {
            	pstmt.setInt(8, dto.getCoupon_value());
            } else {
            	pstmt.setInt(8, 0);
            }

            pstmt.executeUpdate();
            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                generatedKey = rs.getInt(1);
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedKey;
    }

    public void deleteNotice(int noticeNum) {
        String sql = "UPDATE Notice SET deleted = 'Y' WHERE num = ?"; // 컬럼명 수정
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, noticeNum);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateNotice(NoticeDTO dto) {
        String sql = "UPDATE Notice SET title = ?, content = ?, category = ?, coupon_content = ?, start_date = ?, end_date = ? WHERE num = ?"; // 컬럼명 수정
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setString(3, dto.getCategory());
            pstmt.setString(4, dto.getCoupon_content());

            if (dto.getStartDate() != null && !dto.getStartDate().isEmpty()) {
                pstmt.setDate(5, Date.valueOf(dto.getStartDate()));
            } else {
                pstmt.setNull(5, Types.DATE);
            }
            if (dto.getEndDate() != null && !dto.getEndDate().isEmpty()) {
                pstmt.setDate(6, Date.valueOf(dto.getEndDate()));
            } else {
                pstmt.setNull(6, Types.DATE);
            }

            pstmt.setInt(7, dto.getNotice_num());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getNoticeCount(String search, String category) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Notice WHERE deleted = 'N'";
        if (search != null && !search.isEmpty()) {
            sql += " AND (title LIKE ? OR content LIKE ?)";
        }
        if (category != null && !category.isEmpty()) {
            sql += " AND category = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            int idx = 1;
            if (search != null && !search.isEmpty()) {
                pstmt.setString(idx++, "%" + search + "%");
                pstmt.setString(idx++, "%" + search + "%");
            }
            if (category != null && !category.isEmpty()) {
                pstmt.setString(idx++, category);
            }

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    public List<NoticeDTO> getNoticeList(int startRow, int pageSize, String search, String category) {
        List<NoticeDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Notice WHERE deleted = 'N'";
        if (search != null && !search.isEmpty()) {
            sql += " AND (title LIKE ? OR content LIKE ?)";
        }
        if (category != null && !category.isEmpty()) {
            sql += " AND category = ?";
        }
        sql += " ORDER BY date DESC LIMIT ?, ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            int idx = 1;
            if (search != null && !search.isEmpty()) {
                pstmt.setString(idx++, "%" + search + "%");
                pstmt.setString(idx++, "%" + search + "%");
            }
            if (category != null && !category.isEmpty()) {
                pstmt.setString(idx++, category);
            }
            pstmt.setInt(idx++, startRow);
            pstmt.setInt(idx, pageSize);

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                NoticeDTO dto = new NoticeDTO();
                dto.setNotice_num(rs.getInt("num")); // 컬럼명 수정
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCategory(rs.getString("category"));
                dto.setCreated_date(rs.getDate("date")); // 컬럼명 수정
                dto.setCoupon_content(rs.getString("coupon_content"));
                dto.setStartDate(rs.getString("start_date"));
                dto.setEndDate(rs.getString("end_date"));
                dto.setCoupon_type(rs.getString("coupon_type"));
                dto.setCoupon_value(rs.getInt("coupon_value"));
                list.add(dto);
            }
            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public NoticeDTO getNoticeByNum(int noticeNum) {
        NoticeDTO dto = null;
        String sql = "SELECT * FROM Notice WHERE num = ? AND deleted = 'N'"; // 컬럼명 수정
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, noticeNum);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new NoticeDTO();
                dto.setNotice_num(rs.getInt("num")); // 컬럼명 수정
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCategory(rs.getString("category"));
                dto.setCoupon_content(rs.getString("coupon_content"));
                dto.setCreated_date(rs.getDate("date")); // 컬럼명 수정
                dto.setStartDate(rs.getString("start_date"));
                dto.setEndDate(rs.getString("end_date"));
                dto.setCoupon_type(rs.getString("coupon_type"));
                dto.setCoupon_value(rs.getInt("coupon_value"));
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }

    // ✅ JOIN으로 공지 + 쿠폰 정보 함께 불러오기
    public List<NoticeDTO> getNoticeListWithCoupon(int startRow, int pageSize, String search, String category) {
        List<NoticeDTO> list = new ArrayList<>();
        String sql = "SELECT N.*, C.coupon_type, C.coupon_value, C.start_date AS coupon_start, C.end_date AS coupon_end " +
                     "FROM Notice N LEFT JOIN Coupon C ON N.coupon_content = C.coupon_content " +
                     "WHERE N.deleted = 'N'";
        if (search != null && !search.isEmpty()) {
            sql += " AND (N.title LIKE ? OR N.content LIKE ?)";
        }
        if (category != null && !category.isEmpty()) {
            sql += " AND N.category = ?";
        }
        sql += " ORDER BY N.date DESC LIMIT ?, ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            int idx = 1;
            if (search != null && !search.isEmpty()) {
                pstmt.setString(idx++, "%" + search + "%");
                pstmt.setString(idx++, "%" + search + "%");
            }
            if (category != null && !category.isEmpty()) {
                pstmt.setString(idx++, category);
            }
            pstmt.setInt(idx++, startRow);
            pstmt.setInt(idx, pageSize);

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                NoticeDTO dto = new NoticeDTO();
                dto.setNotice_num(rs.getInt("num"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCategory(rs.getString("category"));
                dto.setCreated_date(rs.getDate("date"));
                dto.setCoupon_content(rs.getString("coupon_content"));
                dto.setStartDate(rs.getString("start_date"));
                dto.setEndDate(rs.getString("end_date"));
                dto.setCoupon_type(rs.getString("coupon_type"));
                dto.setCoupon_value(rs.getInt("coupon_value"));
                dto.setCouponStart(rs.getString("coupon_start"));
                dto.setCouponEnd(rs.getString("coupon_end"));

                list.add(dto);
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
