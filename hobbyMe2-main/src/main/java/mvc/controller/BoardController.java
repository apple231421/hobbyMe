package mvc.controller;

import java.io.IOException;
import java.util.ArrayList;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mvc.model.BoardDAO;
import mvc.model.BoardDTO;

public class BoardController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    static final int LISTCOUNT = 5;

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String RequestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String command = RequestURI.substring(contextPath.length());

        response.setContentType("text/html; charset=utf-8");
        request.setCharacterEncoding("utf-8");

        if (command.equals("/BoardListAction.do")) { // 등록된 글 목록 페이지 출력하기
            requestBoardList(request);
            RequestDispatcher rd = request.getRequestDispatcher("./board/list.jsp");
            rd.forward(request, response);
        } else if (command.equals("/BoardWriteForm.do")) { // 글 등록 페이지 출력
            
            RequestDispatcher rd = request.getRequestDispatcher("./board/writeForm.jsp");
            rd.forward(request, response);
        } else if (command.equals("/BoardWriteAction.do")) { // 새로운 글 등록
            requestBoardWrite(request);
            RequestDispatcher rd = request.getRequestDispatcher("/BoardListAction.do");
            rd.forward(request, response);
        } else if (command.equals("/BoardViewAction.do")) { // 선택된 글 상자 페이지 가져오기
            requestBoardView(request);
            RequestDispatcher rd = request.getRequestDispatcher("/BoardView.do");
            rd.forward(request, response);
        } else if (command.equals("/BoardView.do")) { // 글 상세 페이지 출력
            RequestDispatcher rd = request.getRequestDispatcher("./board/view.jsp");
            rd.forward(request, response);
        } else if (command.equals("/BoardUpdateAction.do")) { // 선택된 글 수정하기
            requestBoardUpdate(request);
            RequestDispatcher rd = request.getRequestDispatcher("/BoardListAction.do");
            rd.forward(request, response);
        } else if (command.equals("/BoardDeleteAction.do")) { // 선택된 글 삭제하기
            requestBoardDelete(request);
            RequestDispatcher rd = request.getRequestDispatcher("/BoardListAction.do");
            rd.forward(request, response);
        }
    }

    // 등록된 글 목록 가져오기
    public void requestBoardList(HttpServletRequest request) {
        BoardDAO dao = BoardDAO.getInstance();
        ArrayList<BoardDTO> boardlist = new ArrayList<BoardDTO>();

        int pageNum = 1;
        int limit = LISTCOUNT; // 한 페이지에 표시할 게시글 수

        // 페이지 번호 설정
        if (request.getParameter("pageNum") != null) {
            try {
                pageNum = Integer.parseInt(request.getParameter("pageNum"));
            } catch (NumberFormatException e) {
                pageNum = 1;
            }
        }

        // 검색 조건
        String items = request.getParameter("items");
        String text = request.getParameter("text");
        String sort = request.getParameter("sort");

        // 사용자 등급 확인
        HttpSession session = request.getSession();
        String userClass = (String) session.getAttribute("sessionClass");
        if (userClass == null) userClass = "U"; // 기본값: 일반 사용자

        // 게시글 수 및 목록 가져오기 (등급 고려)
        int total_record = dao.getListCount(items, text, userClass);
        boardlist = dao.getBoardList(pageNum, limit, items, text, sort, userClass);

        // boardlist null 방지
        if (boardlist == null) {
            boardlist = new ArrayList<>();
        }

        // 댓글 수 추가
        for (BoardDTO board : boardlist) {
            int commentCount = dao.getCommentCount(board.getPost_num());
            board.setComment_count(commentCount);
        }

        // 총 페이지 수 계산
        int total_page = (total_record / limit) + (total_record % limit == 0 ? 0 : 1);

        // request 속성 설정
        request.setAttribute("pageNum", pageNum);
        request.setAttribute("total_page", total_page);
        request.setAttribute("total_record", total_record);
        request.setAttribute("boardlist", boardlist);
    }


    // 인증된 사용자명 가져오기
    public void requestLoginName(HttpServletRequest request) {
        String id = request.getParameter("id");

        BoardDAO dao = BoardDAO.getInstance();

        String name = dao.getLoginNameById(id);

        request.setAttribute("name", name);
    }

    // 새로운 글 등록하기
    public void requestBoardWrite(HttpServletRequest request) {
        BoardDAO dao = BoardDAO.getInstance();

        // 새로운 BoardDTO 객체 생성
        BoardDTO board = new BoardDTO();
        
        // 요청 파라미터에서 값 가져오기
        board.setUser_id(request.getParameter("user_id")); // 사용자 아이디
        board.setTitle(request.getParameter("title")); // 제목
        board.setContent(request.getParameter("content")); // 내용
        board.setCategory(request.getParameter("category")); // 카테고리
        board.setTag(request.getParameter("tag")); // 태그
        board.setLocation(request.getParameter("location")); // 위치
        board.setPeople(Integer.parseInt(request.getParameter("people"))); // 인원 (숫자로 변환)
        board.setPrice(Integer.parseInt(request.getParameter("price"))); // 가격 (숫자로 변환)
        board.setThumbnail(request.getParameter("thumbnail")); // 썸네일 경로
        board.setImages(request.getParameter("images")); // 이미지 경로
        board.setDeleted("N"); // 삭제 여부 (기본값 'N')

        // 작성일 및 예약일 설정
        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        String created_date = formatter.format(new java.util.Date()); // 작성일자
        board.setCreated_date(created_date); // 게시글 작성일 설정
        board.setReservation_date(request.getParameter("reservation_date")); // 예약일 (사용자가 입력한 예약일자)
  
        // DB에 새 글 추가
        dao.insertBoard(board);
    }

    // 선택된 글 상세 페이지 가져오기
    public void requestBoardView(HttpServletRequest request) {
        BoardDAO dao = BoardDAO.getInstance();

        int post_num = Integer.parseInt(request.getParameter("post_num"));
        int pageNum = 1;

        // pageNum 예외 처리
        if (request.getParameter("pageNum") != null) {
            try {
                pageNum = Integer.parseInt(request.getParameter("pageNum"));
            } catch (NumberFormatException e) {
                pageNum = 1;
            }
        }

        BoardDTO board = dao.getBoardByNum(post_num);

        request.setAttribute("post_num", post_num);
        request.setAttribute("pageNum", pageNum);
        request.setAttribute("board", board); // ✅ board라는 이름으로 전달해야 JSP에서 받음
    }

    // 선택된 글 내용 수정하기
    public void requestBoardUpdate(HttpServletRequest request) {
        int post_num = Integer.parseInt(request.getParameter("post_num")); // 게시글 번호
        int pageNum = Integer.parseInt(request.getParameter("pageNum")); // 페이지 번호

        BoardDAO dao = BoardDAO.getInstance();

        // 수정할 게시글 객체 생성
        BoardDTO board = new BoardDTO();
        board.setPost_num(post_num); // 게시글 번호
        board.setUser_id(request.getParameter("user_id")); // 사용자 ID
        board.setTitle(request.getParameter("title")); // 제목
        board.setContent(request.getParameter("content")); // 내용
        board.setCategory(request.getParameter("category")); // 카테고리
        board.setTag(request.getParameter("tag")); // 태그
        board.setEnd_date(request.getParameter("end_date")); // 종료날짜
        board.setReservation_date(request.getParameter("reservation_date")); // 종료날짜
        board.setLocation(request.getParameter("location")); // 위치
        board.setPeople(Integer.parseInt(request.getParameter("people"))); // 인원 수
        board.setPrice(Integer.parseInt(request.getParameter("price"))); // 가격
        board.setThumbnail(request.getParameter("thumbnail")); // 썸네일 이미지 경로
        board.setImages(request.getParameter("images")); // 이미지 경로
        board.setDeleted(request.getParameter("deleted")); // 삭제 여부

        // 수정일자 생성
        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        String updated_date = formatter.format(new java.util.Date());
        board.setCreated_date(updated_date); // 수정된 날짜로 설정

        // 게시글 수정 DAO 호출
        dao.updateBoard(board);
    }

    // 선택된 글 삭제하기
    public void requestBoardDelete(HttpServletRequest request) {
        int post_num = Integer.parseInt(request.getParameter("post_num"));
        int pageNum = Integer.parseInt(request.getParameter("pageNum"));

        BoardDAO dao = BoardDAO.getInstance();
        dao.deleteBoard(post_num);
    }
}
