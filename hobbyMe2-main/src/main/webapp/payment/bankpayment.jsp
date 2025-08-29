<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mvc.model.PaymentDTO" %>
<%
    String userId = request.getParameter("user_id");
    String postNum = request.getParameter("post_num");
    String name = request.getParameter("name");
    String finalPriceStr = request.getParameter("finalPrice");
    String couponNum = request.getParameter("couponNum");
    String remainPoint = request.getParameter("remainPoint");
    String couponDiscount = request.getParameter("couponDiscount");
    int price = (finalPriceStr != null && !finalPriceStr.isEmpty()) ? Integer.parseInt(finalPriceStr) : 0;

    int part1 = (int)(Math.random() * 900) + 100;
    int part2 = (int)(Math.random() * 900) + 100;
    int part3 = (int)(Math.random() * 9000) + 1000;
    String fakeAccount = part1 + "-" + part2 + "-" + part3;
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>무통장 입금</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <style>
        .container { margin-top: 50px; max-width: 500px; }
        body { background-color: #f5f7fa; font-family: 'Noto Sans KR', sans-serif; }
        h2 { font-weight: 700; color: #333; margin-bottom: 20px; }
        .card-deposit { background-color: #ffffff; border-radius: 16px; box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06); padding: 30px 40px; max-width: 500px; margin: 50px auto; }
        .form-label { font-weight: 600; margin-bottom: 5px; color: #444; }
        .form-control, .form-select { border-radius: 12px; padding: 12px; border: 1px solid #ddd; font-size: 1rem; margin-bottom: 20px; }
        .btn-submit { background-color: #ff6b00; color: #fff; font-weight: 600; padding: 12px 30px; border-radius: 30px; border: none; width: 100%; transition: background-color 0.3s ease; }
        .btn-submit:hover { background-color: #e65c00; }
        .alert-info-custom { background-color: #fff8f1; border-left: 6px solid #ff6b00; padding: 15px 20px; margin-top: 30px; border-radius: 10px; color: #333; font-size: 0.95rem; line-height: 1.6; }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mb-4">무통장 입금 정보</h2>
    <form action="BankDepositAction.do" method="post">
        <input type="hidden" name="user_id" value="<%= userId %>" />
        <input type="hidden" name="post_num" value="<%= postNum %>" />
        <input type="hidden" name="name" value="<%= name %>" />
        <input type="hidden" name="finalPrice" value="<%= price %>" />
        <input type="hidden" name="couponNum" value="<%= couponNum %>" />
        <input type="hidden" name="remainPoint" value="<%= remainPoint %>" />
        <input type="hidden" name="couponDiscount" value="<%= couponDiscount %>" />

        <div class="mb-3">
            <label for="bank" class="form-label">은행 선택</label>
            <select class="form-select" name="bank" id="bank" required>
                <option value="">-- 은행 선택 --</option>
                <option value="KB국민은행">KB국민은행</option>
                <option value="신한은행">신한은행</option>
                <option value="우리은행">우리은행</option>
                <option value="하나은행">하나은행</option>
                <option value="NH농협은행">NH농협은행</option>
                <option value="카카오뱅크">카카오뱅크</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="depositor" class="form-label">입금자명</label>
            <input type="text" class="form-control" id="depositor" name="depositor" value="<%= name %>">
        </div>

        <div class="mb-3">
            <label for="amount" class="form-label">입금 금액</label>
            <div class="input-group" style="display: inline-flex; align-items: center;">
                <input type="number" class="form-control" id="amount" name="amount" value="<%= price %>" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">입금 계좌번호</label>
            <div class="form-control bg-light"><%= fakeAccount %></div>
        </div>

        <button type="submit" class="btn btn-success w-100">무통장 입금 요청</button>
    </form>

    <div class="alert alert-info mt-4">
        <strong>※ 안내사항</strong><br>
        - 무통장 입금 요청 후 24시간 이내 입금하지 않으면 예약이 취소됩니다.<br>
        - 입금 시 반드시 입력한 입금자명과 동일하게 이체해 주세요.
    </div>
</div>
</body>
</html>
