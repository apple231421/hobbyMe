package mvc.model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {
    private static CommentDAO instance = new CommentDAO();

    public static CommentDAO getInstance() {
        return instance;
    }

    private CommentDAO() {}

    public static Connection getConnection() throws SQLException, ClassNotFoundException  {      

        
        Connection conn = null;      
     
        String url = "jdbc:mysql://localhost:3306/hobbyme";
        String user = "root";
        String password = "1234";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);      
        
        return conn;
    }

    // 댓글 등록
    public void insertComment(CommentDTO comment) {
        String sql = "INSERT INTO Comment (post_num, user_id, content) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, comment.getPost_num());
            pstmt.setString(2, comment.getUser_id());
            pstmt.setString(3, comment.getContent());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 댓글 목록 조회
    public List<CommentDTO> getCommentsByPostNum(int postNum) {
        List<CommentDTO> commentList = new ArrayList<>();
        String sql = "SELECT * FROM Comment WHERE post_num = ? AND deleted = 'N' ORDER BY created_at ASC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postNum);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                CommentDTO comment = new CommentDTO();
                comment.setComment_id(rs.getInt("comment_id"));
                comment.setPost_num(rs.getInt("post_num"));
                comment.setUser_id(rs.getString("user_id"));
                comment.setContent(rs.getString("content"));
                comment.setCreated_at(rs.getTimestamp("created_at"));
                comment.setUpdated_at(rs.getTimestamp("updated_at"));
                commentList.add(comment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return commentList;
    }

    // 댓글 삭제 (소프트 삭제)
    public void deleteComment(int commentId) {
        String sql = "UPDATE Comment SET deleted = 'Y' WHERE comment_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, commentId);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 댓글 수정
    public void updateComment(CommentDTO comment) {
        String sql = "UPDATE Comment SET content = ?, updated_at = CURRENT_TIMESTAMP WHERE comment_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, comment.getContent());
            pstmt.setInt(2, comment.getComment_id());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
