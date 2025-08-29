<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
	<title>회원정보 수정</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
	<c:set var="addressParts" value="${fn:split(user.address, '/')}"/>
	<c:set var="phone" value="${fn:split(user.phone,'-')}" />
	<c:set var="phone1" value="${phone[0]}" />
	<c:set var="phone2" value="${phone[1]}" />
	<c:set var="phone3" value="${phone[2]}" />
	<c:set var="zipcode" value="${addressParts[0]}"/>
	<c:set var="addr1" value="${addressParts[1]}"/>
	<c:set var="addr2" value="${addressParts[2]}"/>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
	    function sample6_execDaumPostcode() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
	                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	                var addr = ''; // 주소 변수
	                var extraAddr = ''; // 참고항목 변수
	
	                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                    addr = data.roadAddress;
	                } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                    addr = data.jibunAddress;
	                }
	
	                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	                if(data.userSelectedType === 'R'){
	                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                        extraAddr += data.bname;
	                    }
	                    // 건물명이 있고, 공동주택일 경우 추가한다.
	                    if(data.buildingName !== '' && data.apartment === 'Y'){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                    if(extraAddr !== ''){
	                        extraAddr = ' (' + extraAddr + ')';
	                    }
	                    // 조합된 참고항목을 해당 필드에 넣는다.
	                    document.getElementById("sample6_extraAddress").value = extraAddr;
	                
	                } else {
	                    document.getElementById("sample6_extraAddress").value = '';
	                }
	
	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('sample6_postcode').value = data.zonecode;
	                document.getElementById("sample6_address").value = addr;
	                // 커서를 상세주소 필드로 이동한다.
	                document.getElementById("sample6_detailAddress").focus();
	            }
	        }).open();
	    }
	</script>
</head>
<body>
<%@ include file="/WEB-INF/view/common/header.jsp" %>

<div class="container mt-5 d-flex justify-content-center align-items-center" style="min-height: 80vh;">
  <form id="updateForm" action="<c:url value='/login/updateProcess.do' />" method="post" class="w-100" style="max-width: 500px;">
    <h2 class="mb-4 text-center">회원정보 수정</h2>
    <input type="hidden" name="user_id" value="${user.userId}" />

    <!-- 전화번호 입력 -->
	<div class="mb-3">
		<label class="form-label">전화번호</label>
		<div class="input-group">
			<select class="form-select" name="phone_prefix" style="max-width: 100px;">
				<option value="010" <c:if test="${phone1 == '010'}">selected</c:if>>010</option>
				<option value="02"  <c:if test="${phone1 == '02'}">selected</c:if>>02</option>
				<option value="011" <c:if test="${phone1 == '011'}">selected</c:if>>011</option>
				<option value="016" <c:if test="${phone1 == '016'}">selected</c:if>>016</option>
				<option value="017" <c:if test="${phone1 == '017'}">selected</c:if>>017</option>
				<option value="018" <c:if test="${phone1 == '018'}">selected</c:if>>018</option>
				<option value="019" <c:if test="${phone1 == '019'}">selected</c:if>>019</option>
			</select>
			<input type="text" class="form-control" id="phone_mid" maxlength="4" value="${phone2}" required>
			<input type="text" class="form-control" id="phone_last" maxlength="4" value="${phone3}" required>
		</div>
	</div>

    <div class="mb-3">
      <label for="postcode" class="form-label">주소</label>
      <div class="input-group mb-2">
        <input type="text" class="form-control" id="sample6_postcode" name="postcode" placeholder="우편번호" value="${zipcode}" readonly>
        <button type="button" class="btn btn-outline-secondary" onclick="sample6_execDaumPostcode()">우편번호 찾기</button>
      </div>
      <input type="text" class="form-control mb-2" id="sample6_address" name="address" placeholder="주소" value="${addr1}" readonly>
      <input type="text" class="form-control mb-2" id="sample6_detailAddress" name="detailAddress" placeholder="상세주소" value="${addr2}">
      <input type="text" class="form-control" id="sample6_extraAddress" name="extraAddress" placeholder="참고항목" readonly hidden="true">
    </div>

    <div class="mb-3">
      <label class="form-label">성별</label><br />
      <input type="radio" name="gender" value="M" <c:if test="${user.gender == 'M'}">checked</c:if> /> 남성
      <input type="radio" name="gender" value="F" <c:if test="${user.gender == 'F'}">checked</c:if> /> 여성
      <input type="radio" name="gender" value="O" <c:if test="${user.gender == 'O'}">checked</c:if> /> 기타
    </div>

    <div class="mb-3">
      <label class="form-label">생년월일</label>
      <input type="date" class="form-control" name="birthdate" value="${user.birthdate}" />
    </div>

    <div class="text-center">
      <button type="submit" class="btn btn-primary">수정 완료</button>
    </div>
  </form>
</div>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
<script>
	function filterPhoneInput(input) {
		input.value = input.value.replace(/[^0-9]/g, '');
	}
	
	document.getElementById("phone_mid").addEventListener("input", function() {
		filterPhoneInput(this);
	});
	document.getElementById("phone_last").addEventListener("input", function() {
		filterPhoneInput(this);
	});
	
	// 폼 제출 시 전체 전화번호 합치기
	document.getElementById("updateForm").addEventListener("submit", function (event) {
		const prefix = document.querySelector("[name='phone_prefix']").value;
		const mid = document.getElementById("phone_mid").value;
		const last = document.getElementById("phone_last").value;
	
		// 유효성 체크
		if (mid.length < 3 || last.length < 4) {
			alert("전화번호를 정확히 입력해주세요.");
			event.preventDefault();
			return;
		}
	
		// 숨겨진 필드로 전체 전화번호 결합해서 전송
		const fullPhone = prefix + "-" + mid + "-" + last;
	
		// 전송 전에 숨겨진 input에 추가
		let hiddenInput = document.querySelector("input[name='phone']");
		if (!hiddenInput) {
			hiddenInput = document.createElement("input");
			hiddenInput.type = "hidden";
			hiddenInput.name = "phone";
			this.appendChild(hiddenInput);
		}
		hiddenInput.value = fullPhone;
	});
</script>
</body>
</html>
