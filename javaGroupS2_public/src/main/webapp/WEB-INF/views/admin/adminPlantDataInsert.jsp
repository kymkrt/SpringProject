<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>adminPlantDataInsert.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script type="text/javascript">
		'use strict'
		
		let swPlantName = 0;
		
  	document.addEventListener('DOMContentLoaded', function () {
  	    document.getElementById('plantName').addEventListener('keydown', function() {
  	    	swPlantName = 0;
  	    });
  	});
		
		//리셋하기
		function resetCheck() {
			let ans = confirm('정말 다시 쓰겠습니까?\n모든 정보가 초기화됩니다');
			if(!ans){
				return false;
			}
			location.reload();
		}
		
		//식물명 중복체크
		function plantNameDuplicateCheck() {
			let plantName = document.getElementById("plantName");
			if(plantName.value.trim() == ''){
				alert("식물명을 확인 해주세요");
				plantName.focus();
				return false;
			}
			$.ajax({
				type : "post",
				url: "${ctp}/admin/adminPlantNameDuplicateCheck",
				data: {plantName : plantName.value.trim()},
				success: function(res) {
					if(res != "0"){
						alert("이미 등록된 식물명입니다.\n 다시 확인해주세요")
					}
					else {
						alert("사용가능한 식물명입니다");
						swPlantName = 1;
					}
				},
				error: function() {
					alert("전송오류");
				}
			});
		}
		
		//제출
		function fCheck() {
			let plantName = document.getElementById("plantName");
			let commonName = document.getElementById("commonName");
			let uses = document.querySelector('input[name="used"]');
			let option = document.getElementById("option");
			let status = document.getElementById("status");
			let maxTemp = document.getElementById("maxTemp");
			let minTemp = document.getElementById("minTemp");
			let maxPH = document.getElementById("maxPH");
			let minPH = document.getElementById("minPH");
			let maxHumidity = document.getElementById("maxHumidity");
			let minHumidity = document.getElementById("minHumidity");
			let lightLevel = document.getElementById("lightLevel");
			let wateringAmount = document.getElementById("wateringAmount");
			let wateringFrequency = document.getElementById("wateringFrequency");
			let dataType = document.querySelector('input[name="dataType"]');
			let usablePart = document.getElementById("usablePart");
			
			if(plantName.value.trim() == ''){
				alert("식물명을 확인 해주세요");
				plantName.focus();
				return false;
			}else if(commonName.value.trim()==''){
				alert("공통명을 확인해주세요");
				commonName.focus();
				return false;
			}else if(uses.value.trim()==''){
				alert("용도를 선택해주세요");
				uses.focus();
				return false;
			}else if(option.value.trim()==''){
				alert("옵션을 확인 해주세요");
				option.focus();
				return false;
			}else if(status.value.trim()==''){
				alert("상태를 선택해주세요");
				status.focus();
				return false;
			}else if(maxTemp.value.trim()==''||maxTemp.value.trim()>100){
				alert("최대온도를 확인 해주세요");
				maxTemp.focus();
				return false;
			}else if(minTemp.value.trim()==''||maxTemp.value.trim()<-20){
				alert("최저온도를 확인해주세요");
				minTemp.focus();
				return false;
			}else if(lightLevel.value.trim()==''){
				alert("광량을 선택해주세요");
				lightLevel.focus();
				return false;
			}else if(wateringAmount.value.trim()==''){
				alert("물의 양을 선택해주세요");
				wateringAmount.focus();
				return false;
			}else if(wateringFrequency.value.trim()==''){
				alert("물 빈도를 선택해주세요");
				wateringFrequency.focus();
				return false;
			}else if(dataType.value.trim()==''){
				alert("데이터 타입을 선택해주세요");
				dataType.focus();
				return false;
			}else if(usablePart.value.trim()==''){
				alert("가용부 값을 선택해주세요");
				usablePart.focus();
				return false;
			}else if(swPlantName==0){
				alert("식물명 중복체크를 해주세요");
				plantName.focus();
				return false;
			}else if(maxPH.value>10){
				alert("최대 산성도 체크를 해주세요");
				maxPH.focus();
				return false;
			}else if(minPH.value<0){
				alert("최저 산성도 체크를 해주세요");
				minPH.focus();
				return false;
			}else if(maxHumidity.value>100){
				alert("최대 습도 체크를 해주세요");
				maxHumidity.focus();
				return false;
			}else if(minHumidity.value<0){
				alert("최저 습도 체크를 해주세요");
				minHumidity.focus();
				return false;
			}
			
			myform.submit();
		}
		
		document.addEventListener("DOMContentLoaded", function () {
		  const radios = document.querySelectorAll('input[name="used"]');
		  const part = document.getElementById("usablePart");

		  radios.forEach(radio => {
		    radio.addEventListener('click', function() {
		      // 기존 옵션 모두 삭제
		      while (part.firstChild) {
		        part.removeChild(part.firstChild);
		      }

		      let uses = [];
		      switch (this.value) {
		        case '관상용':
		          uses = ["관엽류", "다육류", "관화식물", "방향류","관과류"];
		          break;
		        case '식용':
		          uses = ["엽채류", "과실류", "곡류", "허브류", "과채류"];
		          break;
		        case '약용':
		          uses = ["뿌리류", "열매류", "씨앗류", "약엽류"];
		          break;
		      }

		      // 새로운 옵션 추가
					for (let i = 0; i < uses.length; i++) {
					    let use = uses[i];
					    let option = document.createElement('option');
					    option.value = use;
					    option.text = use;
					    part.appendChild(option);
					}
		    });
		  });

		// 초기 로딩 시 '관상용'에 해당하는 옵션 추가 (checked 속성이 있는 radio button)
		const checkedRadio = document.querySelector('input[name="used"]:checked');
		if (checkedRadio) { // checkedRadio가 null이 아닌 경우에만 실행
			  checkedRadio.click();
			}
	});
	</script>
