<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ page import="mvc.model.HobbyDTO" %>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>로그인</title>
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

.main-container {
  flex: 1;
}
</style>
<body>
    <%@ include file="/WEB-INF/view/common/header.jsp" %>
    <c:if test="${param.msg == 'success'}">
	    <div id="popup-alert" class="alert alert-success text-center" style="position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 9999; width: 300px;">
	        가입 되었습니다.
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
    <div class="main-container container py-4">
        <div class="row align-items-md-stretch text-center">
            <h1 class="display-5 fw-bold">로그인</h1>
            <div class="row justify-content-center align-items-center">
                <div class="h-100 p-5 col-md-6">
                    <%
                    String error = request.getParameter("error");
                    if (error != null) {
                        out.println("<div class='alert alert-danger'>");
                        out.println("아이디와 비밀번호를 확인해 주세요");
                        out.println("</div>");
                    }
                    %>
                    <form class="form-signin" action="<c:url value='/login/login.do' />" method="post">
                        <!-- Tomcat 컨테이너가 처리하는 로그인 서블릿 -->
                        <div class="form-floating mb-3 row">
                            <input type="text" class="form-control" name='id' id="floatingInput" required autofocus>
                            <label for="floatingInput">ID</label>
                        </div>
                        <div class="form-floating mb-3 row">
                            <input type="password" class="form-control" name='password'>
                            <label for="floatingPassword">Password</label>
                        </div>

                        <div class="row mb-3 align-items-center flex-column flex-md-row text-center text-md-start">
						    <!-- 왼쪽: 아이디/비밀번호 찾기 -->
						    <div class="col-md-6 d-flex flex-wrap justify-content-center justify-content-md-start gap-2">
						        <a href="#" class="btn btn-link text-nowrap px-1" data-bs-toggle="modal" data-bs-target="#findIdModal">아이디 찾기</a>
						        <a href="#" class="btn btn-link text-nowrap px-1" data-bs-toggle="modal" data-bs-target="#findPasswordModal">비밀번호 찾기</a>
						    </div>
						    <!-- 오른쪽: 회원가입 -->
						    <div class="col-md-6 d-flex justify-content-center justify-content-md-end mt-2 mt-md-0">
						        <a href="${pageContext.request.contextPath}/login/signup.do" class="btn btn-link text-nowrap px-1">회원가입</a>
						    </div>
						</div>
                        
                        <button class="btn btn-lg btn-success" type="submit">로그인</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- 아이디 찾기 모달 -->
    <div class="modal fade" id="findIdModal" tabindex="-1" aria-labelledby="findIdModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="<c:url value='/login/findIdProcess.do' />" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title" id="findIdModalLabel">아이디 찾기</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <%
                        String foundId = request.getParameter("foundId");
                        if (foundId != null) {
                        %>
                        <div class="alert alert-success">
                            회원님의 아이디는 <strong><%= foundId %></strong> 입니다.
                        </div>
                        <% } else { %>
                        <div class="mb-3">
                            <label for="name" class="form-label">이름</label>
                            <input type="text" class="form-control" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">e-mail</label>
                            <input type="text" class="form-control" name="email" required>
                        </div>
                        <% if ("1".equals(request.getParameter("findError"))) { %>
                        <div class="alert alert-danger">일치하는 정보가 없습니다.</div>
                        <% } %>
                        <% } %>
                    </div>

                    <div class="modal-footer">
                        <% if (foundId != null) { %>
                        <a href="login.jsp" class="btn btn-success">로그인 하러 가기</a>
                        <% } else { %>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                        <button type="submit" class="btn btn-primary">아이디 찾기</button>
                        <% } %>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- 비밀번호 찾기 모달 -->
	<div class="modal fade" id="findPasswordModal" tabindex="-1" aria-labelledby="findPasswordModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <form action="<%=request.getContextPath()%>/login/findPasswordProcess.do" method="post">
	                <div class="modal-header">
	                    <h5 class="modal-title" id="findPasswordModalLabel">비밀번호 찾기</h5>
	                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
	                </div>
	                <div class="modal-body">
	                    <div class="mb-3">
	                        <label for="user_id" class="form-label">아이디</label>
	                        <input type="text" class="form-control" id="user_id" name="user_id" required>
	                    </div>
	                    <div class="mb-3">
	                        <label for="pw_email" class="form-label">이메일</label>
	                        <input type="email" class="form-control" id="pw_email" name="pw_email" required>
	                    </div>
	                    <div class="alert alert-info" role="alert">
	                        입력하신 이메일로 비밀번호 재설정 링크를 전송합니다.
	                    </div>
	                </div>
	                <div class="modal-footer">
	                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	                    <button type="submit" class="btn btn-primary">인증 메일 전송</button>
	                </div>
	            </form>
	        </div>
	    </div>
	</div>

    <%@ include file="/WEB-INF/view/common/footer.jsp" %>

    <!-- Bootstrap JS (Modal 작동에 필요) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 에러 발생 시 자동으로 모달 열기 -->
    <script>
        const params = new URLSearchParams(window.location.search);
        if (params.get('findError') === '1' || params.get('foundId')) {
            const modal = new bootstrap.Modal(document.getElementById('findIdModal'));
            modal.show();
        }
    </script>
</body>
</html>
