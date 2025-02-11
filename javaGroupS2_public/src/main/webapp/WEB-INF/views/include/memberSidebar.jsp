<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<!-- <script src="https://cdn.tailwindcss.com"></script> -->
<script type="text/javascript">
	window.Kakao.init("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx");   //클래스라 대소문자 구별
		function kakaoLogout() {
			const accessToken = Kakao.Auth.getAccessToken();
			if(accessToken){
				Kakao.Auth.logout(function() {
					window.location.href="https://kauth.kakao.com/oauth/logout?client_id=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&logout_redirect_uri=http://localhost:9090/javaGroupS2/member/memberLogout"; //세션을 끊는 주소를 넣어준다
				});
			}
		}
</script>
<style>

#sidebar {
    width: 15%;
    height: 100vh;
    position: fixed;
    left: 0;
    top: 0;
    box-sizing: border-box;
    overflow-y: auto;
}

#container {
    margin-left: 16%; 
    margin-right: 50px; */
    width: 100%; 
    box-sizing: border-box;
    justify-content: center;
		align-items: center; 
		text-align:center;
}

.sidebar-content {
    padding: 20px;
    padding-bottom: 0;
}

.sidebar-footer {
    padding: 20px;
    border-top: 1px solid #dee2e6;
}

.btn-toggle-nav li a {
    color: #fff;
    text-decoration: none;
    display: block;
    padding: 5px 10px;
    transition: background-color 0.2s ease-in-out;
}

.btn-toggle-nav li a:hover {
    background-color: rgba(255,255,255,0.2);
}

.btn-toggle {
    transition: background-color 0.2s ease-in-out;
}

