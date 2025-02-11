<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>errorMain.jsp</title>
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
	<h2>에러 발생 연습 폼</h2>
	<hr/>
	<pre>
		JSP(view)파일 에서의 서블릿 에러 발생시는 JSP 파일 상단에 @page 지시자(디렉티브)를 이용하여 에러 페이지로 이동처리한다
	</pre>
	<div>
		<a href="error1" class="btn btn-success">JSP파일에서의 오류페이지 호출</a>
		<a href="errorMessage1" class="btn btn-primary">JSP파일에서의 오류페이지 호출</a><!--컨트롤러 호출  -->
	</div>
	<hr/>
	<pre>
		Servlet에서의 에러발생시 대처하는 방법 : web.xml 사용(400, 404, 405) 403=인증오류
	</pre>
	<div>
		<a href="${ctp}/errorPage/errorTest400?mid=s1234&pwd=1234&name=연습이$age=나이" class="btn btn-info">400오류</a><!--web.xml 처리-->
		<a href="${ctp}/0000000" class="btn btn-secondary">404오류</a><!--web.xml 처리-->
		<a href="${ctp}/errorPage/errorTest405" class="btn btn-warning">405오류</a><!--web.xml 처리-->
	</div>
	<hr/>
	<pre>
		Servlet에서의 에러발생시 대처하는 방법 : web.xml 사용(500)
	</pre>
	<div>
		<a href="${ctp}/errorPage/errorTest500" class="btn btn-info">500오류</a><!--web.xml 처리-->
	</div>
	
</div>
<p><br/></p>
  <footer id="bottom" class="footer">
    <jsp:include page="/WEB-INF/views/include/footer2.jsp" />
  </footer>
</body>
</html>