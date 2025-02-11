<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>adminNewMemberList.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script type="text/javascript">
		'use strict';
		
		let myChart; // 차트 객체를 저장할 변수
		
		function allChecking() {
			let memberCheckBtns = document.getElementsByName("memberCheck");
			let allCheckBtn = document.getElementById("allCheck");
			if(allCheckBtn.checked){
				for(let i=0; i<memberCheckBtns.length; i++){
					memberCheckBtns[i].checked = true;
				}
			}else{
				for(let i=0; i<memberCheckBtns.length; i++){
					memberCheckBtns[i].checked = false;
				}
			}
		}
		
		//등급별 조회
	  	function adminLevelViewCheck() {
				let level = document.getElementById("levelView").value;
				location.href="${ctp}/admin/adminNewMemberList?pageSize=${pageSize}&pag=${pag}&level="+level;			
			}
		
		//탈퇴회원 복구시키기
		function adminMemberActivate(idx) {
			let ans = confirm("탈퇴회원을 복구 시키겠습니까?");
			if(!ans){
				location.reload();//새로고침
				return false;
			}
			let idxForActive = idx;
			$.ajax({
				type: "post",				
				url: "${ctp}/admin/adminMemberActivateByIdx",
				data : {
					idx : idxForActive		
				},
				success: function(res) {
					if(res != 0){
						alert("회원 복구 완료");
						location.reload();//새로고침
					}
					else alert("회원 복구 실패");
				},error: function() {
					alert("전송오류");
				}
			});
		}
		
		//선택 회원 등급 변경
		 function levelchange(e) {
				let ans = confirm("선택한 회원의 등급을 변경하시겠습니까?");
				if(!ans) {
					location.reload();//새로고침
					return false;
				}
				//items[0] : 레벨번호, items[1]: 고유번호			
				let items = e.value.split("/");
				
				$.ajax({
					type : "post", //get도 상관없음
					url : "${ctp}/admin/adminMemberLevelChangeByIdx",
					data : {
						level : items[0],
						idx : items[1]
					},
					success:function(res){
						if(res != 0){
							alert("등급 수정 완료");
							location.reload();//새로고침
						}
						else alert("등급 수정 실패");
					},
					error : function(){
						alert("전송오류");
					}
				});
			}
	  	
		//선택 회원 로그인 타입 변경
		 function loginTypeChange(e) {
				let ans = confirm("선택한 회원의 회원타입을 변경하시겠습니까?");
				if(!ans) {
					location.reload();//새로고침
					return false;
				}
				//items[0] : 로그인타입, items[1]: 고유번호			
				let items = e.value.split("/");
				
				$.ajax({
					type : "post", //get도 상관없음
					url : "${ctp}/admin/adminMemberLoginTypeChangeByIdx",
					data : {
						loginType : items[0],
						idx : items[1]
					},
					success:function(res){
						if(res != 0){
							alert("등급 수정 완료");
							location.reload();//새로고침
						}
						else alert("등급 수정 실패");
					},
					error : function(){
						alert("전송오류");
					}
				});
			}
	  	
		 function viewCheckOption(e, viewCheckOption_2) {
			 		if(e.value=="") return false;		
			 
			    let container = document.getElementById("viewCheck");
			    let plusSelect = document.getElementById("plusSelect"); // 기존 select 엘리먼트 가져오기
						
			    if (!plusSelect) { // select 엘리먼트가 존재하지 않는 경우에만 생성
			        plusSelect = document.createElement("select");
			        plusSelect.classList.add("form-select");
			        plusSelect.id = "plusSelect";

			        // 이벤트 리스너는 select 생성 시점에 한 번만 추가
			        plusSelect.addEventListener('change', (e) => {
			            console.log("선택된 값:", e.target.value);
			            let optionValue = document.getElementById("viewCheckOption").value;
			            location.href = "${ctp}/admin/adminNewMemberList?pageSize=${pageSize}&pag=${pag}&viewCheckOption=" + optionValue + "&viewCheckOption_2=" + e.target.value;
			        });

			        container.appendChild(plusSelect);
			    } else{
			        plusSelect.innerHTML = ""; // 기존 option들 비워주기.
			    }

			    $.ajax({
			        type: "post",
			        url: "${ctp}/admin/allMemberOptionSearchOptionList",
			        data: {
			            option: e.value,
			            type: 'new'
			        },
			        dataType: "json",
			        success: function(res) {
			            if (res && res.length > 0) {
			                let optionZero = new Option("선택하세요", "");
			                plusSelect.appendChild(optionZero);

			                switch (e.value) {
			                    case 'level':
			                        const levels = ["관리자", "일반회원", "준회원", "우수회원"];
			                        for (let i = 0; i < res.length; i++) {
			                            let item = res[i];
			                            if (item >= 0 && item <= 3) {
			                                let option = new Option(levels[item], item);
			                                option.selected = item == viewCheckOption_2; // 올바른 비교
			                                plusSelect.appendChild(option);
			                            }
			                        }
			                        break;
			                    case 'gender':
			                        for (let i = 0; i < res.length; i++) {
			                            let item = res[i];
			                            if (item == '남자' || item == '여자') {
			                                let option = new Option(item, item);
			                                option.selected = item == viewCheckOption_2; // 올바른 비교
			                                plusSelect.appendChild(option);
			                            }
			                        }
			                        break;
			                    default:
			                        for (let i = 0; i < res.length; i++) {
			                            let item = res[i];
			                            let option = new Option(item, item);
			                            option.selected = item == viewCheckOption_2; // 올바른 비교
			                            plusSelect.appendChild(option);
			                        }
			                        break;
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
			 
			 function adminMemberDeleteByIdx() {
					let modalMid = modalForm.deleteMid.value;
					let deleteType = modalForm.deleteType.value;
					let deleteComment = modalForm.deleteComment.value;
									
					$.ajax({
						type: "post",
						url : "${ctp}/admin/adminMemberDeleteByMid",
						data: {
							mid : modalMid,
							deleteType : deleteType,
							deleteComment : deleteComment
						},
						success: function(res) {
							if(res != "0"){
								alert("회원이 탈퇴/정지 되었습니다");
								location.reload();
							}else{
								alert("회원 탈퇴/정지 실패")
							}
						},error: function() {
							alert("전송오류");
						}
					});
				}
			 
			 
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
				        	url: "${ctp}/admin/adminMemberChartCountList",
				        	data: {
				        		chartSelectValue: chartSelectValue,
				        		chartType : 'pie',
				        		listType: 'new'
				        	},success: function(res) {
										if(res !=null ||res !=''){
											console.log("res 값(ajax) : "+res);
											let	chartModalTitle = document.getElementById('chartModalTitle');
											let word;
											switch (chartSelectValue) {
												case 'time':
												word = '일자별';
												break;
												case 'gender':
												word = '남녀별';
												break;
												case 'loginType':
												word = '로그인타입';
												break;
												case 'age':
												word = '연령대';
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
<jsp:include page="/WEB-INF/views/include/adminSidebar.jsp" />
<div id="container">
<h2 class="text-center">신규회원목록(관리자)</h2>
	<div class="row mb-2">
		<div class="col-4">
			<div class="input-group">
				<span class="input-group-text">차트 보기</span>
				<select id="chartSelect" name="chartSelect" class="form-select">
					<option value="" selected>선택하세요</option>
					<option value="time">일자별</option>
					<option value="gender">남녀별</option>
					<option value="loginType">로그인타입</option>
					<option value="age">연령대</option>
				</select>
			</div>
		</div>
		<div class="col-4"></div>
		<div class="col-4 text-end">
			<div id="viewCheck" class="input-group">
				<span class="input-group-text">조회분류선택</span>
				<select name="viewCheckOption" id="viewCheckOption" onchange="viewCheckOption(this)" class="form-select"><!--온체인지 아니면 버튼 또 눌러야 됨  -->
					<option value="" <c:if test="${viewCheckOption==''}">selected</c:if> >종류선택</option>
					<option value="level">회원등급</option>
					<option value="loginType">로그인타입</option>
					<option value="gender">성별</option>
				</select>
			</div>
		</div>
	</div>
	<table class="table table-hover table-bordered text-center align-middle">
		<tr class="table-secondary">
			<th>
				<input type="checkbox" id="allCheck" name="allCheck" onclick="allChecking()" class="form-check-input" />
			</th>
			<th>등록번호</th>
			<th>아이디</th>
			<th>닉네임</th>
			<th>성명</th>
			<th>성별</th>
			<th>이메일</th>
			<th>회원등급</th>
			<th>탈퇴여부</th>
			<th>회원타입</th>
		</tr>
		<c:if test="${adminNewMembers == null || fn:length(adminNewMembers) == 0}">
			<tr>
				<td colspan="9">
					데이터가 없습니다.
				</td>
			</tr>
		</c:if>
		<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}" />
		<c:forEach var="vo" items="${adminNewMembers}" varStatus="st">
			<tr class="${vo.userDel eq 'OK' ? 'table-warning' : ''}"> 
				<td>
					<c:if test="${vo.level == 0 }"><input type="checkbox" name="memberCheck" id="memberCheck${vo.idx}" value="${vo.idx}" class="form-check-input" /></c:if>
					<c:if test="${vo.level != 0 }"><input type="checkbox" name="memberCheck" id="memberCheck${vo.idx}" value="${vo.idx}" class="form-check-input" disabled /></c:if>
				</td>
				<td>
					${curScrStartNo}
				</td>
				<td>
					<a href="${ctp}/admin/adminMemberDetailInfo?idx=${vo.idx}" data-bs-toggle="tooltip" data-bs-title="${vo.remainMid}<br/>회원전체정보수정(관리자)" data-bs-html="true" class="link-info text-dark link-offset-2 link-opacity-75-hover link-underline-opacity-0 link-underline-opacity-100-hover">
						<b>${vo.mid} / ${vo.remainMid}</b>
							<c:if test="${vo.newLabel <8}">
								<img src="${ctp}/images/new.gif">
							</c:if>
					</a>
				</td>
				<td>
					${vo.nickName}
				</td>
				<td>
					${vo.name}
				</td>
				<td>
					${vo.gender}
				</td>
				<td>
					${vo.email}
				</td>
				<td>
					<select data-bs-toggle="tooltip" data-bs-title="회원등급변경" class="form-select" onchange="levelchange(this)">
						<option value="0/${vo.idx}" ${vo.level==0?'selected':''}>관리자</option>
						<option value="1/${vo.idx}" ${vo.level==1?'selected':''}>일반회원</option>
						<option value="2/${vo.idx}" ${vo.level==2?'selected':''}>준회원</option>
						<option value="3/${vo.idx}" ${vo.level==3?'selected':''}>우수회원</option>
					</select>
				</td>
				<td>
					<c:if test="${vo.userDel=='OK'}">
						<span data-bs-toggle="tooltip" data-bs-placement="top" title="탈퇴/정지회원복구">
							<button class="btn btn-danger" onclick="adminMemberActivate(${vo.idx}, '${vo.remainMid}')">
								탈퇴회원
							</button>
						</span>
					</c:if>
					<c:if test="${vo.userDel !='OK'}">
						<span data-bs-toggle="tooltip" data-bs-title="회원탈퇴/정지">
							<button class="btn btn-success open-modal-btn"
								data-bs-toggle="modal" data-bs-target="#adminMemberDeleteModal"
								data-title="${vo.remainMid}">
								활동회원
							</button>
						</span>
					</c:if>
				</td>
				<td>
					<select data-bs-toggle="tooltip" data-bs-title="회원타입변경" class="form-select" onchange="loginTypeChange(this)">
						<option value="일반회원/${vo.idx}" ${vo.loginType=='일반회원'?'selected':''}>일반회원</option>
						<option value="카카오회원/${vo.idx}" ${vo.loginType=='카카오회원'?'selected':''}>카카오회원</option>
					</select>
				</td>
			</tr>
			<c:set var="curScrStartNo" value="${curScrStartNo - 1}" />
		</c:forEach>
	</table>
	
		  <!--검색기 시작  -->
  <div class="row mb-2">
    <div class="col-md-6 offset-md-3">
      <form name="searchForm" method="get">
        <div class="input-group">
          <span class="input-group-text">검색</span>
          <select name="part" id="part" class="form-select">
            <option value="mid" ${part=='mid'?'selected':''}>아이디</option>
            <option value="nickName" ${part=='nickName'?'selected':''}>닉네임</option>
            <option value="name" ${part=='name'?'selected':''}>성명</option>
            <option value="email" ${part=='email'?'selected':''}>이메일</option>
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
		  <c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link text-secondary" href="adminNewMemberList?level=${level}&pageSize=${pageVO.pageSize}&pag=1">첫페이지</a></li></c:if>
		  <c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link text-secondary" href="adminNewMemberList?level=${level}&pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li></c:if>
		  <c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize)+1}" end="${(pageVO.curBlock*pageVO.blockSize) + pageVO.blockSize}" varStatus="st">
		    <c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link bg-secondary border-secondary" href="adminNewMemberList?level=${level}&pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li></c:if>
		   	<!-- 배타적 처리 필요 -->
		    <c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link text-secondary" href="adminNewMemberList?level=${level}&pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li></c:if>
		  </c:forEach>
			  <c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link text-secondary" href="adminNewMemberList?level=${level}&pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}">다음블록</a></li></c:if>
			  <c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link text-secondary" href="adminNewMemberList?level=${level}&pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}">마지막페이지</a></li></c:if>
	  	</ul>
		</div>
	
		<!-- Modal -->
	<div class="modal fade" id="adminMemberDeleteModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="#adminMemberDeleteModal" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id=#adminMemberDeleteModalLabel>회원탈퇴 정보작성</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	      	<form name="modalForm">
						<div class="input-group mb-2">
		      		<span class="input-group-text">아이디 : </span>
		      		<input type="text" id="deleteMid" name="deleteMid" class="form-control" readonly>
						</div>
		      	<div class="input-group mb-2">
		      		<div class="input-group-text">
		      			종류선택
		      		</div>
			      	<select id="deleteType" name="deleteType" class="form-select" required>
			      		<option value="탈퇴">탈퇴</option>
			      		<option value="정지">정지</option>
			      	</select>
		      	</div>
		      	<textarea rows="10" name="deleteComment" id="deleteComment" placeholder="탈퇴/정지 사유를 입력해주세요" class="form-control"></textarea>
	      	</form>
		    </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기(저장안됨)</button>
	        <button type="button" onclick="adminMemberDeleteByIdx()" class="btn btn-primary">제출</button>
	      </div>
	    </div>
	  </div>
	</div>
	
		<!--파이차트용 모달 modal  -->
	<div class="modal fade" id="chartModal" tabindex="-1" aria-labelledby="chartModalTitle" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-xl">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="chartModalTitle">신규 회원 파이차트(관리자-<span style="color: crimson">탈퇴회원제외</span>)</h1>
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