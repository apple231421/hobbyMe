<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String sessionId = (String) session.getAttribute("sessionId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/style.css">

<!-- ✅ Kakao Maps SDK -->
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

<script>
	function checkForm() {
		const form = document.newWrite;

		if (!form.title.value.trim()) {
			alert("제목을 입력하세요.");
			form.title.focus();
			return false;
		}
		if (!form.content.value.trim()) {
			alert("내용을 입력하세요.");
			form.content.focus();
			return false;
		}
		if (!form.category.value.trim()) {
			alert("카테고리를 선택하세요.");
			form.category.focus();
			return false;
		}
		if (!form.tag.value.trim()) {
			alert("태그를 입력하세요.");
			form.tag.focus();
			return false;
		}
		if (!form.reservation_date.value) {
			alert("예약일을 선택하세요.");
			form.reservation_date.focus();
			return false;
		}
		if (!form.end_date.value) {
			alert("모임 종료일을 선택하세요.");
			form.end_date.focus();
			return false;
		}

		const reservation = new Date(form.reservation_date.value);
		const end = new Date(form.end_date.value);
		if (end < reservation) {
			alert("모임 종료일은 예약일보다 이후여야 합니다.");
			form.end_date.focus();
			return false;
		}

		if (!form.location.value.trim()) {
			alert("위치를 선택하거나 주소를 검색하세요.");
			form.location.focus();
			return false;
		}
		if (!form.people.value || form.people.value <= 0) {
			alert("인원을 입력하세요.");
			form.people.focus();
			return false;
		}


		if (!form.price.value || form.price.value <= 0) {
			alert("가격을 입력하세요.");
			form.price.focus();
			return false;
		}

		// ✅ 썸네일 미등록 시 2단계 확인
		if (!form.thumbnailFile.value) {
			alert("썸네일을 등록하지 않았습니다.\n기본 이미지가 자동으로 사용됩니다.");
			const confirmDefault = confirm("정말 썸네일 없이 등록하시겠습니까?");
			if (!confirmDefault) {
				form.thumbnailFile.focus();
				return false;
			}
		}

		return true;
	}

	kakao.maps.load(function() {
		const mapContainer = document.getElementById('map');
		const mapOption = {
			center : new kakao.maps.LatLng(37.5665, 126.9780),
			level : 3
		};
		const map = new kakao.maps.Map(mapContainer, mapOption);
		const geocoder = new kakao.maps.services.Geocoder();
		const marker = new kakao.maps.Marker({
			map : map
		});

		document.getElementById("addressSearch").addEventListener("keypress",
				function(e) {
					if (e.key === 'Enter') {
						e.preventDefault();
						searchAddress(this.value);
					}
				});

		document.getElementById("addressBtn")
				.addEventListener(
						"click",
						function() {
							searchAddress(document
									.getElementById("addressSearch").value);
						});

		function searchAddress(address) {
			geocoder.addressSearch(address, function(result, status) {
				if (status === kakao.maps.services.Status.OK) {
					const coords = new kakao.maps.LatLng(result[0].y,
							result[0].x);
					map.setCenter(coords);
					marker.setPosition(coords);
					setLocation(result[0].address.address_name, result[0].y,
							result[0].x);
				} else {
					alert("주소를 찾을 수 없습니다.");
				}
			});
		}

		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
			const latlng = mouseEvent.latLng;
			geocoder.coord2Address(latlng.getLng(), latlng.getLat(), function(
					result, status) {
				if (status === kakao.maps.services.Status.OK) {
					const address = result[0].address.address_name;
					marker.setPosition(latlng);
					setLocation(address, latlng.getLat(), latlng.getLng());
				}
			});
		});

		function setLocation(address, lat, lng) {
			document.getElementById("location").value = address;
			document.getElementById("lat").value = lat;
			document.getElementById("lng").value = lng;
		}
	});
</script>

</head>

<body>
	<div class="container py-4">
		<jsp:include page="/WEB-INF/view/common/header.jsp" />
		<div class="form-wrapper">
			<h1 class="text-center">📌 게시글 작성</h1>
			<form name="newWrite" action="BoardWriteAction.do" method="post"
				enctype="multipart/form-data" onsubmit="return checkForm()">

				<!-- 제목 -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">제목</label>
					<div class="col-sm-10">
						<input name="title" type="text" class="form-control"
							placeholder="제목을 입력하세요">
					</div>
				</div>

				<!-- 내용 -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">내용</label>
					<div class="col-sm-10">
						<textarea name="content" class="form-control" rows="5"
							placeholder="내용을 입력하세요"></textarea>
					</div>
				</div>

				<!-- 카테고리 -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">카테고리</label>
					<div class="col-sm-4">
						<select name="category" class="form-select">
							<option value="">선택하세요</option>
							<c:forEach var="c" items="${categories}">
								<option value="${c}">${c}</option>
							</c:forEach>
						</select>
					</div>
				</div>

				<!-- 태그 -->
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

				<!-- 예약일, 종료일 -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">예약일</label>
					<div class="col-sm-4">
						<input type="date" name="reservation_date" class="form-control">
					</div>
					<label class="col-sm-2 col-form-label">모임종료일</label>
					<div class="col-sm-4">
						<input type="date" name="end_date" class="form-control">
					</div>
				</div>

				<!-- 주소 검색 입력 -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">주소 검색</label>
					<div class="col-sm-10">
						<div class="input-group">
							<input type="text" id="addressSearch" class="form-control"
								placeholder="주소 검색 (예: 서울 강남구)">
							<button type="button" id="addressBtn"
								class="btn btn-outline-secondary">검색</button>
						</div>
					</div>
				</div>
				<!-- 지도 영역 -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label"></label>
					<div class="col-sm-10">
						<div id="map"
							style="width: 100%; height: 300px; border-radius: 8px;"></div>
					</div>
				</div>

				<!-- 상세 주소 (선택된 주소 표시) -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">상세 주소</label>
					<div class="col-sm-10">
						<input name="location" id="location" class="form-control"
							placeholder="선택된 주소"> <input type="hidden" name="lat"
							id="lat"> <input type="hidden" name="lng" id="lng">
					</div>
				</div>
	
				<!-- 인원 -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">인원</label>
					<div class="col-sm-2">
						<div class="input-group">
							<input name="people" type="number" class="form-control" min="1">
							<span class="input-group-text">명</span>
						</div>
					</div>
				</div>

				<!-- 가격 -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">가격</label>
					<div class="col-sm-2">
						<div class="input-group">
							<input name="price" type="number" class="form-control" min="0">
							<span class="input-group-text">원</span>
						</div>
					</div>
				</div>



				<!-- 썸네일, 이미지 -->
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">썸네일</label>
					<div class="col-sm-10">
						<input name="thumbnailFile" type="file" class="form-control">
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">이미지</label>
					<div class="col-sm-10">
						<input name="imageFile" type="file" class="form-control" multiple>
					</div>
				</div>

				<!-- 버튼 -->
				<div class="text-center mt-4">
					<input type="submit" class="btn btn-success me-2" value="등록">
					<input type="button" class="btn btn-secondary" value="취소"
						onclick="window.history.back();">
				</div>
			</form>
		</div>
		<jsp:include page="/WEB-INF/view/common/footer.jsp" />
	</div>
</body>
<script>
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
</script>
</html>
