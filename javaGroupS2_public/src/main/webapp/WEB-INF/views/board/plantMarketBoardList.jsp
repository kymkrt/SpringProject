<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>plantMarket.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
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
		
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
	<h2>식물 매대</h2>
	<div class="input-gorup">
		<span class="input-group-text">분류선택</span>
		<select id="part" name="part" onchange="" class="form-select">
			<c:forEach var="vo" items="${parts}" varStatus="st">
				<option value="vo">${vo}</option>
			</c:forEach>
		</select>
	</div>
	
	
	<div>
		    <h2>상세 검색</h2>

    <div class="filter-group">
        <h5>제조사별</h5>
        <div class="row row-cols-md-5 row-cols-sm-3 row-cols-2 g-2 filter-options">
            <div class="col"><label><input type="checkbox"> MSI</label></div>
            <div class="col"><label><input type="checkbox"> ASUS</label></div>
            <div class="col"><label><input type="checkbox"> HP</label></div>
            <div class="col"><label><input type="checkbox"> 레노버</label></div>
            <div class="col"><label><input type="checkbox"> 에이서</label></div>
        </div>
        <div class="more-options">
            <a href="#">6개 +</a>
        </div>
    </div>

    <div class="filter-group">
        <h5>화면 크기대</h5>
        <div class="row row-cols-md-5 row-cols-sm-3 row-cols-2 g-2 filter-options">
            <div class="col"><label><input type="checkbox"> 18인치 이상</label></div>
            <div class="col"><label><input type="checkbox"> 17인치대</label></div>
            <div class="col"><label><input type="checkbox"> 16인치대</label></div>
            <div class="col"><label><input type="checkbox"> 15인치대</label></div>
            <div class="col"><label><input type="checkbox"> 14인치대</label></div>
        </div>
        <div class="more-options">
            <a href="#">1개 +</a>
        </div>
    </div>

    <div class="filter-group">
        <h5>가격대</h5>
        <div class="row g-2 align-items-center">
            <div class="col-auto">
                <input type="text" class="form-control" placeholder="최소 가격">
            </div>
            <div class="col-auto">원 ~</div>
            <div class="col-auto">
                <input type="text" class="form-control" placeholder="최대 가격">
            </div>
            <div class="col-auto">원</div>
        </div>
        <div class="mt-2">
            <button class="btn btn-primary">검색</button>
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