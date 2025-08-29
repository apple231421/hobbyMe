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
                            <title>HobbyMe</title>
                            <meta name="viewport" content="width=device-width, initial-scale=1">
                                <link
                                    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
                                    rel="stylesheet">
                                    <link
                                        rel="stylesheet"
                                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                                        <link rel="stylesheet" href="css/style.css"></head>
                                        <body>
                                            <%@ include file="WEB-INF/view/common/header.jsp" %>
                                                <%@ include file="WEB-INF/view/common/remote.jsp" %>
                                                    <%@ include file="WEB-INF/view/main/main.jsp" %>
                                                        <%@ include file="WEB-INF/view/common/footer.jsp" %>

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