<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<%@ page import="mvc.model.HobbyDTO"%>
<%
    String userClass = (String) session.getAttribute("sessionClass");

    if (userClass == null || !"A".equals(userClass)) {
        response.sendRedirect(request.getContextPath() + "/login/myCouponList.do");
        return;
    }
%>
<%
    if (request.getAttribute("total_record") == null ||
        request.getAttribute("pageNum") == null ||
        request.getAttribute("total_page") == null) {
        response.sendRedirect(request.getContextPath() + "/login/checkCouponList.do");
        return;
    }
%>
<%
   int total_record = ((Integer) request.getAttribute("total_record")).intValue();
   int pageNum = ((Integer) request.getAttribute("pageNum")).intValue();
   int total_page = ((Integer) request.getAttribute("total_page")).intValue();
%>
<html>
<head>
<title>보유 쿠폰 목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
<style>
html, body { height: 100%; margin: 0; }
body { display: flex; flex-direction: column; } 
.container { flex: 1; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/view/common/header.jsp" %>

<div class="container py-4">

  <!-- 페이지 제목 -->
  <div class="bg-light p-4 rounded mb-4 shadow-sm">
    <h2 class="mb-1 fw-bold">보유 쿠폰 목록</h2>
    <p class="text-muted">사용자의 보유 쿠폰을 확인하세요.</p>
  </div>

  <!-- 검색 및 전체 건수 -->
  <form action="<c:url value='/login/checkCouponList.do'/>" method="post" class="mb-3">
    <div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
      <div>
        <span class="badge bg-success fs-6">전체 <%= total_record %>건</span>
      </div>
      <div class="d-flex gap-2">
        <select name="items" class="form-select form-select-sm" style="width: 120px;">
          <option value="user_id" selected="selected">소유자</option>
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
		    <col style="width: 10%;">
		    <col style="width: 40%;">
		    <col style="width: 10%;">
		    <col style="width: 10%;">
		    <col style="width: 10%;">
		    <col style="width: 10%;">
		  </colgroup>
          <thead class="table-light">
            <tr>
              <th scope="col">번호</th>
              <th scope="col">소유자</th>
              <th scope="col">내용</th>
              <th scope="col">종류</th>
              <th scope="col">포인트</th>
              <th scope="col">상태</th>
              <th scope="col">삭제</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="coupon" items="${couponList}" varStatus="status">
                <tr>
                    <td>${(pageNum - 1) * 8 +status.index + 1}</td>
                    <td>${coupon.myId}</td>
                    <td>${coupon.couponContent}</td>
                    <td>
                    	<c:choose>
						    <c:when test="${coupon.couponType == 'D'}">할인쿠폰</c:when>
						    <c:when test="${coupon.couponType == 'P'}">포인트</c:when>
						    <c:otherwise>-</c:otherwise>
						</c:choose>
                    </td>
                    <td>${coupon.couponValue}</td>
                    <td>
                    	<c:choose>
						    <c:when test="${coupon.couponState == 'A'}">사용가능</c:when>
						    <c:when test="${coupon.couponState == 'E'}">만료됨</c:when>
						    <c:otherwise>-</c:otherwise>
						</c:choose>
                    </td>
                    <td>
	                    <c:choose>
	                    	<c:when test="${coupon.couponState == 'A'}">
								<button type="button" class="btn btn-danger btn-sm" onclick="deleteCoupon('${coupon.couponNum}')">삭제</button>
							</c:when>
	                    </c:choose>
					</td>
                </tr>
            </c:forEach>
            <c:if test="${empty couponList}">
                <tr>
                    <td colspan="5">쿠폰이 없습니다.</td>
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
              <a class="page-link" href="<c:url value='/login/checkCouponList.do?pageNum=${i}' />">${i}</a>
            </li>
          </c:forEach>
        </ul>
      </nav>
    </div>

  </form>
</div>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
<script>
	function deleteCoupon(couponId) {
	    if (!confirm('정말 삭제하시겠습니까?')) return;
	
	    const form = document.createElement('form');
	    form.method = 'POST';
	    form.action = '${pageContext.request.contextPath}/login/deleteCoupon.do';
	
	    const input = document.createElement('input');
	    input.type = 'hidden';
	    input.name = 'couponId';
	    input.value = couponId;
	
	    form.appendChild(input);
	    document.body.appendChild(form);
	    form.submit();
	}
</script>
</body>
</html>
