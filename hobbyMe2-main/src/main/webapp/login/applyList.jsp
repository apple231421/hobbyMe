<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<%@ page import="mvc.model.HobbyDTO"%>
<%
   List applyList = (List) request.getAttribute("applyList");
   int total_record = ((Integer) request.getAttribute("total_record")).intValue();
   int pageNum = ((Integer) request.getAttribute("pageNum")).intValue();
   int total_page = ((Integer) request.getAttribute("total_page")).intValue();
%>
<html>
<head>
<title>지원 목록</title>
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
    <h2 class="mb-1 fw-bold">지원 목록</h2>
    <p class="text-muted">사용자의 호스트 지원 내역을 확인하세요.</p>
  </div>

  <!-- 검색 및 전체 건수 -->
  <form action="<c:url value='/login/showApply.do'/>" method="post" class="mb-3">
    <div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
      <div>
        <span class="badge bg-success fs-6">전체 <%= total_record %>건</span>
      </div>
      <div class="d-flex gap-2">
        <select name="items" class="form-select form-select-sm" style="width: 120px;">
          <option value="host_title">제목</option>
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
		    <col style="width: 20%;">
		    <col style="width: 20%;">
		  </colgroup>
          <thead class="table-light">
            <tr>
              <th scope="col">번호</th>
              <th scope="col">제목</th>
              <th scope="col">지원자</th>
              <th scope="col">상태</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="apply" items="${applyList}" varStatus="status">
            	<tr>
            		<td>${apply.userNum}</td>
            		<td class="text-start">
            			<a href="${pageContext.request.contextPath}/login/hostApply.do?num=${apply.userNum}&id=${apply.userId}" class="text-decoration-none">
            				${apply.hostTitle}
            			</a>
            		</td>
            		<td>${apply.userId}</td>
            		<td>
		                <c:choose>
						    <c:when test="${apply.hostState == 'G'}">Grand</c:when>
						    <c:when test="${apply.hostState == 'H'}">Hold</c:when>
						    <c:when test="${apply.hostState == 'R'}">Reject</c:when>
						    <c:otherwise>-</c:otherwise>
						</c:choose>
		            </td>
            	</tr>
            </c:forEach>
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
              <a class="page-link" href="<c:url value='/login/showApply.do?pageNum=${i}' />">${i}</a>
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
