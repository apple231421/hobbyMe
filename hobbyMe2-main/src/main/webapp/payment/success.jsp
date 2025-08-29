<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String userId = request.getParameter("user_id");
String postNum = request.getParameter("post_num");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결제 성공</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <style>
        body {
            background-color: #f0f8ff;
            font-family: 'Noto Sans KR', sans-serif;
        }
        .container {
            max-width: 600px;
            margin-top: 100px;
            text-align: center;
        }
        .success-icon {
            font-size: 4rem;
            color: #28a745;
        }
        h1 {
            font-weight: bold;
            margin: 20px 0;
        }
        .btn-home {
            margin-top: 30px;
            padding: 10px 30px;
            border-radius: 30px;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="success-icon">
        <i class="fa fa-check-circle"></i>
    </div>
    <h1>결제가 완료되었습니다!</h1>
    <p>예약이 성공적으로 처리되었습니다. 감사합니다.</p>

    <a href="${pageContext.request.contextPath}/" class="btn btn-success btn-home">홈으로 이동</a>
    <a href="<%=request.getContextPath()%>/ViewReservation.do?post_num=<%=postNum%>&id=<%=userId%>" class="btn btn-outline-primary btn-home">내 예약 확인</a>
</div>

<!-- Font Awesome (아이콘용) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/js/all.min.js"></script>

</body>
</html>
