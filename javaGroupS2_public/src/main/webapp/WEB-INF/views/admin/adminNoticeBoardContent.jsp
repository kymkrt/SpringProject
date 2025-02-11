<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>adminNoticeBoardContent.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
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
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
  <div class="mt-3 p-3 bg-white rounded shadow">
    <div class="d-flex justify-content-between align-items-center">
        <h1 class="text-muted">
	      	<a href="${ctp}/admin/adminNoticeBoardList" class="text-decoration-none text-secondary">공지사항 게시판</a>
        </h1>
        <span class="text-muted">
          <c:choose>
				    <c:when test="${vo.category=='product'}">
				    	상품
				    </c:when>
				    <c:when test="${vo.category=='payment'}">
				    	결제
				    </c:when>
				    <c:when test="${vo.category=='delivery'}">
				    	배송
				    </c:when>
				    <c:otherwise>
				    	기타
				    </c:otherwise>
				</c:choose>
        </span>
    </div>
    <hr class="border border-dark border-2"/>
    <h1 class="fw-bold display-4">${vo.title}</h1>
    <div class="d-flex align-items-center text-muted small">
        <span class="me-3">${vo.nickName}</span>
        <span class="me-3">
				 ${not empty vo.postDate ? vo.postDate : ''}
        </span>
        <span class="me-3" title="조회수"><i class="bi bi-eye"></i> ${vo.viewCnt}</span>
    </div>
    <hr style="height: 1px;" class="mb-5"/>
    <div class="row mb-5">
    	<div class="col-10">
	    	${vo.content}
    	</div>
    </div>
    <hr/>
    <c:if test="${not empty fVos}">
	    <div class="mx-1">
	    	<c:forEach var="vo" items="${fVos}" varStatus="st">
	    		<div>
	    			<a href="${ctp}/noticeBoard/${vo.serverName}" download="${vo.originalName}" class="text-decoration-none text-dark link-info"><i class="bi bi-floppy"></i> ${vo.originalName}</a>
	    		</div>
	    	</c:forEach>
	    </div>
    </c:if>
    <c:if test="${empty fVos}">
    	<p><i class="bi bi-floppy"></i> 파일이 없습니다</p>
    </c:if>
    <div class="text-end">
    	<c:if test="${sLevel ==0 || SMid =='admin'}">
    		<button type="button" onclick="location.href='${ctp}/admin/adminNoticeBoardList'" class="btn btn-secondary">
    			돌아가기
    		</button>&nbsp;&nbsp;
	    	<button type="button" onclick="location.href='${ctp}/admin/adminNoticeBoardContentUpdate?idx=${vo.idx}'" class="btn btn-warning">
	    		수정하기
	    	</button>&nbsp;&nbsp;
	    	<c:url var="deleteUrl" value="/admin/adminNoticeContentDelete">
			    <c:param name="idx" value="${vo.idx}" />
			    <c:if test="${not empty vo.file}">
			        <c:param name="fileEx" value="Ok" />
			    </c:if>
				</c:url>
	    	<button onclick="location.href='${deleteUrl}'" class="btn btn-danger">
	    		삭제하기
	    	</button>
    	</c:if>
    </div>
  </div><!-- 외곽끝 -->	
</div>
<p><br/></p>
<footer class="footer">
	<jsp:include page="/WEB-INF/views/include/footer2.jsp" />
</footer>
</body>
</html>