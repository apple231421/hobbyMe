<%@ page contentType="text/html; charset=UTF-8" language="java"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

        <header
            class="navbar navbar-expand-lg navbar-light bg-light border-bottom w-100">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
                    <img
                        src="${pageContext.request.contextPath}/images/HobbyMe logo.png"
                        alt="로고"
                        height="40"></a>

                    <button
                        class="navbar-toggler"
                        type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#navbarMenu">
                        <span class="navbar-toggler-icon"></span>
                    </button>

                    <div class="collapse navbar-collapse justify-content-between" id="navbarMenu">
                        <ul class="navbar-nav">
                            <li class="nav-item me-2">
                                <a
                                    class="nav-link fw-semibold"
                                    href="<c:url value='/BoardListAction.do?pageNum=1' />">게시판</a>
                            </li>
                            <li class="nav-item me-2">
                                <a
                                    class="nav-link text-dark"
                                    href="${pageContext.request.contextPath}/faq/notice.jsp">공지사항</a>
                            </li>
                            <!-- ✅ FAQ 메뉴 추가 -->
                            <li class="nav-item">
                                <a
                                    class="nav-link text-dark"
                                    href="${pageContext.request.contextPath}/faq/faq.jsp">FAQ</a>
                            </li>
                        </ul>

                        <form
                            method="get"
                            action="BoardListAction.do"
                            class="d-flex mx-auto"
                            style="width: 400px;">
                            <input
                                class="form-control me-2 rounded-pill"
                                name="text"
                                type="search"
                                placeholder="제목 검색">
                                <input type="hidden" name="items" value="title">
                                    <button class="btn btn-outline-success" type="submit">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </form>

                                <div class="d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.sessionId}">
                                            <a
                                                href="${pageContext.request.contextPath}/login/myPage.jsp"
                                                class="me-2 text-decoration-none text-dark fw-semibold">
                                                ${sessionScope.sessionId}님 환영합니다!
                                            </a>

                                            <a
                                                href="${pageContext.request.contextPath}/login/logout.do"
                                                class="btn btn-outline-danger rounded-pill px-3">로그아웃</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a
                                                href="${pageContext.request.contextPath}/login/login_home.do"
                                                class="btn btn-outline-secondary rounded-pill px-3">로그인</a>
                                            <a
                                                href="${pageContext.request.contextPath}/login/signup.do"
                                                class="btn btn-success rounded-pill px-3">회원가입</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </header>