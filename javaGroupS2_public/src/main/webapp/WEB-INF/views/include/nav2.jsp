<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  
<script>
	window.Kakao.init("xxxxxxxxxxxxxxxxx");   //클래스라 대소문자 구별
		function kakaoLogout() {
			const accessToken = Kakao.Auth.getAccessToken();
			if(accessToken){
				Kakao.Auth.logout(function() {
					window.location.href="https://kauth.kakao.com/oauth/logout?client_id=xxxxxxxxxxxxxxxxxxxxxxxxxxxx&logout_redirect_uri=http://localhost:9090/javaGroupS/member/memberLogout"; //세션을 끊는 주소를 넣어준다
				});
			}
		}
</script>
  
  <nav class="navbar navbar-expand-md border-bottom" style="background-color: #90DC1E;">
  <div class="container text-white fw-bold">
    <a class="navbar-brand d-md-none" href="${ctp}/main/mainPage">
      <i class="bi bi-flower1"></i>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvas" aria-controls="offcanvas" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvas" aria-labelledby="offcanvasLabel">
      <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="offcanvasLabel">식물나무</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
      </div>
      <div class="offcanvas-body align-baseline">
        <ul class="navbar-nav flex-grow-1 justify-content-between d-flex align-items-center">
          <li class="nav-item"><a class="nav-link" href="${ctp}/main/mainPage">
            <i class="bi bi-flower1 display-6"></i>
          </a></li>
          <li class="nav-item dropdown">
          	<a class="nav-link d-flex flex-column align-items-center dropdown-toggle btn btn-outline-light" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
          		<i class="bi bi-card-text"></i>
          		<span>게시판</span>
						</a>
						<ul class="dropdown-menu">
					    <li>
						    <a class="dropdown-item" href="${ctp}/admin/adminNoticeBoardList">
						   	 공지사항
						    </a>
          		</li>
		          <li>
		          	<a class="dropdown-item" href="${ctp}/product/plantMarketList">
		          		상품(식물)게시판
		          	</a>
		          </li>
					  </ul>
          </li>
          <c:if test="${!empty sLevel}">
	          <li class="nav-item">
	          <a class="nav-link d-flex flex-column align-items-center" href="${ctp}/member/memberMain">
	          	<i class="bi bi-person-vcard"></i>
	          	마이페이지
	          </a>
	          </li>
	          <c:if test="${sLogin != 'kakao'}">
	         	 <li class="nav-item">
		         	 <a class="nav-link" href="${ctp}/member/memberLogout">
		         	 	<i class="bi bi-person-x"></i>
		         	 	로그아웃
		         	 </a>
	         	 </li>
	          </c:if>
	          <c:if test="${sLogin == 'kakao'}">
		          <li class="nav-item">
			          <a class="nav-link" href="javascript:kakaoLogout()">
			          	<img src="${ctp}/kakao/kakaoIcon.png" class="img-fluid" height="20" width="20">
			          	카카오 로그아웃
			          </a>
		          </li>
	          </c:if>
          </c:if>
          <c:if test="${sLevel == 0}">
          	<li class="nav-item">
	          	<a class="nav-link" href="${ctp}/admin/adminMain">
	          		관리자페이지
	          	</a>
          	</li>
          </c:if>
          <li class="nav-item">
	          <a class="nav-link" href="${ctp}/product/memberCartList">
	         	 장바구니
	          </a>
          </li>
          <c:if test="${empty sLevel}">
	          <li class="nav-item">
	          	<a href="${ctp}/member/memberLogin" class="btn btn-success btn-lg"><i class="bi bi-person-square"></i> 로그인</a>
	          	<a href="${ctp}/member/memberJoin" class="btn btn-primary btn-lg"><i class="bi bi-person-fill-add"></i> 회원가입</a>
	          </li>
          </c:if>
        </ul>
      </div>
    </div>
  </div>
</nav>