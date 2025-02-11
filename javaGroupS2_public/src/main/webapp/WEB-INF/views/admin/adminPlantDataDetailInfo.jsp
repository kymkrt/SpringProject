<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>adminPlantDataDetailInfo.jsp</title>
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
			}else if(maxPH.value.trim()>10){
				alert("최대 산성도 체크를 해주세요");
				maxPH.focus();
				return false;
			}else if(minPH.value.trim()<0){
				alert("최저 산성도 체크를 해주세요");
				minPH.focus();
				return false;
			}else if(maxHumidity.value.trim()>100){
				alert("최대 습도 체크를 해주세요");
				maxHumidity.focus();
				return false;
			}else if(minHumidity.value.trim()<0){
				alert("최저 습도 체크를 해주세요");
				minHumidity.focus();
				return false;
			}
			
			myform.submit();
		}
		
		//식물명 중복체크
		function plantNameDuplicateCheck() {
			let plantName = document.getElementById("plantName");
			if(plantName.value.trim() == ''){
				alert("식물명을 확인 해주세요");
				plantName.focus();
				return false;
			}else if(plantName.value.trim() == "${vo.plantName}"){
				alert("현재 식물 명을 사용합니다");
				swPlantName = 1;
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
							let useP = "${vo.usablePart}";
					    let use = uses[i];
					    let option = document.createElement('option');
					    option.value = use;
					    option.text = use;
					    if (use == useP) {
					        option.selected = true; // 서버 값과 일치하는 경우 selected 속성 추가
					    }
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
	<h2>식물 데이터 상세정보 및 수정(관리자)</h2>
	<form id="myform" name="myform" action="${ctp}/admin/adminPlantDataUpdate" method="post">
		<table class="table table-bordered table-hover align-middle">
			<tr class="">
				<th class="bg-dark-subtle">
					식물명 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<div class="input-group">
						<input type="text" id="plantName" name="plantName" value="${vo.plantName}" class="form-control" required />
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
					<input type="text" id="commonName" name="commonName" value="${vo.commonName}" class="form-control" required />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					학명
				</th>
				<td>
					<input type="text" id="scientificName" name="scientificName" value="${vo.scientificName}" class="form-control"/>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					용도 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<div class="d-flex justify-content-around align-items-center">
						<span><input type="radio" id="used1" name="used" value="관상용" class="form-check-input" ${vo.used=='관상용' ? 'checked' : ''} /><label for="used1">&nbsp;관상용</label>&nbsp;</span>
						<span><input type="radio" id="used2" name="used" value="식용" class="form-check-input" ${vo.used=='식용' ? 'checked' : ''} /><label for="used2">&nbsp;식용</label>&nbsp;</span>
						<span><input type="radio" id="used3" name="used" value="약용" class="form-check-input" ${vo.used=='약용' ? 'checked' : ''} /><label for="used3">&nbsp;약용</label>&nbsp;</span>
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
					<input id="option" name="option" value="${vo.option}" class="form-control" required />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					상태  <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<select id="status" name="status" class="form-select" required >
						<option value="씨앗" ${vo.status=='씨앗' ? 'selected' : ''} >씨앗</option>
						<option value="잎" ${vo.status=='잎' ? 'selected' : ''} >잎</option>
						<option value="열매" ${vo.status=='열매' ? 'selected' : ''} >열매</option>
						<option value="구근" ${vo.status=='구근' ? 'selected' : ''} >구근</option>
						<option value="모종" ${vo.status=='모종' ? 'selected' : ''} >모종</option>
						<option value="묘목" ${vo.status=='묘목' ? 'selected' : ''} >묘목</option>
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
						<input type="number" id="maxTemp" name="maxTemp" value="${vo.maxTemp}" max="100" min="-20" step="0.1" class="form-control" required />
						<span class="input-group-text">최저온도</span>
						<input type="number" id="minTemp" name="minTemp" value="${vo.minTemp}" max="100" min="-20" step="0.1" class="form-control" required />
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
						<input type="number" id="maxHumidity" name="maxHumidity" value="${vo.maxHumidity}" max="100" min="0" step="0.1" class="form-control" />
						<span class="input-group-text">최저습도</span>
						<input type="number" id="minHumidity" name="minHumidity" value="${vo.minHumidity}" max="100" min="0" step="0.1" class="form-control" />
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
						<input type="number" id="maxPH" name="maxPH" value="${vo.maxPH}" max="10" min="0" step="0.1" class="form-control" />
						<span class="input-group-text">최저산도</span>
						<input type="number" id="minPH" name="minPH" value="${vo.minPH}" max="10" min="0" step="0.1" class="form-control" />
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					광량 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<select id="lightLevel" name="lightLevel" class="form-select">
						<option value="직사광선" ${vo.lightLevel=='직사광선' ? 'selected' : ''} >직사광선</option>
						<option value="양지" ${vo.lightLevel=='양지' ? 'selected' : ''} >양지</option>
						<option value="반양지" ${vo.lightLevel=='반양지' ? 'selected' : ''} >반양지</option>
						<option value="반음지" ${vo.lightLevel=='반음지' ? 'selected' : ''} >반음지</option>
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
							<option value="스프레이" ${vo.wateringAmount=='스프레이' ? 'selected' : ''} >스프레이</option>
							<option value="한컵" ${vo.wateringAmount=='한컵' ? 'selected' : ''} >한컵</option>
							<option value="흠뻑" ${vo.wateringAmount=='흠뻑' ? 'selected' : ''} >흠뻑</option>
							<option value="저면관수" ${vo.wateringAmount=='저면관수' ? 'selected' : ''} >저면관수</option>
						</select>
						<span class="input-group-text">주는 빈도</span>
						<select id="wateringFrequency" name="wateringFrequency" class="form-select" required >
							<option value="달1번" ${vo.wateringFrequency=='달1번' ? 'selected' : ''} >달1번</option>
							<option value="주1번" ${vo.wateringFrequency=='주1번' ? 'selected' : ''} >주1번</option>
							<option value="하루1번" ${vo.wateringFrequency=='하루1번' ? 'selected' : ''} >하루1번</option>
							<option value="저면관수" ${vo.wateringFrequency=='저면관수' ? 'selected' : ''} >저면관수</option>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					식물설명 및 주의사항
				</th>
				<td>
					<textarea id="plantIntro" name="plantIntro" rows="4" placeholder="식물설명문구작성" class="form-control" >${vo.plantIntro}</textarea>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					소유자
				</th>
				<td>
					<input type="text" id="owner" name="owner" value="${vo.owner}" class="form-control" />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					관련사이트
				</th>
				<td>
					<input type="text" id="ownSite" name="ownSite" value="${vo.ownSite}" class="form-control" />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					데이터 타입 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<div class="d-flex justify-content-around">
						<span><input type="radio" id="dataType1" name="dataType" value="품종" class="form-check-input" ${vo.dataType=='품종' ? 'checked' : ''} /><label for="dataType1">&nbsp;품종</label>&nbsp;</span>
						<span><input type="radio" id="dataType2" name="dataType" value="공통" class="form-check-input" ${vo.dataType=='공통' ? 'checked' : ''} /><label for="dataType2">&nbsp;공통</label>&nbsp;</span>
					</div>
				</td>
			</tr>
		</table>
		<div class="d-flex justify-content-around">
			<button type="button" onclick="fCheck()" class="btn btn-success">
				수정 하기
			</button>
			<button type="button" onclick="resetCheck()" class="btn btn-warning">
				전부 비우기
			</button>
			<button type="button" onclick="location.href='${ctp}/admin/adminPlantDataList'" class="btn btn-secondary">
				돌아가기
			</button>
			<button type="button" onclick="location.href='${ctp}/admin/adminPlantDataDelete?idx=${vo.idx}'" class="btn btn-danger">
				식물데이터 삭제
			</button>
		</div>
		<input type="hidden" name="idx2" id="idx2" value="${vo.idx}" />
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
	
	let searchName = document.getElementById("searchName");
	
	searchName.addEventListener("change", function () {
		let searchWord = searchName.value; 
		$.ajax({
			type : "post",
			url : "${ctp}/admin/adminCommonPlantDataListByName",
			data: {
				searchWord : searchWord
			},success: function(res) {
				if(res != 0){
					
				}else{
					alert("데이터 가져오기 실패")
				}
			},error: function() {
				alert("전송오류");
			}
		});
	});
	
</script>
</body>
</html>