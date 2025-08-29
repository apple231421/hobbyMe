package mvc.controller;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Timer;
import java.util.TimerTask;

import mvc.database.DBConnection;
import mvc.model.BoardDAO;

public class PostCleanupScheduler {
    private static final long PERIOD = 24 * 60 * 60 * 1000L; // 24시간
    private static Timer timer;

    public static void start() {
        timer = new Timer(true);
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                System.out.println("게시글 마감 자동 삭제 작업 실행");
                BoardDAO.getInstance().autoExpirePosts();
                              
             // 결제 상태 만료 처리
                int updated = expireOldPayments();
                System.out.println("✅ 만료된 게시글 수: " + updated);
            }
        }, 0, PERIOD);
               
    }

    public static void stop() {
        if (timer != null) {
            timer.cancel();
        }
    }
    
    public static int expireOldPayments() {
        int result = 0;
        String sql = "UPDATE payment SET state = 'F', deleted = 'Y' WHERE DATE(today_date) <= DATE_SUB(CURDATE(), INTERVAL 3 DAY)";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
    
    
    
}
