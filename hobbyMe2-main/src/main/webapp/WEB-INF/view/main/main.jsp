<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', sans-serif;
            }

            .hero-section {
                background: linear-gradient(rgba(255, 255, 255, 0.85), rgba(255, 255, 255, 0.85)), url("./images/board_header.jpg") center/cover no-repeat;
                border-radius: 16px;
            }

            .hero-section h1 {
                font-weight: 700;
            }

            .card {
                border-radius: 12px;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
                border: none;
            }

            .card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            }

            .card-title {
                font-size: 1.1rem;
                font-weight: bold;
                color: #343a40;
            }

            .card-text {
                color: #6c757d;
            }

            .fw-bold.text-dark {
                font-size: 1rem;
                color: #e83e8c !important;
            }

            .badge.text-bg-success {
                font-size: 0.95rem;
                padding: 0.5em 0.75em;
            }

            .pagination span,
            .pagination strong {
                margin: 0 4px;
                font-size: 1rem;
                color: #4C5317;
            }

            .form-control,
            .form-select {
                min-width: 120px;
            }

            .btn-primary {
                background-color: #000000;
                border-color: #000000;
            }

            .btn-primary:hover {
                background-color: #bb2d74;
                border-color: #bb2d74;
            }

            .btn-secondary {
                background-color: #6c757d;
                border-color: #6c757d;
            }

            .btn-secondary:hover {
                background-color: #5c636a;
                border-color: #5c636a;
            }

            .like-icon {
                font-size: 18px;
                cursor: pointer;
                transition: transform 0.2s ease, color 0.3s ease;
                user-select: none;
            }

            .like-icon:hover {
                transform: scale(1.2);
            }

            .liked {
                color: #ff5e78;
            }

            .unliked {
                color: #ccc;
            }

            .count {
                margin-left: 5px;
                font-weight: bold;
                font-size: 0.9rem;
                color: #555;
            }

            .card-img-top {
                width: 100%;
                height: 200px;
                /* 원하는 고정 높이 */
                object-fit: cover;
                border-top-left-radius: 12px;
                border-top-right-radius: 12px;
            }

            .text-badge.dark {
                background-color: #343a40;
                color: white;
                padding: 0.3em 0.6em;
                border-radius: 0.6rem;
                font-size: 0.75rem;
                display: inline-block;
            }

            .text-badge.light {
                background-color: #f1f3f5;
                color: #333;
                padding: 0.3em 0.6em;
                border: 1px solid #ced4da;
                border-radius: 0.6rem;
                font-size: 0.75rem;
                display: inline-block;
            }

            .card {
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                transition: all 0.25s ease;
                display: flex;
                flex-direction: column;
                border: none;
                background-color: #ffffff;
            }

            .card:hover {
                transform: translateY(-6px);
                box-shadow: 0 10px 24px rgba(0, 0, 0, 0.1);
            }

            /* 카드 제목 */
            .card-title {
                font-size: 1.05rem;
                font-weight: 600;
                color: #212529;
                margin-bottom: 0.4rem;
            }

            /* 썸네일 이미지 */
            .card-img-top {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-top-left-radius: 16px;
                border-top-right-radius: 16px;
            }

            /* 가격 텍스트 */
            .fw-bold.text-dark {
                font-size: 1.1rem;
                color: #d63384 !important;
                font-weight: 600;
                margin-top: 0.4rem;
            }

            /* 태그 뱃지 */
            .badge.bg-info.text-dark {
                background-color: #e0f7ff !important;
                color: #007b8a !important;
                font-weight: 500;
                border-radius: 0.5rem;
                font-size: 0.75rem;
                padding: 0.3em 0.6em;
            }

            /* 마감일 */
            .text-muted.mb-1 {
                font-size: 0.85rem;
                line-height: 1.4;
            }

            /* 카테고리 뱃지 */
            a.badge.bg-info.text-dark {
                font-size: 0.75rem;
                padding: 0.3em 0.6em;
                border-radius: 0.5rem;
                font-weight: 500;
            }

            /* 모집 인원 뱃지 */
            .badge.bg-light.text-dark.border {
                background-color: #f8f9fa;
                border: 1px solid #ced4da;
                color: #495057;
                font-size: 0.75rem;
                padding: 0.3em 0.6em;
                border-radius: 0.5rem;
            }

            /* 하단 정보 */
            .card-body .small {
                font-size: 0.8rem;
                color: #666;
            }

            /* 좋아요 및 댓글 */
            .comment-area span,
            .like-area .count {
                font-size: 0.85rem;
                font-weight: 500;
                color: #495057;
            }

            .like-area span:first-child {
                font-size: 20px;
                margin-right: 4px;
            }

            .comment-area i {
                font-size: 18px;
                color: #6c757d;
                margin-right: 4px;
            }

            .badge.bg-danger,
            .badge.bg-dark,
            .badge.bg-secondary {
                font-size: 0.75rem;
                padding: 0.35em 0.6em;
                border-radius: 0.5rem;
            }

            .category-slider-container {
                position: relative;
                margin: 0 auto;
                width: 100%;
                overflow: visible;
            }

            /* 카테고리 개수가 적을 때 가운데 정렬 */
            .category-slider-container.centered .category-slider-wrapper {
                justify-content: center;
                margin: 0 auto;
            }

            .category-scroll-area {
                overflow-x: auto;
                scroll-behavior: smooth;
                -webkit-overflow-scrolling: touch;
                scrollbar-width: none;
                -ms-overflow-style: none;
                padding: 10px 0;
            }

            .category-scroll-area::-webkit-scrollbar {
                display: none;
            }

            .category-slider-wrapper {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 0 10px;
                width: max-content;
            }

            .category-item {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 150px;
                height: 80px;
                background-color: #fff;
                border-radius: 12px;
                font-size: 1rem;
                font-weight: 500;
                color: #333;
                text-decoration: none;
                white-space: nowrap;
                border: 2px solid #d0ebff;
                transition: all 0.3s ease;
                box-sizing: border-box;
                line-height: 1;
                padding: 0;
                /* ✅ 텍스트 위치 조정 */
                transform: translate(-2px, 1px);
                /* ← 가로로 2px 왼쪽, 세로로 1px 아래 이동 */
                /* ✅ 오타 수정 */
                text-align: center;
            }

            .category-item:hover {
                background-color: #339af0;
                color: #fff;
                border-color: #1c7ed6;
            }

            /* 좌우 버튼 */
            .category-nav-btn {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                z-index: 20;
                width: 36px;
                height: 36px;
                border: none;
                border-radius: 50%;
                background-color: white;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                font-size: 1rem;
                color: #555;
                cursor: pointer;
            }

            .category-nav-btn.left {
                left: 0;
                transform: translate(-100%, -50%);
            }

            .category-nav-btn.right {
                right: 0;
                transform: translate(100%, -50%);
            }

            .badge-recruiting {
                background-color: #e7f5ff;
                color: #1c7ed6;
                border: 1px solid #a5d8ff;
                font-weight: 500;
            }

            .badge-closed {
                background-color: #f1f3f5;
                color: #868e96;
                border: 1px solid #ced4da;
                font-weight: 500;
            }
        </style>

        <main class="container mt-4">
            <div id="mainSlider" class="carousel slide mb-3" data-bs-ride="carousel">
                <div class="carousel-inner ratio-16x9 rounded overflow-hidden">
                    <div class="carousel-item active">
                        <img
                            src="images/slider_1.png"
                            class="d-block w-100 h-100"
                            style="object-fit: cover;"
                            alt="요리"></div>
                        <div class="carousel-item">
                            <img
                                src="images/slider_2.png"
                                class="d-block w-100 h-100"
                                style="object-fit: cover;"
                                alt="배드민턴"></div>
                            <div class="carousel-item">
                                <img
                                    src="images/slider_3.png"
                                    class="d-block w-100 h-100"
                                    style="object-fit: cover;"
                                    alt="플라워"></div>
                            </div>
                            <button
                                class="carousel-control-prev"
                                type="button"
                                data-bs-target="#mainSlider"
                                data-bs-slide="prev">
                                <span class="carousel-control-prev-icon"></span>
                            </button>
                            <button
                                class="carousel-control-next"
                                type="button"
                                data-bs-target="#mainSlider"
                                data-bs-slide="next">
                                <span class="carousel-control-next-icon"></span>
                            </button>
                        </div>

                        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
                            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

                                <c:set var="catCount" value="${fn:length(categoryList)}"/>

                                <!-- 카테고리 -->
                                <div class="my-4">
                                    <h4 class="section-title fw-bold text-primary mb-3">
                                        <i class="fa fa-list-ul me-2 text-info"></i>카테고리
                                    </h4>

                                    <div class="category-slider-container ${catCount lt 8 ? 'centered' : ''}">
                                        <c:if test="${catCount ge 8}">
                                            <button class="category-nav-btn left" id="catPrevBtn">
                                                <i class="fa fa-chevron-left"></i>
                                            </button>
                                            <button class="category-nav-btn right" id="catNextBtn">
                                                <i class="fa fa-chevron-right"></i>
                                            </button>
                                        </c:if>

                                        <div id="categoryScrollArea" class="category-scroll-area">
                                            <div id="categoryWrapper" class="category-slider-wrapper">
                                                <c:forEach var="cat" items="${categoryList}">
                                                    <a href="BoardListAction.do?items=category&text=${cat}" class="category-item">${cat}</a>

                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 좋아요 많은순 -->

                                <div class="mb-5">
                                    <!-- 좋아요 많은순 -->
                                    <div class="text-center my-5">
                                        <div
                                            style="background-color: #ffffff; padding: 1.5rem; margin: 2rem 0; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); border-radius: 10px; position: relative; text-align: center;">
                                            <!-- 제목 가운데 정렬 -->
                                            <div style="font-weight: 700; font-size: 1.4rem;">지금 가장 인기 있는 클래스</div>

                                            <!-- 전체보기 버튼 오른쪽 정렬 -->
                                            <a
                                                href="BoardListAction.do?sort=like_desc"
                                                class="btn btn-outline-secondary btn-sm"
                                                style="position: absolute; top: 50%; right: 1.5rem; transform: translateY(-50%);">
                                                전체보기
                                            </a>
                                        </div>

                                        <hr style="border-top: 2px solid #adb5bd; width: 100%; margin: 0.8rem auto 0;"></div>

                                        <c:choose>
                                            <c:when test="${empty popularList}">
                                                <div
                                                    class="text-center text-muted my-5 py-5"
                                                    style="border: 2px dashed #dee2e6; border-radius: 12px;">
                                                    <div style="font-size: 3rem;">📭</div>
                                                    <p class="mt-3 mb-1" style="font-size: 1.25rem;">표시할 인기 게시판이 없습니다.</p>
                                                    <p style="font-size: 0.95rem;">새로운 게시판이 등록되면 이곳에 표시됩니다.</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4 mb-4">
                                                    <c:forEach var="post" items="${popularList}">
                                                        <div class="col">
                                                            <div class="card h-100 shadow-sm">
                                                                <a href="BoardViewAction.do?post_num=${post.post_num}">
                                                                    <c:choose>
                                                                        <c:when test="${not empty post.thumbnail}">
                                                                            <img
                                                                                src="${pageContext.request.contextPath}/uploads/${post.thumbnail}"
                                                                                class="card-img-top"
                                                                                alt="대표 이미지"
                                                                                style="height: 200px; object-fit: cover;"></c:when>
                                                                            <c:otherwise>
                                                                                <img
                                                                                    src="./images/default_thumb.jpg"
                                                                                    class="card-img-top"
                                                                                    alt="기본 썸네일"
                                                                                    style="height: 200px; object-fit: cover;"></c:otherwise>
                                                                            </c:choose>
                                                                        </a>
                                                                        <div class="card-body d-flex flex-column">
                                                                            <h5 class="card-title">
                                                                                <c:choose>
                                                                                    <c:when test="${fn:length(post.title) > 16}">
                                                                                        ${fn:substring(post.title, 0, 16)}...
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        ${post.title}
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </h5>

                                                                            <c:if test="${not empty post.tag}">
                                                                                <div class="mb-2 d-flex flex-wrap gap-2">
                                                                                    <c:forEach var="tag" items="${fn:split(post.tag, ',')}">
                                                                                        <a
                                                                                            href="BoardListAction.do?items=tag&text=${fn:trim(tag)}"
                                                                                            class="badge bg-info text-dark text-decoration-none">
                                                                                            ${fn:trim(tag)}
                                                                                        </a>
                                                                                    </c:forEach>
                                                                                </div>
                                                                            </c:if>

                                                                            <p class="fw-bold text-dark mt-1">${post.price}원</p>

                                                                            <p class="text-muted mb-1" style="font-size: 0.9rem;">
                                                                                마감일: ${post.end_date}
                                                                                <c:choose>
                                                                                    <c:when test="${post.expired eq 'Y'}">
                                                                                        <span class="badge bg-secondary ms-2">마감됨</span>
                                                                                    </c:when>
                                                                                    <c:when test="${post.dday == 0}">
                                                                                        <span class="badge bg-danger ms-2">D-day</span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="badge bg-warning ms-2">D-${post.dday}</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                                <c:if test="${post.deleted eq 'Y'}">
                                                                                    <span class="badge bg-dark ms-2">삭제됨</span>
                                                                                </c:if>
                                                                            </p>

                                                                            <!-- 모집 인원 라인 -->
                                                                            <div
                                                                                class="text-muted mb-1 d-flex justify-content-between align-items-center"
                                                                                style="font-size: 0.9rem;">
                                                                                <div>
                                                                                    <strong>모집 인원:</strong>
                                                                                    <c:choose>
                                                                                        <c:when test="${post.reserved >= post.people}">
                                                                                            <span class="badge badge-closed ms-2">모집 완료</span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span class="badge badge-recruiting ms-2">${post.reserved} / ${post.people}</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </div>

                                                                                <c:if test="${not empty post.category}">
                                                                                    <div class="d-flex align-items-center gap-1">
                                                                                        <span style="font-size: 0.9rem;" class="text-muted">카테고리:</span>
                                                                                        <a
                                                                                            href="BoardListAction.do?items=category&text=${fn:trim(post.category)}"
                                                                                            class="badge bg-info text-dark text-decoration-none">
                                                                                            ${post.category}
                                                                                        </a>
                                                                                    </div>
                                                                                </c:if>
                                                                            </div>

                                                                            <div class="mt-auto">
                                                                                <div class="d-flex justify-content-between text-muted small mb-2">
                                                                                    <span>
                                                                                        <i class="fa fa-user me-1"></i>${post.user_id}</span>
                                                                                    <span>작성일: ${post.created_date}</span>
                                                                                </div>
                                                                                <div class="d-flex justify-content-between align-items-center mt-2">
                                                                                    <div class="like-area d-flex align-items-center">
                                                                                        <span style="font-size: 22px; color: #ff5e78;">💖</span>
                                                                                        <span class="count ms-2">${post.board_like}</span>
                                                                                    </div>
                                                                                    <c:if test="${post.comment_count >= 0}">
                                                                                        <div class="comment-area d-flex align-items-center">
                                                                                            <i class="fa-regular fa-comment-dots me-1 text-secondary"></i>
                                                                                            <span class="text-muted small">${post.comment_count}개</span>
                                                                                        </div>
                                                                                    </c:if>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- 최신 게시글 -->
                                            <div class="mb-4">

                                                <div class="text-center my-5">
                                                    <div class="my-5 px-3">

                                                        <div
                                                            style="background-color: #ffffff; padding: 1.5rem; margin: 2rem 0; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); border-radius: 10px; position: relative; text-align: center;">

                                                            <!-- 제목 가운데 -->
                                                            <div style="font-weight: 700; font-size: 1.4rem;">최근에 등록된 클래스 모아보기</div>

                                                            <!-- 전체보기 버튼 오른쪽 끝 -->
                                                            <a
                                                                href="BoardListAction.do?sort=recent"
                                                                class="btn btn-outline-secondary btn-sm"
                                                                style="position: absolute; top: 50%; right: 1.5rem; transform: translateY(-50%);">
                                                                전체보기
                                                            </a>
                                                        </div>

                                                    </div>

                                                    <hr style="border-top: 2px solid #adb5bd; width: 100%; margin: 0.8rem auto 0;"></div>
                                                    <c:choose>
                                                        <c:when test="${empty recentList}">
                                                            <div
                                                                class="text-center text-muted my-5 py-5"
                                                                style="border: 2px dashed #dee2e6; border-radius: 12px;">
                                                                <div style="font-size: 3rem;">📭</div>
                                                                <p class="mt-3 mb-1" style="font-size: 1.25rem;">표시할 최근 게시판이 없습니다.</p>
                                                                <p style="font-size: 0.95rem;">새로운 게시판이 등록되면 이곳에 표시됩니다.</p>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                                                                <c:forEach var="post" items="${recentList}">
                                                                    <div class="col">
                                                                        <div class="card h-100 shadow-sm">
                                                                            <a href="BoardViewAction.do?post_num=${post.post_num}">
                                                                                <c:choose>
                                                                                    <c:when test="${not empty post.thumbnail}">
                                                                                        <img
                                                                                            src="${pageContext.request.contextPath}/uploads/${post.thumbnail}"
                                                                                            class="card-img-top"
                                                                                            alt="대표 이미지"
                                                                                            style="height: 200px; object-fit: cover;"></c:when>
                                                                                        <c:otherwise>
                                                                                            <img
                                                                                                src="./images/default_thumb.jpg"
                                                                                                class="card-img-top"
                                                                                                alt="기본 썸네일"
                                                                                                style="height: 200px; object-fit: cover;"></c:otherwise>
                                                                                        </c:choose>
                                                                                    </a>
                                                                                    <div class="card-body d-flex flex-column">
                                                                                        <h5 class="card-title">
                                                                                            <c:choose>
                                                                                                <c:when test="${fn:length(post.title) > 10}">
                                                                                                    ${fn:substring(post.title, 0, 10)}...
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    ${post.title}
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </h5>

                                                                                        <c:if test="${not empty post.tag}">

                                                                                            <div class="mb-2 d-flex flex-wrap gap-2">
                                                                                                <c:forEach var="tag" items="${fn:split(post.tag, ',')}">
                                                                                                    <a
                                                                                                        href="BoardListAction.do?items=tag&text=${fn:replace(fn:trim(tag), '#', '')}"
                                                                                                        class="badge bg-info text-dark text-decoration-none me-1">
                                                                                                        ${fn:trim(tag)}
                                                                                                    </a>
                                                                                                </c:forEach>
                                                                                            </div>

                                                                                        </c:if>

                                                                                        <p class="fw-bold text-dark mt-1">${post.price}원</p>

                                                                                        <p class="text-muted mb-1" style="font-size: 0.9rem;">
                                                                                            마감일: ${post.end_date}
                                                                                            <c:choose>
                                                                                                <c:when test="${post.expired eq 'Y'}">
                                                                                                    <span class="badge bg-secondary ms-2">마감됨</span>
                                                                                                </c:when>
                                                                                                <c:when test="${post.dday == 0}">
                                                                                                    <span class="badge bg-danger ms-2">D-day</span>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span class="badge bg-warning ms-2">D-${post.dday}</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                            <c:if test="${post.deleted eq 'Y'}">
                                                                                                <span class="badge bg-dark ms-2">삭제됨</span>
                                                                                            </c:if>
                                                                                        </p>
                                                                                        <div
                                                                                            class="text-muted mb-1 d-flex justify-content-between align-items-center"
                                                                                            style="font-size: 0.9rem;">
                                                                                            <div>
                                                                                                <strong>모집 인원:</strong>
                                                                                                <c:choose>
                                                                                                    <c:when test="${post.reserved >= post.people}">
                                                                                                        <span class="badge badge-closed ms-2">모집 완료</span>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                        <span class="badge badge-recruiting ms-2">${post.reserved} / ${post.people}</span>
                                                                                                    </c:otherwise>
                                                                                                </c:choose>
                                                                                            </div>

                                                                                            <c:if test="${not empty post.category}">
                                                                                                <div class="d-flex align-items-center gap-1">
                                                                                                    <span style="font-size: 0.9rem;" class="text-muted">카테고리:</span>
                                                                                                    <a
                                                                                                        href="BoardListAction.do?items=category&text=${fn:trim(post.category)}"
                                                                                                        class="badge bg-info text-dark text-decoration-none">
                                                                                                        ${post.category}
                                                                                                    </a>
                                                                                                </div>
                                                                                            </c:if>
                                                                                        </div>

                                                                                        <div class="mt-auto">
                                                                                            <div class="d-flex justify-content-between text-muted small mb-2">
                                                                                                <span>
                                                                                                    <i class="fa fa-user me-1"></i>${post.user_id}</span>
                                                                                                <span>작성일: ${post.created_date}</span>
                                                                                            </div>
                                                                                            <div class="d-flex justify-content-between align-items-center mt-2">
                                                                                                <div class="like-area d-flex align-items-center">
                                                                                                    <span style="font-size: 22px; color: #ff5e78;">💖</span>
                                                                                                    <span class="count ms-2">${post.board_like}</span>
                                                                                                </div>
                                                                                                <c:if test="${post.comment_count >= 0}">
                                                                                                    <div class="comment-area d-flex align-items-center">
                                                                                                        <i class="fa-regular fa-comment-dots me-1 text-secondary"></i>
                                                                                                        <span class="text-muted small">${post.comment_count}개</span>
                                                                                                    </div>
                                                                                                </c:if>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </c:forEach>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>

                                                        <div class="w-100 my-4">
                                                            <div class="w-100 my-4">
                                                                <a href="${pageContext.request.contextPath}/faq/notice.jsp" target="_blank">
                                                                    <img
                                                                        src="images/banner_1.jpg"
                                                                        alt="공지사항 배너"
                                                                        class="img-fluid rounded w-100"
                                                                        style="max-height: 180px; object-fit: cover;"></a>
                                                                </div>
                                                                <div class="mb-4">
                                                                    <h4 class="section-title text-center border-top pt-4">사용했던 프로그램</h4>
                                                                </div>

                                                                <div class="row row-cols-5 g-4 mb-5 text-center">

                                                                    <!-- Backend -->
                                                                    <div class="col">
                                                                        <div class="card h-100 p-3">
                                                                            <img
                                                                                src="./images/java.jpg"
                                                                                class="mx-auto mb-3"
                                                                                alt="Java"
                                                                                style="width: 130px; height: 70px;">
                                                                                <h5 class="card-title">Backend</h5>
                                                                                <p class="card-text small text-muted">Java Servlet & JSP, JDBC</p>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Frontend -->
                                                                        <div class="col">
                                                                            <div class="card h-100 p-3">
                                                                                <img
                                                                                    src="./images/bu.png"
                                                                                    class="mx-auto mb-3"
                                                                                    alt="Frontend"
                                                                                    style="width: 150px; height: 80px;">
                                                                                    <h5 class="card-title">Frontend</h5>
                                                                                    <p class="card-text small text-muted">JSP, HTML/CSS, JavaScript</p>
                                                                                </div>
                                                                            </div>

                                                                            <!-- Database -->
                                                                            <div class="col">
                                                                                <div class="card h-100 p-3">
                                                                                    <img
                                                                                        src="./images/mysql.png"
                                                                                        class="mx-auto mb-3"
                                                                                        alt="MySQL"
                                                                                        style="width: 180px; height: 85px;">
                                                                                        <h5 class="card-title">Database</h5>
                                                                                        <p class="card-text small text-muted">MySQL</p>
                                                                                    </div>
                                                                                </div>

                                                                                <!-- 서버 환경 -->
                                                                                <div class="col">
                                                                                    <div class="card h-100 p-3">
                                                                                        <img
                                                                                            src="./images/tomcat.png"
                                                                                            class="mx-auto mb-3"
                                                                                            alt="Tomcat"
                                                                                            style="width: 150px; height: 80px;">
                                                                                            <h5 class="card-title">서버 환경</h5>
                                                                                            <p class="card-text small text-muted">Apache Tomcat</p>
                                                                                        </div>
                                                                                    </div>

                                                                                    <!-- 기타 도구 -->
                                                                                    <div class="col">
                                                                                        <div class="card h-100 p-3">
                                                                                            <img
                                                                                                src="./images/eclipse.jpg"
                                                                                                class="mx-auto mb-3"
                                                                                                alt="Tools"
                                                                                                style="width: 85px; height: 70px;">
                                                                                                <h5 class="card-title">기타 도구</h5>
                                                                                                <p class="card-text small text-muted">Eclipse, Git, JSTL</p>
                                                                                            </div>
                                                                                        </div>

                                                                                    </div>

                                                                                    <div
                                                                                        id="popupOverlay"
                                                                                        class="position-fixed top-0 start-0 w-100 h-100 bg-dark bg-opacity-50"
                                                                                        style="z-index: 1999; display: none;"></div>

                                                                                    <div
                                                                                        id="popup"
                                                                                        class="position-fixed top-50 start-50 translate-middle rounded overflow-hidden shadow-lg bg-white"
                                                                                        style="z-index: 2000; max-width: 420px; width: 90%; display: none;">
                                                                                        <a href="#" target="_blank">
                                                                                            <img src="images/popup_event.jpg" alt="이벤트 이미지" class="w-100 d-block"></a>
                                                                                            <div class="d-flex border-top bg-white text-center" style="height: 50px;">
                                                                                                <button
                                                                                                    id="hideTodayBtn"
                                                                                                    class="bg-white border-0 d-flex align-items-center justify-content-center w-50">오늘 그만 보기</button>
                                                                                                <div style="width: 1px; background-color: #ddd;"></div>
                                                                                                <button
                                                                                                    id="closeBtn"
                                                                                                    class="bg-white border-0 d-flex align-items-center justify-content-center w-50">닫기</button>
                                                                                            </div>
                                                                                        </div>
                                                                                    </main>

                                                                                    <script>
                                                                                        document.addEventListener("DOMContentLoaded", function () {
                                                                                            const scrollArea = document.getElementById("categoryScrollArea");
                                                                                            const scrollLeftBtn = document.getElementById("catPrevBtn");
                                                                                            const scrollRightBtn = document.getElementById("catNextBtn");

                                                                                            const scrollStep = 160; // 원하는 이동 거리 (160px)

                                                                                            scrollLeftBtn.addEventListener("click", () => {
                                                                                                scrollArea.scrollBy({
                                                                                                    left: -scrollStep,
                                                                                                    behavior: 'smooth'
                                                                                                });
                                                                                            });

                                                                                            scrollRightBtn.addEventListener("click", () => {
                                                                                                scrollArea.scrollBy({left: scrollStep, behavior: 'smooth'});
                                                                                            });
                                                                                        });
                                                                                    </script>