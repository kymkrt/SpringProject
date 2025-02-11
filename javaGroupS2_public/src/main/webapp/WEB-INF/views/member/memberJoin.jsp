<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>memberJoin.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script src="${ctp}/js/woo.js"></script>
  <style type="text/css">
	 .footer { 
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
  	'use strict'
  	
  	let swId = 0;
  	let swNick = 0;
  	
  	const regexId = /^[a-zA-Z0-9]{5,20}$/; 
  	const regexNick = /^[a-zA-Z0-9가-힣]{2,20}$/; 
  	const regexName = /^[가-힣a-zA-Z]{2,10}$/; 
  	const regexPwd = /^[a-zA-Z0-9\!\@\#\$\%\&\*]{2,20}$/; 
  	const regexTel = /^[0-9]{2,3}\-{1}[0-9]{3,4}\-{1}[0-9]{3,4}$/; 
  	const regexEmail = /^[a-zA-Z0-9]{2,15}\@{1}[a-z]{2,10}\.{1}[a-z]{2,10}$/; 
  	const regexbirth = /^\d{2}(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$/; 
  	
  	function fCheck() {
	    let mid = myform.mid.value;
	    let nickName = myform.nickName.value;
	    let pwd = myform.pwd.value;
  	    
  		let tel1 = myform.tel1.value.trim();
  		let tel2 = myform.tel2.value.trim();
  		let tel3 = myform.tel3.value.trim();
  		if(tel2 == "") tel2 = " ";
  		if(tel3 == "") tel3 = " ";
  		let tel = tel1+"-"+tel2+"-"+tel3;
  		
  		let email = myform.email1.value+"@"+myform.email2.value;
  		let address = myform.postcode.value+" /"+myform.address.value+" /"+myform.detailAddress.value+" /"+myform.extraAddress.value+" ";
  		let birthday = myform.birthday.value;

  		if(swId == 0){
				alert("아이디 중복을 확인해주세요");
				myform.mid.focus();
				return false;
			} else if(swNick == 0) {
				alert("닉네임 중복을 확인해주세요");
				myform.nickName.focus();
				return false;
			} else if(!regexId.test(mid.trim())) {
				alert("아이디 형식을 확인해주세요");
				myform.mid.focus();
				return false;
			} else if(!regexNick.test(nickName.trim())) {
				alert("닉네임 형식을 확인해주세요");
				myform.nickName.focus();
				return false;
			} else if(!regexPwd.test(pwd.trim())){
				alert("비밀번호 형식을 확인해주세요\\n 가능한 특수문자는 ! @ # $ % & * 뿐입니다");
				myform.pwd.focus();
				return false;
			} else if(!regexTel.test(tel.trim())){
				alert("전화번호 형식을 확인해주세요");
				myform.tel2.focus();
				return false;
			} else if(!regexEmail.test(email.trim())){
				alert("이메일 형식을 확인해주세요");
				myform.email1.focus();
				return false;
			} else if(!regexbirth.test(birthday.trim())){
				alert("생년월일을 확인해주세요");
				myform.birthday.focus();
				return false;
			} else if(address.trim()==''){
				alert("주소를 확인해주세요");
				return false;
			}
			
			let profileImage = document.getElementById("profileImage");
			if(profileImage.files.length === 0){
				myform.imageCheck.value="";
			}else if(profileImage.files.length != 0){
				let fName = profileImage.files[0].name;
				let maxSize = 1024*1024*20; //저장파일의 최대용량을 20MByte까지로 제한 
				let ext = fName.substring(fName.lastIndexOf(".")+1).toLowerCase(); //.다음부터 찾아야 해서 +1
				let fileSize = profileImage.files[0].size;
				if(fileSize > maxSize){
					alert("업로드할 파일의 최대용량은 15MB 입니다");
					return false;
				}
				// 안되는거 목록이면 확장자가 너무 많아서 안된다  되는거로 생각해야됨
				else if(ext != 'jpg' && ext != 'png' && ext != 'gif'&&ext != 'webp'){
					alert("업로드 가능한 파일은 'jpg/png/gif/webp'만 가능합니다");
					return false;
				}
				myform.imageCheck.value="파일있음";
			}
			myform.tel.value = tel;
			myform.email.value = email;
			myform.address2.value = address;
			myform.remainMid.value = mid;
			
			swId = 0;
			swNick = 0;
			myform.submit();
		}
  	
  	// 아이디 중복 체크
  		function idCheck() {
				let mid = myform.mid.value;
				if(mid.trim() == "") {
					alert("아이디를 입력하세요");
					myform.mid.focus();
					return false;
				}else if(!regexId.test(mid.trim())) {
					alert("아이디 형식을 확인해주세요");
					myform.mid.focus();
					return false;
				}else if(mid.trim().toLowerCase().includes('member')||mid.trim().toLowerCase().includes('delete')){
					alert("허용되지 않는 단어가 있습니다 확인해주세요");
					myform.mid.focus();
					return false;
				}else {
					$.ajax({
						type : "post",
						url: "${ctp}/member/memberIdDuplicateCheck",
						data: {mid : mid},
						success: function(res) {
							if(res != "0"){
								alert("이미 사용중인 아이디입니다 \n 다른 아이디를 사용하세요")
							}
							else {
								alert("사용가능한 아이디입니다");
								swId = 1;
							}
						},
						error: function() {
							alert("전송오류");
						}
					});
				}
			}
  	
			
		//닉네임 중복체크 (AJax처리)
		function nickNameAjaxCheck() {
			let nickName  = myform.nickName.value;
			if(!regexNick.test(nickName)){
				alert("닉네임은 2자리 이상 한글만 가능합니다");
				myform.nickName.focus();
				return false;
			}
			else if(nickName == '관리자') {
				alert("사용할수없는 단어가 있습니다 확인해주세요");
				return false;
			}
			swNick = 1;
			$.ajax({
				type : "post", //여기get은 restAPI 개념이라 URL에 데이터 붙어가는거랑은 다르다
				url : "${ctp}/member/memberNickNameDuplicateCheck",
				data : {nickName : nickName}, 
				success:function(res){
					if(res != "0") alert("닉네임이 중복되었습니다.\n 다른 닉네임을 사용하세요 ");
					else alert("사용하실수 있는 닉네임입니다\n 계속 작성해주세요");
				},
				error : function() {
					alert("전송오류");
				}
			});
		}

		//이메일 인증 체크
		function emailCheck() {
			//스핀
			$("#spinner").show();
			//필수입력란의 체크를 모두 마친후 인증번호를 메일로 발송한다
			let email = $("#email1").val()+"@"+$("#email2").val();
			console.log("emailCheck 코드");
			$.ajax({
				type: "post",
				url: "${ctp}/member/memberEmailCheck",
				data: {email: email},
				success: function(res) {
					if(res != 0) {
						alert("인증번호가 발송되었습니다\n 메일 확인후 인증번호를 입력해주세요");
						let str = '<div class="input-group">';
						str+= '<input type="text" name="checkkey" id="checkkey" class="form-control" />';
						str+= '<input type="button" value="인증번호확인" onclick="emailCheckOk()" class="btn btn-info" />';
						str+= '</div>';
						//스핀이 돌고 있는 자리에서 이게 되야 한다?
						$("#demoSpin").html(str);
						$("#spinner").hide();
					}
					else {
						alert("인증번호받기 버튼을 다시 눌러 주세요");
						$("#spinner").hide();
					}
				},
				error: function() {
					alert("전송실패 ");
					$("#spinner").hide();
				}
			});
		}
		
		function emailCheckOk() {
			let checkkey = $("#checkkey").val();
			if(checkkey.trim() == "") {
				alert("전송받은 메일에서 인증받은 인증키를 입력해주세요");
				$("#checkkey").focus();
				return false;
			}
			
			$.ajax({
				type:"post",
				url: "${ctp}/member/memberEmailCheckOk",
				data: {checkkey: checkkey},
				success: function(res) {
					if(res != "0"){
						alert("인증확인되었습니다\n 계속해서 추가 인적사항을 기입해주세요");
						//추가로 입력할 부분을 show() 시켜준다 
					}
					else alert("인증실패\n 메일 주소를 확인하시고 다시 인증 메일을 전송해주세요");
				},
				error: function() {
					alert("전송오류");
				}
			});
			
		}
		
		 document.addEventListener('DOMContentLoaded', function() {
          const birthday = document.getElementById('birthday');
          const gender = document.getElementById('gender');
          const maxLength = parseInt(birthday.getAttribute('maxlength'));
          
          birthday.addEventListener('input', function(event) {
              this.value = this.value.replace(/[^0-9]/g, '');

              if (this.value.length > maxLength) {
                  this.value = this.value.substring(0, maxLength);
              }

              if (this.value === '0') {
                  this.value = '';
              }

              if (this.value.length === maxLength) {
                  gender.focus();
              }
          });

          gender.addEventListener('input', function(event) {
              this.value = this.value.replace(/[^1-4]/g, '');
          });
	   });
		
  	document.addEventListener('DOMContentLoaded', function () {
  	    document.getElementById('mid').addEventListener('keydown', function() {
  	        swId = 0;
  	    });

  	    document.getElementById('nickName').addEventListener('keydown', function() {
  	        swNick = 0;
  	    });
  	});
		 
		//모달에 이메일 리스트 처리
		function getEmailAddressList() {
    let str = "";
    $.ajax({
        type: "post",
        url: "${ctp}/member/getEmailAddressList",
        success: function (res) {
            res.forEach(function(email) {
                let [email1, email2] = email.split("@");
                str += "<div id='"+email1+"' class='text-center mb-2'>"+email1+"@"+email2+"</div>";
            });
            $("#emailListModalBody").html(str);
        },
        error: function() {
            alert("전송오류(getEmailAddressList)");
        }
    	});
		}
		
	</script>
  <style type="text/css">
  	th {
			width: 150px; 
			background-color: #eee !important;	
			padding: 10px;
  	}
  	
  	#subject {
			background-color: #eee !important;	
  	}
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
  <form name="myform" id="myform" method="post" action="MemberJoinOk" enctype="multipart/form-data">
	<table class="table table-bordered align-middle">
		<tr id="subject">
			<th class="text-center" colspan="7" style="background-color: #eee"><b class="fs-1">회원가입</b></th>
		</tr>
	  	<tr>
		  	<th class="text-center"><label for="mid" class="form-label">아이디 <span class="text-danger"><i class="bi bi-check-lg"></i></span></label></th>
		  	<td colspan="7">
		  		<div class="input-group mb-1">
			  		<input type="text" name="mid" id="mid" placeholder="아이디를 입력하세요" class="form-control" autofocus required />
			  		<input type="button" value="아이디중복체크" onclick="idCheck()" class="btn btn-secondary" />
		  		</div>
		  		<small class="form-text text-muted my-0 fs-7">
				  	※아이디 형식은 영대소문자 및 숫자 5~20글자 입니다
					</small>
		  	</td>
	  	</tr>
	  	<tr>
		  	<th class="text-center"><label for="pwd" class="form-label">비밀번호 <span class="text-danger"><i class="bi bi-check-lg"></i></span></label></th>
		  	<td colspan="7">
		  	<input type="password" name="pwd" id="pwd" placeholder="비밀번호를 입력하세요" class="form-control" required />
		  	<small class="form-text text-muted my-0 fs-7">
				  ※비밀번호 형식은 영소대문자 및 숫자, 특수문자(!,@,#,$,%,*) 2~20자 입니다
				</small>
		  	</td>
	  	</tr>
	  	<tr class="mb-2">
		  	<th class="text-center"><label for="name" class="form-label">성명 <span class="text-danger"><i class="bi bi-check-lg"></i></span></label></th>
		  	<td colspan="7">
		  	<input type="text" name="name" id="name" placeholder="성명을 입력하세요" class="form-control" required />
	  		<small class="form-text text-muted my-0 fs-7">
			  	※이름 형식은 영대소문자 및 한글 2~10글자 입니다
				</small>
		  	</td>
	  	</tr>
	  	<tr class="mb-2">
		  	<th class="text-center"><label for="nickName" class="form-label">닉네임 <span class="text-danger"><i class="bi bi-check-lg"></i></span></label></th>
	  		<td colspan="7">
	  			<div class="input-group">
	  				<input type="text" name="nickName" id="nickName" placeholder="닉네임을 입력하세요" class="form-control" required />
		  			<!-- <input type="button" value="닉네임중복체크" onclick="idCheck(2)" class="form-control btn-secondary" /> -->
		  			<input type="button" value="닉네임중복체크" onclick="nickNameAjaxCheck()" class="btn btn-secondary" />
	  			</div>
	  			<small class="form-text text-muted my-0 fs-7">
				  	※닉네임 형식은 영대소문자 및 숫자, 한글 2~20글자 입니다
					</small>
	  		</td>
	  	</tr>
	  	<tr class="mb-4">
	  		<th class="text-center"><label for="birthday" class="form-label">생일 <span class="text-danger"><i class="bi bi-check-lg"></i></span></label></th>
	  		<td colspan="7">
	    		<div class="input-group align-items-center d-flex">
		        <input type="text" name="birthday" id="birthday" maxlength="6" class="form-control w-75" placeholder="생년월일6자리">
		        <span class="mx-3">-</span>
		        <input type="text" name="gender" id="gender" maxlength="1" class="form-control" placeholder="주민뒷번호 1번" style="width: 100px;">
	    		</div>
	    		<small class="form-text text-muted my-0 fs-7">
				  	※앞 6자리 뒤 1자리(1~4만 가능) 입니다
					</small>
				</td>
	  	</tr>
	  	<tr class="mb-2">
	  		<th class="text-center"><label for="tel1" class="form-label">전화번호 <span class="text-danger"><i class="bi bi-check-lg"></i></span></label></th>
	  		<td>
	  			<div class="input-group align-items-center d-flex">
						<input type="text" class="form-control" id="tel1" name="tel1" size="4" maxlength="4" required /><span class="mx-3">-</span>
						<input type="text" class="form-control" id="tel2" name="tel2" size="4" maxlength="4" required /><span class="mx-3">-</span>
						<input type="text" class="form-control" id="tel3" name="tel3" size="4" maxlength="4" required />
	  			</div>
			</td>
	  	</tr>
	  	<tr class="mb-2">
	  		<th class="text-center"><label for="address" class="form-label">주소 <span class="text-danger"><i class="bi bi-check-lg"></i></span></label></th>
	  		<td colspan="7">
	  			<div class="input-group mb-1">
	  			<!--readonly 에 onclick="execDaumPostcode()" 이렇게 넣어줄수 있음  -->
					  	<input type="text" name="postcode" id="postcode" onclick="execDaumPostcode()" placeholder="우편번호" class="form-control" readonly />
							<input type="button" onclick="execDaumPostcode()" value="우편번호 찾기" class="btn btn-secondary"><br>
					</div>
					<input type="text" name="address" id="address" placeholder="주소" class="form-control mb-1" readonly />
					<div class="input-group mb-1">
						<input type="text" name="detailAddress" id="detailAddress" placeholder="상세주소" class="form-control" />
						<input type="text" name="extraAddress" id="extraAddress" placeholder="참고항목" class="form-control" readonly />
					</div>
	  		</td>
	  	</tr>
	  	<tr class="mb-2">
		   <th class="text-center">이메일 <span class="text-danger"><i class="bi bi-check-lg"></i></span></th>
		    <td>
		    	<div class="input-group">
	          <input type="text" name="email1" id="email1" placeholder="이메일을 입력하세요" class="form-control" required />
	          <span class="input-group-text">@</span>
	          <select id="email2" name="email2" class="form-select">
	            <option value="naver.com">naver.com</option>
	            <option value="hanmail.net">hanmail.net</option>
	            <option value="daum.net">daum.net</option>
	            <option value="gmail.com">gmail.com</option>
	          </select>
	          <input type="button" value="인증번호받기" onclick="emailCheck()" class="btn btn-warning" />
	          <br/>
	          <div id="demoSpin"></div>
	          <!-- <div id="addContent" style="display:none"></div> -->
	          <div id="spinner" style="display: none">
		          <button class="btn btn-primary" type="button" disabled>
							  <span class="spinner-border spinner-border-sm" ></span>
							</button>
						</div>
        	</div>
				</td>
			</tr>
	  	<tr class="mb-2">
		  	<th class="text-center"><label for="content" class="form-label">자기소개</label></th>
		  	<td colspan="7"><textarea rows="4" name="content" id="content" class="form-control"></textarea></td>
	  	</tr>
	  	<tr class="mb-2">
		  	<th class="text-center"><label for="profileImage" class="form-label">사진(jpg,png,gif,webp)</label></th>
	  		<td colspan="7">
	  			<div style="width: 300px;">
	  				<img id="previewImage" src="${ctp}/member/noimages.jpg" style="width: 100%; height: auto; display: none;">
	  			</div>
	  			<input type="file" name="profileImage" id="profileImage" accept=".jpg, .webp, .png, .gif" class="form-control" />
	  		</td>
	  	</tr>
	  	<tr class="mb-2">
		  	<th class="text-center"><label for="userInfor" class="form-label">정보공개 <span class="text-danger"><i class="bi bi-check-lg"></i></span></label></th>
		  	<td colspan="7" class="text-center">
		  		<input type="radio" name="userInfor" id="YES" value="공개" class="form-check-input" checked /><label for="YES" class="form-check-label me-3">공개</label>
		  		<input type="radio" name="userInfor" id="NO" value="비공개" class="form-check-input" /><label for="NO" class="form-check-label">비공개</label>
		  	</td>
	  	</tr>
  	</table>
  	<button type="button" onclick="fCheck()" class="form-control btn btn-success mb-2">회원가입</button>
  	<button type="reset" class="form-control btn btn-warning mb-2">다시입력</button>
  	<button type="button" onclick="location.href='${ctp}/member/memberLogin'" class="form-control btn btn-info mb-2">돌아가기</button>
  	<input type="hidden" name="tel" id="tel" />
  	<input type="hidden" name="email" id="email" />
  	<input type="hidden" name="address2" id="address2" />
  	<input type="hidden" name="remainMid" id="remainMid" />
  	<input type="hidden" name="imageCheck" id="imageCheck" />
  </form>
  <hr/>
  <!-- <div id="eve" popover>팝오버</div>
  <button popovertarget="eve">버튼임</button> -->
  <div name="demo" id="demo">
  </div>
</div>
<p><br/></p>
<footer class="footer">
	<jsp:include page="/WEB-INF/views/include/footer2.jsp" />
</footer>
<script type="text/javascript">

	//이미지 미리보기
	let imageInput = document.getElementById('profileImage');
	let previewImage = document.getElementById('previewImage');
	
	imageInput.addEventListener('change', (event) => {
	    const file = event.target.files[0];
	
	    if (file) {
	        const imageUrl = URL.createObjectURL(file);
	        previewImage.src = imageUrl;
	        previewImage.style.display = 'block';
	    } else {
	        previewImage.src = '#';
	        previewImage.style.display = 'none';
	    }
	});
</script>
</body>
</html>