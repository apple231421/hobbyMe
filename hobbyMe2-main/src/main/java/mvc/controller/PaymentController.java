package mvc.controller; // 실제 패키지명으로 바꿔주세요

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import mvc.model.BoardDAO;
import mvc.model.BoardDTO;

public class PaymentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String RequestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String command = RequestURI.substring(contextPath.length());

        response.setContentType("text/html; charset=utf-8");
        request.setCharacterEncoding("utf-8");

        if (command.equals("/ReservationViewAction.do")) { // 선택된 글 상자 페이지 가져오기
            requestReservationView(request);
            RequestDispatcher rd = request.getRequestDispatcher("/ReservationView.do");
            rd.forward(request, response);
        }else if (command.equals("/ReservationView.do")) { // 글 상세 페이지 출력
            RequestDispatcher rd = request.getRequestDispatcher("./payment/reservation.jsp");
            rd.forward(request, response);
        }else if (command.equals("/PaymentAction.do")) { // 결제페이지 출력
        	RequestDispatcher rd = request.getRequestDispatcher("./payment/payment.jsp");
        	rd.forward(request, response);
        }
        	
        	
 }

        public void requestReservationView(HttpServletRequest request) {
        	BoardDAO dao = BoardDAO.getInstance();
            
            int post_num = Integer.parseInt(request.getParameter("post_num"));
            
            BoardDTO reservationInfo = dao.getBoardByNum(post_num);

            request.setAttribute("post_num", post_num);
            request.setAttribute("reservationInfo", reservationInfo);
        }
    }