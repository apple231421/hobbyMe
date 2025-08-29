<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="mvc.model.BoardDTO"%>
<%
String sessionId = (String) session.getAttribute("sessionId");
BoardDTO board = (BoardDTO) request.getAttribute("board");
int post_num = ((Integer) request.getAttribute("post_num")).intValue();
int pageNum = ((Integer) request.getAttribute("pageNum")).intValue();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>게시글 상세보기</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<link href="./css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/style.css">


<script
	src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=bc9e965cfe37a104a3df25b79345fc17&libraries=services&autoload=false"></script>

<style>
body {
	background-color: #f7f9fc;
	font-family: 'Noto Sans KR', sans-serif;
}

h2 {
	font-weight: 700;
	color: #333;
}

.card {
	border: none;
	border-radius: 16px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.card-header {
	background: linear-gradient(135deg, #fdfbfb, #ebedee);
	padding: 1.5rem;
	border-top-left-radius: 16px;
	border-top-right-radius: 16px;
}

.card-body {
	padding: 2rem;
	background-color: #fff;
}

.card-footer {
	background-color: #fafafa;
	border-bottom-left-radius: 16px;
	border-bottom-right-radius: 16px;
}

.post-content {
	font-size: 1.1rem;
	line-height: 1.8;
	color: #444;
	white-space: pre-wrap;
	margin-top: 20px;
}

.like-icon {
	font-size: 30px;
	cursor: pointer;
	transition: transform 0.2s ease, color 0.3s ease;
}

.like-icon:hover {
	transform: scale(1.2);
}

.liked {
	color: #ff4081;
}

.unliked {
	color: #cfcfcf;
}

.count {
	margin-left: 8px;
	font-weight: 600;
	font-size: 16px;
	color: #555;
}

#map {
	width: 100%;
	height: 320px;
	border-radius: 10px;
	margin-top: 12px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.comment-block {
	background-color: #fff;
	border-radius: 12px;
	padding: 1.2rem;
	margin-bottom: 1rem;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
}

.btn-group a, .d-flex a.btn {
	margin-left: 5px;
}

.btn {
	border-radius: 30px;
	padding: 8px 20px;
	font-weight: 500;
}

.admin-comment {
	background-color: #fffbe6;
	border-left: 6px solid #f0ad4e;
}

</style>

<script>
function confirmDelete() {
	return confirm("정말 삭제하시겠습니까?");
}
function confirmImageDownload(filename) {
	return confirm("사진을 다운로드하시겠습니까?");
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/view/common/header.jsp" />

	<div class="main-container">
		<div class="content-wrap board-detail py-5" style="margin-top: 80px;">
			<div class="container">
				<h2 class="mb-4 text-center">📄 게시글 상세보기</h2>

				<c:if test="${empty board}">
					<div class="alert alert-warning">
						게시글을 찾을 수 없습니다.
						<div class="mt-3">
							<a href="BoardListAction.do" class="btn btn-secondary">목록으로
								돌아가기</a>
						</div>
					</div>
				</c:if>

				<c:if test="${not empty board}">
					<div class="card shadow mb-5">
						<div class="card-header">
							<h4 class="mb-1">${board.title}</h4>

							<div class="small text-muted mt-2">작성자: ${board.user_id} |
								작성일: ${board.created_date}</div>

							<c:if test="${not empty board.end_date}">
								<div class="mt-1">
									<strong>마감일:</strong> ${board.end_date}
									<c:choose>
										<c:when test="${board.dday == 0}">
											<span class="badge bg-danger ms-2">D-day</span>
										</c:when>
										<c:when test="${board.dday < 0}">
											<span class="badge bg-secondary ms-2">마감됨</span>
										</c:when>
										<c:otherwise>
											<span class="badge bg-warning ms-2">D-${board.dday}</span>
										</c:otherwise>
									</c:choose>
								</div>
							</c:if>

							<!-- ✅ 가격과 최대 인원수 표시 추가 -->
							<div class="mt-2">
								<strong>가격:</strong> <span class="text-dark">${board.price}원</span>

								<span class="ms-3"> <strong>모집 인원:</strong> <span
									class="text-dark">${board.reserved}/${board.people}명</span>
								</span>
							</div>

						</div>


						<div class="card-body">
							<c:if
								test="${not empty board.lat && not empty board.lng && not empty board.location}">
								<hr>
								<!-- 모임 위치: 주소 박스 한 줄로 나열 -->
								<div class="mt-4 d-flex align-items-center flex-wrap">
									<strong class="me-2">📍 모임 위치 :</strong>
									<div
										class="bg-light p-2 px-3 rounded shadow-sm d-flex align-items-center">
										<i class="fa-solid fa-location-dot text-danger me-2"></i> <span>${board.location}</span>
									</div>
								</div>

								<!-- 지도는 아래에 출력 -->
								<div class="mt-3">
									<div id="map"
										style="width: 100%; height: 320px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);">
									</div>
								</div>
							</c:if>





							<!-- 메인 내용 -->
							<hr>
							<div class="mb-4">
								<strong>📝 상세 설명</strong>
								<p class="post-content mt-2">${board.content}</p>
							</div>
							<c:if test="${not empty board.tag}">
								<hr>
								<div class="mb-4">
									<strong>🏷️ 태그</strong><br>
									<div class="d-flex flex-wrap gap-2 mt-2">
										<c:forEach var="t" items="${fn:split(board.tag, ',')}">
											<span class="badge bg-info text-dark">${t}</span>
										</c:forEach>
									</div>
								</div>
							</c:if>

							<c:if test="${not empty board.thumbnail}">
								<hr>
								<div class="mt-4">
									<strong>대표 이미지</strong><br> <a
										href="downloadFile.do?fileName=${board.thumbnail}"
										onclick="return confirmImageDownload('${board.thumbnail}');">
										<img
										src="${pageContext.request.contextPath}/uploads/${board.thumbnail}"
										class="img-fluid rounded mt-3 shadow-sm"
										style="max-height: 300px; object-fit: cover;" alt="대표 이미지">
									</a>
								</div>
							</c:if>

							<c:if test="${not empty board.images}">
								<hr>
								<div class="mt-4">
									<strong>관련 이미지</strong><br>
									<div class="d-flex flex-wrap mt-2">
										<c:forEach var="img" items="${fn:split(board.images, ',')}">
											<a href="downloadFile.do?fileName=${img}"
												onclick="return confirmImageDownload('${img}');"
												class="me-2 mb-2"> <img
												src="${pageContext.request.contextPath}/uploads/${img}"
												class="img-thumbnail"
												style="max-width: 150px; object-fit: cover;" alt="관련 이미지">
											</a>
										</c:forEach>
									</div>
								</div>
							</c:if>

						</div>

						<div
							class="card-footer d-flex justify-content-between align-items-center">
							<div class="like-area d-flex align-items-center">
								<c:choose>
									<c:when test="${sessionScope.sessionClass == 'A'}">
										<!-- 어드민은 클릭 안되게 -->
										<span class="like-icon unliked text-muted"
											title="관리자는 좋아요를 사용할 수 없습니다." style="cursor: not-allowed;">💖</span>
									</c:when>
									<c:otherwise>
										<span
											class="like-icon ${board.user_liked ? 'liked' : 'unliked'}"
											title="좋아요 누르기">💖</span>
									</c:otherwise>
								</c:choose>
								<span class="count">${board.board_like}</span> <span
									class="ms-2 text-muted"> &lt;&lt; 좋아요를 눌러보세요</span>
							</div>


							<div class="btn-group">
								<!-- 수정: 작성자 본인만 가능 -->
								<c:if test="${sessionId == board.user_id}">
									<a
										href="BoardUpdateForm.do?post_num=${board.post_num}&pageNum=${pageNum}"
										class="btn btn-outline-primary btn-sm">수정</a>
								</c:if>

								<!-- 삭제: 작성자 또는 관리자 (삭제되지 않은 글만) -->
								<c:if
									test="${(sessionId == board.user_id || sessionScope.sessionClass == 'A') && board.deleted != 'Y'}">
									<a
										href="BoardDeleteAction.do?post_num=${board.post_num}&pageNum=${pageNum}"
										class="btn btn-outline-danger btn-sm"
										onclick="return confirmDelete()">삭제</a>
								</c:if>

								<!-- 복구: 관리자이고 이미 삭제된 글인 경우 -->
								<c:if
									test="${sessionScope.sessionClass == 'A' && board.deleted == 'Y'}">
									<a
										href="BoardRestoreAction.do?post_num=${board.post_num}&pageNum=${pageNum}"
										class="btn btn-outline-success btn-sm"
										onclick="return confirm('이 게시글을 복구하시겠습니까?');">복구</a>
								</c:if>
							</div>


						</div>
					</div>
					<div
						class="d-flex flex-wrap justify-content-between align-items-center mt-4">
						<a href="BoardListAction.do?pageNum=${pageNum}"
							class="btn btn-secondary mb-2">목록</a>

						<!-- ✅ 작성자가 아니고, 관리자도 아닐 때만 예약 관련 버튼 노출 -->
						<c:if
							test="${sessionScope.sessionClass != 'A' && sessionId != board.user_id}">
							<c:choose>
								<c:when test="${board.reserved >= board.people}">
									<button class="btn btn-dark" disabled>모집이 완료되었습니다</button>
								</c:when>

								<c:when test="${not empty paymentInfo}">
									<c:choose>
										<c:when test="${paymentInfo.state == 'F'}">
											<a href="javascript:void(0);"
												onclick="handleReservation(${post_num})"
												class="btn btn-primary">예약하기</a>
										</c:when>
										<c:when test="${paymentInfo.state == 'W'}">
											<a href="PaymentAction.do?post_num=${post_num}"
												class="btn btn-warning">결제하기</a>
										</c:when>
										<c:when test="${paymentInfo.state == 'C'}">
											<button class="btn btn-secondary" disabled>승인 대기중</button>
										</c:when>
										<c:when test="${paymentInfo.state == 'S'}">
											<button class="btn btn-success" disabled>예약 완료</button>
										</c:when>
									</c:choose>
								</c:when>

								<c:otherwise>
									<a href="javascript:void(0);"
										onclick="handleReservation(${post_num})"
										class="btn btn-primary">예약하기</a>
								</c:otherwise>
							</c:choose>
						</c:if>
					</div>


				</c:if>
			</div>
		</div>
	</div>

	<!-- 댓글 영역 -->
	<div class="container">
		<div class="card mt-4">
			<div class="card-header">💬 댓글</div>

			<div class="card-body">
				<c:if test="${empty comments}">
					<p class="text-muted">등록된 댓글이 없습니다.</p>
				</c:if>
				<c:forEach var="comment" items="${comments}">
					<div
						class="comment-block ${comment.user_id == 'admin' ? 'admin-comment' : ''}">
						<strong>${comment.user_id}</strong> <small class="text-muted">(${comment.created_at})</small>
						<c:if test="${comment.user_id == 'admin'}">
							<span class="badge bg-warning text-dark ms-2">관리자</span>
						</c:if>
						<c:choose>
							<c:when test="${param.edit_id == comment.comment_id}">
								<form method="post" action="commentUpdate.do">
									<input type="hidden" name="comment_id"
										value="${comment.comment_id}"> <input type="hidden"
										name="post_num" value="${post_num}">
									<textarea name="content" class="form-control mb-2" rows="2"
										required>${comment.content}</textarea>
									<button type="submit" class="btn btn-sm btn-success">저장</button>
									<a href="BoardViewAction.do?post_num=${post_num}"
										class="btn btn-sm btn-secondary">취소</a>
								</form>
							</c:when>
							<c:otherwise>
								<p class="mb-1">${comment.content}</p>
								<c:if
									test="${sessionId == comment.user_id || sessionScope.sessionClass == 'A'}">
									<div class="d-flex">

										<c:if test="${sessionId == comment.user_id}">
											<form method="get" action="BoardViewAction.do">
												<input type="hidden" name="post_num" value="${post_num}">
												<input type="hidden" name="edit_id"
													value="${comment.comment_id}">
												<button type="submit" class="btn btn-sm btn-outline-primary">수정</button>
											</form>
											<form method="post" action="commentDelete.do"
												style="margin-right: 5px;">
												<input type="hidden" name="comment_id"
													value="${comment.comment_id}"> <input type="hidden"
													name="post_num" value="${post_num}">
												<button type="submit" class="btn btn-sm btn-outline-danger">삭제</button>
											</form>
										</c:if>
									</div>
								</c:if>

							</c:otherwise>
						</c:choose>
					</div>
				</c:forEach>

				<c:if test="${not empty sessionId}">
					<form method="post" action="commentAdd.do"
						class="comment-form mt-3">
						<input type="hidden" name="post_num" value="${post_num}">
						<textarea name="content" class="form-control" rows="3"
							placeholder="댓글을 입력하고 등록 버튼을 눌러주세요." required></textarea>
						<button type="submit" class="btn btn-primary btn-sm mt-2">댓글
							등록</button>
					</form>
				</c:if>

				<c:if test="${empty sessionId}">
					<p class="text-muted mt-2">댓글을 작성하려면 로그인하세요.</p>
					<a href="${pageContext.request.contextPath}/login/login_home.do"
						class="btn btn-outline-primary btn-sm mt-2">로그인하기</a>
				</c:if>

			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/view/common/footer.jsp" />

	<script>
	document.addEventListener('DOMContentLoaded', function () {
		const likeButton = document.querySelector('.like-icon');
		if (likeButton) {
			likeButton.addEventListener('click', function () {
				// 어드민은 차단
				if ("<%=session.getAttribute("sessionClass")%>" === "A") {
					alert("관리자는 좋아요 기능을 사용할 수 없습니다.");
					return;
				}
				if ("<%=session.getAttribute("sessionId") == null ? "" : session.getAttribute("sessionId")%>" === "") {
					alert("로그인 후 이용 가능합니다.");
					return;
				}

				fetch('BoardLikeAction.do', {
					method: 'POST',
					headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
					body: 'post_num=' + '<%=board.getPost_num()%>'
				})
				.then(response => response.json())
				.then(data => {
					document.querySelector('.count').textContent = data.likeCount;
					likeButton.classList.toggle('liked', data.userLiked);
					likeButton.classList.toggle('unliked', !data.userLiked);
				})
				.catch(error => console.error('Error:', error));
			});
		}
	});

window.onload = function () {
	if (window.kakao && kakao.maps && kakao.maps.load) {
		kakao.maps.load(function () {
			const lat = parseFloat("${board.lat}");
			const lng = parseFloat("${board.lng}");
			const container = document.getElementById('map');
			if (!container || isNaN(lat) || isNaN(lng)) return;
			const mapOption = {
				center: new kakao.maps.LatLng(lat, lng),
				level: 3
			};
			const map = new kakao.maps.Map(container, mapOption);
			const marker = new kakao.maps.Marker({
				position: new kakao.maps.LatLng(lat, lng),
				map: map
			});
		});
	}
};
function handleReservation(postNum) {
	const sessionId = "<%=session.getAttribute("sessionId")%>";
	if (!sessionId || sessionId === "null") {
		alert("로그인 후 예약을 해주세요.");
		window.location.href = "<%=request.getContextPath()%>/login/login_home.do";
		return;
	}
	window.location.href = "ReservationViewAction.do?post_num=" + postNum;
}
</script>

</body>
</html>
