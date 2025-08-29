package mvc.model;

import java.sql.*;
import java.sql.Date;
import java.util.*;
import mvc.database.DBConnection;

public class CouponDAO {

    private static CouponDAO instance = new CouponDAO();

    public static CouponDAO getInstance() {
        return instance;
    }

    private CouponDAO() {}

    // ✅ 유저가 보유 중이고 사용 가능한 쿠폰 조회
    public List<CouponDTO> getValidCouponsByUser(String userId) {
        List<CouponDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Coupon WHERE user_id = ? " +
                     "AND coupon_deleted = 'N' " +
                     "AND coupon_state = 'A' " +
                     "AND CURDATE() BETWEEN start_date AND end_date";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                CouponDTO dto = new CouponDTO();
                dto.setCouponNum(rs.getInt("coupon_num"));
                dto.setUserId(rs.getString("user_id"));
                dto.setCouponContent(rs.getString("coupon_content"));
                dto.setCouponType(rs.getString("coupon_type"));
                dto.setCouponValue(rs.getInt("coupon_value"));
                dto.setStartDate(rs.getDate("start_date"));
                dto.setEndDate(rs.getDate("end_date"));
                dto.setCouponState(rs.getString("coupon_state"));
                dto.setCouponDeleted(rs.getString("coupon_deleted"));
                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ 쿠폰 삭제 처리 (soft delete)
    public void markCouponAsDeleted(int couponNum) {
        String sql = "UPDATE Coupon SET coupon_deleted = 'Y' WHERE coupon_num = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, couponNum);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public CouponDTO getCouponByNum(int couponNum) {
        String sql = "SELECT * FROM coupon WHERE coupon_num = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, couponNum);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                CouponDTO dto = new CouponDTO();
                dto.setCouponNum(rs.getInt("coupon_num"));
                dto.setUserId(rs.getString("user_id"));
                dto.setCouponType(rs.getString("coupon_type"));
                dto.setCouponValue(rs.getInt("coupon_value"));
                dto.setStartDate(rs.getDate("start_date"));
                dto.setEndDate(rs.getDate("end_date"));
                dto.setCouponState(rs.getString("coupon_state"));
                dto.setCouponDeleted(rs.getString("coupon_deleted"));
                return dto;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateCouponUsage(int couponNum, int usedAmount) {
        String selectSql = "SELECT coupon_type, coupon_value FROM coupon WHERE coupon_num = ?";
        String updateSql = "UPDATE coupon SET coupon_value = ?, coupon_state = ? WHERE coupon_num = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {

            selectStmt.setInt(1, couponNum);
            ResultSet rs = selectStmt.executeQuery();

            if (rs.next()) {
                String type = rs.getString("coupon_type");
                int currentValue = rs.getInt("coupon_value");

                if ("P".equals(type)) {
                    int newValue = currentValue - usedAmount;
                    String newState = (newValue <= 0) ? "E" : "A";

                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, Math.max(0, newValue)); // 음수 방지
                        updateStmt.setString(2, newState);
                        updateStmt.setInt(3, couponNum);
                        updateStmt.executeUpdate();
                    }
                }
            }

        } catch (Exception e) {
            System.out.println("updateCouponUsage() 에러: " + e.getMessage());
            e.printStackTrace();
        }
    }


    public void processCouponAfterPayment(int couponNum, int usedAmount) {
        String selectSql = "SELECT coupon_type, coupon_value FROM coupon WHERE coupon_num = ?";
        String updateSql = "UPDATE coupon SET coupon_value = ?, coupon_state = ?, coupon_deleted = ? WHERE coupon_num = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {

            selectStmt.setInt(1, couponNum);
            ResultSet rs = selectStmt.executeQuery();

            if (rs.next()) {
                String type = rs.getString("coupon_type");
                int currentValue = rs.getInt("coupon_value");

                if ("D".equals(type)) {
                    // D 타입 쿠폰은 비율이므로 value 그대로 두고 상태만 만료 처리
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, currentValue); // 그대로 유지
                        updateStmt.setString(2, "E");
                        updateStmt.setString(3, "Y");
                        updateStmt.setInt(4, couponNum);
                        updateStmt.executeUpdate();
                    }

                } else if ("P".equals(type)) {
                    // 할인액보다 잔액이 적으면 전액 소진
                    int actualUsed = Math.min(currentValue, usedAmount);
                    int remainingValue = currentValue - actualUsed;
                    boolean isDepleted = remainingValue <= 0;

                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, remainingValue); // 잔액
                        updateStmt.setString(2, isDepleted ? "E" : "A");
                        updateStmt.setString(3, isDepleted ? "Y" : "N");
                        updateStmt.setInt(4, couponNum);
                        int rows = updateStmt.executeUpdate();

                        System.out.println("[쿠폰 차감] couponNum=" + couponNum +
                                           ", 사용액=" + actualUsed +
                                           ", 잔액=" + remainingValue +
                                           ", 상태=" + (isDepleted ? "E" : "A") +
                                           ", rows updated=" + rows);
                    }
                    
                    System.out.println("[쿠폰 차감] couponNum=" + couponNum + ", remainingValue=" + remainingValue);
                }
            }

        } catch (Exception e) {
            System.out.println("processCouponAfterPayment() 에러: " + e.getMessage());
            e.printStackTrace();
        }
        
        
    }




    // ✅ 공지사항에서 쿠폰 코드 조회 (notice_num 기준)
    public String getCouponByNoticeNum(int noticeNum) {
        String sql = "SELECT coupon_content FROM Notice WHERE notice_num = ? AND category = '이벤트'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, noticeNum);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString("coupon_content");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ 유저가 해당 쿠폰을 이미 발급받았는지 확인
    public boolean hasUserReceivedCoupon(String userId, String couponCode) {
        String sql = "SELECT COUNT(*) FROM Coupon WHERE user_id = ? AND coupon_content = ? AND coupon_deleted = 'N'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, couponCode);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ 유저에게 쿠폰 발급 (일반 발급 - 사용자 기반)
    public boolean insertIssuedCoupon(CouponDTO dto) {
        String sql = "INSERT INTO Coupon (user_id, coupon_content, coupon_type, coupon_value, start_date, end_date, coupon_state, coupon_deleted) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, dto.getUserId());
            pstmt.setString(2, dto.getCouponContent());
            pstmt.setString(3, dto.getCouponType());
            pstmt.setInt(4, dto.getCouponValue());
            pstmt.setDate(5, dto.getStartDate());
            pstmt.setDate(6, dto.getEndDate());
            pstmt.setString(7, dto.getCouponState());
            pstmt.setString(8, dto.getCouponDeleted());

            return pstmt.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ 쿠폰 템플릿 조회 (이벤트용 쿠폰 등록 시 참고용)
    public CouponDTO getCouponTemplateByCode(String couponCode) {
        String sql = "SELECT * FROM Coupon WHERE coupon_content = ? ORDER BY coupon_num ASC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, couponCode);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                CouponDTO dto = new CouponDTO();
                dto.setCouponContent(rs.getString("coupon_content"));
                dto.setCouponType(rs.getString("coupon_type"));
                dto.setCouponValue(rs.getInt("coupon_value"));
                return dto;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ [NEW] 관리자 또는 시스템용 쿠폰 등록 메서드
    public boolean insertCoupon(CouponDTO dto) {
        String sql = "INSERT INTO Coupon (user_id, coupon_content, coupon_type, coupon_value, start_date, end_date, coupon_state, coupon_deleted) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'A', 'N')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, dto.getUserId());           // 일반적으로 'admin' 또는 'system'
            pstmt.setString(2, dto.getCouponContent());
            pstmt.setString(3, dto.getCouponType());
            pstmt.setInt(4, dto.getCouponValue());
            pstmt.setDate(5, dto.getStartDate());
            pstmt.setDate(6, dto.getEndDate());

            return pstmt.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