</head>
<body>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/adminSidebar.jsp" />
<div id="container">
	<h2>식물 데이터 등록</h2>
	<form id="myform" name="myform" action="${ctp}/admin/adminPlantDataInsert" method="post">
		<table class="table table-bordered table-hover align-middle">
			<tr class="">
				<th class="bg-dark-subtle">
					식물명 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<div class="input-group">
						<input type="text" id="plantName" name="plantName" class="form-control" required />
						<button type="button" onclick="plantNameDuplicateCheck()" class="btn btn-warning">
							식물명 중복 검사
						</button>
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					공통명 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<input type="text" id="commonName" name="commonName" class="form-control" required />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					학명
				</th>
				<td>
					<input type="text" id="scientificName" name="scientificName" class="form-control"/>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					용도 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<div class="d-flex justify-content-around align-items-center">
						<span><input type="radio" id="used1" name="used" value="관상용" class="form-check-input" checked /><label for="used1">&nbsp;관상용</label>&nbsp;</span>
						<span><input type="radio" id="used2" name="used" value="식용" class="form-check-input" /><label for="used2">&nbsp;식용</label>&nbsp;</span>
						<span><input type="radio" id="used3" name="used" value="약용" class="form-check-input" /><label for="used3">&nbsp;약용</label>&nbsp;</span>
						<span data-bs-toggle="modal" data-bs-target="#commonPlantDataModal" class="btn btn-info">식물 공통 데이터 불러오기</span>
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					가용부 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td id="partTd">
					<select id="usablePart" name="usablePart" class="form-select" required >
						<option></option>
					</select>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					옵션 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<input id="option" name="option" value="기타" class="form-control" required />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					상태  <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<select id="status" name="status" class="form-select" required >
						<option value="씨앗">씨앗</option>
						<option value="잎">잎</option>
						<option value="열매">열매</option>
						<option value="구근">구근</option>
						<option value="모종">모종</option>
						<option value="묘목">묘목</option>
					</select>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					온도(섭씨 °C) <span class="text-danger"><i class="bi bi-check-lg"></i></span><br>
					최대:100도 최저:-20도
				</th>
				<td>
					<div class="input-group">
						<span class="input-group-text">최고온도</span>
						<input type="number" id="maxTemp" name="maxTemp" max="100" min="-20" step="0.1" class="form-control" required />
						<span class="input-group-text">최저온도</span>
						<input type="number" id="minTemp" name="minTemp" max="100" min="-20" step="0.1" class="form-control" required />
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					습도(상대습도)<br/>
					0%-100%(%생략)
				</th>
				<td>
					<div class="input-group">
						<span class="input-group-text">최고습도</span>
						<input type="number" id="maxHumidity" name="maxHumidity" value="0.0" max="100" min="0" step="0.1" class="form-control" />
						<span class="input-group-text">최저습도</span>
						<input type="number" id="minHumidity" name="minHumidity" value="0.0" max="100" min="0" step="0.1" class="form-control" />
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					산성도(ph)<br/>
					최저:0 최대:10
				</th>
				<td>
					<div class="input-group">
						<span class="input-group-text">최고산도</span>
						<input type="number" id="maxPH" name="maxPH" value="0.0" max="10" min="0" step="0.1" class="form-control" />
						<span class="input-group-text">최저산도</span>
						<input type="number" id="minPH" name="minPH" value="0.0" max="10" min="0" step="0.1" class="form-control" />
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					광량 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<select id="lightLevel" name="lightLevel" class="form-select">
						<option value="직사광선">직사광선</option>
						<option value="양지">양지</option>
						<option value="반양지">반양지</option>
						<option value="반음지">반음지</option>
					</select>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					물공급 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<div class="input-group">
						<span class="input-group-text">한번의 양</span>
						<select id="wateringAmount" name="wateringAmount" class="form-select" required >
							<option value="스프레이">스프레이</option>
							<option value="한컵">한컵</option>
							<option value="흠뻑">흠뻑</option>
							<option value="저면관수">저면관수</option>
						</select>
						<span class="input-group-text">주는 빈도</span>
						<select id="wateringFrequency" name="wateringFrequency" class="form-select" required >
							<option value="달1번">달1번</option>
							<option value="주1번">주1번</option>
							<option value="하루1번">하루1번</option>
							<option value="저면관수">저면관수</option>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					식물설명및주의사항
				</th>
				<td>
					<textarea id="plantIntro" name="plantIntro" rows="4" placeholder="식물설명문구작성" class="form-control" ></textarea>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					소유자
				</th>
				<td>
					<input type="text" id="owner" name="owner" class="form-control" />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					관련사이트
				</th>
				<td>
					<input type="text" id="ownSite" name="ownSite" class="form-control" />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					데이터 타입 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<div class="d-flex justify-content-around">
						<span><input type="radio" id="dataType1" name="dataType" value="품종" class="form-check-input" checked /><label for="dataType1">&nbsp;품종</label>&nbsp;</span>
						<span><input type="radio" id="dataType2" name="dataType" value="공통" class="form-check-input" /><label for="dataType2">&nbsp;기본(공통)</label>&nbsp;</span>
					</div>
				</td>
			</tr>
		</table>
		<div class="d-flex justify-content-around">
			<button type="button" onclick="fCheck()" class="btn btn-success">
				작성하기
			</button>
			<button type="button" onclick="resetCheck()" class="btn btn-warning">
				다시 작성하기
			</button>
			<button type="button" onclick="location.href='${ctp}/admin/adminPlantDataList'" class="btn btn-danger">
				돌아가기
			</button>
		</div>
	</form>
