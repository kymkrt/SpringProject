<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>userTrends.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script type="text/javascript">
		'use strict';
		
    let myChart; // 차트 객체를 저장할 변수
    
		$(document).ready(function() {
	    let typeCheck = document.getElementById('typeCheck');

	    // 필터 변경 이벤트 리스너
	   $('input[name="time"], input[type="checkbox"]').click(function () {
		   
		   let shouldSendAjax = true; // AJAX 요청을 보내야 하는지 여부를 저장하는 변수

		    if ($(this).is('input[name="time"]')) { // 클릭된 요소가 time input인 경우
		        const checkedCount = $('input[type="checkbox"]:checked').length; // 체크된 체크박스 개수

		        if (checkedCount === 0) { // 체크된 체크박스가 하나도 없다면
		            console.log("체크박스가 하나도 선택되지 않았습니다. AJAX 요청을 보내지 않습니다.");
		            shouldSendAjax = false; // AJAX 요청을 보내지 않도록 설정
		        }
		    }
		   
		    if (shouldSendAjax) { // AJAX 요청을 보내야 하는 경우에만 실행
	        // 선택된 필터 값 수집
	        let filters = getFilters();
					let typeFlag = document.getElementById('typeFlag').value;	
		    
	        // AJAX 요청
	        $.ajax({
	            url: '${ctp}/admin/adminDashBoard/userTrends/getNewData?typeFlag='+typeFlag, // 데이터를 가져올 URL
	            type: 'GET',
	            data: filters, // 필터 값을 파라미터로 전달
	            dataType: "json",
	            success: function(data) {
	            	console.log(data);
            	  // 차트 업데이트
            	  let checkedDatas = getCheckedDatas();
            	  console.log(checkedDatas);
                createChart(data, checkedDatas);
                
	            },
	            error: function(error) {
	                console.error("Error fetching chart data:", error);
	                alert("데이터를 가져오는 중 오류가 발생했습니다.");
	            }
	        });
		    }
	    });

	    // 필터 값 수집 함수
	    function getFilters() {
	        const filters = {};

	        // 시간 (라디오 버튼)
	        filters.time = $('input[name="time"]:checked').val();

	        // 성별 (체크박스)
	        filters.male = $('#male').is(':checked');
	        filters.female = $('#female').is(':checked');

	        // 로그인 타입 (체크박스)
	        filters.normal = $('#normal').is(':checked');
	        filters.kakao = $('#kakao').is(':checked');

	        // 나이 (체크박스)
	        filters.twenties = $('#twenties').is(':checked');
	        filters.thirties = $('#thirties').is(':checked');
	        filters.forties = $('#forties').is(':checked');
	        filters.fifties = $('#fifties').is(':checked');
	        filters.sixties = $('#sixties').is(':checked');
	        filters.sevties = $('#sevties').is(':checked');
	        return filters;
	    }
	    
	    // 직접 데이터 수집 함수
	    function getCheckedDatas() {
		    const checkedDatas = {};
		
		 // 성별 (체크박스) - 수정됨
		    checkedDatas.남자 = $('input#male:checked').map(function() { return $(this).val(); }).get();
		    checkedDatas.여자 = $('input#female:checked').map(function() { return $(this).val(); }).get();

		    // 로그인 타입 (체크박스) - 수정됨
		    checkedDatas.일반회원 = $('input#normal:checked').map(function() { return $(this).val(); }).get();
		    checkedDatas.카카오회원 = $('input#kakao:checked').map(function() { return $(this).val(); }).get();

		    // 나이 (체크박스) - 수정됨
		    checkedDatas._20대 = $('input#twenties:checked').map(function() { return $(this).val(); }).get();
		    checkedDatas._30대 = $('input#thirties:checked').map(function() { return $(this).val(); }).get();
		    checkedDatas._40대 = $('input#forties:checked').map(function() { return $(this).val(); }).get();
		    checkedDatas._50대 = $('input#fifties:checked').map(function() { return $(this).val(); }).get();
		    checkedDatas._60대 = $('input#sixties:checked').map(function() { return $(this).val(); }).get();
		    checkedDatas._70대 = $('input#sevties:checked').map(function() { return $(this).val(); }).get();
				
		    return checkedDatas;
			}

	    //타입을 바꾸면 체크박스 전부 해제
    	$('#typeFlag').change(function() {
	    	$('input[type="checkbox"]').prop('checked', false); // 모든 체크박스 해제			
	    	let typeFlag = document.getElementById('typeFlag').value;
	    	 if(typeFlag=='new'){
          $('#typeCheck').text('신규가입자');
          $('#moreInfo').show();
         }else if(typeFlag=='withdraw'){
          $('#typeCheck').text('탈퇴/정지 회원');
          $('#moreInfo').hide();
         }
    	  if (myChart) { 
  		    myChart.destroy();
  		    myChart = null; 
    		}
	    });
	    
		});
	</script>
