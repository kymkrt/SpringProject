<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  String hostIp = request.getRemoteAddr();
  pageContext.setAttribute("hostIp", hostIp); // pageContext를 명시적으로 사용
%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>adminNoticeBoardInput.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script src="${ctp}/ckeditor/ckeditor.js"></script>
		<style type="text/css">
		body {
	    display: flex; 
	    flex-direction: column; 
	    min-height: 100vh; 
		}

		main {
		    flex: 1; 
		}
		footer {
		    margin-top: auto; 
		}
	</style>
	<script type="text/javascript">
		'use strict'
	
		//돌아가기 처리
		function goBack() {
			let ans = confirm("정말로 화면을 나가시겠습니까?\n사진과 글 내용은 저장되지 않습니다");
			if(!ans){
				return false;
			}
			location.href='${ctp}/admin/adminNoticeBoardList';
		}
				
		//제출
		function fCheck() {
			const fileInput = document.getElementById('files');
	    if (fileInput.files && fileInput.files.length > 0) {
	        for (const file of fileInput.files) {
	            if (file.size > (1024 * 1024 * 20)) {
	                alert("파일 업로드는 20MB까지 가능합니다");
	                return; // false가 아닌 return으로 변경 (이벤트 전파 방지 불필요)
	            }
	        }
	  	}
			myform.submit();
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
	<form name="myform" method="post" action="${ctp}/admin/adminNoticeBoardContentUpdate" enctype="multipart/form-data">
		 <div class="mt-3 p-3 bg-white rounded shadow"><!-- 제목부분 -->
		 	 <div class="d-flex justify-content-between align-items-center">
        <h1 class="text-muted">
        	<a href="javascript:goBack()" class="text-decoration-none link-dark">공지사항 게시판</a>
        </h1>
    	</div>
		 </div>
		 <div class="mt-3 p-3 bg-white rounded shadow"> <!-- 글쓰기 부분 -->
		 	<div class="d-flex justify-content-between align-items-center">
				<div>
					<span class="text-success fs-2"><i class="bi bi-pencil-square"></i> 글 수정하기</span>
				</div>
        <div class="input-group w-25">
        	<span class="input-group-text">
        		분류선택
        	</span>
	      	<select class="form-select" name="category" id="category">
	      		<option value="others" ${vo.category== 'others'? 'selected' : ''} >기타</option>
	      		<option value="product" ${vo.category== 'product'? 'selected' : ''} >상품</option>
	      		<option value="payment" ${vo.category== 'payment'? 'selected' : ''} >결제</option>
	      		<option value="delivery" ${vo.category=='delivery' ? 'selected' : ''} >배송</option>
	      	</select>
        </div>
		 	</div>
		 </div>
		 <div class="mt-3 p-3 bg-white rounded shadow">
			 <div class="input-group">
			 	<span class="input-group-text">제목</span>
			 	<input type="text" name="title" id="title" value="${vo.title}" class="form-control" required />
			 </div>
			 <hr/>
			 <div>
			 	<textarea rows="6" name="content" id="CKEDITOR" class="form-control" placeholder="게시글 내용을 입력하세요" required>
			 		${vo.content}
			 	</textarea>
			 	<script>
     			CKEDITOR.replace("content", {
     				height: 480,
     				filebrowserUploadUrl: "${ctp}/admin/adminImageUpload",
     				uploadUrl: "${ctp}/admin/adminImageUpload"
     			});
     	 	</script>
			 </div>
			 <div class="input-group mt-3">
			 <span class="input-group-text">첨부파일</span>
			 	<input type="file" name="files[]" id="files" class="form-control" multiple />
			 	<span class="input-group-text btn-info">파일 유지하기</span>
			 </div>
			 <div id="fileList" class="my-2">
			 </div>
			 <span class="fs-5 fw-bold">기존파일 리스트</span>
			 <div id="existingFileList" class="mt-1">
			 	<c:if test="${empty vos}">
			 		<p>기존 파일이 없습니다</p>
			 	</c:if>
			 	<c:if test="${!empty vos}">
			 		<c:forEach var="vo" items="${vos}" varStatus="st">
			 			<div>
			 			</div>
		    		<div>
		    			 ${vo.originalName} / ${vo.serverName} 
		    			 <input type="checkbox" id="deleteChcekServer${vo.serverName}" name="deleteCheck[]" value="${vo.serverName}/${vo.originalName}" class="form-check-input">
		    			 <label for="deleteChcekServer${vo.serverName}"><span class="badge text-bg-warning">파일 삭제</span></label>
		    		</div>
	    		</c:forEach>
			 	</c:if>
			 </div>
			 <div class="d-flex justify-content-around align-items-center input-group mt-3">
			 	<span class="input-group-text">정보 공개 여부</span>
			 	<span class="fs-5">
				 	<input type="radio" name="openSw" id="openSw1" value="공개" class="form-check-input" ${vo.openSw=='공개'?'checked':''} />
			 	  <label class="form-check-label" for="openSw1">
	 				 공개
					</label>
			 	</span>
			 	<span class="fs-5">
				 	<input type="radio" name="openSw" id="openSw2" value="비공개" class="form-check-input" ${vo.openSw=='비공개'?'checked':''} />
			 	  <label class="form-check-label" for="openSw2">
	 				 비공개
					</label>
			 	</span>
			 </div>
	     <div class="d-flex justify-content-around align-items-center mt-3">
	    	<c:if test="${sLevel ==0 || SMid =='admin'}">
		    	<button type="button" onclick="fCheck()" class="btn btn-info w-25">
		    		수정하기
		    	</button>
		    	<button type="button" onclick="javascript:goBack()" class="btn btn-danger w-25">
		    		돌아가기
		    	</button>
	    	</c:if>
	    </div>
		 </div>
		 <input type="hidden" name="mid" id="mid" value="${sMid}" />
		 <input type="hidden" name="nickName" id="nickName" value="${sNickName}" />
		 <input type="hidden" name="hostIp" id="hostIp" value="${hostIp}" />
		 <input type="hidden" name="eIdx" id="eIdx" value="${vo.idx}" />
	</form>
</div>
<p><br/></p>
<footer class="footer">
	<jsp:include page="/WEB-INF/views/include/footer2.jsp" />
</footer>
<script type="text/javascript">
	'use strict'
	
		const files = document.getElementById('files');
		const fileList = document.getElementById('fileList');
		
		function handleFileChange(event) { // 이벤트 핸들러 함수를 변수에 할당
		    fileList.innerHTML = '';
		
		    const files = event.target.files;
		
		    if (files.length > 0) {
		        const ul = document.createElement('ul');
		        for (const file of files) {
		            if (file.size > (1024 * 1024 * 20)) {
		                alert("파일 업로드는 20MB까지 가능합니다");
		                resetFileInput();
		                return; // false가 아닌 return으로 변경 (이벤트 전파 방지 불필요)
		            }
		            const li = document.createElement('li');
		            li.textContent = file.name + ' (' + formatFileSize(file.size) + ')';
		            ul.appendChild(li);
		        }
		        fileList.appendChild(ul);
		    } else {
		        fileList.textContent = '선택된 파일이 없습니다.';
		    }
		}
		
		files.addEventListener('change', handleFileChange); // 이벤트 리스너 추가
		
		function resetFileInput() {
		    const files = document.getElementById('files');
		    const newFileInput = files.cloneNode(true);
		
		    // 기존 이벤트 리스너 제거
		    files.removeEventListener('change', handleFileChange);
		
		    files.parentNode.replaceChild(newFileInput, files);
		
		    // 새로운 엘리먼트에 이벤트 리스너 다시 추가
		    newFileInput.addEventListener('change', handleFileChange);
		}
		
		// 파일 크기를 보기 좋게 포맷하는 함수
		function formatFileSize(bytes) {
		    if (bytes < 1024) {
		        return bytes + ' bytes';
		    } else if (bytes < 1048576) {
		        return (bytes / 1024).toFixed(2) + ' KB';
		    } else if (bytes < 1073741824) {
		        return (bytes / 1048576).toFixed(2) + ' MB';
		    } else {
		        return (bytes / 1073741824).toFixed(2) + ' GB';
		    }
		}
		
</script>
</body>
</html>