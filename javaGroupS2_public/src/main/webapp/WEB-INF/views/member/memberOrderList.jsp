<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>memberOrderList.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script type="text/javascript">
		'use strict';
		
		let myChart; // 차트 객체를 저장할 변수
		
		//전체 체크 및 전체 해제
		function allChecking() {
			let orderCheckBtns = document.getElementsByName("orderCheck");
			let allCheckBtn = document.getElementById("allCheck");
			if(allCheckBtn.checked){
				for(let i=0; i<orderCheckBtns.length; i++){
					orderCheckBtns[i].checked = true;
				}
			}else{
				for(let i=0; i<orderCheckBtns.length; i++){
					orderCheckBtns[i].checked = false;
				}
			}
		}
				
		//동적으로 목록 불러오기
		 function viewCheckOption(e) {//viewCheckOption_2
			 		if(e.value=="") return false;		
			 
			    let container = document.getElementById("viewCheck"); //아래 select가 있는 div
			    let plusSelect = document.getElementById("plusSelect"); // 기존 select 엘리먼트 가져오기 - 기존 select 부분
						
			    if (!plusSelect) { // select 엘리먼트가 존재하지 않는 경우에만 생성
			        console.log("셀렉트 없을때 들어오는 부분. 옵션부분 select를 생성하는것");
			        plusSelect = document.createElement("select");
			        plusSelect.classList.add("form-select");
			        plusSelect.id = "plusSelect";
							
			        // 이벤트 리스너는 select 생성 시점에 한 번만 추가
			        plusSelect.addEventListener('change', (e) => {
			            console.log("선택된 값:", e.target.value);
			            let optionValue = document.getElementById("viewCheckOption").value;
			            location.href = "${ctp}/member/memberOrderList?pageSize=${pageSize}&pag=${pag}&option="+optionValue+"&subOption="+ e.target.value;
			        });
							
			        container.appendChild(plusSelect);
			    } else{
			        plusSelect.innerHTML = ""; // 기존 option들 비워주기.
			    }

			    $.ajax({
			        type: "post",
			        url: "${ctp}/member/memberOrderOptionDataList",
			        data: {
			            optionData: e.value
			        },
			        dataType: "json",
			        success: function(res) {
			            if (res && res.length > 0) {
			                let optionZero = new Option("선택하세요", "");
			                plusSelect.appendChild(optionZero);
											
                      for (let i = 0; i < res.length; i++) {
                          let item = res[i];
                          let option = new Option(item, item);
                          plusSelect.appendChild(option);
                      }
			            } else {
			                alert("데이터가 없습니다.");
			                return;
			            }
			        },
			        error: function() {
			            alert("전송 실패");
			            return;
			        }
			    });
			}
		 
		 document.addEventListener("DOMContentLoaded", function () {
		    document.querySelectorAll(".open-modal-btn").forEach(button => {
	        	button.addEventListener("click", function () {
            	let modalMid = this.getAttribute("data-title");

            	document.getElementById("deleteMid").value = modalMid;
	        	});
		    });
			});
		
		 
		 //차트 데이터 불러오기
		$(document).ready(function() {
		    $('#chartSelect').change(function() {
		    	let chartSelectValue = document.getElementById("chartSelect").value;
		    	
		        if (myChart) {
		            myChart.destroy();
		        }
		        console.log("선택값:"+chartSelectValue);
						
		        $.ajax({
		        	type: "post",
		        	url: "${ctp}/member/memberOrderDataChartCountList",
		        	data: {
		        		chartSelectValue: chartSelectValue,
		        		chartType : 'pie',
		        		listType: 'all'
		        	},success: function(res) {
								if(res !=null ||res !=''){
									console.log("res 값(ajax) : "+res);
									let	chartModalTitle = document.getElementById('chartModalTitle');
									let word;
									switch (chartSelectValue) {
										case 'productName':
										word = '상품이름별';
										break;
										case 'customerMid':
										word = '주문자별';
										break;
									}
									createChart(res, word);
								}else{
									$("#demo").html("<p>자료가 없습니다.</p>");
								}
							},error: function() {
								alert("전송오류");
							}
		        });
		        
		        $('#chartModal').modal('show');
		    });
		});
		 
		 function createChart(newData, chartSelectValue) {
			 if (typeof newData === "string") {
   			 newData = JSON.parse(newData);
				}
			 
			 if (!newData || !newData.data || !newData.Label) {
			        alert("데이터가 없습니다. 차트를 생성할 수 없습니다.");
			        document.getElementById('demo').innerHTML = '<p>데이터가 없습니다.</p>';
			        return false;
			    }

			    // 기존 차트 삭제
			    if (myChart) {
			        myChart.destroy();
			    }
			    console.log("뉴데이터 : "+newData);
			    // 새로운 데이터 생성
			    const dataArray = [];
					const colorArray = [];

					for (let i = 0; i < newData.Label.length; i++) {
					    const label = newData.Label[i]; // 예: '남자', '여자'
					    dataArray.push(newData.data[label]); // 각 label에 해당하는 데이터 값 추가
					    colorArray.push(newData.colorMap[label]); // 각 label에 해당하는 색상 추가
					}
			    const datasets = [];
			    //Label = 남자 같은 범주?
          datasets.push({
            data: dataArray, // 데이터 배열 사용 // 배열로 감싸기 // newData.data['남자']
            borderColor: colorArray,
            backgroundColor: colorArray, // 색상 배열 사용
          });
					
			    if (datasets.length === 0) {
			    		console.log(datasets);
			    		console.log("생성데이터셋 : "+datasets);
			    		console.log(datasets);
			        alert("선택된 데이터가 없습니다.");
			        return false;
			    }
		    		console.log("생성데이터셋 : "+datasets);
		    		console.log(datasets);
					
		    		const options = {
              responsive: true,
              maintainAspectRatio: false,
              animation: {
               animateRotate: true, // 회전 애니메이션 활성화
               animateScale: true, // 확대/축소 애니메이션 활성화
               duration: 1000,
               easing: 'easeOutQuart'
              },
              plugins: {
                  legend: {
                      display: true, // 범례 표시
                      position: 'right', // 범례 위치 (top, bottom, left, right, chartArea)
                      align: 'center', // 범례 항목 정렬 (start, center, end)
                      labels:{
                          font:{
                              size:16 //범례 폰트 사이즈
                          }
                      }
                  },
                  title: {
                      display: true,
                      text: chartSelectValue,
                      font:{
                          size:30
                      }
                  },
                  tooltip: {
                      enabled: true, // 툴팁 표시
                      callbacks: {
                          label: function(context) {
                              let label = context.label || '';

                              if (label) {
                                  label += ': ';
                              }
                              if (context.parsed.y !== null) {
                              	label += new Intl.NumberFormat('ko-KR').format(context.raw) + '개';
                              }
                              return label;
                          },
                          title: function(context){
                              return context[0].label + "의 비율"
                          }
                      }
                  }	
              }
            };
		    		
			    // 차트 생성
    		 const ctx = document.getElementById('myChart').getContext('2d');
		        myChart = new Chart(ctx, {
		            type: 'pie',
		            data:  {
			            labels: newData.Label,
			            datasets: datasets
			        },
		            options: options,
		        });
		 }
		 
	</script>
