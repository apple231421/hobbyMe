<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.*"%>
<%@ page import="mvc.model.HobbyDTO"%>
<%
   List paymentList = (List) request.getAttribute("paymentList");
   int total_record = ((Integer) request.getAttribute("total_record")).intValue();
   int pageNum = ((Integer) request.getAttribute("pageNum")).intValue();
   int total_page = ((Integer) request.getAttribute("total_page")).intValue();
%>
<html>
<head>
<title>내 결제 목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
<style>
html, body {
  height: 100%;
  margin: 0;
}
body {
  display: flex;
  flex-direction: column;
}
.container {
  flex: 1;
}
</style>
</head>
<body>
<%@ include file="/WEB-INF/view/common/header.jsp" %>

<div class="container py-4">

  <!-- 페이지 제목 -->
  <div class="bg-light p-4 rounded mb-4 shadow-sm">
    <h2 class="mb-1 fw-bold">내 결제 목록</h2>
    <p class="text-muted">사용자의 결제 내역을 확인하세요.</p>
  </div>

  <!-- 검색 및 전체 건수 -->
  <form action="<c:url value='/login/showPayment.do'/>" method="post" class="mb-3">
    <div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
      <div>
        <span class="badge bg-success fs-6">전체 <%= total_record %>건</span>
      </div>
      <div class="d-flex gap-2">
        <select name="items" class="form-select form-select-sm" style="width: 120px;">
          <option value="title">제목</option>
          <option value="user_id">아이디</option>
        </select>
        <input type="text" name="text" class="form-control form-control-sm" placeholder="검색어 입력" />
        <button type="submit" class="btn btn-primary btn-sm">검색</button>
      </div>
    </div>

    <!-- 테이블 -->
    <div class="card shadow-sm">
      <div class="card-body p-0">
        <table class="table table-hover text-center mb-0" style="table-layout: fixed; width: 100%;">
          <colgroup>
		    <col style="width: 10%;">
		    <col style="width: 50%;">
		    <col style="width: 15%;">
		    <col style="width: 15%;">
		    <col style="width: 10%;">
		  </colgroup>
          <thead class="table-light">
            <tr>
              <th scope="col">번호</th>
              <th scope="col">제목</th>
              <th scope="col">유저</th>
              <th scope="col">가격</th>
              <th scope="col">상태</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="payment" items="${paymentList}" varStatus="status">
                <tr>
                    <td>${(pageNum - 1) * 8 +status.index + 1}</td>
                    <td class="text-start">
                        <a href="${pageContext.request.contextPath}/login/showReservation.do?post_num=${payment.myBoardNum}&id=${payment.myId}" class="text-decoration-none">
		                  ${payment.myPayTitle}
		                </a>
                    </td>
                    <td>${payment.myId}</td>
                    <td>${payment.myBoardPrice}</td>
                    <td>
		                <c:choose>
						    <c:when test="${payment.myPayState == 'F'}">Failed</c:when>
						    <c:when test="${payment.myPayState == 'S'}">Success</c:when>
						    <c:when test="${payment.myPayState == 'W'}">Wait</c:when>
						    <c:when test="${payment.myPayState == 'C'}">Confirm</c:when>
						    <c:otherwise>-</c:otherwise>
						</c:choose>
		            </td>
                </tr>
            </c:forEach>
            <c:if test="${empty paymentList}">
                <tr>
                    <td colspan="5">참여한 프로젝트가 없습니다.</td>
                </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 페이지네이션 -->
    <div class="d-flex justify-content-center mt-4">
      <c:set var="pageNum" value="<%=pageNum%>" />
      <nav>
        <ul class="pagination pagination-sm mb-0">
          <c:forEach var="i" begin="1" end="<%=total_page%>">
            <li class="page-item ${pageNum == i ? 'active' : ''}">
              <a class="page-link" href="<c:url value='/login/myPaymentList.do?pageNum=${i}' />">${i}</a>
            </li>
          </c:forEach>
        </ul>
      </nav>
    </div>

  </form>
</div>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
</body>
</html>
