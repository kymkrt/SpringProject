<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<c:set var="hostIp" value="${pageContext.request.remoteAddr}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>memberLogin.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script src="https://cdn.tailwindcss.com"></script>
	<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
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
	<script type="text/javascript">
		'use strict'
		
		//카카오 로그인 앱키 이렇게 꺼내놓는게 좋다 다른것들도 마찬가지
  	window.Kakao.init("xxxxxxxxxxx");   //클래스라 대소문자 구별
  	
  	function kakaoLogin() {
  		//들어갈때 무조건 윈도우 객체 시작할때 카카오로 시작
  		window.Kakao.Auth.login({
  			scope: 'profile_nickname, account_email', //더 있으면 여기에 계속 쓰면된다
  			success: function(autoObj) {//사용자 변수라 이름 바꿔도 됨
  				window.Kakao.API.request({//무조건 쓰려면 window.Kakao. 필요
  					url : '/v2/user/me',
  					success: function(res) { //여기부터는 공식문서 없음 여기서 강제 가입처리 해도된다 
							const kakao_account = res.kakao_account;
  						location.href="${ctp}/member/kakaoLogin?nickName="+kakao_account.profile.nickname+"&email="+kakao_account.email+"&accessToken="+Kakao.Auth.getAccessToken();
  						$("#overlay").show();
  						$("body").css("pointer-events", "none"); // body 전체 클릭 막기
						}
  				}); 
				}
  		});
		}
  	
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container text-center">
	<h2 class="text-6xl font-bold mb-6 text-center text-gray-800">로그인</h2>
	<div class="text-center my-2">
		관리자:admin 비밀번호:1234<br/>
		멤버: btom1234 비밀번호:1234<br/>
	</div>
	
	<div>
		<div class="bg-white p-8 rounded-lg shadow-md w-full" style="box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
	    <form name="loginForm" action="${ctp}/member/memberLoginOk" method="post">
        <div class="mb-4">
            <label for="username" class="text-2xl block text-gray-700 font-bold mb-2">아이디</label>
            <input type="text" id="mid" name="mid" value="${mid}" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring focus:ring-blue-300" placeholder="아이디를 입력하세요" required>
        </div>
        <div class="mb-6">
            <label for="password" class="text-2xl block text-gray-700 font-bold mb-2">비밀번호</label>
            <input type="password" id="pwd" name="pwd" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring focus:ring-blue-300" placeholder="비밀번호를 입력하세요" required>
        </div>

        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center">
                <input type="checkbox" id="idSave" name="idSave" class="form-check-input me-2" checked />
                <label for="idSave" class="text-sm text-gray-600">아이디 저장</label>
            </div>
            <div class="d-grid gap-2 col-6">
            </div>
        </div>
        <button type="submit" class="w-50 bg-lime-400 hover:bg-lime-500 text-white font-bold py-2 rounded-lg mb-3 focus:outline-none focus:ring focus:ring-green-300">로그인</button>
      	<a href="${ctp}/member/memberJoin" class="btn btn-success w-50 font-bold mb-3">회원가입</a>
      	<div class="flex justify-center">
	        <a href="javascript:kakaoLogin()"><img src="${ctp}/kakao/kakao_login_medium_narrow.png"></a>
      	</div>
        <input type="hidden" name="hostIp" value="${hostIp}" />
    </form>
    <div class="mt-6 text-center">
      <a href="${ctp}/member/memberIdSearch" 
   			class="bg-green-300 text-black text-center text-sm px-1 py-1 rounded hover:bg-green-500 transition duration-200 no-underline">
   			아이디 찾기</a> / 
      <a href="${ctp}/member/memberPwdSearch" class="bg-green-300 text-black text-center text-sm px-1 py-1 rounded hover:bg-green-500 transition duration-200 no-underline ">비밀번호 찾기</a>
    </div>
		</div>
	</div>
	
<!--전체화면 오버레이-->
	<div id="overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 9999;">
   <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);">
    <span id="spin" class="spinner-grow text-light" role="status"></span> <span style="color: white; margin-left:10px;">이메일 전송중...</span>
   </div>
	</div>
	
</div>
<p><br/></p>
<footer class="footer">
	<jsp:include page="/WEB-INF/views/include/footer2.jsp" />
</footer>
</body>
</html>