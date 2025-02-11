<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>noticeBoardList.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<!-- <script src="https://cdn.tailwindcss.com"></script> -->
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
  
  	function pageChange() {
  		let category = document.getElementById("category").value;
  		let boardType = 'notice';
			let pageSize = document.getElementById("pageSize").value;
			location.href="${ctp}/admin/adminNoticeBoardList?pageSize="+pageSize+"&pag=${pageVO.pag}&boardType="+boardType+"&category="+category;			
		}
		  	
	  	
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
	<h2 class="display-4 fw-bold mb-5 text-center text-dark">공지사항 게시판</h2>
	<div class="row mb-3">
		<div class="col-3">
			<div class="input-group">
				<span class="input-group-text">분류별 보기</span>
				<select name="category" id="category" class="form-select" onchange="pageChange()"><!--온체인지 아니면 버튼 또 눌러야 됨  -->
					<option value="all" <c:if test="${category == 'all'}">selected</c:if> >전체보기</option>
					<option value="product" <c:if test="${category == 'product'}">selected</c:if> >상품</option>
					<option value="payment" <c:if test="${category == 'payment'}">selected</c:if> >결제</option>
					<option value="delivery" <c:if test="${category == 'delivery'}">selected</c:if> >배송</option>
					<option value="others" <c:if test="${category == 'others'}">selected</c:if> >기타</option>
				</select>	
			</div>		
		</div>
		<div class="col-6">
		</div>
		<div class="col-3">
			<div class="input-group">
				<span class="input-group-text">페이지</span>
				<select name="pageSize" id="pageSize" class="form-select" onchange="pageChange()"><!--온체인지 아니면 버튼 또 눌러야 됨  -->
					<option <c:if test="${pageVO.pageSize == 15}">selected</c:if>>15</option>
					<option <c:if test="${pageVO.pageSize == 20}">selected</c:if>>20</option>
					<option <c:if test="${pageVO.pageSize == 30}">selected</c:if>>30</option>
					<option <c:if test="${pageVO.pageSize == 50}">selected</c:if>>50</option>
				</select>	
			</div>		
		</div>
	</div>
	
  <table class="table table-hover text-center">
	  <tr class="table table-secondary">
	  	<th>글번호</th>
	  	<th>분류</th>
	  	<th>글제목</th>
	  	<th>글쓴이</th>
	  	<th>글쓴날짜</th>
	  	<th>조회수</th>
	  </tr>
	  <!-- 생략가능 아래에 직접 들어가기 때문 -->
	  <c:set var="curScrStartNo" value="${pageVO.curScrStartNo}" />
	  <c:forEach var="vo" items="${vos}" varStatus="st">
	  	<c:if test="${vo.openSw == '공개' || sMid == vo.mid || sLevel == 0}">
			  <tr>
			  	<td>${curScrStartNo}</td>
			  	<td>
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
			  	</td>
			  	<td>
			  		<a href="${ctp}/admin/adminNoticeBoardContent?idx=${vo.idx}" class="text-decoration-none text-dark link-primary fs-6 fw-bold">${vo.title}<c:if test="${vo.time_diff <= 24}"><img src="${ctp}/images/new.gif" /></c:if></a>
			  	</td>
			  	<td>${vo.nickName}</td>
			  	<td>${vo.postDate}</td>
			  	<td>${vo.viewCnt}</td>
			  </tr>
		  </c:if>
		  <!--얘는 빼는거라 있어야함  -->
		  <c:set var="curScrStartNo" value="${curScrStartNo - 1}" />
	  </c:forEach>
  </table>
  <br/>
  <!--사용자 페이지 설정  -->
  <div class="row">
  	<div class="col-5">
  	</div>
  	<div class="col-5">
  	</div>
  	<div class="col-2">
  		<c:if test="${sLevel == 0 || sMid=='admin'}">
				<a href="${ctp}/admin/adminNoticeBoardInput" class="btn btn-success form-control">
					글쓰기
				</a>
  		</c:if>
  	</div>
  </div>
  			
	<!-- 블록페이지 시작-->	
  <div class="text-center">
	  <ul class="pagination justify-content-center">
		  <c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link text-secondary" href="adminNoticeBoardList?pageSize=${pageVO.pageSize}&pag=1">첫페이지</a></li></c:if>
		  <c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link text-secondary" href="adminNoticeBoardList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li></c:if>
		  <c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize)+1}" end="${(pageVO.curBlock*pageVO.blockSize) + pageVO.blockSize}" varStatus="st">
		    <c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link bg-secondary border-secondary" href="adminNoticeBoardList?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li></c:if>
		   	<!-- 배타적 처리 필요 -->
		    <c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link text-secondary" href="adminNoticeBoardList?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li></c:if>
		  </c:forEach>
			  <c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link text-secondary" href="adminNoticeBoardList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}">다음블록</a></li></c:if>
			  <c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link text-secondary" href="adminNoticeBoardList?pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}">마지막페이지</a></li></c:if>
	  	</ul>
		</div>
  	
 	 <!--검색기 시작  -->
  <div class="row mb-2">
    <div class="col-md-6 offset-md-3">
      <form name="searchForm" method="get">
        <div class="input-group">
          <span class="input-group-text">검색</span>
          <select name="part" id="part" class="form-select">
            <option value="title" ${part=='title'?'selected':''}>제목</option>
            <option value="content" ${part=='content'?'selected':''}>글내용</option>
          </select>
          <input type="text" name="searchString" id="searchString" class="form-control" value="${searchString}" required />
          <input type="submit" value="검색" class="btn btn-secondary" />
        </div>
        <input type="hidden" name="pag" value="${pageVO.pag}" />
        <input type="hidden" name="pageSize" value="${pageVO.pageSize}" />
      </form>
    </div>
	</div>
  <!--검색기 끝  -->
  
  <!-- The Modal -->
	<div class="modal fade" id="myModal">
	  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h3 class="modal-title">자기소개</h3>
	        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	      </div>
	      <div class="modal-body">
	        <span id="modalContent">${vo.content}</span>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
	      </div>
	    </div>
	  </div>
	</div>
	<!--모달 끝  -->
	
</div>
<p><br/></p>
<footer>
	<jsp:include page="/WEB-INF/views/include/footer2.jsp" />
</footer>
</body>
</html>