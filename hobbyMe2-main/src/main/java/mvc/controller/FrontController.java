package mvc.controller;

import jakarta.servlet.annotation.MultipartConfig;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;
import java.text.SimpleDateFormat;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
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
import mvc.model.CouponDAO;
import mvc.model.CouponDTO;
import mvc.controller.PostCleanupScheduler;
import util.MailUtil;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
		maxFileSize = 1024 * 1024 * 5, // 5MB
		maxRequestSize = 1024 * 1024 * 10 // 10MB
)

public class FrontController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static final int LISTCOUNT = 8;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String RequestURI = request.getRequestURI();
		String contextPath = request.getContextPath();
		String command = RequestURI.substring(contextPath.length());

		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("utf-8");

		if (command.equals("/downloadFile.do")) {
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
		} else if (command.startsWith("/login/")) {
			command = command.substring(("/login").length());
			if (command.equals("/login.do")) {
				// ======================= 로그인 =======================
				String id = request.getParameter("id");
				String password = request.getParameter("password");

				HobbyDAO dao = HobbyDAO.getInstance();
				boolean result = dao.validateUser(id, password);

				if (result) {
					request.getSession().setAttribute("sessionId", id);
					request.getSession().setAttribute("sessionClass", dao.getUserById(id).getClasses());
					response.sendRedirect(request.getContextPath() + "/index.jsp");
				} else {
					response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=1");
				}

			} else if (command.equals("/login_home.do")) {
				response.sendRedirect(request.getContextPath() + "/login/login.jsp");

			} else if (command.equals("/signup.do")) {
				RequestDispatcher rd = request.getRequestDispatcher("/login/signup.jsp");
				rd.forward(request, response);

			} else if (command.equals("/signupProcess.do")) {
				String address = String.join("/", request.getParameter("postcode"), request.getParameter("address"),
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
				response.sendRedirect(request.getContextPath() + "/login/login.jsp?msg=success");

			} else if (command.equals("/updateMember.do")) {
				// ======================= 회원 정보 수정 =======================
				String sessionId = (String) request.getSession().getAttribute("sessionId");
				HobbyDTO user = HobbyDAO.getInstance().getUserById(sessionId);
				request.setAttribute("user", user);
				RequestDispatcher rd = request.getRequestDispatcher("/login/updateMember.jsp");
				rd.forward(request, response);

			} else if (command.equals("/updateProcess.do")) {
				String address = String.join("/", request.getParameter("postcode"), request.getParameter("address"),
						request.getParameter("detailAddress"));
				Date birthdate = Date.valueOf(request.getParameter("birthdate"));

				HobbyDTO dto = new HobbyDTO();
				dto.setUserId(request.getParameter("user_id"));
				dto.setPhone(request.getParameter("phone"));
				dto.setAddress(address);
				dto.setGender(request.getParameter("gender"));
				dto.setBirthdate(birthdate);

				HobbyDAO.getInstance().updateUser(dto);
				response.sendRedirect(request.getContextPath() + "/index.jsp");

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
					response.sendRedirect(request.getContextPath() + "/login/login.jsp?foundId="
							+ URLEncoder.encode(userId, "UTF-8"));
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

					String link = "http://localhost:8080/hobbyMe/login/verifyToken.do?token=" + token;
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
					response.sendRedirect(request.getContextPath() + "/login/resetPassword.jsp?error=nomatch");
				}

			} else if (command.equals("/logout.do") || command.equals("/login/logout.do")) {
				// ======================= 로그아웃 =======================
				HttpSession session = request.getSession(false);
				if (session != null)
					session.invalidate();

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
					Boolean already = HobbyDAO.getInstance().checkApplyed(sessionId);
					if (applyed) {
						HobbyDTO applyUser = HobbyDAO.getInstance().getApplyById(sessionId, num);
						request.setAttribute("user", applyUser);
						RequestDispatcher rd = request.getRequestDispatcher("/login/applyed.jsp");
						rd.forward(request, response);
					} else {
						if (already) {
							response.sendRedirect(request.getContextPath() + "/login/myPage.jsp?msg=already");
						} else {
							response.sendRedirect(request.getContextPath() + "/login/apply.jsp");
						}
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

			} else if (command.equals("/showPaymentConfim.do")) {
				confirmPaymentView(request);
				RequestDispatcher rd = request.getRequestDispatcher("/payment/adminCheckReservation.jsp");
				rd.forward(request, response);

			} else if (command.equals("/showReservation.do")) { // 일반유저 마이페이지에서 결제내역 확인
				checkReservationView(request, response);
				RequestDispatcher rd = request.getRequestDispatcher("/login/ReservationView.do");
				rd.forward(request, response);
			} else if (command.equals("/ReservationView.do")) { // 예약글 상세 페이지 출력
				requestPaymentView(request);
				RequestDispatcher rd = request.getRequestDispatcher("/payment/reservation.jsp");
				rd.forward(request, response);
			} else if (command.equals("/PaymentAction.do")) { // 송금하기 뷰 보여주기
				requestSaveReservation(request, response);
				RequestDispatcher rd = request.getRequestDispatcher("/payment/bankpayment.jsp");
				rd.forward(request, response);	
				
			} else if (command.equals("/myCouponList.do")) {
				myCouponList(request);
				RequestDispatcher rd = request.getRequestDispatcher("/login/myCouponList.jsp");
				rd.forward(request, response);
			} else if (command.equals("/checkCouponList.do")) {
				adminCouponList(request);
				RequestDispatcher rd = request.getRequestDispatcher("/login/couponList.jsp");
				rd.forward(request, response);
			} else if (command.equals("/deleteCoupon.do")) {
				String couponId = request.getParameter("couponId");
				HobbyDAO.deleteCouponById(Integer.parseInt(couponId));
				response.sendRedirect(request.getContextPath() + "/login/checkCouponList.do");
			}
			// ========== 회원 관련 ==========
			
			// ========== 게시판 관련 ==========
		} else if (command.equals("/BoardView.do")) {
			RequestDispatcher rd = request.getRequestDispatcher("/board/view.jsp");
			rd.forward(request, response);

		} else if (command.equals("/BoardListAction.do")) {

			requestBoardList(request);
			RequestDispatcher rd = request.getRequestDispatcher("./board/list.jsp");
			rd.forward(request, response);
		} else if (command.equals("/BoardWriteForm.do")) {
			List<String> categories = BoardDAO.getInstance().getAllCategories();
			request.setAttribute("categories", categories);
			RequestDispatcher rd = request.getRequestDispatcher("./board/writeForm.jsp");
			rd.forward(request, response);

		} else if (command.equals("/BoardWriteAction.do")) {
			requestBoardWrite(request);
			RequestDispatcher rd = request.getRequestDispatcher("/BoardListAction.do");
			rd.forward(request, response);

		} else if (command.equals("/BoardViewAction.do")) {
			requestBoardView(request);
			requestPaymentView(request);
			RequestDispatcher rd = request.getRequestDispatcher("/BoardView.do");
			rd.forward(request, response);

		} else if (command.equals("/BoardView.do")) {
			RequestDispatcher rd = request.getRequestDispatcher("./board/view.jsp");
			rd.forward(request, response);

		} else if (command.equals("/BoardUpdateAction.do")) {
			try {
				requestBoardUpdate(request);
				RequestDispatcher rd = request.getRequestDispatcher("/BoardListAction.do");
				rd.forward(request, response);
			} catch (Exception e) {
				e.printStackTrace();
				response.sendRedirect(request.getContextPath() + "/errorPage.jsp"); // 에러 페이지로 리디렉션
			}

		} else if (command.equals("/BoardDeleteAction.do")) {
			requestBoardDelete(request);
			RequestDispatcher rd = request.getRequestDispatcher("/BoardListAction.do");
			rd.forward(request, response);
		} else if (command.equals("/BoardUpdateForm.do")) {
			int post_num = Integer.parseInt(request.getParameter("post_num"));
			BoardDAO dao = BoardDAO.getInstance();
			BoardDTO board = dao.getBoardByNum(post_num);

			List<String> categories = BoardDAO.getInstance().getAllCategories();
			request.setAttribute("categories", categories);
			request.setAttribute("board", board);

			RequestDispatcher rd = request.getRequestDispatcher("./board/updateBoardForm.jsp");
			rd.forward(request, response);

		} else if (command.equals("/BoardLikeAction.do")) {
			String sessionId = (String) request.getSession().getAttribute("sessionId");

			if (sessionId == null || sessionId.isEmpty()) {
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				return;
			}

			int postNum = Integer.parseInt(request.getParameter("post_num"));

			BoardDAO dao = BoardDAO.getInstance();
			boolean userLiked = dao.toggleLike(postNum, sessionId);

			// 변경된 게시글 정보 다시 조회해서 board_like를 최신값으로 가져옴
			int likeCount = dao.getBoardByNum(postNum).getBoard_like();

			response.setContentType("application/json;charset=UTF-8");
			response.getWriter().write("{\"likeCount\":" + likeCount + ",\"userLiked\":" + userLiked + "}");

		} else if (command.equals("/commentAdd.do")) {
			String sessionId = (String) request.getSession().getAttribute("sessionId");
			int postNum = Integer.parseInt(request.getParameter("post_num"));
			String content = request.getParameter("content");

			CommentDTO dto = new CommentDTO();
			dto.setPost_num(postNum);
			dto.setUser_id(sessionId);
			dto.setContent(content);

			CommentDAO.getInstance().insertComment(dto);
			response.sendRedirect("BoardViewAction.do?post_num=" + postNum);
		} else if (command.equals("/commentDelete.do")) {
			String sessionId = (String) request.getSession().getAttribute("sessionId");
			if (sessionId == null) {
				response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=login_required");
				return;
			}

			int commentId = Integer.parseInt(request.getParameter("comment_id"));
			int postNum = Integer.parseInt(request.getParameter("post_num"));

			CommentDAO.getInstance().deleteComment(commentId);
			response.sendRedirect("BoardViewAction.do?post_num=" + postNum);
		} else if (command.equals("/commentUpdate.do")) {
			String sessionId = (String) request.getSession().getAttribute("sessionId");
			if (sessionId == null) {
				response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=login_required");
				return;
			}

			int commentId = Integer.parseInt(request.getParameter("comment_id"));
			int postNum = Integer.parseInt(request.getParameter("post_num"));
			String content = request.getParameter("content");

			if (content == null || content.trim().isEmpty()) {
				response.sendRedirect("BoardViewAction.do?post_num=" + postNum + "&error=empty_comment");
				return;
			}

			CommentDTO comment = new CommentDTO();
			comment.setComment_id(commentId);
			comment.setContent(content);

			CommentDAO.getInstance().updateComment(comment);
			response.sendRedirect("BoardViewAction.do?post_num=" + postNum);
		} else if (command.equals("/BoardRestoreAction.do")) {
			int post_num = Integer.parseInt(request.getParameter("post_num"));
			BoardDAO.getInstance().restoreBoard(post_num); // 복구 DAO 호출
			response.sendRedirect("BoardViewAction.do?post_num=" + post_num);

		} else if (command.equals("/index.do")) {
			BoardDAO dao = BoardDAO.getInstance();

			List<BoardDTO> popularList = dao.getTopLikedBoards(4);
			List<BoardDTO> recentList = dao.getRecentBoards(4);

			request.setAttribute("popularList", popularList);
			request.setAttribute("recentList", recentList);

			RequestDispatcher rd = request.getRequestDispatcher("/index.jsp");
			rd.forward(request, response);
		}

		else if (command.equals("/ReservationViewAction.do")) { // 예약글 상자 페이지 가져오기
			// $$$$$$$$$$$$$$$$$ 예약 관련 $$$$$$$$$$$$$$$$$
			HttpSession session = request.getSession();
			String userId = (String) session.getAttribute("sessionId");

			if (userId == null) {
				response.sendRedirect(request.getContextPath() + "/login/login.jsp");
				return;
			}
			requestPaymentView(request);
			requestReservationView(request);
			RequestDispatcher rd = request.getRequestDispatcher("/ReservationView.do");
			rd.forward(request, response);
		} else if (command.equals("/ReservationView.do")) { // 예약글 상세 페이지 출력
			RequestDispatcher rd = request.getRequestDispatcher("./payment/reservation.jsp");
			rd.forward(request, response);

		} else if (command.equals("/PaymentAction.do")) { // 송금하기 뷰 보여주기
			requestSaveReservation(request, response);
			RequestDispatcher rd = request.getRequestDispatcher("./payment/bankpayment.jsp");
			rd.forward(request, response);

		} else if (command.equals("/BankDepositAction.do")) {
			PaymentComplete(request);
			RequestDispatcher rd = request.getRequestDispatcher("./payment/success.jsp");
			rd.forward(request, response);
		} else if (command.equals("/ConfirmPaymentAction.do")) {
			ConfirmPayment(request);
			RequestDispatcher rd = request.getRequestDispatcher("/login/showPayment.do");
			rd.forward(request, response);
		} else if (command.equals("/CouponListPopup.do")) {

			// CouponCouponCoupon 쿠폰 관련 CouponCouponCoupon
			requestCouponList(request);
			RequestDispatcher rd = request.getRequestDispatcher("/payment/couponPopup.jsp");
			rd.forward(request, response);
		} else if (command.equals("/ViewReservation.do")) { // 일반유저 마이페이지에서 결제내역 확인
			checkReservationView(request, response);
			requestPaymentView(request);
			RequestDispatcher rd = request.getRequestDispatcher("/payment/reservation.jsp");
			rd.forward(request, response);
		}
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

		int total_record = dao.getMyPayListCount(items, text, sessionId);
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

	public void myCouponList(HttpServletRequest request) {

		HobbyDAO dao = HobbyDAO.getInstance();
		ArrayList<HobbyDTO> couponList = new ArrayList<HobbyDTO>();

		int pageNum = 1;
		int limit = LISTCOUNT;
		String sessionId = (String) request.getSession().getAttribute("sessionId");

		if (request.getParameter("pageNum") != null)
			pageNum = Integer.parseInt(request.getParameter("pageNum"));

		String items = request.getParameter("items");
		String text = request.getParameter("text");

		int total_record = dao.getMyCouponListCount(items, text, sessionId);
		couponList = dao.getMyCouponList(pageNum, limit, items, text, sessionId);

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
		request.setAttribute("couponList", couponList);
	}

	public void adminCouponList(HttpServletRequest request) {

		HobbyDAO dao = HobbyDAO.getInstance();
		ArrayList<HobbyDTO> couponList = new ArrayList<HobbyDTO>();

		int pageNum = 1;
		int limit = LISTCOUNT;

		if (request.getParameter("pageNum") != null)
			pageNum = Integer.parseInt(request.getParameter("pageNum"));

		String items = request.getParameter("items");
		String text = request.getParameter("text");

		int total_record = dao.getCouponListCount(items, text);
		couponList = dao.getCouponList(pageNum, limit, items, text);

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
		request.setAttribute("couponList", couponList);
	}

	// ======================= Board 관련 메서드 =======================

	public void requestBoardList(HttpServletRequest request) {
		BoardDAO dao = BoardDAO.getInstance();
		ArrayList<BoardDTO> boardlist;

		int pageNum = 1;
		int limit = LISTCOUNT;

		if (request.getParameter("pageNum") != null) {
			try {
				pageNum = Integer.parseInt(request.getParameter("pageNum"));
			} catch (NumberFormatException e) {
				pageNum = 1;
			}
		}

		String items = request.getParameter("items");
		String text = request.getParameter("text");
		String sort = request.getParameter("sort");

		// 세션에서 사용자 등급 정보 가져오기
		HttpSession session = request.getSession();
		String userClass = (String) session.getAttribute("sessionClass");
		if (userClass == null)
			userClass = "U"; // 비로그인 시 일반 사용자로 간주

		// 게시글 목록 및 개수 가져오기 (DAO에서 등급에 따라 필터링)
		int total_record = dao.getListCount(items, text, userClass);
		boardlist = dao.getBoardList(pageNum, limit, items, text, sort, userClass);

		// 댓글 수 및 D-day 계산
		for (BoardDTO board : boardlist) {
			int commentCount = dao.getCommentCount(board.getPost_num());
			board.setComment_count(commentCount);

			// 마감 여부는 이미 DAO에서 expired 필드로 설정됨
			// 여기서 추가적인 마감 판단은 불필요
		}

		int total_page = (total_record / limit) + (total_record % limit == 0 ? 0 : 1);

		request.setAttribute("pageNum", pageNum);
		request.setAttribute("total_page", total_page);
		request.setAttribute("total_record", total_record);
		request.setAttribute("boardlist", boardlist);
	}

	public void requestBoardWrite(HttpServletRequest request) {
		try {
			HttpSession session = request.getSession();
			String user_id = (String) session.getAttribute("sessionId");

			if (user_id == null) {
				System.out.println("로그인 정보가 없습니다.");
				return;
			}

			BoardDAO dao = BoardDAO.getInstance();
			BoardDTO board = new BoardDTO();

			board.setUser_id(user_id);
			board.setTitle(request.getParameter("title"));
			board.setContent(request.getParameter("content"));
			board.setCategory(request.getParameter("category"));

			// ✅ 태그 처리
			String rawTag = request.getParameter("tag");
			board.setTag(formatTags(rawTag));

			board.setLocation(request.getParameter("location"));

			// ✅ 숫자 파싱 시 예외 방지
			try {
				board.setPeople(Integer.parseInt(request.getParameter("people")));
			} catch (NumberFormatException e) {
				board.setPeople(0);
			}

			try {
				board.setPrice(Integer.parseInt(request.getParameter("price")));
			} catch (NumberFormatException e) {
				board.setPrice(0);
			}

			board.setDeleted("N");

			try {
				board.setLat(Double.parseDouble(request.getParameter("lat")));
				board.setLng(Double.parseDouble(request.getParameter("lng")));
			} catch (NumberFormatException e) {
				board.setLat(0.0);
				board.setLng(0.0);
			}

			String created_date = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new java.util.Date());
			board.setCreated_date(created_date);
			board.setReservation_date(request.getParameter("reservation_date"));
			board.setEnd_date(request.getParameter("end_date"));

			// ✅ 파일 업로드 경로
			String uploadPath = request.getServletContext().getRealPath("/uploads");
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists())
				uploadDir.mkdirs();

			// ✅ 썸네일
			Part thumbnailPart = request.getPart("thumbnailFile");
			String thumbnailName = getFilename(thumbnailPart);
			if (thumbnailName != null && !thumbnailName.isEmpty()) {
				thumbnailPart.write(uploadPath + File.separator + thumbnailName);
				board.setThumbnail(thumbnailName);
			}

			// ✅ 다중 이미지
			Collection<Part> parts = request.getParts();
			List<String> imageNames = new ArrayList<>();
			for (Part part : parts) {
				if ("imageFile".equals(part.getName())) {
					String imageName = getFilename(part);
					if (imageName != null && !imageName.isEmpty()) {
						part.write(uploadPath + File.separator + imageName);
						imageNames.add(imageName);
					}
				}
			}
			if (!imageNames.isEmpty()) {
				board.setImages(String.join(",", imageNames));
			}

			dao.insertBoard(board);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// ✅ 태그 전처리 함수: 공백 제거 + 중복 제거 + # 붙여서 반환
	private String formatTags(String rawTag) {
		if (rawTag == null || rawTag.trim().isEmpty())
			return null;

		String[] tags = rawTag.split(",");
		Set<String> uniqueTags = new LinkedHashSet<>();
		for (String tag : tags) {
			String cleaned = tag.trim().replaceAll("#", "");
			if (!cleaned.isEmpty()) {
				uniqueTags.add(cleaned);
			}
		}
		if (uniqueTags.isEmpty())
			return null;

		return uniqueTags.stream().map(tag -> "#" + tag).collect(Collectors.joining(","));
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

	@Override
	public void init() throws ServletException {
		super.init();
		PostCleanupScheduler.start(); // ✅ 이렇게 수정
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

	    HttpSession session = request.getSession();
	    String sessionClass = (String) session.getAttribute("sessionClass");
	    boolean isAdmin = "A".equals(sessionClass);

	    BoardDTO board = dao.getBoardByNum(post_num, isAdmin);

	    if (board == null) {
	        request.setAttribute("error", "해당 게시글을 찾을 수 없습니다.");
	        request.setAttribute("post_num", post_num);
	        request.setAttribute("pageNum", pageNum);
	        return;
	    }

	    String sessionId = (String) session.getAttribute("sessionId");
	    if (sessionId != null) {
	        board.setUser_liked(dao.isLikedByUser(sessionId, post_num));
	    }

	    // ✅ 현재 확정된 예약 인원 수 조회 → DTO에 저장
	    int reservedCount = PaymentDAO.getInstance().getConfirmedReservationCount(post_num);
	    board.setReserved(reservedCount);

	    // ✅ 댓글 목록 조회
	    List<CommentDTO> commentList = CommentDAO.getInstance().getCommentsByPostNum(post_num);

	    // ✅ 로그인 사용자의 예약 정보 확인
	    if (sessionId != null) {
	        PaymentDTO paymentInfo = PaymentDAO.getInstance().getPaymentByUserAndPost(sessionId, post_num);
	        if (paymentInfo != null) {
	            request.setAttribute("paymentInfo", paymentInfo);
	        }
	    }

	    // ✅ JSP 전달 데이터 설정
	    request.setAttribute("post_num", post_num);
	    request.setAttribute("pageNum", pageNum);
	    request.setAttribute("board", board);
	    request.setAttribute("comments", commentList);
	}



	public void requestBoardUpdate(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String loggedInUserId = (String) session.getAttribute("sessionId");

		int post_num = Integer.parseInt(request.getParameter("post_num"));
		BoardDAO dao = BoardDAO.getInstance();
		BoardDTO board = dao.getBoardByNum(post_num);

		board.setPost_num(post_num);
		board.setUser_id(request.getParameter("user_id"));
		board.setTitle(request.getParameter("title"));
		board.setContent(request.getParameter("content"));
		board.setCategory(request.getParameter("category"));

		// 태그 자동 #처리
		String rawTag = request.getParameter("tag");
		if (rawTag != null && !rawTag.trim().isEmpty()) {
			String[] tags = rawTag.split(",");
			Set<String> uniqueTags = new LinkedHashSet<>();
			for (String tag : tags) {
				String trimmed = tag.trim();
				if (!trimmed.isEmpty()) {
					uniqueTags.add(trimmed);
				}
			}
			String formattedTag = uniqueTags.stream().map(t -> "#" + t).collect(Collectors.joining(","));
			board.setTag(formattedTag);
		} else {
			board.setTag(null);
		}

		board.setEnd_date(request.getParameter("end_date"));
		board.setReservation_date(request.getParameter("reservation_date"));
		board.setLocation(request.getParameter("location"));
		board.setPeople(Integer.parseInt(request.getParameter("people")));
		board.setPrice(Integer.parseInt(request.getParameter("price")));
		board.setDeleted("N");
		board.setLat(Double.parseDouble(request.getParameter("lat")));
		board.setLng(Double.parseDouble(request.getParameter("lng")));

		String uploadPath = request.getServletContext().getRealPath("/uploads");
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists())
			uploadDir.mkdirs();

		// ✅ 썸네일 삭제 처리
		String deleteThumbnail = request.getParameter("deleteThumbnail");
		if ("on".equals(deleteThumbnail)) {
			String oldThumb = request.getParameter("thumbnail");
			if (oldThumb != null && !oldThumb.isEmpty()) {
				File oldThumbFile = new File(uploadPath, oldThumb);
				if (oldThumbFile.exists())
					oldThumbFile.delete();
			}
			board.setThumbnail(null); // DB에 null로 설정
		} else {
			// 썸네일 업로드
			Part thumbPart = request.getPart("thumbnailFile");
			String thumbFileName = getFilename(thumbPart);
			if (thumbFileName != null && !thumbFileName.isEmpty()) {
				thumbPart.write(uploadPath + File.separator + thumbFileName);
				board.setThumbnail(thumbFileName);
			} else {
				board.setThumbnail(request.getParameter("thumbnail")); // 기존 값 유지
			}
		}

		// ✅ 기존 이미지 유지 + 선택 삭제 처리
		String[] deleteImages = request.getParameterValues("deleteImages");
		List<String> originalImages = new ArrayList<>();
		String existingImages = request.getParameter("images");
		if (existingImages != null && !existingImages.isEmpty()) {
			originalImages = new ArrayList<>(Arrays.asList(existingImages.split(",")));
		}

		if (deleteImages != null) {
			for (String delImg : deleteImages) {
				File delFile = new File(uploadPath, delImg);
				if (delFile.exists())
					delFile.delete();
				originalImages.remove(delImg); // 남은 이미지 리스트에서 제거
			}
		}

		// ✅ 새로 업로드한 이미지 추가
		Collection<Part> parts = request.getParts();
		for (Part part : parts) {
			if ("imageFile".equals(part.getName())) {
				String imageName = getFilename(part);
				if (imageName != null && !imageName.isEmpty()) {
					part.write(uploadPath + File.separator + imageName);
					originalImages.add(imageName); // 남은 이미지 리스트에 추가
				}
			}
		}

		board.setImages(String.join(",", originalImages)); // 최종 이미지 목록 저장

		// 수정 시간 기록
		String updated_date = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new java.util.Date());
		board.setCreated_date(updated_date); // created_date를 업데이트 시점으로 덮어쓰기

		dao.updateBoard(board);
	}

	public void requestBoardDelete(HttpServletRequest request) {
		int post_num = Integer.parseInt(request.getParameter("post_num"));
		BoardDAO.getInstance().deleteBoard(post_num);
	}

	// $$$$$$$$$$$$$$$$$ 예약 관련 메서드 $$$$$$$$$$$$$$$$$
	public void requestReservationView(HttpServletRequest request) {

		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("sessionId");

		BoardDAO dao = BoardDAO.getInstance();

		int post_num = Integer.parseInt(request.getParameter("post_num"));

		BoardDTO reservationInfo = dao.getBoardByNum(post_num);

		request.setAttribute("post_num", post_num);
		request.setAttribute("reservationInfo", reservationInfo);

		HobbyDAO userDao = HobbyDAO.getInstance();
		HobbyDTO loginUser = userDao.getUserById(userId);

		request.setAttribute("loginUser", loginUser);

	}

	public void requestSaveReservation(HttpServletRequest request, HttpServletResponse response) {

	    try {
	        HttpSession session = request.getSession();
	        String userId = (String) session.getAttribute("sessionId");

	        if (userId == null) {
	            System.out.println("세션이 만료되었습니다. 로그인 후 다시 시도해주세요.");
	            response.sendRedirect(request.getContextPath() + "/login/login.jsp");
	            return;
	        }

	        // DAO 호출
	        HobbyDAO hobbyDao = HobbyDAO.getInstance();
	        HobbyDTO reservationUser = hobbyDao.getUserById(userId);

	        PaymentDAO boarddao = PaymentDAO.getInstance();
	        int post_num = Integer.parseInt(request.getParameter("post_num"));
	        BoardDTO classReservation = boarddao.getBoardByNum(post_num);

	        // 💡 쿠폰 관련 파라미터 처리
	        String finalPriceStr = request.getParameter("finalPrice");
	        String couponNum = request.getParameter("couponNum");
	        String usedPoint = request.getParameter("usedPoint");

	        int finalPrice = (finalPriceStr != null && !finalPriceStr.isEmpty())
	                ? Integer.parseInt(finalPriceStr)
	                : classReservation.getPrice();

	        // 결제 정보 DTO 세팅
	        PaymentDTO reservationPaymentInfo = new PaymentDTO();
	        reservationPaymentInfo.setUser_id(reservationUser.getUserId());
	        reservationPaymentInfo.setName(reservationUser.getName());
	        reservationPaymentInfo.setPhone(reservationUser.getPhone());
	        reservationPaymentInfo.setEmail(reservationUser.getEmail());
	        reservationPaymentInfo.setPost_num(classReservation.getPost_num());
	        reservationPaymentInfo.setTitle(classReservation.getTitle());
	        reservationPaymentInfo.setPrice(finalPrice);
	        reservationPaymentInfo.setReservation_date(classReservation.getReservation_date());
	        reservationPaymentInfo.setEnd_date(classReservation.getEnd_date());
	        reservationPaymentInfo.setState("W");
	        reservationPaymentInfo.setDeleted("N");

	        // 이미 존재하는 예약인지 확인
	        PaymentDAO dao = PaymentDAO.getInstance();
	        PaymentDTO reservationConfirmation = dao.getPaymentByUserAndPostW(userId, post_num);

	        if (reservationConfirmation == null) {
	            dao.insertPayment(reservationPaymentInfo);
	        }

	        // View로 전달
	        request.setAttribute("post_num", post_num);
	        request.setAttribute("reservationPaymentInfo", reservationPaymentInfo);

	        // ✅ 쿠폰 정보도 함께 전달
	        request.setAttribute("couponNum", couponNum != null ? couponNum : "0");
	        request.setAttribute("usedPoint", usedPoint != null ? usedPoint : "0");
	        request.setAttribute("finalPrice", finalPriceStr != null ? finalPriceStr : String.valueOf(finalPrice));

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}


	//
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

	public void confirmPaymentView(HttpServletRequest request) {
		try {
			// 관리자용: 사용자 ID를 파라미터로 받음
			String targetUserId = request.getParameter("id");
			int postNum = Integer.parseInt(request.getParameter("post_num"));

			if (targetUserId == null || targetUserId.isEmpty()) {
				System.out.println("전달된 사용자 ID가 없습니다.");
				return;
			}

			PaymentDAO dao = PaymentDAO.getInstance();
			PaymentDTO adminCheckPaymentInfo = dao.getPaymentByUserAndPost(targetUserId, postNum);

			if (adminCheckPaymentInfo != null) {
				request.setAttribute("adminCheckPaymentInfo", adminCheckPaymentInfo);
			} else {
				System.out.println("해당 결제 정보가 없습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void ConfirmPayment(HttpServletRequest request) {
		try {
			String targetUserId = request.getParameter("user_id");
			int postNum = Integer.parseInt(request.getParameter("post_num"));

			PaymentDAO dao = PaymentDAO.getInstance();
			PaymentDTO confirmpayment = dao.getPaymentByUserAndPost(targetUserId, postNum);

			confirmpayment.setPost_num(postNum);
			confirmpayment.setUser_id(targetUserId);

			dao.ConfirmPaymentByUserAndPost(confirmpayment);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void PaymentComplete(HttpServletRequest request) {
		try {

			String couponNumStr = request.getParameter("couponNum");
			String remainPointStr = request.getParameter("remainPoint"); // ✅ 잔액 차감
			String couponDiscountStr = request.getParameter("couponDiscount"); //
			String userId = request.getParameter("user_id");
		    String postNumStr = request.getParameter("post_num");

			if (couponNumStr != null && !couponNumStr.equals("0")) {
			    int couponNum = Integer.parseInt(couponNumStr);
			    int usedAmount = (couponDiscountStr != null && !couponDiscountStr.isEmpty()) 
			                    ? Integer.parseInt(couponDiscountStr) : 0;

			    CouponDAO couponDao = CouponDAO.getInstance();
			    couponDao.processCouponAfterPayment(couponNum, usedAmount);
			}
			
			// ✅ 결제 완료 처리 (state = 'C') 업데이트
	        if (userId != null && postNumStr != null) {
	            int postNum = Integer.parseInt(postNumStr);

	            PaymentDTO dto = new PaymentDTO();
	            dto.setUser_id(userId);
	            dto.setPost_num(postNum);

	            PaymentDAO dao = PaymentDAO.getInstance();
	            dao.paymentCompleteByUserAndPost(dto);
	        }

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// CouponCouponCoupon쿠폰메서드CouponCouponCoupon

	public void requestCouponList(HttpServletRequest request) {
		try {
			HttpSession session = request.getSession();
			String userId = (String) session.getAttribute("sessionId");

			if (userId == null) {
				System.out.println("세션이 만료되었습니다. 로그인 후 다시 시도해주세요.");
				return;
			}

			CouponDAO couponDAO = CouponDAO.getInstance();
			List<CouponDTO> couponList = couponDAO.getValidCouponsByUser(userId);

			request.setAttribute("couponList", couponList);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void requestHomeData(HttpServletRequest request) {
		BoardDAO dao = BoardDAO.getInstance();

		// 좋아요 많은순 상위 4개
		List<BoardDTO> popularList = dao.getBoardList(1, 4, null, null, "like_desc", "U");

		// 최신순 상위 4개
		List<BoardDTO> recentList = dao.getBoardList(1, 4, null, null, "recent", "U");

		request.setAttribute("popularList", popularList);
		request.setAttribute("recentList", recentList);
	}

}
