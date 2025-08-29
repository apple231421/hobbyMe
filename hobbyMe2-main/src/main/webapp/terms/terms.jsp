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
                            <title>이용약관</title>
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
                                                            <h1>이용약관</h1>
                                                            <p>본 약관은 회사(이하 "당사")가 제공하는 서비스 이용과 관련하여 당사와 이용자 간의 권리, 의무 및 책임사항 등을 규정합니다.</p>

                                                            <h3>제1조 목적</h3>
                                                            <p>이 약관은 당사가 제공하는 모든 서비스의 이용 조건 및 절차, 이용자와 당사의 권리∙의무∙책임사항 등을 규정함을 목적으로 합니다.</p>

                                                            <h3>제2조 정의</h3>
                                                            <p>1. "서비스"란 당사가 제공하는 웹사이트, 모바일 앱 등에서 제공하는 모든 기능 및 정보전달 서비스를 의미합니다.<br>
                                                                    2. "이용자"란 본 약관에 따라 당사의 서비스를 이용하는 회원 및 비회원을 말합니다.<br>
                                                                        3. "회원"이라 함은 당사의 절차에 따라 회원등록을 완료한 자를 의미합니다.</p>

                                                                    <h3>제3조 약관의 효력 및 변경</h3>
                                                                    <p>1. 본 약관은 당사의 서비스 화면에 게시하거나 기타의 방법으로 이용자에게 공지함으로써 효력을 발생합니다.<br>
                                                                            2. 당사는 필요한 경우 관련 법령을 위배하지 않는 범위에서 본 약관을 개정할 수 있으며, 개정된 약관은 제1항과 같은 방법으로 효력을
                                                                            발생합니다.<br>
                                                                                3. 이용자가 변경된 약관에 동의하지 않는 경우, 서비스 이용을 중단하고 회원 탈퇴를 요청할 수 있습니다.</p>

                                                                            <h3>제4조 서비스의 제공 및 변경</h3>
                                                                            <p>1. 당사는 업무상 또는 기술상 특별한 사정이 없는 한 지속적이고 안정적으로 서비스를 제공합니다.<br>
                                                                                    2. 당사는 서비스 개선 및 개발 등의 이유로 서비스의 전부 또는 일부를 변경할 수 있으며, 변경된 내용은 사전에 공지합니다.<br>
                                                                                        3. 당사는 무료로 제공되는 서비스의 일부 또는 전부를 사전 공지 없이 변경하거나 중단할 수 있습니다.</p>

                                                                                    <h3>제5조 회원 가입</h3>
                                                                                    <p>1. 이용자는 당사가 정한 절차에 따라 회원가입 신청을 하고, 당사는 이를 승인함으로써 회원가입이 완료됩니다.<br>
                                                                                            2. 회원은 가입 시 정확하고 최신의 정보를 제공해야 하며, 허위 정보를 제공한 경우 서비스 이용이 제한될 수 있습니다.<br>
                                                                                                3. 당사는 다음 각 호에 해당하는 경우 회원 가입을 거절하거나 사후에 이용계약을 해지할 수 있습니다.
                                                                                                <br>① 타인의 명의 또는 정보를 도용한 경우
                                                                                                    <br>② 허위 정보를 기재한 경우
                                                                                                        <br>③ 사회의 안녕질서 또는 미풍양속을 저해할 목적으로 신청한 경우</p>

                                                                                                        <h3>제6조 회원의 의무</h3>
                                                                                                        <p>1. 회원은 관련 법령, 본 약관 및 당사가 제공하는 서비스 이용안내 등에서 정한 사항을 준수해야 합니다.<br>
                                                                                                                2. 회원은 서비스 이용과 관련하여 다음 행위를 하여서는 안 됩니다.
                                                                                                                <br>① 타인의 정보를 도용하는 행위
                                                                                                                    <br>② 해킹, 악성코드 배포 등 시스템에 위해를 가하는 행위
                                                                                                                        <br>③ 회사의 서비스 운영을 방해하는 행위
                                                                                                                            <br>④ 음란물, 혐오 표현, 타인 비방 등 공공질서를 해치는 게시물 등록</p>

                                                                                                                            <h3>제7조 회사의 의무</h3>
                                                                                                                            <p>1. 당사는 관련 법령 및 본 약관이 금지하거나 미풍양속에 반하는 행위를 하지 않으며, 안정적인 서비스를 제공하기 위해 최선을 다합니다.<br>
                                                                                                                                    2. 당사는 이용자의 개인정보 보호를 위해 개인정보 처리방침을 수립하고 이를 준수합니다.</p>

                                                                                                                                <h3>제8조 계약 해지 및 서비스 이용 제한</h3>
                                                                                                                                <p>1. 회원은 언제든지 서비스 내 회원 탈퇴 기능을 통해 이용계약을 해지할 수 있습니다.<br>
                                                                                                                                        2. 당사는 이용자가 약관의 의무를 위반하거나 정상적인 서비스 운영을 방해한 경우, 사전 통지 없이 이용을 제한하거나 계약을 해지할 수
                                                                                                                                        있습니다.</p>

                                                                                                                                    <h3>제9조 손해배상 및 면책조항</h3>
                                                                                                                                    <p>1. 당사는 무료로 제공하는 서비스의 이용과 관련하여 발생하는 손해에 대해서는 책임을 지지 않습니다.<br>
                                                                                                                                            2. 당사는 천재지변, 불가항력적 사유, 이용자의 귀책사유 등으로 인해 발생한 손해에 대해서는 책임을 지지 않습니다.</p>

                                                                                                                                        <h3>제10조 분쟁의 해결</h3>
                                                                                                                                        <p>1. 본 약관에 명시되지 않은 사항은 관련 법령 및 상관례에 따릅니다.<br>
                                                                                                                                                2. 서비스 이용과 관련하여 회사와 회원 간에 분쟁이 발생한 경우, 회사의 본사 소재지를 관할하는 법원을 제1심의 관할법원으로 합니다.</p>

                                                                                                                                            <h3>부칙</h3>
                                                                                                                                            <p>본 약관은 2025년 5월 21일부터 시행됩니다.</p>
                                                                                                                                        </main>
                                                                                                                                    </div>
                                                                                                                                    <%@ include file="../WEB-INF/view/common/footer.jsp" %>
                                                                                                                                        <script
                                                                                                                                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                                                                                                                                        <script>
                                                                                                                                            window.addEventListener('scroll', () => {
                                                                                                                                                const remote = document.getElementById('remoteMenu');
                                                                                                                                                if (window.innerWidth > 768) {
                                                                                                                                                    remote.style.top = window.scrollY + 100 + 'px';
                                                                                                                                                }
                                                                                                                                            });

                                                                                                                                            document.addEventListener('DOMContentLoaded', function () {
                                                                                                                                                const popup = document.getElementById('popup');
                                                                                                                                                const overlay = document.getElementById('popupOverlay');
                                                                                                                                                const todayKey = 'hidePopupDate';
                                                                                                                                                const today = new Date().toLocaleDateString();

                                                                                                                                                if (localStorage.getItem(todayKey) !== today) {
                                                                                                                                                    popup.style.display = 'block';
                                                                                                                                                    overlay.style.display = 'block';
                                                                                                                                                }

                                                                                                                                                document
                                                                                                                                                    .getElementById('hideTodayBtn')
                                                                                                                                                    .addEventListener('click', function () {
                                                                                                                                                        localStorage.setItem(todayKey, today);
                                                                                                                                                        popup.style.display = 'none';
                                                                                                                                                        overlay.style.display = 'none';
                                                                                                                                                    });

                                                                                                                                                document
                                                                                                                                                    .getElementById('closeBtn')
                                                                                                                                                    .addEventListener('click', function () {
                                                                                                                                                        popup.style.display = 'none';
                                                                                                                                                        overlay.style.display = 'none';
                                                                                                                                                    });
                                                                                                                                            });
                                                                                                                                        </script>
                                                                                                                                    </body>
                                                                                                                                </html>