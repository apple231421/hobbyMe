<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="mvc.model.PaymentDTO"%>

<%
String sessionId = (String) session.getAttribute("sessionId");

PaymentDTO adminCheckPaymentInfo = (PaymentDTO) request.getAttribute("adminCheckPaymentInfo");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약 확인 전환 페이지</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/style.css">

<style>
body {
	background-color: #f5f7fa;
	font-family: 'Noto Sans KR', sans-serif;
}

h1, h2 {
	font-weight: 700;
	color: #333;
}

.thumbnail-img {
	max-width: 100%;
	max-height: 300px;
	object-fit: cover;
	border-radius: 12px;
	box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
	margin-bottom: 20px;
}

.card-custom {
	background-color: #ffffff;
	border-radius: 16px;
	box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
	padding: 30px;
	margin-bottom: 40px;
}

.price-text {
	color: #ff6b00;
	font-size: 2rem;
	font-weight: bold;
}

.btn-group-custom {
	text-align: center;
	margin-top: 20px;
}

.btn-warning {
	border-radius: 30px;
	padding: 10px 30px;
	font-weight: 600;
}

.btn-danger {
	border-radius: 30px;
	padding: 10px 30px;
	font-weight: 600;
	margin-left: 10px;
}

.btn-success {
	border-radius: 30px;
	padding: 10px 30px;
	font-weight: 600;
	margin-left: 10px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
}

table, th, td {
	border: 1px solid #ddd;
}

th, td {
	padding: 10px;
	text-align: left;
}

th {
	background-color: #f2f2f2;
}

.jump {
	padding: 40px;
}
</style>

</head>
<body>

	<jsp:include page="/WEB-INF/view/common/header.jsp" />

	<div class="container py-4">
		<div class="position-relative p-5 mb-4 rounded-3"
			style="overflow: hidden; background-color: #fefefe;">
			<!-- 배경 이미지 효과 -->
			<div
				style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background-image: url('./images/class_reservation.jpg'); background-size: cover; background-position: center; background-repeat: no-repeat; opacity: 0.2; z-index: 1; pointer-events: none;">
			</div>

			<!-- 분기된 타이틀 실제 출력 -->
			<div class="container-fluid py-5 position-relative"
				style="z-index: 2;">
				<h1 class="display-5 fw-bold text-center">입금 확인</h1>
			</div>
		</div>

		<div class="card-custom">

			<!-- 클래스 정보 테이블 -->
			<table>
				<h3>클래스 예약정보</h3>
				<tr>
					<th>제목</th>
					<td>${adminCheckPaymentInfo.title}</td>
				</tr>
				<tr>
					<th>일정</th>
					<td>${adminCheckPaymentInfo.reservation_date}~
						${adminCheckPaymentInfo.end_date}</td>
				</tr>
				<tr>
				<tr>
					<th>가격</th>
					<td>${adminCheckPaymentInfo.price}원<c:choose>
							<c:when test="${adminCheckPaymentInfo.state == 'C'}">
								<span class="badge bg-success ms-2">입금확인</span>
							</c:when>
							<c:when test="${adminCheckPaymentInfo.state == 'F'}">
								<span class="badge bg-danger ms-2">예약실패</span>
							</c:when>
							<c:when test="${adminCheckPaymentInfo.state == 'S'}">
								<span class="badge bg-primary ms-2">예약성공</span>
							</c:when>
							<c:when test="${adminCheckPaymentInfo.state == 'W'}">
								<span class="badge bg-warning text-dark ms-2">결제대기중</span>
							</c:when>
							<c:otherwise>
								<span class="badge bg-secondary ms-2">알 수 없음</span>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>

			<span class="jump"></span>

			<table>
				<h3>참여자 정보</h3>
				<tr>
					<th>이름</th>
					<td>${adminCheckPaymentInfo.name}</td>
				</tr>
				<tr>
					<th>연락처</th>
					<td>${adminCheckPaymentInfo.phone}</td>
				</tr>
				<tr>
					<th>이메일</th>
					<td>${adminCheckPaymentInfo.email}</td>
				</tr>
				<tr>
					<th>예약날짜</th>
					<td>${adminCheckPaymentInfo.today_date}</td>
				</tr>
			</table>

			<!-- 버튼 -->
			<div class="btn-group-custom">
				<c:choose>
					<%-- 처음 예약한 사람 결제 실행 (정상) Fail --%>
					<c:when
						test="${empty adminCheckPaymentInfo or (adminCheckPaymentInfo.state == 'F')}">
						<c:set var="paymentState" value="fail" />
					</c:when>

					<%-- 결제 확인 중(Confirm) --%>
					<c:when test="${adminCheckPaymentInfo.state == 'C'}">
						<c:set var="paymentState" value="confirm" />
					</c:when>

					<%-- 결제 완료(Success) --%>
					<c:when test="${adminCheckPaymentInfo.state == 'S'}">
						<c:set var="paymentState" value="success" />
					</c:when>

					<%-- 결제 대기중(W) --%>
					<c:when test="${adminCheckPaymentInfo.state == 'W'}">
						<c:set var="paymentState" value="wait" />
					</c:when>

					<%-- 그 외 예외 처리 --%>
					<c:otherwise>
						<c:set var="paymentState" value="unknown" />
					</c:otherwise>
				</c:choose>

				<!-- 조건에 따라 실제 HTML 출력 -->
				<!-- 조건에 따라 실제 HTML 출력 -->
				<div class="d-flex justify-content-center gap-3 mt-4">
					<c:choose>
						<c:when
							test="${empty adminCheckPaymentInfo or adminCheckPaymentInfo.state == 'F'}">
							<form
								action="${pageContext.request.contextPath}/login/showPayment.do"
								method="post" class="d-inline">
								<input type="submit" class="btn btn-danger" value="나가기">
							</form>
						</c:when>

						<c:when test="${adminCheckPaymentInfo.state == 'C'}">
							<form
								action="${pageContext.request.contextPath}/ConfirmPaymentAction.do"
								method="post" class="d-inline">
								<input type="submit" class="btn btn-success" value="결제 승인">
								<input type="hidden" name="user_id"
									value="${adminCheckPaymentInfo.user_id}" /> <input
									type="hidden" name="post_num"
									value="${adminCheckPaymentInfo.post_num}" />
							</form>
							<form
								action="${pageContext.request.contextPath}/login/showPayment.do"
								method="post" class="d-inline">
								<input type="submit" class="btn btn-danger" value="나가기">
							</form>
						</c:when>

						<c:when
							test="${adminCheckPaymentInfo.state == 'S' || adminCheckPaymentInfo.state == 'W'}">
							<form
								action="${pageContext.request.contextPath}/login/showPayment.do"
								method="post" class="d-inline">
								<input type="submit" class="btn btn-danger" value="나가기">
							</form>
						</c:when>

						<c:otherwise>
							<button class="btn btn-secondary">결제 상태를 확인할 수 없습니다</button>
							<form
								action="${pageContext.request.contextPath}/login/showPayment.do"
								method="post" class="d-inline">
								<input type="submit" class="btn btn-danger" value="나가기">
							</form>
						</c:otherwise>
					</c:choose>
				</div>

			</div>

		</div>

		<jsp:include page="/WEB-INF/view/common/footer.jsp" />
</body>
</html>
