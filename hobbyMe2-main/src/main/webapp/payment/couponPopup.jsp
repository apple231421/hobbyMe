<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>쿠폰 선택</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        .submit-btn {
            margin-top: 15px;
            padding: 8px 20px;
            font-weight: bold;
            cursor: pointer;
        }
    </style>

    <script>
        function applySelectedCoupon() {
            const radios = document.getElementsByName("selectedCoupon");

            let selectedCouponNum = 0;
            let selectedCouponType = "";
            let selectedCouponValue = 0;

            for (let i = 0; i < radios.length; i++) {
                if (radios[i].checked) {
                    selectedCouponNum = radios[i].value;
                    selectedCouponType = radios[i].dataset.type || "";
                    selectedCouponValue = parseInt(radios[i].dataset.value || "0");
                    break;
                }
            }

            if (window.opener && typeof window.opener.applyCouponFromPopup === 'function') {
                window.opener.applyCouponFromPopup(
                    selectedCouponNum,
                    selectedCouponType,
                    selectedCouponValue
                );
                window.close();
            } else {
                alert("❌ 부모창이 없거나 함수가 정의되지 않았습니다.");
            }
        }
    </script>
</head>
<body>

    <h3>사용 가능한 쿠폰 목록</h3>

    <form>
        <table>
            <tr>
                <th>선택</th>
                <th>쿠폰 종류</th>
                <th>할인 혜택</th>
                <th>사용 기간</th>
            </tr>

            <!-- 선택 안 함 -->
            <tr>
                <td><input type="radio" name="selectedCoupon" value="0" data-type="" data-value="0" checked></td>
                <td colspan="3">선택 안 함</td>
            </tr>

            <!-- 쿠폰 목록 -->
            <c:forEach var="coupon" items="${couponList}">
                <tr>
                    <td>
                        <input type="radio"
                               name="selectedCoupon"
                               value="${coupon.couponNum}"
                               data-type="${coupon.couponType}"
                               data-value="${coupon.couponValue}">
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${coupon.couponType == 'D'}">가격 쿠폰</c:when>
                            <c:when test="${coupon.couponType == 'P'}">포인트 차감 쿠폰</c:when>
                            <c:otherwise>기타</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${coupon.couponType == 'D'}">${coupon.couponValue}% 할인</c:when>
                            <c:when test="${coupon.couponType == 'P'}">${coupon.couponValue}원 할인</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${coupon.startDate} ~ ${coupon.endDate}</td>
                </tr>
            </c:forEach>
        </table>

        <button type="button" class="submit-btn" onclick="applySelectedCoupon()">선택 완료</button>
    </form>

</body>
</html>
