<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <footer
            class="text-white text-center py-4 mt-5 w-100"
            style="background-color: #2c2f33;">
            <div class="container-fluid">
                <p class="mb-1 fw-bold">HobbyMe | 대표자: 최재우, 김효영, 김진혁, 김창규</p>
                <p class="mb-1">사업자등록번호: 123-45-67890</p>
                <p class="mb-1">주소: 서울 구로구 디지털로 306 대륭포스트타워 2차 203호</p>
                <p class="mb-3">고객센터: 1600-1234 | 이메일: help@hobbyme.co.kr</p>
                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <a
                        href="${pageContext.request.contextPath}/terms/terms.jsp"
                        class="text-secondary text-decoration-none">이용약관</a>
                    <a
                        href="${pageContext.request.contextPath}/terms/privacy.jsp"
                        class="text-secondary text-decoration-none">개인정보 처리방침</a>
                    <a
                        href="${pageContext.request.contextPath}/terms/location_terms.jsp"
                        class="text-secondary text-decoration-none">위치기반 서비스 이용약관</a>
                </div>
            </div>
        </footer>