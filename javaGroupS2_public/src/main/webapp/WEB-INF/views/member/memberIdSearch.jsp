<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>memberIdSearch.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script src="https://cdn.tailwindcss.com"></script>
	<style type="text/css">
	 .footer { 
		position: absolute;
     bottom: 0;
     width: 100%;
    	padding: 10px;
	  }
	    
	  html, body {
			height: 100%; 
			margin: 0; 
			padding: 0; 
			display: flex;
			flex-direction: column; 
		}
		
		.container {
			flex: 1; 
		}
	</style>
	<script type="text/javascript">
		'use strict';
		
		const regexTel = /^[0-9]{2,3}\-{1}[0-9]{3,4}\-{1}[0-9]{3,4}$/; 
	  const regexEmail = /^[a-zA-Z0-9]{2,15}\@{1}[a-z]{2,10}\.{1}[a-z]{2,10}$/; 
		
		$(function() {
			$("#demo").hide();
			$("#wholeMid").hide();
			$("#spin").hide();
			$("#partId").hide();
			$("#idSend").hide();
		});
		
		function partIdSearch() {
			let tel1 = document.getElementById("tel1").value.trim();
  		let tel2 = document.getElementById("tel2").value.trim();
  		let tel3 = document.getElementById("tel3").value.trim();
  		if(tel2 == "") tel2 = " ";
  		if(tel3 == "") tel3 = " ";

  		let tel = tel1+"-"+tel2+"-"+tel3;
  		let email = document.getElementById("email").value;
  		
		if(!regexTel.test(tel.trim())){
			alert("전화번호 형식을 확인해주세요");
			tel1.focus();
			return false;
		} 
		else if(!regexEmail.test(email.trim())){
			alert("이메일 형식을 확인해주세요");
			email.focus();
			return false;
		}
		
  		$.ajax({
  			type: "post",
  			url: "${ctp}/member/memberPartIdSearch",
  			data: {
  				tel : tel,
  				email : email
  			},
  			success: function(res) {
  				if(res != "없음"){
  					const partId = document.getElementById("partId");
  					const ans = document.createElement("p");
						ans.classList.add("text-6xl", "font-bold", "mb-6", "text-center", "text-gray-800");
						ans.textContent = "부분아이디 : "+res;
  					partId.appendChild(ans);
						
	  				$("#partId").show();
	  				$("#idSend").show();
	  				$("#partIdSearch").hide();
	  				//$("#partId").text(res);
  				}
  				else{
  					alert("일치하는 연락처나 이메일이 없습니다 \n 다시 확인해주세요");
  				}
				},
				error: function() {
					alert("전송오류");
				}
  		});
		}
		
		//인증번호 메일 보내기
		function fullMidSearch() {
			let email = document.getElementById("email");
			let tel1 = document.getElementById("tel1");
  		let tel2 = document.getElementById("tel2");
  		let tel3 = document.getElementById("tel3");
  		
  		email.readOnly = true;
  		tel1.readOnly = true;
  		tel2.readOnly = true;
  		tel3.readOnly = true;
  		
			$("#overlay").show();
			$("body").css("pointer-events", "none"); // body 전체 클릭 막기
			
			$.ajax({
				type: "post",
				url: "${ctp}/member/fullMidSearch",
				data: {
					email : email.value
				},
				success: function(res) {
					$("body").css("pointer-events", "auto"); // 클릭 다시 활성화
					if(res != 0){
						alert("이메일로 인증번호가 갔습니다 확인하시고 입력해주세요");
						$("#demo").show();
						$("#overlay").hide();
						$("#idSend").hide();
					}
					else {
						alert("이메일이 맞지않습니다 다시 확인해주세요");
						email.readOnly = false;
						$("#overlay").hide();
					}
				},
				error: function() {
					$("body").css("pointer-events", "auto"); // 클릭 다시 활성화
					alert("전송실패");
					$("#overlay").hide();
					$("#demo").hide();
				}
			});
		}
		
		//인증번호 체크후 아이디 보여주기
		function codeCheck() {
			let code = document.getElementById("code").value;
			let email = document.getElementById("email").value;
			
			$.ajax({
				type: "post",
				url: "${ctp}/member/emailKeyCheck",
				data: {
					code : code,
					email : email
				},
				success: function(res) {
					if(res != "다름"){
						$("#partId").hide();
						$("#demo").hide();
						const wholeMid = document.getElementById("wholeMid");
  					const ans = document.createElement("p");
						ans.classList.add("text-6xl", "font-bold", "mb-6", "text-center", "text-gray-800");
						ans.textContent = "전체아이디 : "+res;
						wholeMid.appendChild(ans);
					}
					else {
						$("#wholeMid").html("<font size ='3em'>인증번호가 틀립니다<br>다시 확인해주세요</font>");
					}
						$("#wholeMid").show();
				},
				error: function() {
					alert("전송실패");
				}
			});
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
	<h2 class="text-6xl font-bold mb-6 text-center text-gray-800">아이디 찾기</h2>
	<div class="bg-white p-8 rounded-lg shadow-md w-full" style="box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
	<table class="table table-borderless table-hover text-center">
			<tr>
				<th class="text-center"><label for="tel1" class="form-label">연락처</label></th>
				<td>
					<div class="input-group align-items-center d-flex">
						<input type="text" class="form-control" id="tel1" name="tel1" size="4" maxlength="4" required /><span class="mx-3">-</span>
						<input type="text" class="form-control" id="tel2" name="tel2" size="4" maxlength="4" required /><span class="mx-3">-</span>
						<input type="text" class="form-control" id="tel3" name="tel3" size="4" maxlength="4" required />
	  			</div>
				</td>
			</tr>
			<tr>
				<th class="text-center"><label for="email" class="form-label">이메일</label></th>
				<td>
					<input name="email" id="email" type="email" placeholder="@를 포함한 이메일을 입력해주세요" class="form-control" required />
				</td>
			</tr>
		</table>
		
		<!--부분 아이디 표시-->
		<div id="partId"></div>
		<!-- 전체 아이디 표시 -->		
		<div id="wholeMid"></div>

		<!--인증번호 입력-->
		<div id="demo" class="input-group mb-3">
			<input type="text" name="code" id="code" class="form-control"/>
			<button onclick="codeCheck()" class="btn btn-primary">인증번호 확인</button>
		</div>
		<!--전체화면 오버레이-->
		<div id="overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 9999;">
	   <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);">
	    <span id="spin" class="spinner-grow text-light" role="status"></span> <span style="color: white; margin-left:10px;">이메일 전송중...</span>
	   </div>
		</div>
		
		<button onclick="partIdSearch()" id="partIdSearch" class="btn btn-success form-control mb-3">아이디 찾기</button>
		<button onclick="fullMidSearch()" id="idSend" class="btn btn-info form-control mb-3">아이디 전체 보기</button>
		<div class="d-flex justify-content-evenly mt-3">
			<button onclick="location.href='${ctp}/member/memberPwdSearch'" class="btn btn-secondary">비밀번호 찾기</button>
			<button onclick="location.href='${ctp}/member/memberLogin'" class="btn btn-warning">돌아가기(로그인)</button>
		</div>
	</div>
</div>
<p><br/></p>
<footer class="footer">
	<jsp:include page="/WEB-INF/views/include/footer2.jsp" />
</footer>
</body>
</html>