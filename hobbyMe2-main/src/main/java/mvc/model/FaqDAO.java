package mvc.model;

import java.sql.*;
import java.util.*;
import mvc.database.DBConnection;

public class FaqDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    public static FaqDAO instance;

    public static FaqDAO getInstance() {
        if (instance == null) instance = new FaqDAO();
        return instance;
    }

    public void insertFaq(FaqDTO dto) {
        String sql = "INSERT INTO FAQ (title, content, category, created_date, deleted) VALUES (?, ?, ?, CURDATE(), 'N')";
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setString(3, dto.getCategory());
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        finally { close(); }
    }

    public void updateFaq(FaqDTO dto) {
        String sql = "UPDATE FAQ SET title=?, content=?, category=? WHERE faq_num=?";
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setString(3, dto.getCategory());
            pstmt.setInt(4, dto.getFaq_num());
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        finally { close(); }
    }

    public void deleteFaq(int faqNum) {
        String sql = "UPDATE FAQ SET deleted='Y' WHERE faq_num=?";
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, faqNum);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        finally { close(); }
    }

    public int getFaqCount(String search, String category) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM FAQ WHERE deleted='N'";
        if (search != null && !search.isEmpty()) {
            sql += " AND (title LIKE ? OR content LIKE ?)";
        }
        if (category != null && !category.isEmpty()) {
            sql += " AND category = ?";
        }
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            int idx = 1;
            if (search != null && !search.isEmpty()) {
                pstmt.setString(idx++, "%" + search + "%");
                pstmt.setString(idx++, "%" + search + "%");
            }
            if (category != null && !category.isEmpty()) {
                pstmt.setString(idx++, category);
            }
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        finally { close(); }
        return count;
    }

    public List<FaqDTO> getFaqList(int startRow, int pageSize, String search, String category) {
        List<FaqDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM FAQ WHERE deleted='N'";
        if (search != null && !search.isEmpty()) {
            sql += " AND (title LIKE ? OR content LIKE ?)";
        }
        if (category != null && !category.isEmpty()) {
            sql += " AND category = ?";
        }
        sql += " ORDER BY faq_num DESC LIMIT ?, ?";
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
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
            rs = pstmt.executeQuery();
            while (rs.next()) {
                FaqDTO dto = new FaqDTO();
                dto.setFaq_num(rs.getInt("faq_num"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCategory(rs.getString("category"));
                dto.setCreated_date(rs.getString("created_date"));
                dto.setDeleted(rs.getString("deleted"));
                list.add(dto);
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { close(); }
        return list;
    }

    private void close() {
        try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
    }
}
