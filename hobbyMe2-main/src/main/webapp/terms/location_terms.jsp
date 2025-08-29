<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="mvc.model.BoardDAO, mvc.model.BoardDTO, java.util.*" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <%
    BoardDAO dao = BoardDAO.getInstance();
    List<BoardDTO> popularList = dao.getTopLikedBoards(4);
    List<BoardDTO> recentList = dao.getRecentBoards(4);
    List<String> categoryList = dao.getAllCategories(); 

    request.setAttribute("popularList", popularList);
    request.setAttribute("recentList", recentList);
    request.setAttribute("categoryList", categoryList); 
%>
                <!DOCTYPE html>
                <html lang="ko">
                    <head>
                        <meta charset="UTF-8">
                            <title>위치기반 서비스 이용약관</title>
                            <meta name="viewport" content="width=device-width, initial-scale=1">
                                <link
                                    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
                                    rel="stylesheet">
                                    <link
                                        rel="stylesheet"
                                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                                        <link rel="stylesheet" href="../css/style.css">
                                            <style>
                                                body,
                                                html {
                                                    height: 100%;
                                                    margin: 0;
                                                    padding: 0;
                                                }
                                                .wrapper {
                                                    min-height: 100vh;
                                                    display: flex;
                                                    flex-direction: column;
                                                }
                                                main {
                                                    flex: 1;
                                                }
                                            </style>
                                        </head>
                                        <body>

                                            <%@ include file="../WEB-INF/view/common/header.jsp" %>
                                                <%@ include file="../WEB-INF/view/common/remote.jsp" %>
                                                    <div class="wrapper">
                                                        <main class="container my-5">
                                                            <<h1>위치기반 서비스 이용약관</h1> <p>본 약관은 HobbyMe(이하 "회사")가 제공하는 위치기반 서비스(이하 "서비스")의 이용과
                                                            관련하여, 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.</p> <h3>제1조 위치정보의 정의 및 수집 방법</h3>
                                                            <p> 1. "위치정보"란 이동 중인 개인 또는 사물의 특정 시간 내 위치에 관한 정보를 의미합니다.<br> 2. 회사는 GPS, Wi-Fi,
                                                            기지국 정보, IP 주소 등을 이용하여 위치정보를 수집합니다.<br> 3. 개인위치정보란 특정 개인을 식별할 수 있는 위치정보를 말합니다.
                                                            </p> <h3>제2조 위치정보의 수집 및 이용 목적</h3> <p> 회사는 다음 목적을 위해 위치정보를 수집 및 이용합니다:<br> 1. 주변
                                                            콘텐츠 및 사용자 맞춤형 정보 제공<br> 2. 위치기반 커뮤니티 추천 및 통계 분석<br> 3. 이벤트 및 프로모션 안내 (사전 동의
                                                            시)<br> 4. 서비스 이용 내역 기반 피드백 및 개선 </p> <h3>제3조 위치정보 수집∙이용∙제공에 대한 동의</h3> <p> 1.
                                                            회사는 개인위치정보를 수집하거나 제3자에게 제공하는 경우, 이용자의 사전 동의를 반드시 받습니다.<br> 2. 이용자는 동의를 거부할 수
                                                            있으며, 이 경우 위치기반 서비스 일부가 제한될 수 있습니다. </p> <h3>제4조 개인위치정보의 보유 및 이용 기간</h3> <p> 1.
                                                            회사는 개인위치정보를 수집한 날로부터 30일간 보유하며, 해당 기간이 경과하면 지체 없이 파기합니다.<br> 2. 서비스 이력을 증명해야 할
                                                            필요가 있는 경우, 법령에서 정한 범위 내에서 보유할 수 있습니다. </p> <h3>제5조 위치정보 제3자 제공에 관한 사항</h3> <p>
                                                            1. 회사는 이용자의 동의 없이는 개인위치정보를 제3자에게 제공하지 않습니다.<br> 2. 제3자에게 제공하는 경우, 사전에 제공 목적,
                                                            제공받는 자의 정보 등을 고지하고 개별 동의를 받습니다. </p> <h3>제6조 위치기반서비스의 이용 요금</h3> <p> 회사가 제공하는
                                                            위치기반 서비스는 기본적으로 무료입니다. 단, 이동통신사가 부과하는 데이터 통신료 등은 이용자의 부담입니다. </p> <h3>제7조 이용자의
                                                            권리 및 행사 방법</h3> <p> 1. 이용자는 언제든지 위치정보 제공 동의 여부를 변경하거나 철회할 수 있습니다.<br> 2. 위치정보
                                                            열람, 고지 내역 확인, 정정 요청은 고객센터 또는 마이페이지에서 처리할 수 있습니다.<br> 3. 회사는 철회 요청이 있는 경우 즉시 수집을
                                                            중단하며, 보유 중인 위치정보를 파기합니다. </p> <h3>제8조 위치정보관리책임자 지정</h3> <p> 회사는 위치정보 보호와 민원 처리를
                                                            위해 다음과 같이 책임자를 지정합니다:<br> - 이름: 정소연<br> - 이메일: location@hobbyme.co.kr<br> - 연락처:
                                                            1600-1234 </p> <h3>제9조 손해배상</h3> <p> 1. 회사가 위치정보법 등 관련 법령을 위반하여 이용자에게 손해가 발생한
                                                            경우, 이용자는 손해배상을 청구할 수 있습니다.<br> 2. 단, 회사가 고의 또는 과실이 없음을 입증한 경우 책임을 지지 않습니다. </p>
                                                            <h3>제10조 면책조항</h3> <p> 다음 각 호의 사유로 인해 발생한 손해에 대해 회사는 책임을 지지 않습니다:<br> 1. 천재지변 또는
                                                            이에 준하는 불가항력적 사유<br> 2. 이용자의 귀책사유로 인한 손해<br> 3. 회사의 고의 또는 중대한 과실이 없는 기술적 장애 </p>
                                                            <h3>제11조 분쟁해결 및 관할법원</h3> <p> 본 약관에 따른 분쟁은 회사의 본사 소재지를 관할하는 대한민국 법원에서 해결하며, 대한민국
                                                            법을 준거법으로 합니다. </p> <h3>부칙</h3> <p> 본 약관은 2025년 5월 21일부터 시행됩니다. 회사는 관련 법령에 따라 본
                                                            약관을 개정할 수 있으며, 개정 시 시행일 최소 7일 전부터 공지합니다. </p> </main> </div> <%@ include
                                                            file="../WEB-INF/view/common/footer.jsp" %> <script
                                                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                                                            <script> window.addEventListener('scroll', () => { const remote =
                                                            document.getElementById('remoteMenu'); if (window.innerWidth > 768) {
                                                            remote.style.top = window.scrollY + 100 + 'px'; } });
                                                            document.addEventListener('DOMContentLoaded', function () { const popup =
                                                            document.getElementById('popup'); const overlay =
                                                            document.getElementById('popupOverlay'); const todayKey = 'hidePopupDate'; const
                                                            today = new Date().toLocaleDateString(); if (localStorage.getItem(todayKey) !==
                                                            today) { popup.style.display = 'block'; overlay.style.display = 'block'; }
                                                            document.getElementById('hideTodayBtn').addEventListener('click', function () {
                                                            localStorage.setItem(todayKey, today); popup.style.display = 'none';
                                                            overlay.style.display = 'none'; });
                                                            document.getElementById('closeBtn').addEventListener('click', function () {
                                                            popup.style.display = 'none'; overlay.style.display = 'none'; }); }); </script>
                                                            </body> </html> 