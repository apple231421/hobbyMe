<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="java.util.*, mvc.model.NoticeDAO, mvc.model.NoticeDTO, mvc.model.CouponDAO, mvc.model.CouponDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
request.setCharacterEncoding("UTF-8");

String classes = (String) session.getAttribute("sessionClass");
String userId = (String) session.getAttribute("sessionId");
boolean isAdmin = classes != null && classes.equals("A");

String mode = request.getParameter("mode");
String numStr = request.getParameter("notice_num");
String search = request.getParameter("search");
String category = request.getParameter("category");
if (search == null) search = "";
if (category == null || category.equals("전체")) category = "";

NoticeDAO dao = NoticeDAO.getInstance();
CouponDAO couponDao = CouponDAO.getInstance();

if ("add".equals(mode) && isAdmin) {
    NoticeDTO dto = new NoticeDTO();
    dto.setTitle(request.getParameter("title"));
    dto.setContent(request.getParameter("content"));
    dto.setCategory(request.getParameter("category"));
    dto.setCreated_date(new java.util.Date());

    if ("이벤트".equals(dto.getCategory())) {
        dto.setStartDate(request.getParameter("start_date"));
        dto.setEndDate(request.getParameter("end_date"));
        dto.setCoupon_content(request.getParameter("coupon_content"));
        dto.setCoupon_type(request.getParameter("coupon_type"));
        dto.setCoupon_value(Integer.parseInt(request.getParameter("coupon_value")));
    }

    dao.insertNoticeReturnKey(dto);
    response.sendRedirect("notice.jsp");
    return;
} else if ("delete".equals(mode) && isAdmin && numStr != null) {
    dao.deleteNotice(Integer.parseInt(numStr));
    response.sendRedirect("notice.jsp");
    return;
} else if ("update".equals(mode) && isAdmin && numStr != null) {
    NoticeDTO dto = new NoticeDTO();
    dto.setNotice_num(Integer.parseInt(numStr));
    dto.setTitle(request.getParameter("title"));
    dto.setContent(request.getParameter("content"));
    dto.setCategory(request.getParameter("category"));
    dao.updateNotice(dto);
    response.sendRedirect("notice.jsp");
    return;
}

int pageSize = 10;
int pageNum = request.getParameter("pageNum") == null ? 1 : Integer.parseInt(request.getParameter("pageNum"));
int startRow = (pageNum - 1) * pageSize;

int totalCount = dao.getNoticeCount(search, category);
int pageCount = (int) Math.ceil((double) totalCount / pageSize);

List<NoticeDTO> list = dao.getNoticeList(startRow, pageSize, search, category);

java.util.Date currentDate = new java.util.Date();
Map<String, CouponDTO> couponInfoMap = new HashMap<>();
for (NoticeDTO notice : list) {
    if ("이벤트".equals(notice.getCategory()) && notice.getEndDate() != null) {
        java.util.Date endDate = java.sql.Date.valueOf(notice.getEndDate());
        if (currentDate.after(endDate)) {
            notice.setExpired(true);
        }
    }
    if (userId != null && notice.getCoupon_content() != null) {
        boolean issued = couponDao.hasUserReceivedCoupon(userId, notice.getCoupon_content());
        notice.setCouponIssued(issued);
    }
    if ("이벤트".equals(notice.getCategory()) && notice.getCoupon_content() != null) {
        CouponDTO coupon = couponDao.getCouponTemplateByCode(notice.getCoupon_content());
        if (coupon != null) {
            couponInfoMap.put(notice.getCoupon_content(), coupon);
        }
    }
}

request.setAttribute("noticeList", list);
request.setAttribute("couponInfoMap", couponInfoMap);