</head>
<body>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/adminSidebar.jsp" />
<div id="container">
	<h1 class="text-center">유저경향(<span id="typeCheck">신규가입자</span>)</h1>
	<h2 class="text-center" id="moreInfo">탈퇴회원 포함</h2>
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
	
	<script>
	//json 파싱법
	//let labels = JSON.parse('${dayList != null ? dayList : "[]"}');
		function getRandomRgbColor() {
		    const r = Math.floor(Math.random() * 256); // 0부터 255 사이의 랜덤한 정수
		    const g = Math.floor(Math.random() * 256);
		    const b = Math.floor(Math.random() * 256);
		    return 'rgb(' + r + ', ' + g + ', ' + b + ')';
		}
	
		// 차트 업데이트 함수 -labels=x값. 날짜 label 데이터 태그(성별 등)
	    // 차트 업데이트 함수
		function createChart(newData, checkedDatas) {
			 if (!newData || !newData.dates || !newData.data || !newData.Label) {
			        alert("데이터가 없습니다. 차트를 생성할 수 없습니다.");
			        document.getElementById('demo').innerHTML = '<p>데이터가 없습니다.</p>';
			        return false;
			    }

			    // 기존 차트 삭제
			    if (myChart) {
			        myChart.destroy();
			    }
			    console.log("뉴데이터 : "+newData);
			    console.log("체크데이터 : "+checkedDatas);
			    // 새로운 데이터 생성
			    const datasets = [];
			    for (let i = 0; i < newData.Label.length; i++) {
			        const label = newData.Label[i]; // '남자'
			        
			        // checkedDatas에 해당 label이 존재하고, 값이 비어있지 않은 경우
			        if (checkedDatas[label] && checkedDatas[label].length > 0) {
			            datasets.push({
			                label: label,
			                data: newData.data[label], // newData.data['남자']
			                fill: false,
			                borderColor: newData.colorMap[label],
			                backgroundColor: newData.colorMap[label],
			                pointStyle: 'circle',
			                pointRadius: 5,
			                pointHoverRadius: 10,
			                tension: 0.1
			            });
			        }
			    }
					
			    if (datasets.length === 0) {
			    		console.log(datasets);
			    		console.log("생성데이터셋 : "+datasets);
			    		console.log(datasets);
			        alert("선택된 데이터가 없습니다.");
			        return false;
			    }
		    		console.log("생성데이터셋 : "+datasets);
		    		console.log(datasets);

			    // 차트 생성
			    const ctx = document.getElementById('myChart').getContext('2d');
			    myChart = new Chart(ctx, {
			        type: 'line',
			        data: {
			            labels: newData.dates,
			            datasets: datasets
			        },
			        options: {
			            scales: {
			                y: {
			                    beginAtZero: true,
			                    ticks: {
			                        stepSize: 1
			                    }
			                }
			            },
			            responsive: true,
			            maintainAspectRatio: false
			        }
			    });
		}
		    	  
		
		//차트업데이트
		function updateDataset() {
			 let data; // 조건문 외부에서 변수 선언
			    
			    if (!newData|| !newData.dates || !newData.data || !newData.Label) {
			        alert("데이터가 없습니다. 차트를 생성할 수 없습니다.");
			        document.getElementById('demo').innerHTML = '<p>데이터가 없습니다.</p>'; // 차트를 감싸는 컨테이너
			        return false;
			    } else {
			        data = {
			            labels: newData.dates,
			            datasets: [{
			                label: newData.Label[0],
			                data: newData.data.남자,
			                fill: false,
			                borderColor: getRandomRgbColor(),
			                tension: 0.1
			            }]
			        };
			    }
			    const options = {
				        scales: {
				            y: {
				                beginAtZero: true, // y축 시작점을 0으로 설정 (필요에 따라 조절)
				                ticks: {
				                    stepSize: 1, // y축 간격을 1로 설정
				                },
				            },
				        },
				        responsive: true, // 차트가 반응형으로 동작하도록 설정
				        maintainAspectRatio: false, // 비율 유지 여부 설정
				    };
			    // 기존 차트가 있으면 삭제
			    if (myChart) {
			        myChart.destroy(); // 기존 차트를 파괴
			    }
					
			    // 차트 생성
			    const ctx = document.getElementById('myChart').getContext('2d');
			    myChart = new Chart(ctx, {
			        type: 'line', // 그래프의 종류
			        data: data, // 데이터 설정
			        options: options, // 옵션 설정
			    });
		}
		
		$(window).on('resize', function() {
		    setTimeout(function() {
		        if (myChart) {
		            myChart.resize();
		        }
		    }, 100);
		});
		
	</script>
</body>
</html>