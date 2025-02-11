<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>memberMain.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<style type="text/css">
	 .footer { 
/*    position: absolute; */
     bottom: 0;
     width: 100%;
    	padding: 10px;
	  }
	    
	  html, body {
			height: 100%; /* html과 body의 높이를 100%로 설정 */
			margin: 0; /* 기본 여백을 제거 */
			padding: 0; /* 기본 패딩을 제거 */
			display: flex;
			flex-direction: column; /* 수직 방향으로 정렬 */
		}
		
		.container {
			/* min-height: 100vh; /* 뷰포트의 100% 높이로 설정 */ */
			flex: 1; /* 남는 공간을 차지하게 함 */
		}
		
	</style>
	<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
	  
	<script>
		window.Kakao.init("xxxxxxxxxxxxxxxxxxxx");   //클래스라 대소문자 구별
			function kakaoLogout() {
				const accessToken = Kakao.Auth.getAccessToken();
				if(accessToken){
					Kakao.Auth.logout(function() {
						window.location.href="https://kauth.kakao.com/oauth/logout?client_id=x&logout_redirect_uri=http://localhost:9090/javaGroupS/member/memberLogout"; //세션을 끊는 주소를 넣어준다
					});
				}
			}
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/memberSidebar.jsp" />
<p><br/></p>
<div id="container">
	<h2>멤버 메인 페이지</h2>
	<div>
		${sMid}
	</div>
	<div class="my-2" >
		<img src="${ctp}/member/${vo.photo}" class="img-fluid">
	</div>
	<div class="my-2">
		로그인 타입 :  ${sLogin}
	</div>
	<c:if test="${sLogin != 'kakao'}">
		<a href="${ctp}/member/memberLogout" class="btn btn-warning">일반 Logout</a>
	</c:if>
	<c:if test="${sLogin == 'kakao'}">
		<a href="javascript:kakaoLogout()" class="btn btn-warning">
			<img src="${ctp}/kakao/kakaoIcon.png" class="img-fluid" height="20" width="20">
		</a>
	</c:if>
</div>
<p><br/></p>
<div class="footer">
</div>
</body>
</html>