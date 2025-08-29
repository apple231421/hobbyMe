<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ page import="mvc.model.HobbyDTO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
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
<body>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<c:if test="${param.msg == 'success'}">
    <div id="popup-alert" class="alert alert-success text-center" style="position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 9999; width: 300px;">
        지원이 완료되었습니다.
    </div>

    <script>
        // 3초 후 알림창 사라짐
        setTimeout(function() {
            const alertBox = document.getElementById("popup-alert");
            if (alertBox) {
                alertBox.style.transition = "opacity 0.5s";
                alertBox.style.opacity = 0;
                setTimeout(() => alertBox.remove(), 500); // 완전히 사라진 뒤 DOM 제거
            }
        }, 1000);
    </script>
</c:if>
<c:if test="${param.msg == 'already'}">
	<div id="popup-already" class="alert alert-success text-center" style="position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 9999; width: 300px;">
        이미 지원이 완료되었습니다.
    </div>

    <script>
        // 3초 후 알림창 사라짐
        setTimeout(function() {
            const alertBox = document.getElementById("popup-already");
            if (alertBox) {
                alertBox.style.transition = "opacity 0.5s";
                alertBox.style.opacity = 0;
                setTimeout(() => alertBox.remove(), 500); // 완전히 사라진 뒤 DOM 제거
            }
        }, 1000);
    </script>
</c:if>
<div class="container mt-5">
    <h2 class="mb-4">마이페이지</h2>
    <div class="row row-cols-1 row-cols-md-2 g-4">
        <!-- 결제 내역 -->
        <div class="col">
            <div class="card h-100">
                <div class="card-body">
	                <h5 class="card-title">결제 내역</h5>
                	<c:choose>
					    <c:when test="${sessionScope.sessionClass == 'A'}">
					        <p class="card-text">유저 결제 내역을 확인 하세요.</p>
					        <a href="${pageContext.request.contextPath}/login/showPayment.do" class="btn btn-primary">확인하기</a>
					    </c:when>
					    <c:otherwise>
					        <p class="card-text">내 결제 내역을 확인해보세요.</p>
					        <a href="${pageContext.request.contextPath}/login/myPaymentList.do" class="btn btn-primary">확인하기</a>
					    </c:otherwise>
					</c:choose>
                </div>
            </div>
        </div>

        <!-- 개인정보 수정 -->
		<div class="col">
		    <div class="card h-100">
		        <div class="card-body">
		            <h5 class="card-title">개인정보 수정</h5>
		            <p class="card-text">이메일, 비밀번호 등을 수정할 수 있어요.</p>
		            <a href="${pageContext.request.contextPath}/login/updateMember.do" class="btn btn-primary">수정하기</a>
		
		            <!-- 회원 탈퇴 버튼 -->
		            <form method="post" action="${pageContext.request.contextPath}/login/deleteMember.do" style="margin-top: 10px;" onsubmit="return confirm('정말로 회원 탈퇴하시겠습니까? 탈퇴 시 모든 정보가 삭제됩니다.');">
		                <button type="submit" class="btn btn-outline-danger">회원 탈퇴</button>
		            </form>
		        </div>
		    </div>
		</div>

        <!-- 참여한 프로젝트 -->
        <div class="col">
            <div class="card h-100">
                <div class="card-body">
                	<c:choose>
					    <c:when test="${sessionScope.sessionClass == 'A'}">
					    	<div class="container">
						        <h3>전체 카테고리 관리</h3>
						
						        <!-- 전체 카테고리 목록 출력 -->
						        <ul class="list-group mb-4">
								    <c:forEach var="category" items="${categoryList}">
								        <li class="list-group-item d-flex justify-content-between align-items-center">
								            ${category.categoryName}
								            <form method="post" action="${pageContext.request.contextPath}/login/deleteCategory.do" style="margin: 0;">
								                <input type="hidden" name="categoryId" value="${category.categoryNum}" />
								                <button type="submit" class="btn btn-sm btn-danger">삭제</button>
								            </form>
								        </li>
								    </c:forEach>
								</ul>

						        <!-- 신규 카테고리 추가 폼 -->
						        <form method="post" action="${pageContext.request.contextPath}/login/addCategory.do">
						            <div class="input-group">
						                <input type="text" name="newCategory" class="form-control" placeholder="신규 카테고리명" required />
						                <button class="btn btn-success" type="submit">카테고리 추가</button>
						            </div>
						        </form>
						    </div>
					    </c:when>
					    <c:otherwise>
		                    <h5 class="card-title">참여한 프로젝트</h5>
		                    <p class="card-text">내가 참여한 프로젝트를 볼 수 있어요.</p>
		                    <a href="${pageContext.request.contextPath}/login/myProject.do" class="btn btn-primary">프로젝트 보기</a>
					    </c:otherwise>
					</c:choose>
                </div>
            </div>
        </div>

        <!-- 쿠폰 -->
        <div class="col">
            <div class="card h-100">
                <div class="card-body">
                	<c:choose>
					    <c:when test="${sessionScope.sessionClass == 'A'}">
					    	<h5 class="card-title">쿠폰 현황</h5>
		                    <p class="card-text">이벤트 진행중인 쿠폰을 확인하세요.</p>
		                    <a href="${pageContext.request.contextPath}/login/checkCouponList.do" class="btn btn-primary">쿠폰 확인</a>
					    </c:when>
					    <c:otherwise>
		                    <h5 class="card-title">보유 쿠폰</h5>
		                    <p class="card-text">사용 가능한 쿠폰을 확인하세요.</p>
		                    <a href="${pageContext.request.contextPath}/login/myCouponList.do" class="btn btn-primary">쿠폰 확인</a>
					    </c:otherwise>
					</c:choose>
                </div>
            </div>
        </div>

        <!-- 호스트 지원 -->
        <div class="col">
            <div class="card h-100">
                <div class="card-body">
                	<c:choose>
					    <c:when test="${sessionScope.sessionClass == 'A'}">
					    	<h5 class="card-title">호스트 지원 현황</h5>
		                    <p class="card-text">프로젝트 호스트 신청 내역을 확인 합니다.</p>
		                    <a href="${pageContext.request.contextPath}/login/showApply.do" class="btn btn-primary">확인하기</a>
					    </c:when>
					    <c:otherwise>
		                    <h5 class="card-title">호스트 지원</h5>
		                    <p class="card-text">프로젝트 호스트가 되고 싶으신가요?</p>
		                    <a href="${pageContext.request.contextPath}/login/hostApply.do" class="btn btn-primary">지원하기</a>
					    </c:otherwise>
					</c:choose>
                </div>
            </div>
        </div>

        <!-- 이용약관 -->
        <div class="col">
            <div class="card h-100">
                <div class="card-body">
                	<c:choose>
					    <c:when test="${sessionScope.sessionClass == 'A'}">
					    	<h5 class="card-title">공지사항 작성</h5>
		                    <p class="card-text">공지사항을 수정/작성 합니다.</p>
		                    <a href="${pageContext.request.contextPath}/faq/notice.jsp" class="btn btn-primary">확인하기</a>
					    </c:when>
					    <c:otherwise>
		                    <h5 class="card-title">공지사항</h5>
		                    <p class="card-text">공지사항을 확인하세요.</p>
		                    <a href="${pageContext.request.contextPath}/faq/notice.jsp" class="btn btn-secondary">확인하기</a>
					    </c:otherwise>
					</c:choose>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/view/common/footer.jsp" %>
</body>
</html>
