<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>memberPwdCheck.jsp</title>
	<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
	<script type="text/javascript">
		'use strict';
		
	</script>
	<!-- <script src="https://cdn.tailwindcss.com"></script> -->
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<style type="text/css">
	 .footer { 
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
			flex: 1; /* 남는 공간을 차지하게 함 */
		}
	</style>
</head>
<body>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/memberSidebar.jsp" />
<div id="container">
<c:if test="${flag=='update'||flag=='pwd'||flag=='withdraw'}">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-12">
                <c:if test="${flag=='update'}"><h2 class="text-center mb-4 display-4 fw-bold">회원정보수정</h2></c:if>
                <c:if test="${flag=='pwd'}"><h2 class="text-center mb-4 display-4 fw-bold">비밀번호변경</h2></c:if>
                <c:if test="${flag=='withdraw'}"><h2 class="text-center mb-4 display-4 fw-bold">회원탈퇴</h2></c:if>

                <div class="card shadow">
                    <div class="card-body p-4">
                        <form action="<c:choose><c:when test="${flag=='update'}">${ctp}/member/memberInfoUpdate?flag=update</c:when><c:when test="${flag=='pwd'}">${ctp}/member/memberPwdUpdate?flag=pwd</c:when><c:when test="${flag=='withdraw'}">${ctp}/member/memberWithdraw?flag=withdraw</c:when><c:otherwise>${ctp}/member/memberMain</c:otherwise></c:choose>" method="post">
                            <div class="mb-3">
                                <label for="pwd" class="form-label fs-2 fw-bold">비밀번호</label>
                                <input type="password" id="pwd" name="pwd" class="form-control form-control-lg" placeholder="비밀번호를 입력하세요" required>
                            </div>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-lg btn-success">비밀번호 확인</button>
                            </div>
                        </form>
                        <c:if test="${empty sLevel}">
	                        <div class="mt-4 text-center">
	                            <a href="${ctp}/member/memberPwdSearch" class="btn btn-sm btn-outline-secondary">비밀번호 찾기</a>
	                        </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</c:if>

<c:if test="${empty flag&&flag!='update'&&flag!='pwd'&&flag!='withdraw'}">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <h2 class="text-center mb-4 display-4 fw-bold">잘못된 접근입니다</h2>
                <div class="d-grid gap-2">
                    <a href="${ctp}/member/memberMain" class="btn btn-lg btn-primary">돌아가기</a>
                </div>
            </div>
        </div>
    </div>
</c:if>
</div>
<p><br/></p>
</body>
</html>