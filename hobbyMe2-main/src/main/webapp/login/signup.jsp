<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<title>회원가입</title>
	<style>
		.form-control {
			max-width: 300px;
		}
	</style>
</head>
<body>
<%@ include file="/WEB-INF/view/common/header.jsp" %>

<div class="container mt-5 text-center">
	<h2 class="mb-4">회원가입</h2>

	<div class="d-flex justify-content-center">
		<form id="signupForm" action="<c:url value='/login/signupProcess.do'/>" method="post" class="text-start" style="width: 320px;">
			<div class="mb-3">
				<label for="user_id" class="form-label">아이디</label>
				<div class="input-group">
					<input type="text" class="form-control" id="user_id" name="user_id" required>
					<button type="button" class="btn btn-outline-secondary" onclick="checkUserId()">중복확인</button>
				</div>
				<div id="id-check-msg" class="form-text text-danger"></div>
			</div>

			<div class="mb-3">
				<label for="password" class="form-label">비밀번호</label>
				<input type="password" class="form-control" name="password" id="password" required>
			</div>
			<div class="mb-3">
				<label for="confirm_password" class="form-label">비밀번호 확인</label>
				<input type="password" class="form-control" id="confirm_password" name="confirm_password" required>
				<div class="form-text text-danger d-none" id="mismatchWarning">
					비밀번호가 일치하지 않습니다.
				</div>
			</div>
			<div class="mb-3">
				<label for="name" class="form-label">이름</label>
				<input type="text" class="form-control" name="name" required>
			</div>
			<div class="mb-3">
				<label for="email" class="form-label">e-mail</label>
				<div class="input-group">
					<input type="email" class="form-control" id="email" name="email" required>
					<button type="button" class="btn btn-outline-secondary" onclick="checkEmail()">중복확인</button>
				</div>
				<div id="email-check-msg" class="form-text text-danger"></div>
			</div>

			<!-- 전화번호 입력 -->
			<div class="mb-3">
				<label class="form-label">전화번호</label>
				<div class="input-group">
					<select class="form-select" name="phone_prefix" style="max-width: 100px;">
						<option value="010" selected="selected">010</option>
						<option value="02">02</option>
						<option value="011">011</option>
						<option value="016">016</option>
						<option value="017">017</option>
						<option value="018">018</option>
						<option value="019">019</option>
					</select>
					<input type="text" class="form-control" id="phone_mid" maxlength="4" required>
					<input type="text" class="form-control" id="phone_last" maxlength="4" required>
				</div>
			</div>

			<div class="mb-3">
				<label for="postcode" class="form-label">주소</label>
				<div class="input-group mb-2">
					<input type="text" class="form-control" id="sample6_postcode" name="postcode" placeholder="우편번호" readonly>
					<button type="button" class="btn btn-outline-secondary" onclick="sample6_execDaumPostcode()">우편번호 찾기</button>
				</div>
				<input type="text" class="form-control mb-2" id="sample6_address" name="address" placeholder="기본주소" readonly>
				<input type="text" class="form-control mb-2" id="sample6_detailAddress" name="detailAddress" placeholder="상세주소">
				<input type="text" class="form-control" id="sample6_extraAddress" name="extraAddress" placeholder="참고항목" readonly hidden="true">
			</div>
			<div class="mb-3">
				<label class="form-label">성별</label><br>
				<input type="radio" name="gender" value="M" checked> 남성
				<input type="radio" name="gender" value="F"> 여성
				<input type="radio" name="gender" value="O"> 기타
			</div>
			<div class="mb-3">
				<label for="birthdate" class="form-label">생년월일</label>
				<input type="date" class="form-control" name="birthdate" required>
			</div>
			<button type="submit" class="btn btn-primary w-100" id="submitBtn">가입하기</button>
		</form>
	</div>
