<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>adminMain.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<!--달력 라이브러리-1개. 그외(6부터 필요없어짐)는 드래그앤드롭등의 기능-->
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js'></script>
	<script src='https://cdn.jsdelivr.net/npm/@fullcalendar/bootstrap5@6.1.14/index.global.min.js'></script>
	
	
	<style type="text/css">
		html{
		  margin: 0;
		  padding: 0;
		  box-sizing: border-box; /* 전체 요소의 경계 설정 */
		}
		
</style>
	<script type="text/javascript">
	'use strict'	
	
	document.addEventListener('DOMContentLoaded', function () {
		 let dataNew = JSON.parse('${dataNew}');
     let dataWithdraw = JSON.parse('${dataWithdraw}');
     let dataPurchase = JSON.parse('${dataPurchase}');
		
      let calendarEl = document.getElementById('calendar');
      let calendar = new FullCalendar.Calendar(calendarEl, {
          themeSystem: 'bootstrap5',
          locale: 'ko',
          initialView: 'dayGridMonth',
          headerToolbar: {
              left: 'prev,next today',
              center: 'title',
              right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
          }
      });
      
   // 신규회원 이벤트 추가
      dataNew.forEach(function(event) {
          calendar.addEvent({
              title: event.title, // 제목
              start: event.start, // 시작일
              color: event.color, // 색상
              display: event.display, // 표시 형태
              url: '${ctp}/admin/adminNewMemberList'
          });
      });

      // 탈퇴회원 이벤트 추가
      dataWithdraw.forEach(function(event) {
          calendar.addEvent({
              title: event.title, // 제목
              start: event.start, // 시작일
              color: event.color, // 색상
              display: event.display, // 표시 형태
              url: '${ctp}/admin/adminWithdrawMemberList'
          });
      });
      
      // 구매수 이벤트 추가
      dataPurchase.forEach(function(event) {
          calendar.addEvent({
              title: event.title, // 제목
              start: event.start, // 시작일
              color: event.color, // 색상
              display: event.display, // 표시 형태
              url: '${ctp}/admin/adminOrderList'
          });
      });
      
      calendar.render();
    });
	</script>
</head>
<body>
<br/>
<jsp:include page="/WEB-INF/views/include/adminSidebar.jsp" />
<div id="container">
	<h1 class="text-center">관리자 메인</h1>
	<h2 class="text-center mb-3"></h2>
	<div id="calendar"></div>
</div><!-- 콘테이너 -->
<br/>
</body>
</html>