.btn-toggle:hover {
    background-color: rgba(255, 255, 255, 0.2);
    cursor: pointer;
}
</style>

	<div id="sidebar" class="sidebar text-bg-dark">
    <div class="sidebar-content"> <%-- 스크롤 영역 --%>
        <a href="${ctp}/main/mainPage" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
           <span class="fs-5"><i class="bi bi-layout-sidebar"></i>&nbsp;메인으로 이동</span>
        </a>
        <hr>
        <ul class="nav nav-pills flex-column mb-auto">
            <li class="nav-item">
              <button class="btn btn-toggle d-inline-flex align-items-center rounded border-0 text-white collapsed ${empty category? 'bg-secondary' :''}" data-bs-toggle="collapse" data-bs-target="#home-collapse" aria-expanded="false">
			          <i class="bi bi-house-door-fill"></i>&nbsp;&nbsp;메인페이지
			        </button>
			        <div class="collapse" id="home-collapse">
			          <ul class="btn-toggle-nav list-unstyled fw-normal fs-5 pb-1">
			            <li><a href="${ctp}/member/memberMain" class="text-white-emphasis d-inline-flex text-decoration-none mt-1 ${empty section? 'bg-secondary' :''}">전체보기</a></li>
			          </ul>
			        </div>
            </li>
            <li>
              <button class="btn btn-toggle d-inline-flex align-items-center rounded border-0 text-white collapsed ${category=='member'? 'bg-secondary' :''}" data-bs-toggle="collapse" data-bs-target="#customer-collapse" aria-expanded="false">
			          <i class="bi bi-people-fill"></i>&nbsp;&nbsp;정보관리
			        </button>
			        <div class="collapse" id="customer-collapse">
			          <ul class="btn-toggle-nav list-unstyled fw-normal fs-5 pb-1">
			            <li><a href="${ctp}/member/memberPwdCheck?flag=update" class="link-light text-decoration-none mt-1 ${section=='update'? 'bg-secondary' :''}">내 정보 수정</a></li>
			            <li><a href="${ctp}/member/memberPwdCheck?flag=pwd" class="text-white-emphasis d-inline-flex text-decoration-none mt-1 ${section=='pwd'? 'bg-secondary' :''}">비밀번호변경</a></li>
			            <li><a href="${ctp}/member/memberPwdCheck?flag=withdraw" class="text-white-emphasis d-inline-flex text-decoration-none mt-1 ${section=='withdraw'? 'bg-secondary' :''}">회원탈퇴</a></li>
			          </ul>
			        </div>
            </li>
            <li>
              <button class="btn btn-toggle d-inline-flex align-items-center rounded border-0 text-white collapsed ${category=='dataTrend'? 'bg-secondary' :''}" data-bs-toggle="collapse" data-bs-target="#dashboard-collapse" aria-expanded="false">
			          <i class="bi bi-bar-chart-line"></i>&nbsp;&nbsp;데이터로 보기
			        </button>
			        <div class="collapse" id="dashboard-collapse">
			          <ul class="btn-toggle-nav list-unstyled fw-normal fs-5 pb-1">
			            <li><a href="${ctp}/member/memberOrderTrends" class="link-light text-decoration-none mt-1 ${section=='memberOrderTrends'? 'bg-secondary' :''}">주문차트</a></li>
			          </ul>
			        </div>
            </li>
            <li>
              <button class="btn btn-toggle d-inline-flex align-items-center rounded border-0 text-white collapsed ${category=='orders'? 'bg-secondary' :''}" data-bs-toggle="collapse" data-bs-target="#orders-collapse" aria-expanded="false">
			          <i class="bi bi-cart"></i>&nbsp;&nbsp;주문관리
			        </button>
			        <div class="collapse" id="orders-collapse">
			          <ul class="btn-toggle-nav list-unstyled fw-normal fs-5 pb-1">
			            <li><a href="${ctp}/product/memberCartList" class="link-light text-decoration-none mt-1 ${section=='cartList'? 'bg-secondary' :''}">장바구니보기</a></li>
			            <li><a href="${ctp}/member/memberOrderList" class="link-light text-decoration-none mt-1 ${section=='recentOrders'? 'bg-secondary' :''}">주문목록</a></li>
			          </ul>
			        </div>
            </li>
            <li>
			        <button class="btn btn-toggle d-inline-flex align-items-center rounded border-0 text-white collapsed ${category=='etc'? 'bg-secondary' :''}" data-bs-toggle="collapse" data-bs-target="#etc-collapse" aria-expanded="false">
			         	<span class="fs-6"><i class="bi bi-front"></i></i>&nbsp;&nbsp;Etc</span>
			        </button>
			        <div class="collapse" id="etc-collapse">
			          <ul class="btn-toggle-nav list-unstyled fw-normal fs-5 pb-1">
			            <li><a href="#" class="link-light text-decoration-none mt-1 ${section=='부분'? 'bg-secondary' :''}">기타</a></li>
			          </ul>
			        </div>
            </li>
        </ul>
        <hr>
    </div> <%-- sidebar-content end --%>
    <div class="sidebar-footer"> <%-- 하단 고정 영역 --%>
        <div class="dropdown">
        	<c:if test="${sImge==null}">
            <a href="${ctp}/member/memberMain" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                <img src="${ctp}/member/noimage.jpeg" alt="프로필 이미지" width="50" height="50" class="rounded-circle me-2">
            </a>
        	</c:if>
        	<c:if test="${sImge != null}">
            <a href="${ctp}/member/memberMain" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                <img src="${ctp}/member/${sImge}" alt="프로필 이미지" width="50" height="50" class="rounded-circle me-2">
            </a>
        	</c:if>
                <strong>${sNickName}</strong>	
            <ul class="dropdown-menu dropdown-menu-dark text-small shadow">
                <li><a class="dropdown-item" href="${ctp}/member/memberMain">마이페이지</a></li>
                <c:if test="${!empty sLevel && sLevel == 0}">
	                <li><a class="dropdown-item" href="${ctp}/admin/adminMain">관리자페이지</a></li>
                </c:if>
                <li><hr class="dropdown-divider"></li>
	             	<c:if test="${sLogin == 'kakao'}">
			          	<li class="nav-item">
				          	<a class="nav-link" href="javascript:kakaoLogout()">
				          		<img src="${ctp}/kakao/kakaoIcon.png" class="img-fluid">
				          		카카오 로그아웃
				          	</a>
			          	</li>
		          	</c:if>
	             	<c:if test="${sLogin != 'kakao'}">
                	<li><a class="dropdown-item" href="${ctp}/member/memberLogout">로그아웃</a></li>
	          		</c:if>
            </ul>
        </div>
    </div> <%-- sidebar-footer end --%>
	</div>