<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, mvc.model.FaqDAO, mvc.model.FaqDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
request.setCharacterEncoding("UTF-8");
String classes = (String) session.getAttribute("sessionClass");
boolean isAdmin = classes != null && classes.equals("A");

String mode = request.getParameter("mode");
String faqNumStr = request.getParameter("faq_num");
String search = request.getParameter("search");
String categoryParam = request.getParameter("category");
if (search == null) search = "";
if (categoryParam == null || categoryParam.equals("전체")) categoryParam = "";

request.setAttribute("categoryParam", categoryParam);

FaqDAO dao = FaqDAO.getInstance();

// 관리자만 글쓰기/수정/삭제 가능하도록 수정
if ("add".equals(mode) && isAdmin) {
    FaqDTO dto = new FaqDTO();
    dto.setTitle(request.getParameter("title"));
    dto.setContent(request.getParameter("content"));
    dto.setCategory(request.getParameter("category"));
    dao.insertFaq(dto);
} else if ("delete".equals(mode) && isAdmin && faqNumStr != null) {
    dao.deleteFaq(Integer.parseInt(faqNumStr));
} else if ("update".equals(mode) && isAdmin && faqNumStr != null) {
    FaqDTO dto = new FaqDTO();
    dto.setFaq_num(Integer.parseInt(faqNumStr));
    dto.setTitle(request.getParameter("title"));
    dto.setContent(request.getParameter("content"));
    dto.setCategory(request.getParameter("category"));
    dao.updateFaq(dto);
}

int pageSize = 10;
int pageNum = request.getParameter("pageNum") == null ? 1 : Integer.parseInt(request.getParameter("pageNum"));
int startRow = (pageNum - 1) * pageSize;

int totalCount = dao.getFaqCount(search, categoryParam);
int pageCount = (int) Math.ceil((double) totalCount / pageSize);

List<FaqDTO> list = dao.getFaqList(startRow, pageSize, search, categoryParam);
request.setAttribute("faqList", list);

