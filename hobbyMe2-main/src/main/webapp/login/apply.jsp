<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>호스트 지원</title>
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
    <h2 class="mb-4">호스트 지원서 작성</h2>

    <form action="${pageContext.request.contextPath}/login/apply.do" method="post" enctype="multipart/form-data">
        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" id="title" name="title" required />
        </div>

        <div class="mb-3">
            <label for="projectIdea" class="form-label">프로젝트 아이디어 요약</label>
            <textarea class="form-control" id="projectIdea" name="projectIdea" rows="4" required></textarea>
        </div>
        
        <div class="mb-3 row">
			<label class="col-sm-2 control-label">첨부파일</label>
			<div class="col-sm-5">
				<input name="applyFile" type="file" class="form-control">
			</div>
		</div>
        
        <button type="submit" class="btn btn-primary">지원하기</button>
    </form>
</div>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
</body>
</html>
