<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>memberWithdraw.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<!-- <script src="https://cdn.tailwindcss.com"></script> -->
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
		'use strict';
		
		const regexText = /<(?=.*?[\s\/>])(?!area|base|br|col|embed|hr|img|input|keygen|link|meta|param|source|track|wbr)[^>]*>/gi;
		
		function withdrawCheck() {
			let reason = document.getElementById("reason"); // 요소 객체를 가져옴
			let mid = document.getElementById("mid"); // 요소 객체를 가져옴 (변수명 변경)
			let pwd = document.getElementById("pwd"); // 요소 객체를 가져옴 (변수명 변경)

			if(!$("#check").is(':checked')){
		    alert("주의사항을 모두 읽으시고 체크해주세요");
		    return false;
			}else if(regexText.test(reason.value)){ // reason.value로 값을 비교
				reason.focus(); // 요소에 focus() 호출
		    alert("HTML 태그는 입력할 수 없습니다.");
		    return false;
			}else if(mid.value.trim()==""){ // midElement.value로 값을 비교
				mid.focus(); // 요소에 focus() 호출
		    alert("아이디를 입력해주세요.");
		    return false;
			}else if(pwd.value.trim()==""){ // pwdElement.value로 값을 비교
		    alert("비밀번호를 입력해주세요.");
		    pwd.focus(); // 요소에 focus() 호출
		    return false;
			}
			
			let ans = confirm("정말 탈퇴하시겠습니까?\n탈퇴시 같은 아이디로 6개월간 재가입 불가입니다");
			if(ans){
				$.ajax({
					type: "post",
					url: "${ctp}/member/memberWithdrawOk",
					data: {
						mid : mid.value.trim(),
						pwd : pwd.value.trim(),
						type : "탈퇴",
						reason : reason.value
					},success: function(res) {
						if(res != "0"){
							alert("탈퇴되셨습니다\n 향후 6개월간 같은 아이디로 가입하실수 없습니다");
							location.href="${ctp}/member/memberLogout";
						}else{
							alert("회원 탈퇴 실패 \n 아이디와 비밀번호를 확인해주세요");
							mid.focus();
						}
					},error: function() {
						alert("전송 오류")
					}
				});
			}
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/memberSidebar.jsp" />
<p><br/></p>
<div id="container">
    <div class="row justify-content-center">
      <div class="col-md-12">
          <div class="card shadow">
              <div class="card-body p-5">
                  <h2 class="text-center mb-4 display-4 fw-bold">회원 탈퇴</h2>

                  <h3 class="fs-4 fw-semibold mb-3">탈퇴 안내</h3>
                  <p class="mb-3">회원탈퇴 신청에 앞서 <span class="text-danger fw-bold">아래 사항을 반드시 확인</span> 하시기 바랍니다.</p>

                  <ul class="list-decimal ps-4 mb-5 text-start">
                      <li>
                          각 종 포인트, 쿠폰 등의 삭제<br>
                          <span class="text-secondary">회원탈퇴 시 서비스 이용 시 보유하고 있던 <span class="text-danger fw-bold">개인의 모든 재산은 삭제</span>됩니다.</span>
                      </li>
                      <li>
                          일정 기간 동안 재가입 불가 및 동일 아이디 사용 가능 여부<br>
                          <span class="text-secondary">회원탈퇴를 신청하시면 해당 아이디는 즉시 탈퇴 처리되며 이후 <span class="text-danger fw-bold">6개월 동안 재가입이 불가능</span>합니다.</span>
                      </li>
                      <li>
                          회원 탈퇴 이후에도 개인정보를 보유하는 경우 그 근거와 사유 및 기관에 관한 사항<br>
                          <span class="text-secondary">회원탈퇴를 하더라도 특정한 사유가 있을 시 일정기간동안 개인정보를 보관할 수 있습니다.</span>
                      </li>
                      <li>기타 해당 웹사이트의 정책 약관 등에서 정하고 있는 정보 삭제</li>
                  </ul>

                  <div class="d-flex align-items-center mb-4">
                      <span class="fs-4 fw-bold me-3">
                          <label for="check">상기 주의사항을 모두 읽으셨습니까?</label>
                      </span>
                      <input type="checkbox" id="check" name="check" class="form-check-input ms-2" style="transform: scale(1.5);">
                  </div>

                  <div class="row">
                      <div class="col-md-6 mb-4 mb-md-0">
                          <h4 class="fs-5 fw-semibold mb-2">탈퇴 사유 입력</h4>
                          <p class="text-secondary mb-2">향후 더 나은 서비스 제공을 위한 탈퇴 사유를 입력해주세요.</p>
                          <textarea rows="3" id="reason" maxlength="100" placeholder="최대 100자 까지 가능합니다" class="form-control"></textarea>
                      </div>
                      <div class="col-md-6">
                          <h4 class="fs-5 fw-semibold mb-2">패스워드 인증</h4>
                          <p class="text-secondary mb-2">타인에 의한 회원탈퇴를 방지하기 위해 추가 인증을 수행합니다.</p>
                          <div class="input-group mb-2">
                              <span class="input-group-text"><label for="mid" class="form-label">아이디</label></span>
                              <input type="text" name="mid" id="mid" class="form-control" required>
                          </div>
                          <div class="input-group">
                              <span class="input-group-text"><label for="pwd" class="form-label">비밀번호</label></span>
                              <input type="password" name="pwd" id="pwd" class="form-control" required>
                          </div>
                      </div>
                  </div>

                  <div class="d-grid gap-2 mt-4">
                      <button onclick="withdrawCheck()" class="btn btn-danger">회원 탈퇴</button>
                      <a href="${ctp}/member/memberMain" class="btn btn-info">돌아가기</a>
                  </div>
              </div>
          </div>
      </div>
  </div>
</div>
<p><br/></p>
</body>
</html>