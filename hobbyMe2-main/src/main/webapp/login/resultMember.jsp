<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:choose>
    <c:when test="${param.msg == '1'}">
        <h3>회원가입이 완료되었습니다.</h3>
        <a href="${pageContext.request.contextPath}/login_home.do">로그인하러 가기</a>
    </c:when>
    <c:when test="${param.msg == '2'}">
        <h3>로그인에 성공했습니다.</h3>
        <a href="${pageContext.request.contextPath}/updateMember.do">정보 수정</a><br>
        <a href="${pageContext.request.contextPath}/logout.do">로그아웃</a>
        <a href="${pageContext.request.contextPath}/deleteMember.do">회원탈퇴</a>
    </c:when>
    <c:when test="${param.msg == '3'}">
        <h3>정보 수정 하였습니다.</h3>
        <a href="${pageContext.request.contextPath}/index.jsp">메인으로 가기</a>
    </c:when>
</c:choose>
