package mvc.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Date;
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import mvc.model.BoardDAO;
import mvc.model.BoardDTO;
import mvc.model.CommentDAO;
import mvc.model.CommentDTO;
import mvc.model.HobbyDAO;
import mvc.model.HobbyDTO;
import mvc.model.PaymentDAO;
import mvc.model.PaymentDTO;
import util.MailUtil;

@MultipartConfig
public class HobbyController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static final int LISTCOUNT = 10; 

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String RequestURI = request.getRequestURI();
		String contextPath = request.getContextPath();
		// '/login' 경로가 포함된 매핑으로 수정됨에 따라 잘라낼 부분 보정
        String command = RequestURI.substring((contextPath + "/login").length());
		
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("utf-8");
	
		if (command.equals("/downloadFile.do")) {
		    // ======================= 파일 다운로드 =======================
		    String fileName = request.getParameter("fileName");
		    if (fileName == null || fileName.trim().isEmpty()) {
		        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "파일명이 제공되지 않았습니다.");
		        return;
		    }

		    String UPLOAD_DIR = "/uploads";
		    String realPath = getServletContext().getRealPath(UPLOAD_DIR + File.separator + fileName);
		    File file = new File(realPath);

		    if (!file.exists()) {
		        response.sendError(HttpServletResponse.SC_NOT_FOUND, "파일을 찾을 수 없습니다.");
		        return;
		    }

		    String encodedFileName = URLEncoder.encode(file.getName(), "UTF-8").replaceAll("\\+", "%20");
		    response.setContentType("application/octet-stream");
		    response.setHeader("Content-Disposition", "attachment;filename=\"" + encodedFileName + "\"");
		    response.setContentLength((int) file.length());

		    try (BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
		         BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream())) {
		        byte[] buffer = new byte[4096];
		        int len;
		        while ((len = in.read(buffer)) != -1) {
		            out.write(buffer, 0, len);
		        }
		    }
		    return;
		    
		} else if (command.equals("/login.do")) {
		    // ======================= 로그인 =======================
		    String id = request.getParameter("id");
		    String password = request.getParameter("password");

		    HobbyDAO dao = HobbyDAO.getInstance();
		    boolean result = dao.validateUser(id, password);

		    if (result) {
		        request.getSession().setAttribute("sessionId", id);
		        request.getSession().setAttribute("sessionClass", dao.getUserById(id).getClasses());
		        response.sendRedirect(request.getContextPath() +"/index.jsp");
		    } else {
		        response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=1");
		    }

		} else if (command.equals("/login_home.do")) {
		    response.sendRedirect(request.getContextPath() +"/login/login.jsp");

		} else if (command.equals("/signup.do")) {
		    RequestDispatcher rd = request.getRequestDispatcher("/login/signup.jsp");
		    rd.forward(request, response);

		} else if (command.equals("/signupProcess.do")) {
		    String address = String.join("/",
		            request.getParameter("postcode"),
		            request.getParameter("address"),
		            request.getParameter("detailAddress"));
		    Date birthdate = Date.valueOf(request.getParameter("birthdate"));

		    HobbyDTO dto = new HobbyDTO();
		    dto.setUserId(request.getParameter("user_id"));
		    dto.setPassword(request.getParameter("password"));
		    dto.setName(request.getParameter("name"));
		    dto.setEmail(request.getParameter("email"));
		    dto.setPhone(request.getParameter("phone"));
		    dto.setAddress(address);
		    dto.setGender(request.getParameter("gender"));
		    dto.setBirthdate(birthdate);
		    dto.setClasses("U");

		    HobbyDAO.getInstance().insertUser(dto);
		    response.sendRedirect(request.getContextPath() +"/login/login.jsp?msg=success");

		} else if (command.equals("/updateMember.do")) {
		    // ======================= 회원 정보 수정 =======================
		    String sessionId = (String) request.getSession().getAttribute("sessionId");
		    HobbyDTO user = HobbyDAO.getInstance().getUserById(sessionId);
		    request.setAttribute("user", user);
		    RequestDispatcher rd = request.getRequestDispatcher("/login/updateMember.jsp");
		    rd.forward(request, response);

		} else if (command.equals("/updateProcess.do")) {
		    String address = String.join("/",
		            request.getParameter("postcode"),
		            request.getParameter("address"),
		            request.getParameter("detailAddress"));
		    Date birthdate = Date.valueOf(request.getParameter("birthdate"));

		    HobbyDTO dto = new HobbyDTO();
		    dto.setUserId(request.getParameter("user_id"));
		    dto.setEmail(request.getParameter("email"));
		    dto.setPhone(request.getParameter("phone"));
		    dto.setAddress(address);
		    dto.setGender(request.getParameter("gender"));
		    dto.setBirthdate(birthdate);

		    HobbyDAO.getInstance().updateUser(dto);
		    response.sendRedirect(request.getContextPath() +"/index.jsp");

		} else if (command.equals("/checkId.do")) {
		    // ======================= ID 중복 체크 =======================
		    String userId = request.getParameter("user_id");
		    HobbyDTO user = HobbyDAO.getInstance().getUserById(userId);
		    if (user != null && user.getUserId().equals(userId)) {
		        response.getWriter().write("duplicate");
		    } else {
		        response.getWriter().write("available");
		    }

		} else if (command.equals("/checkEmail.do")) {
		    // ======================= 이메일 중복 체크 =======================
		    String email = request.getParameter("email");
		    HobbyDTO user = HobbyDAO.getInstance().getUserByEmail(email);
		    if (user != null && user.getEmail().equals(email)) {
		        response.getWriter().write("duplicate");
		    } else {
		        response.getWriter().write("available");
		    }

		} else if (command.equals("/findId.do")) {
		    // ======================= ID 찾기 =======================
		    RequestDispatcher rd = request.getRequestDispatcher("/login/findId.jsp");
		    rd.forward(request, response);

		} else if (command.equals("/findIdProcess.do")) {
		    String name = request.getParameter("name");
		    String email = request.getParameter("email");

		    HobbyDAO dao = HobbyDAO.getInstance();
		    String userId = dao.findUserIdByNameAndEmail(name, email);

		    if (userId != null) {
		        response.sendRedirect(request.getContextPath() + "/login/login.jsp?foundId=" + URLEncoder.encode(userId, "UTF-8"));
		    } else {
		        response.sendRedirect(request.getContextPath() + "/login/login.jsp?findError=1");
		    }

		} else if (command.equals("/findPasswordProcess.do")) {
		    String userId = request.getParameter("user_id");
		    String email = request.getParameter("pw_email");

		    HobbyDAO dao = HobbyDAO.getInstance();
		    boolean exists = dao.checkUserIdAndEmail(userId, email);

		    if (exists) {
		        String token = UUID.randomUUID().toString();
		        dao.deleteToken(userId);
		        dao.saveResetToken(userId, token);

		        String link = "http://localhost:8080/hobbyMe/verifyToken.do?token=" + token;
		        String subject = "HobbyMe 비밀번호 재설정 링크입니다.";
		        String content = "아래 링크를 클릭하여 비밀번호를 재설정하세요:\n" + link;

		        MailUtil.send(email, subject, content);
		        response.sendRedirect(request.getContextPath() + "/login/login.jsp?msg=sent");
		    } else {
		        response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=1");
		    }

		} else if (command.equals("/verifyToken.do")) {
		    String token = request.getParameter("token");
		    String userId = HobbyDAO.getInstance().getUserIdByToken(token);

		    if (userId != null) {
		        HobbyDTO user = HobbyDAO.getInstance().getUserById(userId);
		        request.setAttribute("user_id", userId);
		        request.setAttribute("pre_password", user.getPassword());
		        RequestDispatcher rd = request.getRequestDispatcher("/login/resetPassword.jsp");
		        rd.forward(request, response);
		    } else {
		        response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=token");
		    }

		} else if (command.equals("/resetPasswordProcess.do")) {
		    String userId = request.getParameter("user_id");
		    String pw1 = request.getParameter("password");
		    String pw2 = request.getParameter("confirm_password");

		    if (pw1.equals(pw2)) {
		        HobbyDAO.getInstance().updatePassword(userId, pw1);
		        HobbyDAO.getInstance().deleteToken(userId);
		        response.sendRedirect(request.getContextPath() + "/login/login.jsp?reset=success");
		    } else {
		        response.sendRedirect(request.getContextPath() +"/login/resetPassword.jsp?error=nomatch");
		    }

		} else if (command.equals("/logout.do") || command.equals("/login/logout.do")) {
		    // ======================= 로그아웃 =======================
		    HttpSession session = request.getSession(false);
		    if (session != null) session.invalidate();

		    Cookie[] cookies = request.getCookies();
		    if (cookies != null) {
		        for (Cookie cookie : cookies) {
		            if ("JSESSIONID".equals(cookie.getName())) {
		                cookie.setValue("");
		                cookie.setMaxAge(0);
		                cookie.setPath("/hobbyMe");
		                response.addCookie(cookie);
		            }
		        }
		    }

		    response.sendRedirect(request.getContextPath() + "/login/login.jsp");

		} else if (command.equals("/myPage.do")) {
		    // ======================= 마이페이지 (관리자/사용자 공통) =======================
		    if ("A".equals(request.getSession().getAttribute("sessionClass"))) {
		        List<HobbyDTO> categoryList = HobbyDAO.getInstance().getAllCategories();
		        request.setAttribute("categoryList", categoryList);
		    }
		    RequestDispatcher rd = request.getRequestDispatcher("/login/myPage.jsp");
		    rd.forward(request, response);

		} else if (command.equals("/apply.do")) {
		    // ======================= 호스트 신청 =======================
			String sessionId = (String) request.getSession().getAttribute("sessionId");
			if (sessionId == null) {
				response.sendRedirect(request.getContextPath() + "/login/login.jsp");
				return;
			}

			HobbyDTO dto = HobbyDAO.getInstance().getUserById(sessionId);
			dto.setHostTitle(request.getParameter("title"));
			dto.setHostContent(request.getParameter("projectIdea"));

			String uploadPath = request.getServletContext().getRealPath("/uploads");
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists())
				uploadDir.mkdirs();

			Part filePart = request.getPart("applyFile");
			String fileName = getFilename(filePart);
			if (fileName != null && !fileName.isEmpty()) {
				filePart.write(uploadPath + File.separator + fileName);
				dto.setHostFile(fileName); // DB 저장용
			} else {
				dto.setHostFile(null);
			}

			HobbyDAO.getInstance().insertApply(dto);
			response.sendRedirect(request.getContextPath() + "/login/myPage.jsp?msg=success");
		} else if (command.equals("/hostApply.do")) {
		    // ======================= 호스트 신청서 조회 =======================
			int num = 0;
			String id = null;
			if (request.getParameter("num") != null && request.getParameter("id") != null) {
				num = Integer.parseInt(request.getParameter("num"));
				id = request.getParameter("id");
				HobbyDTO applyUser = HobbyDAO.getInstance().getApplyById(id, num);
				request.setAttribute("num", num);
				request.setAttribute("user", applyUser);
				RequestDispatcher rd = request.getRequestDispatcher("/login/applyed.jsp");
				rd.forward(request, response);
			} else {
				String sessionId = (String) request.getSession().getAttribute("sessionId");
				Boolean applyed = HobbyDAO.getInstance().checkApply(sessionId);
				if (applyed) {
					HobbyDTO applyUser = HobbyDAO.getInstance().getApplyById(sessionId, num);
					request.setAttribute("user", applyUser);
					RequestDispatcher rd = request.getRequestDispatcher("/login/applyed.jsp");
					rd.forward(request, response);
				} else {
					response.sendRedirect(request.getContextPath() + "/login/apply.jsp");
				}
			}
		} else if (command.equals("/approveHost.do")) {
		    HobbyDAO.getInstance().approveHost(request.getParameter("userId"),
		            Integer.parseInt(request.getParameter("num")));
		    response.sendRedirect(request.getContextPath() + "/login/showApply.do");

		} else if (command.equals("/rejectHost.do")) {
		    HobbyDAO.getInstance().rejectHost(request.getParameter("userId"),
		            Integer.parseInt(request.getParameter("num")));
		    response.sendRedirect(request.getContextPath() + "/login/showApply.do");

		} else if (command.equals("/showApply.do")) {
		    requestApplyList(request);
		    RequestDispatcher rd = request.getRequestDispatcher("/login/applyList.jsp");
		    rd.forward(request, response);

		} else if (command.equals("/addCategory.do")) {
		    String newCategory = request.getParameter("newCategory");
		    if (newCategory != null && !newCategory.trim().isEmpty()) {
		        HobbyDAO.getInstance().insertCategory(newCategory.trim());
		    }
		    response.sendRedirect(request.getContextPath() + "/login/myPage.do");

		} else if (command.equals("/deleteCategory.do")) {
		    String idParam = request.getParameter("categoryId");
		    if (idParam != null && !idParam.isEmpty()) {
		        int categoryId = Integer.parseInt(idParam);
		        HobbyDAO.getInstance().deleteCategory(categoryId);
		    }
		    response.sendRedirect(request.getContextPath() + "/login/myPage.do");

		} else if (command.equals("/deleteMember.do")) {
		    String sessionId = (String) request.getSession().getAttribute("sessionId");
		    HobbyDAO.getInstance().deleteMemberById(sessionId);
		    request.getSession().invalidate();

		    Cookie[] cookies = request.getCookies();
		    if (cookies != null) {
		        for (Cookie cookie : cookies) {
		            if ("JSESSIONID".equals(cookie.getName())) {
		                cookie.setValue("");
		                cookie.setMaxAge(0);
		                cookie.setPath("/hobbyMe");
		                response.addCookie(cookie);
		            }
		        }
		    }
		    response.sendRedirect(request.getContextPath() + "/index.jsp?msg=deleted");

		} else if (command.equals("/myProject.do")) {
		    myProjectList(request);
		    myPayMentList(request);
		    RequestDispatcher rd = request.getRequestDispatcher("/login/myProject.jsp");
		    rd.forward(request, response);

		} else if (command.equals("/myPaymentList.do")) {
		    myPayList(request);
		    RequestDispatcher rd = request.getRequestDispatcher("/login/myPaymentList.jsp");
		    rd.forward(request, response);

		} else if (command.equals("/showPayment.do")) {
		    adminPayMentList(request);
		    RequestDispatcher rd = request.getRequestDispatcher("/login/paymentList.jsp");
		    rd.forward(request, response);

		} else if (command.equals("/showReservation.do")) {
		    checkReservationView(request, response);
		    RequestDispatcher rd = request.getRequestDispatcher("/login/ReservationView.do");
		    rd.forward(request, response);
		} else if (command.equals("/ReservationView.do")) { // 예약글 상세 페이지 출력
			RequestDispatcher rd = request.getRequestDispatcher("/payment/reservation.jsp");
			rd.forward(request, response);
		} else if (command.equals("/BoardViewAction.do")) {
			requestBoardView(request);
			requestPaymentView(request);
			RequestDispatcher rd = request.getRequestDispatcher("/login/BoardView.do");
			rd.forward(request, response);

		} else if (command.equals("/BoardView.do")) {
			RequestDispatcher rd = request.getRequestDispatcher("/board/view.jsp");
			rd.forward(request, response);

		}
		
	}
	private String getFilename(Part part) {
		String contentDisposition = part.getHeader("content-disposition");
		for (String cd : contentDisposition.split(";")) {
			if (cd.trim().startsWith("filename")) {
				return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
			}
		}
		return null;
	}
	
	public void requestPaymentView(HttpServletRequest request) {
		try {
			HttpSession session = request.getSession();
			String userId = (String) session.getAttribute("sessionId");

			if (userId == null) {
				System.out.println("세션 만료 또는 로그인 정보 없음");
				return;
			}

			int post_num = Integer.parseInt(request.getParameter("post_num"));

			PaymentDAO dao = PaymentDAO.getInstance();
			PaymentDTO paymentInfo = dao.getPaymentByUserAndPost(userId, post_num);

			if (paymentInfo != null) {
				request.setAttribute("paymentInfo", paymentInfo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void requestBoardView(HttpServletRequest request) {
		BoardDAO dao = BoardDAO.getInstance();
		int post_num = Integer.parseInt(request.getParameter("post_num"));
		int pageNum = 1;

		if (request.getParameter("pageNum") != null) {
			try {
				pageNum = Integer.parseInt(request.getParameter("pageNum"));
			} catch (NumberFormatException e) {
				pageNum = 1;
			}
		}

		// 사용자 등급 확인 (관리자 여부)
		HttpSession session = request.getSession();
		String sessionClass = (String) session.getAttribute("sessionClass");
		boolean isAdmin = "A".equals(sessionClass);

		// 게시글 조회 (관리자는 삭제된 게시글도 조회)
		BoardDTO board = dao.getBoardByNum(post_num, isAdmin);

		if (board == null) {
			request.setAttribute("error", "해당 게시글을 찾을 수 없습니다.");
			request.setAttribute("post_num", post_num);
			request.setAttribute("pageNum", pageNum);
			return;
		}

		// 로그인한 사용자의 좋아요 여부 확인
		String sessionId = (String) session.getAttribute("sessionId");
		if (sessionId != null) {
			board.setUser_liked(dao.isLikedByUser(sessionId, post_num));
		}

		// 댓글 목록 가져오기
		List<CommentDTO> commentList = CommentDAO.getInstance().getCommentsByPostNum(post_num);

		// 결제 상태 확인 (해당 게시글에 대해 현재 로그인한 사용자의 예약 상태)
		if (sessionId != null) {
			PaymentDTO paymentInfo = PaymentDAO.getInstance().getPaymentByUserAndPost(sessionId, post_num);
			if (paymentInfo != null) {
				request.setAttribute("paymentInfo", paymentInfo);
			}
		}

		// JSP에 전달
		request.setAttribute("post_num", post_num);
		request.setAttribute("pageNum", pageNum);
		request.setAttribute("board", board);
		request.setAttribute("comments", commentList);
	}
	
	public void requestApplyList(HttpServletRequest request) {

		HobbyDAO dao = HobbyDAO.getInstance();
		ArrayList<HobbyDTO> applyList = new ArrayList<HobbyDTO>();

		int pageNum = 1;
		int limit = LISTCOUNT;

		if (request.getParameter("pageNum") != null)
			pageNum = Integer.parseInt(request.getParameter("pageNum"));

		String items = request.getParameter("items");
		String text = request.getParameter("text");

		int total_record = dao.getListCount(items, text);
		applyList = dao.getApplyList(pageNum, limit, items, text);

		int total_page;

		if (total_record % limit == 0) {
			total_page = total_record / limit;
			Math.floor(total_page);
		} else {
			total_page = total_record / limit;
			Math.floor(total_page);
			total_page = total_page + 1;
		}

		request.setAttribute("pageNum", pageNum);
		request.setAttribute("total_page", total_page);
		request.setAttribute("total_record", total_record);
		request.setAttribute("applyList", applyList);
	}
	
	public void myProjectList(HttpServletRequest request) {
	    HobbyDAO dao = HobbyDAO.getInstance();
	    
	    String id = (String) request.getSession().getAttribute("sessionId");

	    // 페이징 없이 전체 리스트 조회
	    ArrayList<HobbyDTO> myList = dao.getMyBoardList(id);

	    request.setAttribute("myList", myList);
	}
	
	public void myPayMentList(HttpServletRequest request) {
	    HobbyDAO dao = HobbyDAO.getInstance();
	    ArrayList<HobbyDTO> myPayList = new ArrayList<HobbyDTO>();
		String id = (String) request.getSession().getAttribute("sessionId");

	    myPayList = dao.getMyPaymentList(id); // 수정 필요: 검색 조건 없이 페이징된 리스트 가져오기

	    request.setAttribute("myPayList", myPayList);
	}
	
	public void adminPayMentList(HttpServletRequest request) {

		HobbyDAO dao = HobbyDAO.getInstance();
		ArrayList<HobbyDTO> paymentList = new ArrayList<HobbyDTO>();

		int pageNum = 1;
		int limit = LISTCOUNT;

		if (request.getParameter("pageNum") != null)
			pageNum = Integer.parseInt(request.getParameter("pageNum"));

		String items = request.getParameter("items");
		String text = request.getParameter("text");

		int total_record = dao.getPaymentListCount(items, text);
		paymentList = dao.getPaymentList(pageNum, limit, items, text);

		int total_page;

		if (total_record % limit == 0) {
			total_page = total_record / limit;
			Math.floor(total_page);
		} else {
			total_page = total_record / limit;
			Math.floor(total_page);
			total_page = total_page + 1;
		}

		request.setAttribute("pageNum", pageNum);
		request.setAttribute("total_page", total_page);
		request.setAttribute("total_record", total_record);
		request.setAttribute("paymentList", paymentList);
	}
	
	public void checkReservationView(HttpServletRequest request, HttpServletResponse response) {
		
		try {
	        String userId = request.getParameter("id");

	        if (userId == null) {
	            System.out.println("세션이 만료되었습니다. 로그인 후 다시 시도해주세요.");
	            response.sendRedirect(request.getContextPath() + "/login/login.jsp");
	            return; // 더 이상 아래 로직이 실행되지 않도록 종료
	        } 
	        
		BoardDAO dao = BoardDAO.getInstance();

		int post_num = Integer.parseInt(request.getParameter("post_num"));

		BoardDTO reservationInfo = dao.getBoardByNum(post_num);

		request.setAttribute("post_num", post_num);
		request.setAttribute("reservationInfo", reservationInfo);
		

		HobbyDAO userDao = HobbyDAO.getInstance();
		HobbyDTO loginUser = userDao.getUserById(userId);
		
		request.setAttribute("loginUser", loginUser);
		
		} catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
	public void myPayList(HttpServletRequest request) {

		HobbyDAO dao = HobbyDAO.getInstance();
		ArrayList<HobbyDTO> paymentList = new ArrayList<HobbyDTO>();

		int pageNum = 1;
		int limit = LISTCOUNT;
		String sessionId = (String) request.getSession().getAttribute("sessionId");

		if (request.getParameter("pageNum") != null)
			pageNum = Integer.parseInt(request.getParameter("pageNum"));

		String items = request.getParameter("items");
		String text = request.getParameter("text");

		int total_record = dao.getMyPayListCount(items, text,sessionId);
		paymentList = dao.getMyPayList(pageNum, limit, items, text, sessionId);

		int total_page;

		if (total_record % limit == 0) {
			total_page = total_record / limit;
			Math.floor(total_page);
		} else {
			total_page = total_record / limit;
			Math.floor(total_page);
			total_page = total_page + 1;
		}

		request.setAttribute("pageNum", pageNum);
		request.setAttribute("total_page", total_page);
		request.setAttribute("total_record", total_record);
		request.setAttribute("paymentList", paymentList);
	}
}