System.out.println("search=[" + search + "]");
System.out.println("category=[" + category + "]");
System.out.println("list.size()=" + list.size());
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body, html { height: 100%; margin: 0; }
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .container { flex: 1; }
        .badge[data-category="공지"] { background-color: #2d8eff; }
        .badge[data-category="이벤트"] { background-color: #8b5cf6; }
        .badge[data-category="일반"] { background-color: #22c55e; }
        .notice-title { cursor: pointer; }
        .notice-content { display: none; padding: 0.5rem 0 0.5rem 1rem; color: #333; }
        .category-tab { margin-bottom: 1.5rem; display: flex; flex-wrap: wrap; gap: 0.5rem; }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<div class="container mt-5">
    <h3 class="mb-3">📢 공지사항</h3>
    <div class="category-tab mb-4 d-flex flex-wrap gap-2">
        <a href="notice.jsp?category=전체&search=<%=search%>" class="btn btn-sm <%= "".equals(category) ? "btn-dark" : "btn-outline-secondary" %>">전체</a>
        <a href="notice.jsp?category=공지&search=<%=search%>" class="btn btn-sm <%= "공지".equals(category) ? "btn-dark" : "btn-outline-secondary" %>">공지</a>
        <a href="notice.jsp?category=이벤트&search=<%=search%>" class="btn btn-sm <%= "이벤트".equals(category) ? "btn-dark" : "btn-outline-secondary" %>">이벤트</a>
        <a href="notice.jsp?category=일반&search=<%=search%>" class="btn btn-sm <%= "일반".equals(category) ? "btn-dark" : "btn-outline-secondary" %>">일반</a>
    </div>
    <form method="get" action="notice.jsp" class="mb-3">
        <input type="hidden" name="category" value="<%= category %>"/>
        <input type="text" name="search" value="<%= search %>" placeholder="제목 또는 내용 검색" class="form-control w-50 d-inline">
        <button type="submit" class="btn btn-outline-secondary">검색</button>
    </form>

    <% if (isAdmin) { %>
        <button class="btn btn-success mb-3" onclick="toggleWriteForm()">글쓰기</button>
        <div id="writeForm" style="display:none;">
            <form method="post">
                <input type="hidden" name="mode" value="add"/>
                <div class="mb-2">
                    <select name="category" id="categorySelect" class="form-select" onchange="toggleEventFields()" required="required">
                        <option value="공지">공지</option>
                        <option value="이벤트">이벤트</option>
                        <option value="일반">일반</option>
                    </select>
                </div>
                <div class="mb-2">
                    <input type="text" name="title" class="form-control" placeholder="제목" required="required"/>
                </div>
                <div class="mb-2">
                    <textarea name="content" class="form-control" rows="4" placeholder="내용" required="required"></textarea>
                </div>
                <div id="eventDateFields" style="display:none;">
                    <div class="mb-2">
                        <label>구분</label><br>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="coupon_type" id="discountRadio" value="D" required="required">
                            <label class="form-check-label" for="discountRadio">할인</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="coupon_type" id="pointRadio" value="P" required="required">
                            <label class="form-check-label" for="pointRadio">포인트</label>
                        </div>
                        <div>
                            <input type="number" name="coupon_value" class="form-control" placeholder="수치를 입력해주세요" required="required"/>
                        </div>
                    </div>
                    <div class="row mb-2">
                        <div class="col">
                            <label>시작일:</label>
                            <input type="date" name="start_date" class="form-control"/>
                        </div>
                        <div class="col">
                            <label>만료일:</label>
                            <input type="date" name="end_date" class="form-control"/>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label>쿠폰 코드:</label>
                        <input type="text" name="coupon_content" class="form-control" placeholder="이벤트 쿠폰 코드 입력"/>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">등록</button>
            </form>
        </div>
    <% } %>

    <!-- 공지 리스트 출력 -->
    <c:forEach var="n" items="${noticeList}">
        <div class="border p-3 mb-2">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <span class="badge" data-category="${n.category}">${n.category}</span>
                    <span class="notice-title" onclick="toggleContent(this)">${n.title}</span>
                    <c:if test="${n.expired}">
                        <span class="badge bg-secondary">종료됨</span>
                    </c:if>
                    <c:if test="${n.category == '이벤트'}">
                        <small class="text-muted">
                            (${n.startDate} ~ ${n.endDate})</small>
                    </c:if>
                </div>
                <div><fmt:formatDate value="${n.created_date}" pattern="yyyy-MM-dd"/></div>
            </div>
            <div class="notice-content">
                <p>${n.content}</p>
                <c:if test="${n.category == '이벤트'}">
                    <div class="mt-2 text-muted">
                        유효기간: ${n.startDate} ~ ${n.endDate}
                    </div>
                    <div>할인 유형: ${n.coupon_type == 'D' ? '할인' : '포인트'}</div>
                    <div>수치: ${n.coupon_value}</div>
                </c:if>
                <c:if test="${n.category == '이벤트'}">
                    <c:choose>
                        <c:when test="${empty sessionScope.sessionId}">
                            <div class="text-danger">※ 쿠폰 발급을 위해 로그인해주세요.</div>
                        </c:when>
                        <c:when test="${n.expired}">
                            <span class="badge bg-secondary">이벤트 종료됨</span>
                        </c:when>
                        <c:when test="${n.couponIssued}">
                            <span class="badge bg-success">이미 쿠폰을 발급받았습니다</span>
                        </c:when>
                        <c:when test="${sessionScope.sessionClass != 'A'}">
                            <form method="post" action="issueCoupon.jsp">
                                <input type="hidden" name="notice_num" value="${n.notice_num}"/>
                                <button type="submit" class="btn btn-sm btn-warning">🎁 쿠폰 받기</button>
                            </form>
                        </c:when>
                    </c:choose>
                </c:if>
                <% if (isAdmin) { %>
                    <form method="post" action="notice.jsp" style="display:inline-block">
                        <input type="hidden" name="mode" value="delete"/>
                        <input type="hidden" name="notice_num" value="${n.notice_num}"/>
                        <button type="submit" class="btn btn-sm btn-outline-danger">삭제</button>
                    </form>
                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="toggleEdit(${n.notice_num})">수정</button>
                    <div id="editForm_${n.notice_num}" style="display:none; margin-top:1rem;">
                        <form method="post" action="notice.jsp">
                            <input type="hidden" name="mode" value="update"/>
                            <input type="hidden" name="notice_num" value="${n.notice_num}"/>
                            <div class="mb-2">
                                <input type="text" name="title" class="form-control" value="${n.title}" required="required"/>
                            </div>
                            <div class="mb-2">
                                <textarea name="content" class="form-control" rows="4" required="required">${n.content}</textarea>
                            </div>
                            <div class="mb-2">
                                <select name="category" class="form-select" required="required">
                                    <option value="공지" <c:if test="${n.category == '공지'}">selected</c:if>>공지</option>
                                    <option value="이벤트" <c:if test="${n.category == '이벤트'}">selected</c:if>>이벤트</option>
                                    <option value="일반" <c:if test="${n.category == '일반'}">selected</c:if>>일반</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-sm btn-primary">수정 완료</button>
                        </form>
                    </div>
                <% } %>
            </div>
        </div>
    </c:forEach>

    <div class="mt-4">
        <% for (int i = 1; i <= pageCount; i++) { %>
            <a href="notice.jsp?pageNum=<%=i%>&search=<%=search%>&category=<%=category%>" class="btn btn-sm btn-outline-dark m-1"><%= i %></a>
        <% } %>
    </div>
</div>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
<script>
    function toggleWriteForm() {
        const form = document.getElementById("writeForm");
        form.style.display = form.style.display === "block" ? "none" : "block";
    }
    function toggleEventFields() {
        const category = document.getElementById("categorySelect").value;
        const dateFields = document.getElementById("eventDateFields");
        dateFields.style.display = category === "이벤트" ? "block" : "none";
    }
    function toggleContent(el) {
        const content = el.parentElement.parentElement.nextElementSibling;
        content.style.display = content.style.display === "block" ? "none" : "block";
    }
    function toggleEdit(num) {
        const form = document.getElementById("editForm_" + num);
        form.style.display = form.style.display === "block" ? "none" : "block";
    }
</script>
</body>
</html>