</div>

<!--식물데이터 목록 보기 모달-->
<div class="modal fade" id="commonPlantDataModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">식물 공용 데이터 불러오기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      	<div class="input-group">
      		<span class="input-group-text">
      			식물명(공통명)
      		</span>
      		<input id="searchName" name="searchName" placeholder="식물명(공통명)을 검색해주세요" class="form-control" />
      		<button type="button" onclick="getPlantDataListByName()" class="btn btn-success">
      			상품검색
      		</button>
      	</div>
      	<hr/>
      	<div id="dataList">
      		
      	</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<p><br/></p>
<script type="text/javascript">
	'use strict'
	
	//상품(식물)정보 데이터 가져오기
	function getPlantDataListByName() {
		let searchName = document.getElementById("searchName");
		let searchWord = searchName.value; 
		$.ajax({
			type : "post",
			url : "${ctp}/admin/getAdminPlantDataListByName",
			data: {
				searchWord : searchWord
			},
			dataType: "json", // JSON 데이터 받기
			success: function(res) {
				if(res != "0"){
					let dataList = document.getElementById('dataList');
					let table = document.createElement('table');
					table.classList.add('table', 'table-hover', 'text-center'); // Bootstrap 스타일 적용 (선택 사항)
					let headers = ["idx", "commonName", "dataType", "postDate"]; // 원하는 필드만 수동 지정
					// JSON 데이터의 첫 번째 객체에서 필드명 추출 (모든 객체가 동일한 필드를 가진다고 가정)
					//let headers = Object.keys(res[0]);
					
					// 헤더 행 추가
					let headerRow = table.insertRow();
					headers.forEach(headerText => {
					  let headerCell = document.createElement('th'); // <th> 요소 생성
					  headerCell.textContent = headerText;
					  headerRow.appendChild(headerCell);
					});
				
					  // 데이터 행 추가 (이전 코드와 동일)
					  res.forEach(item => {
					    let row = table.insertRow();
					    headers.forEach(header => { // headers 배열 순회
					      let cell = row.insertCell();
					      cell.textContent = item[header]; // item 객체의 header 속성 값 추가
					    });
					  });
						
					dataList.appendChild(table);

					addClickEventToCommonName(table, res); // commonName 셀에 클릭 이벤트 추가
				}else{
					alert("데이터 가져오기 실패")
				}
			},error: function() {
				alert("전송오류");
			}
		});
	}
	
	function addClickEventToCommonName(table, res) {
	    let rows = table.querySelectorAll('tr');

	    rows.forEach(row => {
	        if (row.rowIndex > 0) {
	            let commonNameCell = row.querySelector('td:nth-child(2)');
	            if (commonNameCell) {
	                commonNameCell.addEventListener('click', (function(item) {
	                    return function() {
	                        let commonName = document.getElementById("commonName");
	                        let used = document.querySelector('input[name="used"]'); // 라디오 버튼
	                        let option = document.getElementById("option"); // 텍스트 input
	                        let status = document.getElementById("status"); // select
	                        let maxTemp = document.getElementById("maxTemp"); // 텍스트 input
	                        let minTemp = document.getElementById("minTemp"); // 텍스트 input
	                        let maxPH = document.getElementById("maxPH"); // 텍스트 input
	                        let minPH = document.getElementById("minPH"); // 텍스트 input
	                        let maxHumidity = document.getElementById("maxHumidity"); // 텍스트 input
	                        let minHumidity = document.getElementById("minHumidity"); // 텍스트 input
	                        let lightLevel = document.getElementById("lightLevel"); // select
	                        let wateringAmount = document.getElementById("wateringAmount"); // select
	                        let wateringFrequency = document.getElementById("wateringFrequency"); // select
	                        let dataType = document.querySelectorAll('input[name="dataType"]'); // 라디오 버튼
	                        let usablePart = document.getElementById("usablePart"); // select

	                        commonName.value = item.commonName;
	                        option.value = item.option; // 텍스트 input 값 설정
	                        status.value = item.status; // select value 설정
	                        maxTemp.value = item.maxTemp;
	                        minTemp.value = item.minTemp;
	                        maxPH.value = item.maxPH;
	                        minPH.value = item.minPH;
	                        maxHumidity.value = item.maxHumidity;
	                        minHumidity.value = item.minHumidity;
	                        lightLevel.value = item.lightLevel; // select value 설정
	                        wateringAmount.value = item.wateringAmount; // select value 설정
	                        wateringFrequency.value = item.wateringFrequency; // select value 설정
	                        usablePart.value = item.usablePart; // select value 설정

	                        // used 라디오 버튼 처리
	                        let usedRadios = document.querySelectorAll('input[name="used"]');
	                        usedRadios.forEach(radio => {
	                            if (radio.value === item.used) {
	                                radio.checked = true;
	                            }
	                        });

	                        // dataType 라디오 버튼 처리
	                        dataType.forEach(radio => {
	                            if (radio.value === item.dataType) {
	                                radio.checked = true;
	                            }
	                        });

	                    };
	                })(res[row.rowIndex - 1]));
	            }
	        }
	    });
	}
</script>
</body>
</html>