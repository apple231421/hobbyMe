<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-header text-center bg-primary text-white">
                        <h4 class="mb-0">비밀번호 재설정</h4>
                    </div>
                    <div class="card-body">
                        <form action="<%=request.getContextPath()%>/login/resetPasswordProcess.do" method="post" id="resetForm">
                            <input type="hidden" name="user_id" value="<%= request.getAttribute("user_id") %>">

                            <div class="mb-3">
                                <label for="password" class="form-label">새 비밀번호</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>

                            <div class="mb-3">
                                <label for="confirm_password" class="form-label">비밀번호 확인</label>
                                <input type="password" class="form-control" id="confirm_password" name="confirm_password" required>
                                <div class="form-text text-danger d-none" id="mismatchWarning">
                                    비밀번호가 일치하지 않습니다.
                                </div>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-success" id="submitBtn" disabled>비밀번호 재설정</button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="text-center mt-3">
                    <a href="${pageContext.request.contextPath}/login/login_home.do" class="text-decoration-none">로그인 페이지로 돌아가기</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 실시간 비밀번호 일치 확인 스크립트 -->
    <script>
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirm_password');
        const warning = document.getElementById('mismatchWarning');
        const submitBtn = document.getElementById('submitBtn');
     	// 서버에서 전달된 이전 비밀번호 값 (null-safe 처리)
        const previousPassword = '<%= request.getAttribute("pre_password") != null ? request.getAttribute("pre_password") : "" %>';
     	// 추가 경고 메시지 요소 생성
        const sameAsOldWarning = document.createElement('div');
     	
        sameAsOldWarning.className = 'form-text text-danger d-none';
        sameAsOldWarning.id = 'sameAsOldWarning';
        sameAsOldWarning.textContent = '이전 비밀번호와 동일할 수 없습니다.';
        password.parentElement.appendChild(sameAsOldWarning);

        function validatePasswords() {
            const passVal = password.value;
            const confirmVal = confirmPassword.value;

            const isMismatch = passVal && confirmVal && passVal !== confirmVal;
            const isSameAsOld = passVal && passVal === previousPassword;

            // 비밀번호 불일치 경고
            warning.classList.toggle('d-none', !isMismatch);

            // 이전 비밀번호와 동일 경고
            sameAsOldWarning.classList.toggle('d-none', !isSameAsOld);

            // 버튼 활성화 조건
            submitBtn.disabled = (
                !passVal || !confirmVal || isMismatch || isSameAsOld
            );
        }

        password.addEventListener('input', validatePasswords);
        confirmPassword.addEventListener('input', validatePasswords);
    </script>
</body>
</html>
