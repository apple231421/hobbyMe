<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="mvc.model.BoardDTO"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.time.temporal.ChronoUnit"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
String sessionId = (String) session.getAttribute("sessionId");
List<BoardDTO> boardList = (List<BoardDTO>) request.getAttribute("boardlist");
int total_record = (int) request.getAttribute("total_record");
int pageNum = (int) request.getAttribute("pageNum");
int total_page = (int) request.getAttribute("total_page");
String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
pageContext.setAttribute("today", today);
String classes = (String) session.getAttribute("classes");
%>

<c:set var="sessionId" value="${sessionScope.sessionId}" />
<c:set var="pageNum" value="<%=pageNum%>" />
<c:set var="totalPage" value="<%=total_page%>" />
<c:set var="classes" value="${sessionScope.sessionClass}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>Board</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<link href="./css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/style.css">


<style>
body {
	background-color: #f8f9fa;
	font-family: 'Segoe UI', sans-serif;
}

.hero-section {
	background: linear-gradient(rgba(255, 255, 255, 0.85),
		rgba(255, 255, 255, 0.85)), url('./images/board_header.jpg') center/cover
		no-repeat;
	border-radius: 16px;
}

.hero-section h1 {
	font-weight: 700;
}

.card {
	border-radius: 12px;
	transition: transform 0.2s ease, box-shadow 0.2s ease;
	border: none;
}

