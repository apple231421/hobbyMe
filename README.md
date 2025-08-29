# 🎨 HobbyMe — 취미 공유 플랫폼
> 취미 활동을 공유하고 클래스 모집/예약/결제를 지원하는 웹 플랫폼

🔗 [HobbyMe GitHub Repository](https://github.com/apple231421/hobbyMe)

---

## 👥 팀 구성
- **총원**: 4인 (백엔드 3, 프론트엔드 1)

### ✅ 내 역할 (Backend Developer)
- **게시판 핵심 기능 전체 설계 및 구현**
  - 좋아요 / 댓글 / 카테고리 / 태그 / 마감일(D-day)
  - 게시판 정렬(최신순, 좋아요순, 댓글순)
- **파일 업로드 처리**
  - 썸네일 & 본문 이미지 업로드 로직
  - 기본 이미지 자동 등록 기능
- **지도 연동**
  - Kakao 지도 API 기반 위치 선택
  - 게시글 상세보기 페이지 지도 표시
- **예약/결제 흐름 지원**
  - 예약 인원 제한 및 모집 마감 처리 로직

---

## 👥 팀원 역할
- **프론트엔드**: JSP + Bootstrap 기반 UI, 페이지 디자인, 사용자 UX 개선  
- **백엔드 서포트**: 회원 관리, 결제 API 연동, 공통 DAO/DTO 구성  

---

## 📂 주요 기능
- **회원 관리**: 회원가입, 로그인/로그아웃, 권한 관리  
- **게시판**: 좋아요, 댓글, 태그, 카테고리, 정렬(최신/좋아요/댓글순), 마감일 D-day 표시  
- **지도 연동**: Kakao 지도 API 기반 위치 선택 & 지도 표시  
- **파일 업로드**: 썸네일/본문 이미지 업로드, 태그 자동 처리, 기본 이미지 자동 등록  
- **예약/결제**: 예약 인원 제한 및 모집 마감 처리, 결제(일부 기능 구현)  

---

## 🛠 기술 스택
- **Backend**: Java Servlet/JSP, Spring Boot  
- **Frontend**: JSP, Bootstrap 5, JavaScript  
- **Database**: MySQL 8.0  
- **API**: Kakao Maps API  
- **Server**: Apache Tomcat 9.0  

---

# IDE에서 Tomcat 서버 실행 (예: Eclipse, VSCode, IntelliJ)
# MySQL DB 연결 (db.properties 수정 필요)
