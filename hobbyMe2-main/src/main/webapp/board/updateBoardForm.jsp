<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="mvc.model.BoardDTO"%>
<%
String sessionId = (String) session.getAttribute("sessionId");
BoardDTO board = (BoardDTO) request.getAttribute("board");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/style.css">

<!-- Kakao 지도 SDK -->
<script
	src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=bc9e965cfe37a104a3df25b79345fc17&libraries=services&autoload=false"></script>

<style>
.form-wrapper {
	background-color: #fff;
	border-radius: 16px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	padding: 40px;
}
</style>
</head>
<body>
	<div class="container py-4">
		<jsp:include page="/WEB-INF/view/common/header.jsp" />

		<div class="form-wrapper">
			<h1 class="text-center">🛠 게시글 수정</h1>
			<form name="updateForm" action="BoardUpdateAction.do" method="post"
				enctype="multipart/form-data">

				<input type="hidden" name="post_num" value="${board.post_num}">
				<input type="hidden" name="lat" id="lat" value="${board.lat}">
				<input type="hidden" name="lng" id="lng" value="${board.lng}">

				<input type="hidden" name="user_id" value="${sessionId}">

				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">제목</label>
					<div class="col-sm-8">
						<input name="title" type="text" class="form-control"
							value="${board.title}" required>
					</div>
				</div>

				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">내용</label>
					<div class="col-sm-10">
						<textarea name="content" class="form-control" rows="5" required>${board.content}</textarea>
					</div>
				</div>

				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">카테고리</label>
					<div class="col-sm-4">
						<select name="category" class="form-select">
							<option value="">선택하세요</option>
							<c:forEach var="cat" items="${categories}">
								<option value="${cat}"
									${cat == board.category ? 'selected' : ''}>${cat}</option>
							</c:forEach>
						</select>
					</div>
				</div>

				<div class="mb-2 row">
					<label class="col-sm-2 col-form-label">태그 목록</label>
					<div class="col-sm-10">
						<div id="tagList" class="d-flex flex-wrap gap-2"></div>
						<input type="hidden" name="tag" id="tagHidden">
					</div>
				</div>

				<!-- ✅ 태그 입력 필드 (이전 name="tag" → id="tagInput") -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">태그</label>
					<div class="col-sm-10">
						<input id="tagInput" type="text" class="form-control"
							placeholder="엔터로 태그 추가">
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">예약일</label>
					<div class="col-sm-4">
						<input type="date" name="reservation_date" class="form-control"
							value="${board.reservation_date}">
					</div>
				</div>

				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">모임종료일</label>
					<div class="col-sm-4">
						<input type="date" name="end_date" class="form-control"
							value="${board.end_date}">
					</div>
				</div>
				<!-- 위치 -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">상세 주소</label>
					<div class="col-sm-10">
						<!-- 주소 결과 출력 -->
						<input name="location" id="location" class="form-control mb-2"
							value="${board.location}" readonly> <input type="hidden"
							name="lat" id="lat" value="${board.lat}"> <input
							type="hidden" name="lng" id="lng" value="${board.lng}">

						<!-- 주소 검색 입력 + 버튼 -->
						<div class="input-group mb-2">
							<span class="input-group-text">주소 검색</span> <input type="text"
								id="addressSearch" class="form-control"
								placeholder="주소 검색 (예: 서울 강남구)">
							<button type="button" id="addressBtn"
								class="btn btn-outline-secondary">검색</button>
						</div>

						<!-- 지도 표시 영역 -->
						<div id="map"
							style="width: 100%; height: 300px; border-radius: 8px;"></div>
					</div>
				</div>



				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">인원</label>
					<div class="col-sm-2">
						<div class="input-group">
							<input name="people" type="number" class="form-control"
								value="${board.people}"> <span class="input-group-text">명</span>
						</div>
					</div>
				</div>

				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">가격</label>
					<div class="col-sm-2">
						<div class="input-group">
							<input name="price" type="number" class="form-control"
								value="${board.price}"> <span class="input-group-text">원</span>
						</div>
					</div>
				</div>

				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">썸네일</label>
					<div class="col-sm-10">
						<c:if test="${not empty board.thumbnail}">
							<p>현재 썸네일:</p>
							<img
								src="${pageContext.request.contextPath}/uploads/${board.thumbnail}"
								alt="썸네일" class="img-thumbnail mb-2" style="max-height: 150px;">
							<div class="form-check mt-1">
								<input class="form-check-input" type="checkbox"
									name="deleteThumbnail" id="deleteThumbnail"> <label
									class="form-check-label text-danger" for="deleteThumbnail">
									썸네일 삭제 </label>
							</div>
						</c:if>

						<input name="thumbnailFile" type="file" class="form-control">
						<input type="hidden" name="thumbnail" value="${board.thumbnail}">
					</div>
				</div>

				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">이미지</label>
					<div class="col-sm-10">
						<c:if test="${not empty board.images}">
							<p>현재 이미지들:</p>
							<div class="d-flex flex-wrap gap-2 mb-2">
								<c:forTokens var="img" items="${board.images}" delims=",">
									<div class="position-relative">
										<img src="${pageContext.request.contextPath}/uploads/${img}"
											class="img-thumbnail" style="max-height: 150px;">
										<div class="form-check text-center mt-1">
											<input class="form-check-input" type="checkbox"
												name="deleteImages" value="${img}" id="delete_${img}">
											<label class="form-check-label text-danger"
												for="delete_${img}" style="font-size: 0.85rem;"> 삭제
											</label>
										</div>
									</div>
								</c:forTokens>
							</div>
						</c:if>

						<input name="imageFile" type="file" class="form-control" multiple>
						<input type="hidden" name="images" value="${board.images}">
					</div>
				</div>

				<div class="mb-3 row text-center">
					<div class="col">
						<input type="submit" class="btn btn-success me-2" value="수정 완료">
						<input type="button" class="btn btn-secondary" value="취소"
							onclick="window.history.back();">
					</div>
				</div>
			</form>
		</div>
		<jsp:include page="/WEB-INF/view/common/footer.jsp" />
	</div>

	<script>
	// 초기 태그값 반영
	window.addEventListener("DOMContentLoaded", function () {
		const rawTag = `${board.tag}`; // EL을 통해 서버에서 전달된 태그 문자열
		if (rawTag) {
			// "#등산,#막걸리" → ["등산", "막걸리"]
			tagList = rawTag.split(",")
				.map(tag => tag.trim().replace(/^#/, "")) // 앞의 # 제거
				.filter(tag => tag.length > 0);
			updateTagDisplay();
		}
	});	
	let tagList = [];

	document.getElementById("tagInput").addEventListener("keydown", function(e) {
		if (e.key === "Enter") {
			e.preventDefault();

			let input = this.value.trim();
			if (!input) return;

			// 중복 / 5개 제한
			if (tagList.includes(input)) {
				alert("이미 추가된 태그입니다.");
				this.value = "";
				return;
			}
			if (tagList.length >= 5) {
				alert("최대 5개까지 태그를 입력할 수 있습니다.");
				return;
			}

			tagList.push(input);
			updateTagDisplay();
			this.value = "";
		}
	});

	function updateTagDisplay() {
		const tagListContainer = document.getElementById("tagList");
		const hiddenInput = document.getElementById("tagHidden");

		tagListContainer.innerHTML = "";

		tagList.forEach(tag => {
			const tagEl = document.createElement("span");
			tagEl.className = "badge bg-primary";
			tagEl.style.cursor = "pointer";
			tagEl.textContent = "#" + tag;
			tagEl.onclick = () => {
				tagList = tagList.filter(t => t !== tag);
				updateTagDisplay();
			};
			tagListContainer.appendChild(tagEl);
		});

		// CSV 저장
		hiddenInput.value = tagList.join(",");
	}
		kakao.maps
				.load(function() {
					const container = document.getElementById('map');
					const lat = parseFloat("${board.lat}");
					const lng = parseFloat("${board.lng}");

					const mapOption = {
						center : new kakao.maps.LatLng(lat, lng),
						level : 3
					};

					const map = new kakao.maps.Map(container, mapOption);
					const geocoder = new kakao.maps.services.Geocoder();
					const marker = new kakao.maps.Marker({
						map : map
					});

					const coords = new kakao.maps.LatLng(lat, lng);
					marker.setPosition(coords);
					map.setCenter(coords);

					kakao.maps.event
							.addListener(
									map,
									'click',
									function(mouseEvent) {
										const latlng = mouseEvent.latLng;
										geocoder
												.coord2Address(
														latlng.getLng(),
														latlng.getLat(),
														function(result, status) {
															if (status === kakao.maps.services.Status.OK) {
																const address = result[0].address.address_name;
																document
																		.getElementById("location").value = address;
																document
																		.getElementById("lat").value = latlng
																		.getLat();
																document
																		.getElementById("lng").value = latlng
																		.getLng();
																marker
																		.setPosition(latlng);
															}
														});
									});
				});
	</script>
</body>
</html>