</div>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
	// 우편번호 찾기
	function sample6_execDaumPostcode() {
		new daum.Postcode({
			oncomplete: function(data) {
				var addr = '';
				var extraAddr = '';

				if (data.userSelectedType === 'R') {
					addr = data.roadAddress;
				} else {
					addr = data.jibunAddress;
				}

				if (data.userSelectedType === 'R') {
					if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
						extraAddr += data.bname;
					}
					if (data.buildingName !== '' && data.apartment === 'Y') {
						extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
					}
					if (extraAddr !== '') {
						extraAddr = ' (' + extraAddr + ')';
					}
					document.getElementById("sample6_extraAddress").value = extraAddr;
				} else {
					document.getElementById("sample6_extraAddress").value = '';
				}

				document.getElementById('sample6_postcode').value = data.zonecode;
				document.getElementById("sample6_address").value = addr;
				document.getElementById("sample6_detailAddress").focus();
			}
		}).open();
	}

	let isUserIdChecked = false;
	let lastCheckedUserId = "";
	let isEmailChecked = false;
	let lastCheckedEmail = "";

	document.getElementById("user_id").addEventListener("input", function () {
		const currentVal = this.value;
		if (currentVal !== lastCheckedUserId) {
			isUserIdChecked = false;
			document.getElementById("id-check-msg").innerText = "중복확인을 해주세요.";
			document.getElementById("id-check-msg").classList.remove("text-success", "text-danger");
		}
	});

	document.getElementById("email").addEventListener("input", function () {
		const currentVal = this.value;
		if (currentVal !== lastCheckedEmail) {
			isEmailChecked = false;
			document.getElementById("email-check-msg").innerText = "중복확인을 해주세요.";
			document.getElementById("email-check-msg").classList.remove("text-success", "text-danger");
		}
	});

	function checkUserId() {
		const userId = document.getElementById("user_id").value.trim();
		const msg = document.getElementById("id-check-msg");

		if (!userId) {
			msg.innerText = "아이디를 입력해주세요.";
			msg.classList.add("text-danger");
			return;
		}

		fetch("/hobbyMe/login/checkId.do?user_id=" + encodeURIComponent(userId))
			.then(response => response.text())
			.then(result => {
				if (result === "available") {
					msg.innerText = "사용 가능한 아이디입니다.";
					msg.classList.remove("text-danger");
					msg.classList.add("text-success");
					isUserIdChecked = true;
					lastCheckedUserId = userId;
				} else {
					msg.innerText = "이미 사용 중인 아이디입니다.";
					msg.classList.remove("text-success");
					msg.classList.add("text-danger");
					isUserIdChecked = false;
				}
			})
			.catch(() => {
				msg.innerText = "서버 오류가 발생했습니다.";
				msg.classList.add("text-danger");
			});
	}

	function checkEmail() {
		const email = document.getElementById("email").value.trim();
		const msg = document.getElementById("email-check-msg");

		if (!email) {
			msg.innerText = "이메일을 입력해주세요.";
			msg.classList.add("text-danger");
			return;
		}

		fetch("/hobbyMe/login/checkEmail.do?email=" + encodeURIComponent(email))
			.then(response => response.text())
			.then(result => {
				if (result === "available") {
					msg.innerText = "사용 가능한 이메일입니다.";
					msg.classList.remove("text-danger");
					msg.classList.add("text-success");
					isEmailChecked = true;
					lastCheckedEmail = email;
				} else {
					msg.innerText = "이미 사용 중인 이메일입니다.";
					msg.classList.remove("text-success");
					msg.classList.add("text-danger");
					isEmailChecked = false;
				}
			})
			.catch(() => {
				msg.innerText = "서버 오류가 발생했습니다.";
				msg.classList.add("text-danger");
			});
	}

	// 비밀번호 확인
	const password = document.getElementById('password');
	const confirmPassword = document.getElementById('confirm_password');
	const warning = document.getElementById('mismatchWarning');
	const submitBtn = document.getElementById('submitBtn');

	function validatePasswords() {
		if (password.value && confirmPassword.value && password.value !== confirmPassword.value) {
			warning.classList.remove('d-none');
			submitBtn.disabled = true;
		} else {
			warning.classList.add('d-none');
			submitBtn.disabled = !(password.value && confirmPassword.value);
		}
	}

	password.addEventListener('input', validatePasswords);
	confirmPassword.addEventListener('input', validatePasswords);

	// 회원가입 시 중복확인
	document.getElementById("signupForm").addEventListener("submit", function (event) {
		if (!isUserIdChecked) {
			alert("아이디 중복확인을 해주세요.");
			event.preventDefault();
			return;
		}
		if (!isEmailChecked) {
			alert("이메일 중복확인을 해주세요.");
			event.preventDefault();
			return;
		}
	});
	
	// 전화번호 숫자만 필터링 (중간 + 끝자리)
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
	document.getElementById("signupForm").addEventListener("submit", function (event) {
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
