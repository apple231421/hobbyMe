<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>참여한 프로젝트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
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
.container {
  flex: 1;
}
</style>
<body>
<%@ include file="/WEB-INF/view/common/header.jsp" %>

<div class="container mt-5">
    <h2 class="mb-4">참여한 프로젝트</h2>
    <table class="table table-bordered text-center" style="table-layout: fixed; width: 100%;">
        <colgroup>
            <col style="width: 10%;">
            <col style="width: 55%;">
            <col style="width: 20%;">
            <col style="width: 15%;">
        </colgroup>
        <thead class="table-light">
            <tr>
                <th scope="col">번호</th>
                <th scope="col">프로젝트명</th>
                <th scope="col">결제 기한</th>
                <th scope="col">상태</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="project" items="${myPayList}" varStatus="status">
                <tr>
                    <td>${fn:length(myPayList) - status.index}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/BoardViewAction.do?post_num=${project.myPayNum}">
                            ${project.myPayTitle}
                        </a>
                    </td>
                    <td>${project.myPayReservation} ~ ${project.myPayEndDate}</td>
                    <td>
                    	<c:choose>
						    <c:when test="${project.myPayState == 'G'}">Grand</c:when>
						    <c:when test="${project.myPayState == 'H'}">Hold</c:when>
						    <c:when test="${project.myPayState == 'W'}">Wait</c:when>
						    <c:otherwise>-</c:otherwise>
						</c:choose>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty myPayList}">
                <tr>
                    <td colspan="5">참여한 프로젝트가 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
    <h2 class="mb-4">내 프로젝트</h2>
    <table class="table table-bordered text-center" style="table-layout: fixed; width: 100%;">
        <colgroup>
            <col style="width: 10%;">
            <col style="width: 55%;">
            <col style="width: 20%;">
            <col style="width: 15%;">
        </colgroup>
        <thead class="table-light">
            <tr>
                <th scope="col">번호</th>
                <th scope="col">프로젝트명</th>
                <th scope="col">참여 기간</th>
                <th scope="col">상태</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="myProject" items="${myList}" varStatus="status">
                <tr>
                    <td>${fn:length(myList) - status.index}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/BoardViewAction.do?post_num=${myProject.myBoardNum}">
						    ${myProject.myBoardTitle}
						</a>
                    </td>
                    <td>${myProject.myBoardReservation} ~ ${myProject.myBoardEndDate}</td>
                    <td>${myProject.myBoardState}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty myList}">
                <tr>
                    <td colspan="5">참여한 프로젝트가 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
</body>
</html>
