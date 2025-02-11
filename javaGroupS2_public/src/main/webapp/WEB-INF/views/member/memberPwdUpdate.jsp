<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>memberPwdUpdate.jsp</title>
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
	
		const regexPwd = /^[a-zA-Z0-9\!\@\#\$\%\&\*]{2,20}$/;
		
		function pwdChange() {
			let pwd = myform.pwd.value;
			let pwdCheck = myform.pwdCheck.value;
			
			if(!regexPwd.test(pwd.trim())){
				alert("비밀번호 형식을 확인해주세요\\n 가능한 특수문자는 ! @ # $ % & * 뿐입니다");
				myform.pwd.focus();
				return false;
			}else if(pwd != pwdCheck){
				alert("비밀번호가 다릅니다 다시 확인하시고 \n두 비밀번호를 일치시켜 주세요");
				myform.pwd.focus();
				return false;
			}
			$.ajax({
				type: "post",
				url: "${ctp}/member/memberPwdChange",
				data: {
					pwd: pwd					
				},
				success: function(res) {
					if(res != "0"){
						alert("비밀번호가 변경되었습니다\n 다시 로그인 해주세요");
						location.href="${ctp}/member/memberLogout";
					}
					else {
						alert("비밀번호 변경이 실패하였습니다\n잠시후 다시 시도해주세요");
						location.reload();
					}
				},error: function() {
					alert("전송실패");
				}
			});
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/memberSidebar.jsp" />
<p><br/></p>
<div id="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <h2 class="text-center mb-4 display-4 fw-bold">비밀번호 변경</h2>
            <div class="card shadow">
                <div class="card-body p-5">
                    <form name="myform" id="myform" action="${ctp}/member/memberPwdChange">
                        <div class="input-group mb-3">
                            <span class="input-group-text">변경할 비밀번호</span>
                            <input type="password" name="pwd" id="pwd" placeholder="비밀번호를 입력해주세요" class="form-control">
                        </div>
                        <small class="text-start form-text text-muted fs-7 mb-3">
                            ※ 비밀번호 형식은 영소대문자 및 숫자, 특수문자(!,@,#,$,%,*) 2~20자 입니다
                        </small>
                        <div class="input-group my-3">
                            <span class="input-group-text">변경할 비밀번호 확인</span>
                            <input type="password" name="pwdCheck" id="pwdCheck" placeholder="비밀번호를 입력해주세요" class="form-control">
                        </div>
                        <div class="d-grid gap-2">
                            <button type="button" onclick="pwdChange()" class="btn btn-warning">비밀번호 변경</button>
                            <a href="${ctp}/member/memberMain" class="btn btn-secondary">돌아가기</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<p><br/></p>
</body>
</html>