.card:hover {
	transform: translateY(-4px);
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

.card-title {
	font-size: 1.1rem;
	font-weight: bold;
	color: #343a40;
}

.card-text {
	color: #6c757d;
}

.fw-bold.text-dark {
	font-size: 1rem;
	color: #e83e8c !important;
}

.badge.text-bg-success {
	font-size: 0.95rem;
	padding: 0.5em 0.75em;
}

.pagination span, .pagination strong {
	margin: 0 4px;
	font-size: 1rem;
	color: #4C5317;
}

.form-select, .form-control {
	min-width: 120px;
}

.btn-primary {
	background-color: #000000;
	border-color: #000000;
}

.btn-primary:hover {
	background-color: #bb2d74;
	border-color: #bb2d74;
}

.btn-secondary {
	background-color: #6c757d;
	border-color: #6c757d;
}

.btn-secondary:hover {
	background-color: #5c636a;
	border-color: #5c636a;
}

.like-icon {
	font-size: 18px;
	cursor: pointer;
	transition: transform 0.2s ease, color 0.3s ease;
	user-select: none;
}

.like-icon:hover {
	transform: scale(1.2);
}

.liked {
	color: #ff5e78;
}

.unliked {
	color: #ccc;
}

.count {
	margin-left: 5px;
	font-weight: bold;
	font-size: 0.9rem;
	color: #555;
}

.card-img-top {
	width: 100%;
	height: 200px; /* 원하는 고정 높이 */
	object-fit: cover;
	border-top-left-radius: 12px;
	border-top-right-radius: 12px;
}

.text-badge.dark {
	background-color: #343a40;
	color: white;
	padding: 0.3em 0.6em;
	border-radius: 0.6rem;
	font-size: 0.75rem;
	display: inline-block;
}

.text-badge.light {
	background-color: #f1f3f5;
	color: #333;
	padding: 0.3em 0.6em;
	border: 1px solid #ced4da;
	border-radius: 0.6rem;
	font-size: 0.75rem;
	display: inline-block;
}

.card {
	border-radius: 16px;
	overflow: hidden;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
	transition: all 0.25s ease;
	display: flex;
	flex-direction: column;
	border: none;
	background-color: #ffffff;
}

.card:hover {
	transform: translateY(-6px);
	box-shadow: 0 10px 24px rgba(0, 0, 0, 0.1);
}

/* 카드 제목 */
.card-title {
	font-size: 1.05rem;
	font-weight: 600;
	color: #212529;
	margin-bottom: 0.4rem;
}

/* 썸네일 이미지 */
.card-img-top {
	width: 100%;
	height: 200px;
	object-fit: cover;
	border-top-left-radius: 16px;
	border-top-right-radius: 16px;
}

/* 가격 텍스트 */
.fw-bold.text-dark {
	font-size: 1.1rem;
	color: #d63384 !important;
	font-weight: 600;
	margin-top: 0.4rem;
}

/* 태그 뱃지 */
.badge.bg-info.text-dark {
	background-color: #e0f7ff !important;
	color: #007b8a !important;
	font-weight: 500;
	border-radius: 0.5rem;
	font-size: 0.75rem;
	padding: 0.3em 0.6em;
}

/* 마감일 */
.text-muted.mb-1 {
	font-size: 0.85rem;
	line-height: 1.4;
}

/* 카테고리 뱃지 */
a.badge.bg-info.text-dark {
	font-size: 0.75rem;
	padding: 0.3em 0.6em;
	border-radius: 0.5rem;
	font-weight: 500;
}

/* 모집 인원 뱃지 */
.badge.bg-light.text-dark.border {
	background-color: #f8f9fa;
	border: 1px solid #ced4da;
	color: #495057;
	font-size: 0.75rem;
	padding: 0.3em 0.6em;
	border-radius: 0.5rem;
}

/* 하단 정보 */
.card-body .small {
	font-size: 0.8rem;
	color: #666;
}

/* 좋아요 및 댓글 */
.like-area .count, .comment-area span {
	font-size: 0.85rem;
	font-weight: 500;
	color: #495057;
}

.like-area span:first-child {
	font-size: 20px;
	margin-right: 4px;
}

.comment-area i {
	font-size: 18px;
	color: #6c757d;
	margin-right: 4px;
}

.badge.bg-danger, .badge.bg-secondary, .badge.bg-dark {
	font-size: 0.75rem;
	padding: 0.35em 0.6em;
	border-radius: 0.5rem;
}
</style>


<script type="text/javascript">
	function checkForm() {
		window.location.href = "./BoardWriteForm.do";
	}

	function handleWriteButton() {
		const userClass = "<c:out value='${classes}'/>";
		console.log("userClass:", userClass); // 이 줄 추가
		if (userClass !== 'H') {
			alert('등급업을 신청하세요.');
			return;
		}
		checkForm(); // 등급이 'H'인 경우에만 글쓰기 페이지 이동
	}
</script>


</head>
<jsp:include page="/WEB-INF/view/common/header.jsp" />
<body>
	<div class="container py-4">


		<!-- Hero -->
		<div class="p-5 mb-4 hero-section shadow-sm">
			<div class="container-fluid py-5">
				<h1 class="display-5">📋 게시판</h1>
				<p class="col-md-8 fs-5">Board</p>
			</div>
		</div>

		<!-- Top bar -->
		<div class="d-flex justify-content-end align-items-center mb-3 gap-3">
			<span class="badge text-bg-success">전체 ${total_record}건</span>
			<form action="BoardListAction.do" method="get"
				class="d-flex align-items-center">
				<input type="hidden" name="items" value="${param.items}"> <input
					type="hidden" name="text" value="${param.text}"> <select
					name="sort" class="form-select form-select-sm w-auto"
					onchange="this.form.submit()">
					<c:set var="currentSort" value="${param.sort}" />

					<option value="recent"
						<c:if test="${currentSort == 'recent'}">selected</c:if>>최신순</option>
					<option value="oldest"
						<c:if test="${currentSort == 'oldest'}">selected</c:if>>오래된순</option>
					<option value="like_desc"
						<c:if test="${currentSort == 'like_desc'}">selected</c:if>>좋아요
						많은순</option>
					<option value="like_asc"
						<c:if test="${currentSort == 'like_asc'}">selected</c:if>>좋아요
						적은순</option>
					<option value="comment_desc"
						<c:if test="${currentSort == 'comment_desc'}">selected</c:if>>댓글
						많은순</option>
					<option value="comment_asc"
						<c:if test="${currentSort == 'comment_asc'}">selected</c:if>>댓글
						적은순</option>
				</select>

			</form>
		</div>

		<!-- 게시글 카드 리스트 -->
		<c:choose>
			<c:when test="${empty boardlist}">
				<div class="text-center text-muted my-5 py-5"
					style="border: 2px dashed #dee2e6; border-radius: 12px;">
					<div style="font-size: 3rem;">📭</div>
					<p class="mt-3 mb-1" style="font-size: 1.25rem;">
						<c:choose>
							<c:when test="${not empty param.text}">
						"<strong>${param.text}</strong>"에 대한 검색 결과가 없습니다.
					</c:when>
							<c:otherwise>
						게시글이 없습니다.
					</c:otherwise>
						</c:choose>
					</p>
				</div>
			</c:when>

			<c:otherwise>
				<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4 mb-4">
					<c:forEach var="notice" items="${boardlist}">
						<div class="col">
							<div class="card h-100 shadow-sm">
								<a
									href="BoardViewAction.do?post_num=${notice.post_num}&pageNum=${pageNum}">
									<c:choose>
										<c:when test="${not empty notice.thumbnail}">
											<img
												src="${pageContext.request.contextPath}/uploads/${notice.thumbnail}"
												class="card-img-top" alt="대표 이미지">
										</c:when>
										<c:otherwise>
											<img src="./images/default_thumb.jpg" class="card-img-top"
												alt="기본 썸네일">
										</c:otherwise>
									</c:choose>
								</a>
								<div class="card-body d-flex flex-column">
									<h5 class="card-title">
										<c:choose>
											<c:when test="${fn:length(notice.title) > 16}">
			${fn:substring(notice.title, 0, 16)}...
		</c:when>
											<c:otherwise>
			${notice.title}
		</c:otherwise>
										</c:choose>
									</h5>


									<c:if test="${not empty notice.tag}">
										<div class="mb-2 d-flex flex-wrap gap-2">
											<c:forEach var="tag" items="${fn:split(notice.tag, ',')}">
												<a
													href="BoardListAction.do?items=tag&text=${fn:replace(fn:trim(tag), '#', '')}"
													class="badge bg-info text-dark text-decoration-none me-1">
													${fn:trim(tag)} </a>
											</c:forEach>
										</div>
									</c:if>

									<p class="fw-bold text-dark mt-1">${notice.price}원</p>
									<p class="text-muted mb-1" style="font-size: 0.9rem;">
										마감일: ${notice.end_date}
										<c:choose>
											<c:when test="${notice.expired eq 'Y'}">
												<span class="badge bg-secondary ms-2">마감됨</span>
											</c:when>
											<c:when test="${notice.dday == 0}">
												<span class="badge bg-danger ms-2">D-day</span>
											</c:when>
											<c:otherwise>
												<span class="badge bg-warning ms-2">D-${notice.dday}</span>
											</c:otherwise>
										</c:choose>
										<c:if test="${notice.deleted eq 'Y'}">
											<span class="badge bg-dark ms-2">삭제됨</span>
										</c:if>

									</p>
									<div
										class="d-flex justify-content-between align-items-center mb-1"
										style="font-size: 0.9rem;">
										<!-- 왼쪽: 모집 인원 -->
										<div>
											<strong>모집 인원:</strong>
											<c:choose>
												<c:when test="${notice.reserved >= notice.people}">
													<span class="badge bg-dark ms-2">모집 완료</span>
												</c:when>
												<c:otherwise>
													<span class="badge bg-light text-dark border ms-2"
														style="font-size: 0.75rem; padding: 0.4em 0.6em; border-radius: 0.6rem;">
														${notice.reserved} / ${notice.people} </span>
												</c:otherwise>
											</c:choose>
										</div>

										<!-- 오른쪽: 카테고리 -->
										<c:if test="${not empty notice.category}">
											<div class="d-flex align-items-center gap-1">
												<span style="font-size: 0.9rem;" class="text-muted">카테고리:</span>
												<a
													href="BoardListAction.do?items=category&text=${fn:trim(notice.category)}"
													class="badge bg-info text-dark text-decoration-none">
													${notice.category} </a>
											</div>
										</c:if>



									</div>



									<div class="mt-auto">
										<div
											class="d-flex justify-content-between text-muted small mb-2">
											<span><i class="fa fa-user me-1"></i>${notice.user_id}</span>
											<span>${notice.created_date}</span>
										</div>
										<div
											class="d-flex justify-content-between align-items-center mt-2">
											<div class="like-area d-flex align-items-center">
												<span style="font-size: 22px; color: #ff5e78;">💖</span> <span
													class="count ms-2">${notice.board_like}</span>
											</div>
											<div class="comment-area d-flex align-items-center">
												<i class="fa-regular fa-comment-dots me-1 text-secondary"></i>
												<span class="text-muted small">${notice.comment_count}개</span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:otherwise>
		</c:choose>


		<!-- 페이지네이션 -->
		<div class="py-3 text-center">
			<c:forEach var="i" begin="1" end="${totalPage}">
				<a href="<c:url value='./BoardListAction.do?pageNum=${i}'/>"> <c:choose>
						<c:when test="${pageNum == i}">
							<strong style="color: #4C5317;">[${i}]</strong>
						</c:when>
						<c:otherwise>
							<span style="color: #4C5317;">[${i}]</span>
						</c:otherwise>
					</c:choose>
				</a>
			</c:forEach>
		</div>

		<!-- 글쓰기 버튼 -->
		<!-- 글쓰기 버튼 -->
		<div class="py-3 text-end">
			<c:choose>
				<c:when test="${not empty sessionId}">
					<a href="javascript:void(0);" onclick="handleWriteButton();"
						class="btn btn-primary">글쓰기</a>
				</c:when>
				<c:otherwise>
					<a href="${pageContext.request.contextPath}/login/login_home.do"
						class="btn btn-secondary">로그인 후 글쓰기</a>
				</c:otherwise>
			</c:choose>
		</div>

		<!-- 검색 폼 -->
		<div class="text-start py-2">
			<form action="<c:url value='./BoardListAction.do'/>" method="post"
				class="d-flex gap-2 flex-wrap">
				<select name="items" class="form-select w-auto">
					<option value="title" ${param.items == 'title' ? 'selected' : ''}>제목에서</option>
					<option value="content"
						${param.items == 'content' ? 'selected' : ''}>본문에서</option>
					<option value="user_id"
						${param.items == 'user_id' ? 'selected' : ''}>글쓴이에서</option>
					<option value="tag" ${param.items == 'tag' ? 'selected' : ''}>태그에서</option>
					<option value="category"
						${param.items == 'category' ? 'selected' : ''}>카테고리에서</option>
				</select> <input name="text" type="text" class="form-control w-auto"
					value="${param.text}" /> <input type="submit"
					class="btn btn-primary" value="검색" />
			</form>
		</div>


	</div>
</body>
<jsp:include page="/WEB-INF/view/common/footer.jsp" />
</html>