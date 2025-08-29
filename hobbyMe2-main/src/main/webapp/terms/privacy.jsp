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
                            <title>개인정보 처리방침</title>
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
                                                            <h1>개인정보 처리방침</h1>
                                                            <p>HobbyMe(이하 "회사")는 「개인정보 보호법」 등 관련 법령을 준수하며, 이용자의 개인정보를 소중하게 보호합니다. 본 방침은 회사가
                                                                운영하는 웹사이트 및 서비스에서 수집하는 개인정보의 처리방침을 명시합니다.</p>

                                                            <h3>제1조 수집하는 개인정보 항목 및 수집 방법</h3>
                                                            <p>회사는 다음과 같은 개인정보를 수집합니다.</p>
                                                            <p>1. 회원 가입 시: 이름, 이메일 주소, 비밀번호, 휴대폰 번호<br>
                                                                    2. 서비스 이용 시: 접속 IP, 쿠키, 방문 일시, 서비스 이용 기록, 기기 정보<br>
                                                                        3. 선택 수집: 닉네임, 프로필 사진, 생년월일, 성별, 관심 카테고리</p>

                                                                    <h3>제2조 개인정보의 수집 및 이용 목적</h3>
                                                                    <p>회사는 수집한 개인정보를 다음의 목적에 따라 이용합니다.</p>
                                                                    <p>1. 회원 식별 및 가입 절차, 본인 확인<br>
                                                                            2. 콘텐츠 추천, 맞춤형 서비스 제공<br>
                                                                                3. 고객 문의 및 민원 처리<br>
                                                                                    4. 마케팅, 이벤트 정보 제공 (사전 동의 시)<br>
                                                                                        5. 법령상 의무 이행 및 분쟁 조정을 위한 기록 보존</p>

                                                                                    <h3>제3조 개인정보의 보유 및 이용기간</h3>
                                                                                    <p>회사는 수집한 개인정보를 다음과 같은 기준으로 보유 및 이용합니다.</p>
                                                                                    <p>1. 회원 탈퇴 시까지 보유하되, 관련 법령에 따라 보존이 필요한 경우에는 예외로 합니다.<br>
                                                                                            2. 전자상거래 등에서의 소비자 보호에 관한 법률에 의한 보존:
                                                                                            <br>
                                                                                                - 계약 또는 청약철회 등에 관한 기록: 5년
                                                                                                <br>
                                                                                                    - 소비자의 불만 또는 분쟁처리에 관한 기록: 3년
                                                                                                    <br>
                                                                                                        - 표시/광고에 관한 기록: 6개월</p>

                                                                                                    <h3>제4조 개인정보의 제3자 제공</h3>
                                                                                                    <p>회사는 이용자의 동의 없이 개인정보를 외부에 제공하지 않습니다. 단, 다음의 경우는 예외로 합니다.</p>
                                                                                                    <p>1. 이용자가 사전에 동의한 경우<br>
                                                                                                            2. 법령에 의하여 제공이 요구되는 경우<br>
                                                                                                                3. 수사기관의 요청에 따라 절차에 따른 제공이 필요한 경우</p>

                                                                                                            <h3>제5조 개인정보 처리의 위탁</h3>
                                                                                                            <p>회사는 원활한 업무 수행을 위해 일부 서비스를 외부 업체에 위탁할 수 있으며, 이 경우 관련 내용을 고지하고 필요한 계약을 체결합니다.</p>
                                                                                                            <p>1. 위탁 대상: 클라우드 서버 운영, 고객센터 시스템 운영 등<br>
                                                                                                                    2. 위탁 업체명 및 내용은 홈페이지를 통해 별도 안내합니다.</p>

                                                                                                                <h3>제6조 개인정보 파기 절차 및 방법</h3>
                                                                                                                <p>1. 수집된 개인정보는 보유기간의 경과, 처리 목적 달성 시 지체 없이 파기합니다.<br>
                                                                                                                        2. 전자적 파일: 복구 불가능한 기술적 방법으로 영구 삭제<br>
                                                                                                                            3. 종이 문서: 파쇄 또는 소각 방식으로 폐기</p>

                                                                                                                        <h3>제7조 이용자의 권리와 행사 방법</h3>
                                                                                                                        <p>1. 이용자는 언제든지 본인의 개인정보 열람, 수정, 삭제, 처리 정지를 요청할 수 있습니다.<br>
                                                                                                                                2. 개인정보 열람 및 수정은 마이페이지 또는 고객센터를 통해 요청 가능하며, 삭제 요청 시 회사는 즉시 조치합니다.<br>
                                                                                                                                    3. 개인정보 보호법 등 관련 법령에 따라 제한이 있을 수 있습니다.</p>

                                                                                                                                <h3>제8조 쿠키(Cookie)의 사용</h3>
                                                                                                                                <p>1. 회사는 맞춤형 서비스 제공을 위해 쿠키를 사용할 수 있습니다.<br>
                                                                                                                                        2. 이용자는 브라우저 설정을 통해 쿠키 저장을 거부할 수 있습니다. 단, 이 경우 일부 서비스 이용에 제한이 있을 수 있습니다.</p>

                                                                                                                                    <h3>제9조 개인정보 보호책임자</h3>
                                                                                                                                    <p>회사는 개인정보 보호에 대한 책임을 지며, 아래와 같이 개인정보 보호책임자를 지정합니다.</p>
                                                                                                                                    <p>▶ 개인정보 보호책임자<br>
                                                                                                                                            - 성명: 박진우<br>
                                                                                                                                                - 이메일: privacy@hobbyme.co.kr<br>
                                                                                                                                                    - 전화번호: 1600-1234</p>

                                                                                                                                                <h3>제10조 고지의 의무</h3>
                                                                                                                                                <p>본 개인정보 처리방침은 2025년 5월 21일부터 적용됩니다. 내용 추가, 삭제 및 수정이 있을 시에는 시행 최소 7일 전부터 공지사항을
                                                                                                                                                    통해 고지합니다.</p>

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