int pageBlock = 5;
int startPage = ((pageNum - 1) / pageBlock) * pageBlock + 1;
int endPage = startPage + pageBlock - 1;
if (endPage > pageCount) endPage = pageCount;
%>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>FAQ</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            body, html { height: 100%; margin: 0; }
            body { display: flex; flex-direction: column; }
            .container { flex: 1; }
            .notice-item { display: flex; justify-content: space-between; align-items: center; padding: 1rem 0.5rem; border-bottom: 1px solid #eee; cursor: pointer; }
            .notice-left { display: flex; align-items: center; gap: 1rem; }
            .badge { font-size: 0.75rem; font-weight: 600; color: #fff; padding: 0.3rem 0.7rem; border-radius: 20px; }
            .badge[data-category="이용안내"] { background-color: #2d8eff; }
            .badge[data-category="회원정보"] { background-color: #8b5cf6; }
            .badge[data-category="결제/환불"] { background-color: #22c55e; }
            .badge[data-category="쿠폰"] { background-color: #f97316; }
            .badge[data-category="호스트"] { background-color: #ec4899; }
            .badge[data-category="기타"] { background-color: #6b7280; }
            .notice-title { font-size: 1rem; font-weight: 600; cursor: pointer; }
            .notice-date { margin-left: auto; color: #888; font-size: 0.9rem; white-space: nowrap; }
            #writeForm, .edit-form, .faq-answer { display: none; background-color: #f8f8f8; padding: 1rem; border-left: 4px solid #0d6efd; }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/view/common/header.jsp" %>

        <div class="container mt-5">
            <h3 class="mb-3">📌 자주 묻는 질문</h3>

            <!-- 🔖 카테고리 탭 -->
            <div class="category-tab mb-4 d-flex flex-wrap gap-2">
                <a href="faq.jsp?category=전체" class="btn btn-sm <%= "".equals(categoryParam) ? "btn-dark" : "btn-outline-secondary" %>">전체</a>
                <a href="faq.jsp?category=이용안내" class="btn btn-sm <%= "이용안내".equals(categoryParam) ? "btn-dark" : "btn-outline-secondary" %>">이용안내</a>
                <a href="faq.jsp?category=회원정보" class="btn btn-sm <%= "회원정보".equals(categoryParam) ? "btn-dark" : "btn-outline-secondary" %>">회원정보</a>
                <a href="faq.jsp?category=결제/환불" class="btn btn-sm <%= "결제/환불".equals(categoryParam) ? "btn-dark" : "btn-outline-secondary" %>">결제/환불</a>
                <a href="faq.jsp?category=쿠폰" class="btn btn-sm <%= "쿠폰".equals(categoryParam) ? "btn-dark" : "btn-outline-secondary" %>">쿠폰</a>
                <a href="faq.jsp?category=호스트" class="btn btn-sm <%= "호스트".equals(categoryParam) ? "btn-dark" : "btn-outline-secondary" %>">호스트</a>
                <a href="faq.jsp?category=기타" class="btn btn-sm <%= "기타".equals(categoryParam) ? "btn-dark" : "btn-outline-secondary" %>">기타</a>
            </div>

            <form method="get" action="faq.jsp" class="mb-3">
                <input type="text" name="search" value="<%=search%>" placeholder="제목 또는 내용 검색" class="form-control w-50 d-inline">
                <button type="submit" class="btn btn-outline-secondary">검색</button>
            </form>

            <% if (isAdmin) { %>
                <button class="btn btn-success mb-3" onclick="toggleWriteForm()">글쓰기</button>
                <div id="writeForm">
                    <form method="post">
                        <input type="hidden" name="mode" value="add"/>
                        <div class="mb-2"><input type="text" name="title" class="form-control" placeholder="제목" required="required"/></div>
                        <div class="mb-2">
                            <textarea name="content" class="form-control" placeholder="내용" required="required"></textarea>
                        </div>
                        <div class="mb-2"><input type="text" name="category" class="form-control" placeholder="카테고리" required="required"/></div>
                        <button type="submit" class="btn btn-success">등록</button>
                    </form>
                </div>
            <% } %>

            <c:forEach var="f" items="${faqList}">
                <div class="notice-item" onclick="toggleContent(this)">
                    <div class="notice-left">
                        <span class="badge" data-category="${f.category}">${f.category}</span>
                        <span class="notice-title">${f.title}</span>
                    </div>
                    <div class="notice-date">${f.created_date}</div>
                </div>
                <div class="faq-answer">
                    <p><c:out value="${f.content}" /></p>
                    <% if (isAdmin) { %>
                        <form method="post" action="faq.jsp" style="display:inline;" onsubmit="return confirm('정말 삭제할까요?')">
                            <input type="hidden" name="mode" value="delete"/>
                            <input type="hidden" name="faq_num" value="${f.faq_num}"/>
                            <button type="submit" class="btn btn-sm btn-outline-danger">삭제</button>
                        </form>
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="toggleEdit('${f.faq_num}')">수정</button>
                        <form method="post" action="faq.jsp" id="editForm_${f.faq_num}" class="edit-form mt-3">
                            <input type="hidden" name="mode" value="update"/>
                            <input type="hidden" name="faq_num" value="${f.faq_num}"/>
                            <input type="text" name="title" class="form-control mb-2" value="${f.title}" required="required"/>
                            <textarea name="content" class="form-control mb-2" rows="4"><c:out value="${f.content}" /></textarea>
                            <input type="text" name="category" class="form-control mb-2" value="${f.category}" required="required"/>
                            <button type="submit" class="btn btn-sm btn-primary">수정 완료</button>
                            <button type="button" class="btn btn-sm btn-secondary" onclick="toggleEdit('${f.faq_num}')">취소</button>
                        </form>
                    <% } %>
                </div>
            </c:forEach>

            <div class="paging mt-4">
                <% for (int i = 1; i <= pageCount; i++) { %>
                    <a href="faq.jsp?pageNum=<%=i%>&search=<%=search%>&category=<%=categoryParam%>" class="btn btn-outline-dark btn-sm m-1"><%=i%></a>
                <% } %>
            </div>
        </div>

        <%@ include file="/WEB-INF/view/common/footer.jsp" %>

        <script>
            function toggleWriteForm() {
                const form = document.getElementById("writeForm");
                form.style.display = (form.style.display === "block") ? "none" : "block";
            }
            function toggleContent(el) {
                const answer = el.nextElementSibling;
                answer.style.display = (answer.style.display === "block") ? "none" : "block";
            }
            function toggleEdit(num) {
                const edit = document.getElementById("editForm_" + num);
                edit.style.display = (edit.style.display === "block") ? "none" : "block";
            }
        </script>
    </body>
</html>