</head>
<body>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/memberSidebar.jsp" />
<div id="container">
	<h2 class="text-center">전체 주문 데이터 목록</h2>
	<div class="row mb-2">
		<div class="col-4">
		</div>
		<div class="col-4"></div>
		<div class="col-4 text-end">
		</div>
	</div>
	<div class=" my-2">
		<!-- tr class="userDel eq 'OK' ? 'table-warning' : '' 이거 저온 다습 고온다습 에 따라 다르게 표기  -->
	</div>
	<table class="table table-hover table-bordered text-center align-middle">
		<tr class="table-secondary">
			<th>
				<input type="checkbox" id="allCheck" name="allCheck" onclick="allChecking()" class="form-check-input" />
			</th>
			<th>등록번호</th>
			<th>상품명</th>
			<th>판매물건</th>
			<th>판매가격(정가)</th>
			<th>판매가격(할인가)</th>
			<th>배송비</th>
			<th>할인금액</th>
			<th>구매량</th>
			<th>총가격</th>
			<th>할인율</th>
			<th>구매일</th>
		</tr>
		<!-- 데이터 없을시 -->
		<c:if test="${vos == null || fn:length(vos) == 0}">
			<tr>
				<td colspan="14">
					데이터가 없습니다.
				</td>
			</tr>
		</c:if>
		<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}" />
		<c:forEach var="vo" items="${vos}" varStatus="st">
		<%-- tr class="userDel eq 'OK' ? 'table-warning' : '' 이거 저온 다습 고온다습 에 따라 다르게 표기  --%>
			<tr> <%--class="${vo.dataType=='공통'? 'table-info ' : ''}"  --%>
				<td>
					<c:if test="${sLevel == 0 }"><input type="checkbox" name="orderCheck" id="orderCheck${vo.idx}" value="${vo.idx}" class="form-check-input" /></c:if>
					<c:if test="${sLevel != 0 }"><input type="checkbox" name="orderCheck" id="orderCheck${vo.idx}" value="${vo.idx}" class="form-check-input" disabled /></c:if>
				</td>
				<td>
					<label for="orderCheck${vo.idx}">
						${curScrStartNo}
					</label>
				</td>
				<td class="text-wrap">
					<a href="${ctp}/product/productDetailInfo?idx=${vo.productIdx}" data-bs-toggle="tooltip" data-bs-title="상품명:${vo.productName}<br/>상품상세페이지" data-bs-html="true" class="link-info text-dark link-offset-2 link-opacity-75-hover link-underline-opacity-0 link-underline-opacity-100-hover">
						<b>${vo.productName}</b>
							<c:if test="${vo.newLabel <8}">
								<img src="${ctp}/images/new.gif">
							</c:if>
					</a>
				</td>
				<td class="text-wrap">
					${vo.productName}
				</td>
				<td>
					<fmt:formatNumber value="${vo.normalPrice}" pattern="#,###" />원
				</td>
				<td>
					<fmt:formatNumber value="${vo.discountPrice}" pattern="#,###" />원
				</td>
				<td class="text-wrap">
					<fmt:formatNumber value="${vo.deliveryCost}" pattern="#,###" />원
				</td>
				<td class="text-wrap">
					<fmt:formatNumber value="${vo.discountAmount}" pattern="#,###" />원
				</td>
				<td class="text-wrap">
					<fmt:formatNumber value="${vo.quantity}" pattern="#,###" />
				</td>
				<td class="text-wrap">
					<fmt:formatNumber value="${vo.totalPrice}" pattern="#,###" />원
				</td>
				<td class="text-wrap">
					${vo.discountRate}%
				</td>
				<td class="text-wrap">
					${fn:substring(vo.postDate, 0, 10) == fn:substring(now, 0, 10) ? fn:substring(vo.postDate, 11, 19) : fn:substring(vo.postDate, 0, 10)}
				</td>
			</tr>
			<c:set var="curScrStartNo" value="${curScrStartNo - 1}" />
		</c:forEach>
	</table>
	<div>
		<div class="row mb-2">
			<div class="col-4">
				<div class="input-group">
					<span class="input-group-text">차트 보기</span>
					<select id="chartSelect" name="chartSelect" class="form-select">
						<option value="" selected>선택하세요</option>
						<option value="productName">상품이름별</option>
					</select>
				</div>
			</div>
			<div class="col-4"></div>
			<div class="col-4 text-end">
				<div id="viewCheck" class="input-group">
				<!--동적으로 값추가하는 부분 -->
					<span class="input-group-text">조회분류선택</span>
					<select name="viewCheckOption" id="viewCheckOption" onchange="viewCheckOption(this)" class="form-select"><!--온체인지 아니면 버튼 또 눌러야 됨  -->
						<option value="" <c:if test="${viewCheckOption==''}">selected</c:if> >종류선택</option>
						<option value="productName">상품이름별</option>
					</select>
				</div>
			</div>
		</div>
	</div>
	  <!--검색기 시작  -->
  <div class="row mb-2">
    <div class="col-md-6 offset-md-3">
      <form name="searchForm" method="get">
        <div class="input-group">
          <span class="input-group-text">검색</span>
          <select name="part" id="part" class="form-select">
            <option value="productName" ${part=='productName'?'selected':''}>상품명</option>
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
	
	<!-- 블록페이지 시작-->	
  <div class="text-center">
	  <ul class="pagination justify-content-center">
		  <c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link text-secondary" href="memberOrderList?pageSize=${pageVO.pageSize}&pag=1">첫페이지</a></li></c:if>
		  <c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link text-secondary" href="memberOrderList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li></c:if>
		  <c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize)+1}" end="${(pageVO.curBlock*pageVO.blockSize) + pageVO.blockSize}" varStatus="st">
		    <c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link bg-secondary border-secondary" href="memberOrderList?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li></c:if>
		   	<!-- 배타적 처리 필요 -->
		    <c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link text-secondary" href="memberOrderList?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li></c:if>
		  </c:forEach>
			  <c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link text-secondary" href="memberOrderList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}">다음블록</a></li></c:if>
			  <c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link text-secondary" href="memberOrderList?pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}">마지막페이지</a></li></c:if>
	  	</ul>
		</div>
		
	<!--파이차트용 모달 modal  -->
	<div class="modal fade" id="chartModal" tabindex="-1" aria-labelledby="chartModalTitle" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-xl">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="chartModalTitle">주문 데이터 파이차트(관리자)</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
		      <div id="demo" class="container-fluid">
		        <canvas id="myChart"></canvas>
		      </div>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary form-control" data-bs-dismiss="modal">Close</button>
	      </div>
	    </div>
	  </div>
	</div>
	
</div>
<p><br/></p>
<script type="text/javascript">

	//툴팁초기화 처리- 이거 없으면 툴팁안됨
	const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
	const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
	
</script>
</body>
</html>