<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<!-- <script src="https://cdn.tailwindcss.com"></script> -->

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
    margin-right: 50px; 
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
			            <li><a href="${ctp}/admin/adminMain" class="text-white-emphasis d-inline-flex text-decoration-none mt-1 ${empty section? 'bg-secondary' :''}">전체보기</a></li>
			          </ul>
			        </div>
            </li>
            <li>
              <button class="btn btn-toggle d-inline-flex align-items-center rounded border-0 text-white collapsed ${category=='dashboard'? 'bg-secondary' :''}" data-bs-toggle="collapse" data-bs-target="#dashboard-collapse" aria-expanded="false">
			          <i class="bi bi-bar-chart-line"></i>&nbsp;&nbsp;데이터로 보기
			        </button>
			        <div class="collapse" id="dashboard-collapse">
			          <ul class="btn-toggle-nav list-unstyled fw-normal fs-5 pb-1">
			            <li><a href="${ctp}/admin/adminDashBoard/orderTrends" class="link-light text-decoration-none mt-1 ${section=='orderTrends'? 'bg-secondary' :''}">주문추세</a></li>
			            <li><a href="${ctp}/admin/adminDashBoard/userTrends" class="text-white-emphasis d-inline-flex text-decoration-none mt-1 ${section=='userTrends'? 'bg-secondary' :''}">회원경향</a></li>
			          </ul>
			        </div>
            </li>
            <li>
              <button class="btn btn-toggle d-inline-flex align-items-center rounded border-0 text-white collapsed ${category=='orders'? 'bg-secondary' :''}" data-bs-toggle="collapse" data-bs-target="#orders-collapse" aria-expanded="false">
			          <i class="bi bi-cart"></i>&nbsp;&nbsp;주문관리
			        </button>
			        <div class="collapse" id="orders-collapse">
			          <ul class="btn-toggle-nav list-unstyled fw-normal fs-5 pb-1">
			            <li><a href="${ctp}/admin/adminOrderList" class="link-light text-decoration-none mt-1 ${section=='최근주문리스트'? 'bg-secondary' :''}">최근주문리스트</a></li>
			          </ul>
			        </div>
            </li>
            <li>
              <button class="btn btn-toggle d-inline-flex align-items-center rounded border-0 text-white collapsed ${category=='product'? 'bg-secondary' :''}" data-bs-toggle="collapse" data-bs-target="#product-collapse" aria-expanded="false">
			          <i class="bi bi-basket"></i></i>&nbsp;&nbsp;상품관리
			        </button>
			        <div class="collapse" id="product-collapse">
			          <ul class="btn-toggle-nav list-unstyled fw-normal fs-5 pb-1">
			            <li><a href="${ctp}/admin/adminPlantDataList" class="link-light text-decoration-none mt-1 ${section=='식물데이터삽입' || section=='식물데이터리스트'||section=='식물데이터수정'? 'bg-secondary' :''}">식물 데이터 리스트</a></li>
			            <li><a href="${ctp}/admin/adminProductDataList" class="link-light text-decoration-none mt-1 ${section=='상품데이터삽입' || section=='상품데이터리스트'||section=='상품데이터수정'? 'bg-secondary' :''}">상품 데이터 리스트</a></li>
			          </ul>
			        </div>
            </li>
            <li>
              <button class="btn btn-toggle d-inline-flex align-items-center rounded border-0 text-white collapsed ${category=='customer'? 'bg-secondary' :''}" data-bs-toggle="collapse" data-bs-target="#customer-collapse" aria-expanded="false">
			          <i class="bi bi-people-fill"></i>&nbsp;&nbsp;고객관리
			        </button>
			        <div class="collapse" id="customer-collapse">
			          <ul class="btn-toggle-nav list-unstyled fw-normal fs-5 pb-1">
			            <li><a href="${ctp}/admin/adminAllMemberList" class="link-light text-decoration-none mt-1 ${section=='adminAllMemberList'? 'bg-secondary' :''}">전체 회원</a></li>
			            <li><a href="${ctp}/admin/adminNewMemberList" class="text-white-emphasis d-inline-flex text-decoration-none mt-1 ${section=='adminNewMemberList'? 'bg-secondary' :''}">신규가입목록</a></li>
			            <li><a href="${ctp}/admin/adminWithdrawMemberList" class="text-white-emphasis d-inline-flex text-decoration-none mt-1 ${section=='adminWithdrawMemberList'? 'bg-secondary' :''}">탈퇴회원목록</a></li>
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
            <ul class="dropdown-menu dropdown-menu-dark text-small shadow">
                <li><a class="dropdown-item" href="${ctp}/admin/adminMain">관리자페이지</a></li>
                <li><a class="dropdown-item" href="${ctp}/member/memberMain">마이페이지</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="${ctp}/member/memberLogout">로그아웃</a></li>
            </ul>
        </div>
    </div> <%-- sidebar-footer end --%>
	</div>