<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>orderTrends.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/adminSidebar.jsp" />
<div id="container">
	<h1 class="text-center">주문추세(<span id="typeCheck">관리자</span>)</h1>
		<h2 class="text-center" id="moreInfo">식물데이터</h2>
	<div class="row">
		<div class="col-8">
	  	<canvas id="myChart"></canvas>
	  	<span id="demo" class="my-2"></span>
		</div>
		<div class="col-4 text-end">
			<table class="table table-hover table-bordered text-center align-items-center">
				<tr>
					<th colspan="2">
						<span class="fs-5">유형선택</span>
					</th>
				</tr>
				<tr>
					<td colspan="2">
						<select id="typeFlag" name="typeFlag" class="form-select">
							<option value="new">신규가입</option>
							<option value="withdraw">탈퇴회원</option>
						</select>
					</td>
				</tr>
				<tr class="table-secondary">
					<th colspan="2">
						시간을 고르고 데이터를 추가하세요
					</th>
				</tr>
				<tr>
					<th><span class="fs-4">시간</span></th>
					<td class="align-items-center">
						<input type="radio" name="time" id="year" value="year" ${chartVo.time=='year'? 'checked':''} class="form-check-input" />
		     		<label class="form-check-label" for="year">년</label>
		     		<input type="radio" name="time" id="month" value="month" ${chartVo.time=='month'? 'checked':''} class="form-check-input" />
		     		<label class="form-check-label" for="month">월</label>
		     		<input type="radio" name="time" id="week" value="week" ${chartVo.time=='week'? 'checked':''} class="form-check-input" />
		     		<label class="form-check-label" for="week">주</label>
		     		<input type="radio" name="time" id="day" value="day" ${(empty chartVo || chartVo.time=='day')? 'checked':''} class="form-check-input" />
		     		<label class="form-check-label" for="day">일</label>
					</td>
				</tr>
				<tr>
					<th><span class="fs-4">성별</span></th>
					<td class="text-center align-items-center">
						<input type="checkbox" name="male" id="male" ${chartVo.gender=='male'? 'checked':''} value="남자" class="form-check-input" />
		     		<label class="form-check-label" for="male">남자</label>
		     		<input type="checkbox" name="female" id="female" ${chartVo.gender=='female'? 'checked':''} value="여자" class="form-check-input" />
		     		<label class="form-check-label" for="female">여자</label>
					</td>
				</tr>
				<tr>
					<th><span class="fs-4">로그인 타입</span></th>
					<td class="text-center align-items-center">
						<input type="checkbox" name="normal" id="normal" ${chartVo.loginType=='normal'? 'checked':''} value="일반회원" class="form-check-input" />
		     		<label class="form-check-label" for="normal">일반회원</label>
		     		<input type="checkbox" name="kakao" id="kakao" ${chartVo.loginType=='kakao'? 'checked':''} value="카카오회원" class="form-check-input" />
		     		<label class="form-check-label" for="kakao">카카오회원</label>
					</td>
				</tr>
				<tr>
					<th><span class="fs-4">나이</span></th>
					<td class="text-center align-items-center">
		     		<input type="checkbox" name="twenties" id="twenties" ${chartVo.strAge=='twenties'? 'checked':''} value="20대" class="form-check-input" />
		     		<label class="form-check-label" for="twenties">20대</label>
		     		<input type="checkbox" name="thirties" id="thirties" ${chartVo.strAge=='thirties'? 'checked':''} value="30대" class="form-check-input" />
		     		<label class="form-check-label" for="thirties">30대</label>
		     		<input type="checkbox" name="forties" id="forties" ${chartVo.strAge=='forties'? 'checked':''} value="40대" class="form-check-input" />
		     		<label class="form-check-label" for="forties">40대</label>
		     		<input type="checkbox" name="fifties" id="fifties" ${chartVo.strAge=='fifties'? 'checked':''} value="50대" class="form-check-input" />
		     		<label class="form-check-label" for="fifties">50대</label>
		     		<input type="checkbox" name="sixties" id="sixties" ${chartVo.strAge=='sixties'? 'checked':''} value="60대" class="form-check-input" />
		     		<label class="form-check-label" for="sixties">60대</label>
		     		<input type="checkbox" name="sevties" id="sevties" ${chartVo.strAge=='sevties'? 'checked':''} value="70대" class="form-check-input" />
		     		<label class="form-check-label" for="sevties">70대</label>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<p><br/></p>
<script type="text/javascript">
	'use strict'
	
		function getRandomRgbColor() {
	    const r = Math.floor(Math.random() * 256); // 0부터 255 사이의 랜덤한 정수
	    const g = Math.floor(Math.random() * 256);
	    const b = Math.floor(Math.random() * 256);
	    return 'rgb(' + r + ', ' + g + ', ' + b + ')';
	}
	
		document.addEventListener('DOMContentLoaded', function() {
		    const ctx = document.getElementById('myChart');
		    new Chart(ctx, {
		        type: 'bubble',
		        data: {
		            datasets: [{
		                label: '판매 데이터',
		                data: [{
		                    x: -10,
		                    y: 50,
		                    r: 20
		                }, {
		                    x: 20,
		                    y: 80,
		                    r: 30
		                }, {
		                    x: 50,
		                    y: 30,
		                    r: 15
		                }, {
		                    x: 80,
		                    y: 60,
		                    r: 25
		                }],
		                backgroundColor: 'rgba(54, 162, 235, 0.5)',
		                borderColor: 'rgba(54, 162, 235, 1)',
		                borderWidth: 1
		            }]
		        },
		        options: {
		            scales: {
		                x: {
		                    title: {
		                        display: true,
		                        text: '온도 (°C)'
		                    },
		                    min: -20,
		                    max: 100
		                },
		                y: {
		                    title: {
		                        display: true,
		                        text: '습도 (%)'
		                    },
		                    min: 0,
		                    max: 100
		                }
		            }
		        }
		    });
		});
</script>
</body>
</html>