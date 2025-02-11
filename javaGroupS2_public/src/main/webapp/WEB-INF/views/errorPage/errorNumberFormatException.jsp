<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page errorPage="/WEB-INF/views/errorPage/errorMessage1.jsp" %> <!--서버에 보이는 실제 경로. 컨트롤러 안타고 바로 jsp로 이동 안좋은 방법 컨트롤러타는게 좋다-->
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>errorNumberFormatException.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	  <style type="text/css">
    body {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }
    main { flex: 1; }
    footer { margin-top: auto; }
	</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
	<h2>에러 발생시 호출되는 페이지입니다(errorNumberFormatException.jsp)</h2>
	<hr/>
	<div class="img-fluid">
		<img src="${ctp}/pageImg/errorNumberFormatException.jpg" class="img-fluid" />
	</div>	
	<hr/>
	<h2>현재 시스템 정비 중입니다</h2>
	<div>(사용에 불편을 드려서 죄송합니다)</div>
	<div>빠른시일내에 복구되도록 하겠습니다</div>
	<div><a href="${ctp}/main/mainPage" class="btn btn-warning form-control">돌아가기</a></div>
</div>
<p><br/></p>
  <footer id="bottom" class="footer">
    <jsp:include page="/WEB-INF/views/include/footer2.jsp" />
  </footer>p" />
</body>
</html>