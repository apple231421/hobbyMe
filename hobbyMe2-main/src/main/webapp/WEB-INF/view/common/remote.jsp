<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
        <div class="remote" id="remoteMenu">
            <a href="#" class="btn btn-outline-light w-100 my-1">맨 위로</a>
            <a
                href="${pageContext.request.contextPath}/faq/faq.jsp"
                class="btn btn-outline-light w-100 my-1">FAQ</a>
            <a
                href="<c:url value ="/BoardListAction.do?pageNum=1"/>"
                class="btn btn-outline-light w-100 my-1">게시판</a>
            <c:choose>
                <c:when test="${not empty sessionScope.sessionId}">
                    <a
                        href="<c:url value ="/login/myPage.do"/>"
                        class="btn btn-outline-light w-100 my-1">마이페이지</a>
                </c:when>
            </c:choose>
        </div>