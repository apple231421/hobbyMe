<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>호스트 지원</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
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
        .readonly-box {
            background-color: #f8f9fa;
            border: 1px solid #ced4da;
            padding: 0.5rem;
            border-radius: 0.25rem;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/view/common/header.jsp" %>

<div class="container mt-5">
    <h2 class="mb-4">호스트 지원 현황</h2>

    <div class="mb-3">
        <label class="form-label">제목</label>
        <div class="readonly-box">${user.hostTitle}</div>
    </div>

    <div class="mb-3">
        <label class="form-label">프로젝트 아이디어 요약</label>
        <div class="readonly-box" style="white-space: pre-wrap;">${user.hostContent}</div>
    </div>

    <div class="mb-3">
        <label class="form-label">첨부파일</label>
        <div>
            <c:choose>
                <c:when test="${not empty user.hostFile}">
                    <a href="${pageContext.request.contextPath}/downloadFile.do?fileName=${user.hostFile}" class="btn btn-outline-primary btn-sm">
                        ${user.hostFile} 다운로드
                    </a>
                </c:when>
                <c:otherwise>
                    <span class="text-muted">첨부된 파일이 없습니다.</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <c:choose>
    	<c:when test="${sessionClass == 'A'}">
		    <div class="mt-4 d-flex gap-2">
			    <form method="post" action="${pageContext.request.contextPath}/login/approveHost.do?id=${user.userId}">
			    	<c:if test="${not empty num}">
					    <input type="hidden" name="num" value="${num}" />
					</c:if>
			        <input type="hidden" name="userId" value="${user.userId}" />
			        <button type="submit" class="btn btn-success">승인</button>
			    </form>
			    <form method="post" action="${pageContext.request.contextPath}/login/rejectHost.do?id=${user.userId}">
			        <c:if test="${not empty num}">
					    <input type="hidden" name="num" value="${num}" />
					</c:if>
			        <input type="hidden" name="userId" value="${user.userId}" />
			        <button type="submit" class="btn btn-danger">승인 거부</button>
			    </form>
			</div>
    	</c:when>
    </c:choose>
	    
</div>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
</body>
</html>
