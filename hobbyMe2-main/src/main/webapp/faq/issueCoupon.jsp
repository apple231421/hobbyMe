<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="mvc.model.CouponDAO, mvc.model.NoticeDAO, mvc.model.NoticeDTO, mvc.model.CouponDTO" %>
        <%@ page import="java.util.*, java.sql.*" %>

            <%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("sessionId");

    if (userId == null || userId.trim().equals("")) {
%>
                <script>
                    alert("로그인이 필요합니다.");
                    window.location.href = "<%=request.getContextPath()%>/login/login.jsp";
                </script>
                <%
        return;
    }

    String noticeNumStr = request.getParameter("notice_num");
    int noticeNum = 0;
    try {
        noticeNum = Integer.parseInt(noticeNumStr);
    } catch (Exception e) {
%>
                    <script>
                        alert("잘못된 접근입니다.");
                        history.back();
                    </script>
                    <%
        return;
    }

    CouponDAO couponDao = CouponDAO.getInstance();
    NoticeDAO noticeDao = NoticeDAO.getInstance();

    NoticeDTO notice = noticeDao.getNoticeByNum(noticeNum);
    if (notice == null || !"이벤트".equals(notice.getCategory())) {
%>
                        <script>
                            alert("유효하지 않은 쿠폰입니다.");
                            history.back();
                        </script>
                        <%
        return;
    }

    if (notice.getEndDate() != null && new java.util.Date().after(java.sql.Date.valueOf(notice.getEndDate()))) {
%>
                            <script>
                                alert("이벤트 기간이 종료되어 쿠폰을 발급받을 수 없습니다.");
                                history.back();
                            </script>
                            <%
        return;
    }

    String couponCode = notice.getCoupon_content();
    if (couponCode == null || couponCode.trim().isEmpty()) {
%>
                                <script>
                                    alert("해당 이벤트에 쿠폰이 없습니다.");
                                    history.back();
                                </script>
                                <%
        return;
    }

    if (couponDao.hasUserReceivedCoupon(userId, couponCode)) {
%>
                                    <script>
                                        alert("이미 해당 쿠폰을 발급받았습니다.");
                                        history.back();
                                    </script>
                                    <%
        return;
    }

    CouponDTO userCoupon = new CouponDTO();
    userCoupon.setUserId(userId);
    userCoupon.setCouponContent(couponCode);
    userCoupon.setCouponType(notice.getCoupon_type());
    userCoupon.setCouponValue(notice.getCoupon_value());
    userCoupon.setCouponState("A");
    userCoupon.setCouponDeleted("N");
    userCoupon.setStartDate(java.sql.Date.valueOf(notice.getStartDate()));
    userCoupon.setEndDate(java.sql.Date.valueOf(notice.getEndDate()));

    boolean success = couponDao.insertIssuedCoupon(userCoupon);
    if (!success) {
        System.err.println("쿠폰 발급 실패: userId=" + userId + ", code=" + couponCode);
%>
                                        <script>
                                            alert("쿠폰 발급 중 오류가 발생했습니다.");
                                            history.back();
                                        </script>
                                        <%
        return;
    }

%>
                                            <script>
                                                alert("쿠폰이 정상적으로 발급되었습니다! 내 쿠폰함으로 이동합니다.");
                                                window.location.href = "<%=request.getContextPath()%>/login/couponList.jsp";
                                            </script>
                                            <%
%>