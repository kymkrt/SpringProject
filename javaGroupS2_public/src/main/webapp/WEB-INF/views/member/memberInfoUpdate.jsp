<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>memberUpdate.jsp</title>
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
  	
	  let swNick = 0;
  	
  	const regexNick = /^[a-zA-Z0-9가-힣]{2,20}$/; 
  	const regexName = /^[가-힣a-zA-Z0-9]{2,10}$/; 
  	const regexTel = /^[0-9]{2,3}\-{1}[0-9]{3,4}\-{1}[0-9]{3,4}$/; 
  	const regexEmail = /^[a-zA-Z0-9]{2,15}\@{1}[a-z]{2,10}\.{1}[a-z]{2,10}$/; 
  	
  	function fCheck() {
  	    
  		let nickName = myform.nickName.value;
  		
  		let tel2 = myform.tel2.value.trim();
  		let tel3 = myform.tel3.value.trim();
  		if(tel2 == "") tel2 = " ";
  		if(tel3 == "") tel3 = " ";
  		let tel = myform.tel1.value+"-"+tel2+"-"+tel3;
  		
  		let email = myform.email1.value+"@"+myform.email2.value;
  		let address = myform.postcode.value+" /"+myform.address.value+" /"+myform.detailAddress.value+" /"+myform.extraAddress.value+" ";
  		
		if(swNick == 0) {
			alert("닉네임 중복을 확인해주세요");
			myform.nickName.focus();
			return false;
		} 
			else if(!regexNick.test(nickName.trim())) {
			alert("닉네임 형식을 확인해주세요");
			myform.nickName.focus();
			return false;
		} else if(!regexTel.test(tel.trim())){
			alert("전화번호 형식을 확인해주세요");
			myform.tel2.focus();
			return false;
		} else if(!regexEmail.test(email.trim())){
			alert("이메일 형식을 확인해주세요");
			myform.email1.focus();
			return false;
		}else if (address.trim()==""){
			alert("주소를 확인해주세요");
			return false;
		}
		else {
			
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
			
			myform.submit();
		}
	}
  	
		//닉네임 중복체크 (AJax처리)
		function nickNameAjaxCheck() {
			let nickName  = myform.nickName.value;
			if(!regexNick.test(nickName)){
				alert("닉네임은 2자리 이상 한글 및 숫자만 가능합니다");
				myform.nickName.focus();
				return false;
			}
			else if(nickName == '관리자' && ${sLevel} != 0) {
				alert("사용할수없는 단어(예: 관리자 등)이 있습니다 확인해주세요");
				return false;
			}
			else if(nickName == '${sNickName}') {
				alert("현재 닉네임을 그대로 사용합니다");
				swNick = 1;
				return false;
			}
			
			$.ajax({
				type : "post", //여기get은 restAPI 개념이라 URL에 데이터 붙어가는거랑은 다르다
				url : "${ctp}/member/memberNickNameDuplicateCheck",
				data : {nickName : nickName}, 
				success:function(res){
					if(res != "0"){
						alert("닉네임이 중복되었습니다.\n 다른 닉네임을 사용하세요");
						swNick = 0;
					}
					else {
						alert("사용하실수 있는 닉네임입니다\n 계속 작성해주세요")
						swNick = 1;
					}
				},//명령어 이어질때는 무조건 , 
				error : function() {
					alert("전송오류");
				}
			});
		}
		
	  	document.addEventListener('DOMContentLoaded', function () {
	  	    document.getElementById('nickName').addEventListener('keydown', function() {
	  	        swNick = 0;
	  	    });
	  	});
		
		//기존사진 유지 유지시키기
		function remainPhoto() {
			let Photo = document.getElementById('profileImage');
			Photo.style.pointerEvents='none'; 
			Photo.style.opacity='0.5'; 
			alert("기존사진을 유지합니다");
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
<p><br /></p>
<jsp:include page="/WEB-INF/views/include/memberSidebar.jsp" />
<div id="container">
  <form name="myform" id="myform" action="${ctp}/member/memberInfoUpdateOk" method="post" onsubmit="return fCheck()" enctype="multipart/form-data">
	<table class="table table-bordered">
		<tr id="subject">
			<td class="text-center" colspan="7"><b>회원 정보 수정</b></td>
		</tr>
	  	<tr>
		  	<th class="text-center"><label for="mid" class="form-label">아이디</label></th>
		  	<td colspan="7">
			  	<input type="text" name="mid" id="mid" value="${sMid}" class="form-control" readonly />
		  	</td>
	  	</tr>
	  	<tr class="mb-2">
		  	<th class="text-center"><label for="name" class="form-label">성명</label></th>
		  	<td colspan="7"><input type="text" name="name" id="name" value="${vo.name}" class="form-control" required /></td>
	  	</tr>
	  	<tr class="mb-2">
		  	<th class="text-center"><label for="nickName" class="form-label">닉네임</label></th>
	  		<td colspan="7">
	  			<div class="input-group">
	  				<input type="text" name="nickName" id="nickName" value="${vo.nickName}" class="form-control" required />
			  		<input type="button" value="닉네임중복체크" onclick="nickNameAjaxCheck()" class="btn btn-secondary" />
	  			</div>
	  		</td>
	  	</tr>
	  	<tr class="mb-2">
	  		<th class="text-center"><label for="tel1" class="form-label">전화번호</label></th>
	  		<td class="input-group align-items-center d-flex">
	  		<select class="form-select" id="tel1" name="tel1">
				  <option ${vo.tel1=='010' ? 'selected' : ''}>010</option>
				  <option ${vo.tel1=='02' ? 'selected' : ''} value="02">서울</option>
				  <option ${vo.tel1=='041' ? 'selected' : ''} value="041">천안</option>
				  <option ${vo.tel1=='042' ? 'selected' : ''} value="042">대전</option>
				  <option ${vo.tel1=='043' ? 'selected' : ''} value="043">청주</option>
				  <option ${vo.tel1=='031' ? 'selected' : ''} value="031">인천</option>
				</select>
				<span class="mx-3">-</span><input type="text" class="form-control" id="tel2" value="${vo.tel2}" name="tel2" size="4" maxlength="4" />
				<span class="mx-3">-</span><input type="text" class="form-control" id="tel3" value="${vo.tel3}" name="tel3" size="4" maxlength="4" />
			</td>
	  	</tr>
	  	<tr class="mb-2">
	  		<th class="text-center"><label for="address" class="form-label">주소</label></th>
	  		<td colspan="7">
	  			<div class="input-group mb-1">
				  	<input type="text" name="postcode" id="postcode" value="${vo.postcode}" onclick="execDaumPostcode()" placeholder="우편번호" class="form-control" readonly />
						<input type="button" onclick="execDaumPostcode()" class="btn btn-secondary" value="우편번호 찾기"><br>
					</div>
					<input type="text" name="address" id="address" value="${vo.address}" placeholder="주소" class="form-control mb-1" readonly />
					<div class="input-group mb-1">
						<input type="text" name="detailAddress" id="detailAddress" value="${vo.detailAddress}" placeholder="상세주소" class="form-control" />
						<input type="text" name="extraAddress" id="extraAddress" value="${vo.extraAddress}" placeholder="참고항목" class="form-control" readonly />
					</div>
	  		</td>
	  	</tr>
	  	<tr class="mb-2">
		    <th class="text-center">이메일</th>
		    <td colspan="7">
		    	<div class="input-group">
				    <input type="text" name="email1" id="email1" value="${vo.email1}" class="form-control" required />
				    <span class="input-group-text"><b>@</b></span>
		        <select class="form-select" id="email2" name="email2" required>
					    <option value="">선택하세요</option>
					    <option ${vo.email2 == 'naver.com' ? 'selected' : ''} value="naver.com">naver.com</option>
					    <option ${vo.email2 == 'daum.net' ? 'selected' : ''} value="daum.net">daum.net</option>
					    <option ${vo.email2 == 'gmail.com' ? 'selected' : ''} value="gmail.com">gmail.com</option>
						</select>
	        </div>
		    </td>
		</tr>
	  	<tr class="mb-2">
		  	<th class="text-center"><label for="content" class="form-label">자기소개</label></th>
		  	<td colspan="7"><textarea cols="5" name="content" id="content" class="form-control">${vo.content}</textarea></td><!--엔터키가 없음?  -->
	  	</tr>
	  	<tr class="mb-2">
		  	<th class="text-center"><label for="profileImage" class="form-label">사진(jpg,png,gif,webp)</label></th>
	  		<td colspan="7">
		  		<div style="width: 300px; text-align: center;" class="justify-content-center mb-2">
	  				<img id="previewImage" src="${ctp}/member/${vo.photo}" style="width: 100%; height: auto;">
	  			</div>
	  			<div class="input-group">
	  				<input type="file" name="profileImage" id="profileImage" accept=".jpg, .webp, .png, .gif" class="form-control" />
	  				<span onclick="remainPhoto()" class="input-group-text btn btn-info">기존사진사용버튼</span>
	  			</div>
	  		</td>
	  	</tr>
	  	<tr class="mb-2">
		  	<th class="text-center"><label for="userInfor" class="form-label">정보공개</label></th>
		  	<td colspan="7" class="text-center">
		  		<input type="radio" name="userInfor" id="YES" value="공개" <c:if test="${vo.userInfor == '공개'}">checked</c:if> class="form-check-input" /><label for="YES" class="form-label mr-3">공개</label>
		  		<input type="radio" name="userInfor" id="NO" value="비공개" <c:if test="${vo.userInfor == '비공개'}">checked</c:if> class="form-check-input" /><label for="NO" class="form-label">비공개</label>
		  	</td>
	  	</tr>
  	</table>
  	<button type="submit" class="form-control btn btn-success mb-2">회원 정보 수정</button>
  	<button type="reset" class="form-control btn btn-warning mb-2">다시입력</button>
  	<button type="button" onclick="location.href='memberMain'" class="form-control btn btn-info mb-2">돌아가기</button>
  	<input type="hidden" name="tel" id="tel" />
  	<input type="hidden" name="email" id="email" />
  	<input type="hidden" name="address2" id="address2" />
  	<input type="hidden" name="imageCheck" id="imageCheck" />
  </form>
  <div name="demo" id="demo">
  </div>
</div>
<p><br /></p>
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