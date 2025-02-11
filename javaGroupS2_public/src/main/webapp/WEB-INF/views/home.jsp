<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<html>
<head>
	<title>Home</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<style type="text/css">
	
	</style>
</head>
<body>
<h1>
	Hello world!  
</h1>

<P>  The time on the server is ${serverTime}. </P>

<a href="${ctp}/main/mainPage" class="btn btn-light">메인페이지</a>
<a href="${ctp}/test/regexTest" class="btn btn-success">정규식 테스트</a>
<a href="${ctp}/test/es-gangul" class="btn btn-info">한글 처리</a>
<a href="${ctp}/test/anime_lib" class="btn btn-primary">애니메이션 처리</a>
<a href="${ctp}/test/tailwind" class="btn btn-secondary">테일윈드</a>
<a href="${ctp}/test/tailwind" class="btn bg-primary-subtle">버튼확인</a>
<a href="${ctp}/test/footer" class="btn bg-secondary-subtle">푸터 확인</a>
<a href="${ctp}/test/test" class="btn bg-dark-subtle">test 이동</a>
</body>
</html>
