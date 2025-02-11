<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>memberPwdSearch.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<!-- <script src="https://cdn.tailwindcss.com"></script> -->
	<style type="text/css">
       body {
           display: flex;
           flex-direction: column;
           min-height: 100vh;
       }
       main { flex: 1; }
       footer { margin-top: auto; }
	</style>
	<script type="text/javascript">
		'use strict';
		
		const regexTel = /^[0-9]{2,3}\-{1}[0-9]{3,4}\-{1}[0-9]{3,4}$/; 
		const regexEmail = /^[a-zA-Z0-9]{2,15}\@{1}[a-z]{2,10}\.{1}[a-z]{2,10}$/; 
		
		function pwdTempChange() {
			let mid = document.getElementById("mid");
			let tel1 = document.getElementById("tel1");
  		let tel2 = document.getElementById("tel2");
  		let tel3 = document.getElementById("tel3");
  		if(tel2 == "") tel2 = " ";
  		if(tel3 == "") tel3 = " ";

  		let tel = tel1.value.trim()+"-"+tel2.value.trim()+"-"+tel3.value.trim();
  		let email = document.getElementById("email");
  		
  		if(mid.value.trim() == ""){
				alert("아이디를 입력해주세요");
				mid.focus();
				return false;
  		}
  		else if(!regexTel.test(tel.trim())){
				alert("전화번호 형식을 확인해주세요");
				tel1.focus();
				return false;
			} 
			else if(!regexEmail.test(email.value.trim())){
				alert("이메일 형식을 확인해주세요");
				email.focus();
				return false;
			}
  		
  		mid.readOnly = true;
  		email.readOnly = true;
  		tel1.readOnly = true;
  		tel2.readOnly = true;
  		tel3.readOnly = true;
  		
			$("#overlay").show();
			$("body").css("pointer-events", "none"); // body 전체 클릭 막기
			
			$.ajax({
				type: "post",
				url: "${ctp}/member/pwdTempChange",
				data: {
					email : email.value.trim(),
					mid : mid.value.trim(),
					tel : tel
				},
				success: function(res) {
					$("body").css("pointer-events", "auto"); // 클릭 다시 활성화
					if(res != 0){
						$("#overlay").hide();
						alert("이메일로 인증번호가 갔습니다 확인하시고 로그인해주세요\n비밀번호를 바꾸시는걸 권장드립니다");
						location.href="${ctp}/member/memberLogin";
					}
					else {
						alert("아이디, 이메일 혹은 연락처가 맞지않습니다 다시 확인해주세요");
						mid.readOnly = false;
						email.readOnly = false;
						tel1.readOnly = false;
			  		tel2.readOnly = false;
			  		tel3.readOnly = false;
						$("#overlay").hide();
					}
				},
				error: function() {
					$("body").css("pointer-events", "auto"); // 클릭 다시 활성화
					alert("전송실패");
					$("#overlay").hide();
				}
			});
  		
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card shadow">
                <div class="card-body p-4">
                    <h2 class="text-center mb-4 display-4 fw-bold">비밀번호 찾기</h2>

                    <p class="text-center mb-4">비밀번호는 변경만 가능합니다</p>

                    <table class="table table-borderless table-hover">
                        <tr>
                            <th class="text-center align-middle"><label for="mid" class="form-label">아이디</label></th>
                            <td><input type="text" name="mid" id="mid" placeholder="아이디를 입력하세요" class="form-control" autofocus required></td>
                        </tr>
                        <tr>
                            <th class="text-center align-middle"><label for="tel1" class="form-label">연락처</label></th>
                            <td>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="tel1" name="tel1" size="4" maxlength="4" required>
                                    <span class="input-group-text">-</span>
                                    <input type="text" class="form-control" id="tel2" name="tel2" size="4" maxlength="4" required>
                                    <span class="input-group-text">-</span>
                                    <input type="text" class="form-control" id="tel3" name="tel3" size="4" maxlength="4" required>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-center align-middle"><label for="email" class="form-label">이메일</label></th>
                            <td><input name="email" id="email" type="email" placeholder="@를 포함한 이메일을 입력해주세요" class="form-control" required></td>
                        </tr>
                    </table>

                    <div id="overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 9999;">
                        <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);">
                            <div class="spinner-border text-light" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <span style="color: white; margin-left:10px;">이메일 전송중...</span>
                        </div>
                    </div>

                    <div class="d-grid gap-2 mb-3"> <button onclick="pwdTempChange()" id="partIdSearch" class="btn btn-success">비밀번호 변경</button> </div>
                    <div class="d-flex justify-content-evenly">
                        <button onclick="location.href='${ctp}/member/memberIdSearch'" class="btn btn-secondary">아이디 찾기</button>
                        <button onclick="location.href='${ctp}/member/memberLogin'" class="btn btn-warning">돌아가기(로그인)</button>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
<p><br/></p>
<footer class="footer">
	<jsp:include page="/WEB-INF/views/include/footer2.jsp" />
</footer>
</body>
</html>