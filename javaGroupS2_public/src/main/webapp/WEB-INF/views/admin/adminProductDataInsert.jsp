<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>adminProductDataInsert.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<!-- 파일 업로드 라이브러리 Dropzone.js -->
	<script src="https://unpkg.com/dropzone@5/dist/min/dropzone.min.js"></script>
	<link rel="stylesheet" href="https://unpkg.com/dropzone@5/dist/min/dropzone.min.css" type="text/css" />
	<script type="text/javascript">
		'use strict'
		
		let swProductName = 0;
		
  	document.addEventListener('DOMContentLoaded', function () {
  	    document.getElementById('productName').addEventListener('keydown', function() {
  	    	swProductName = 0;
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
		
		//상품명 중복체크
		function productNameDuplicateCheck() {
			let productName = document.getElementById("productName");
			if(productName.value.trim() == ''){
				alert("상품명을 확인 해주세요");
				productName.focus();
				return false;
			}
			$.ajax({
				type : "post",
				url: "${ctp}/admin/adminProductNameDuplicateCheck",
				data: {productName : productName.value.trim()},
				success: function(res) {
					if(res != "0"){
						alert("이미 등록된 상품명입니다.\n 다시 확인해주세요")
					}
					else {
						alert("사용가능한 상품명입니다");
						swProductName = 1;
					}
				},
				error: function() {
					alert("전송오류");
				}
			});
		}
		
		//제출
		function fCheck() {
			let productName = document.getElementById("productName");
			let productCategory = document.querySelector('input[name="productCategory"]');
			let productPrice = document.getElementById("productPrice");
			let deliveryCost = document.getElementById("deliveryCost");
			let productStock = document.getElementById("productStock");
			let productStatus = document.querySelector('input[name="productStatus"]');
			let discountRate = document.getElementById("discountRate");
						
			if(productName.value.trim() == ''){
				alert("상품명을 확인 해주세요");
				productName.focus();
				return false;
			}else if(productCategory.value.trim()==''){
				alert("상품카테고리를 선택해주세요");
				productCategory.focus();
				return false;
			}else if(productPrice.value.trim()==''){
				alert("상품가격을 확인 해주세요");
				productPrice.focus();
				return false;
			}else if(deliveryCost.value.trim()==''){
				alert("배송비를 확인 해주세요");
				deliveryCost.focus();
				return false;
			}else if(productStock.value.trim()==''){
				alert("상품재고를 확인해주세요");
				productStock.focus();
				return false;
			}else if(productStatus.value.trim()==''){
				alert("판매상태를 선택 해주세요");
				productStatus.focus();
				return false;
			}else if(discountRate.value.trim()==''||discountRate.value.trim()<0||discountRate.value.trim()>100){
				alert("할인율을 확인해주세요");
				discountRate.focus();
				return false;
			}
			
			  let mainImage = document.getElementById("mainImage");
			  let detailedImage = document.getElementById("detailedImage");

			  let images = [ // 검사할 이미지 파일 입력 요소들을 배열에 저장
			    { input: mainImage, name: "메인 이미지" },
			    { input: detailedImage, name: "세부 이미지" }
			  ];

			  for (let image of images) { // 배열을 순회하며 각 이미지 파일 검사
			    if (image.input.files.length === 0) {
			      myform.mainImageCheck.value = ""; // 이미지 없음
			      myform.detailImageCheck.value = ""; // 이미지 없음
			      alert(image.name + "를 선택해주세요.");
			      return false; // 함수 종료
			    } else {
			      let fName = image.input.files[0].name;
			      let maxSize = 1024 * 1024 * 10; // 10MB 제한
			      let ext = fName.substring(fName.lastIndexOf(".") + 1).toLowerCase();
			      let fileSize = image.input.files[0].size;

			      if (fileSize > maxSize) {
			        alert(image.name + "의 최대 용량은 10MB입니다.");
			        return false;
			      } else if (ext !== 'jpg' && ext !== 'png' && ext !== 'gif' && ext !== 'webp') {
			        alert(image.name + " 파일 형식은 'jpg/png/gif/webp'만 가능합니다.");
			        return false;
			      }
			    }
			  }
			  myform.mainImageCheck.value = "파일있음"; // 모든 이미지 검사 통과
			  myform.detailImageCheck.value = "파일있음"; // 모든 이미지 검사 통과
				
				myform.submit();
		}
		
		//상품데이터 불러오기
		
	</script>
</head>
<body>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/adminSidebar.jsp" />
<div id="container">
	<h2>상품 데이터 상세정보 및 수정(관리자)</h2>
	<form id="myform" name="myform" action="${ctp}/admin/adminProductDataInsert" method="post" enctype="multipart/form-data">
		<table class="table table-bordered table-hover align-middle">
			<tr>
				<th class="bg-dark-subtle">
					상품명 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<div class="input-group">
						<input type="text" id="productName" name="productName" class="form-control" required />
						<button type="button" onclick="productNameDuplicateCheck()" class="btn btn-warning">
							상품명 중복 검사
						</button>
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					상품카테고리 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<div class="d-flex justify-content-around align-items-center">
						<span><input type="radio" id="productCategory1" name="productCategory" value="식물" class="form-check-input" checked /><label for="productCategory1">&nbsp;식물</label>&nbsp;</span>
						<span><input type="radio" id="productCategory2" name="productCategory" value="부자재" class="form-check-input" /><label for="productCategory2">&nbsp;부자재</label>&nbsp;</span>
						<span><input type="radio" id="productCategory3" name="productCategory" value="기타" class="form-check-input" /><label for="productCategory3">&nbsp;기타</label>&nbsp;</span>
						<button type="button" data-bs-toggle="modal" data-bs-target="#productDataModal" class="btn btn-primary">
							상품데이터 불러오기
						</button>
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					판매물건 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<div class="input-group">
						<input type="text" id="productPlantName" name="productPlantName" value="기타" class="form-control" />
						<button type="button" data-bs-toggle="modal" data-bs-target="#plantDataModal" class="btn btn-secondary text-wrap w-25">
							상품데이터(식물) 불러오기
						</button>
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					기본가격 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<input type="number" id="productPrice" name="productPrice" value="0" class="form-control" required />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					배송비 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<input type="number" id="deliveryCost" name="deliveryCost" value="3000" class="form-control" required />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					재고수량 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<input type="number" id="productStock" name="productStock" value="0" class="form-control" required />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					상세설명 
				</th>
				<td>
					<textarea id="productDescription" name="productDescription" rows="5" placeholder="상세설명을 적어주세요" class="form-control"></textarea>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					판매상태 <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
					<div class="d-flex justify-content-around">
						<span><input type="radio" id="productStatus1" name="productStatus" value="판매중" class="form-check-input" /><label for="productStatus1">&nbsp;판매중</label>&nbsp;</span>
						<span><input type="radio" id="productStatus2" name="productStatus" value="임시등록" class="form-check-input" checked /><label for="productStatus2">&nbsp;임시등록</label>&nbsp;</span>
						<span><input type="radio" id="productStatus3" name="productStatus" value="판매중지" class="form-check-input" /><label for="productStatus3">&nbsp;판매중지</label>&nbsp;</span>
						<span><input type="radio" id="productStatus4" name="productStatus" value="재고없음" class="form-check-input" /><label for="productStatus4">&nbsp;재고없음</label>&nbsp;</span>
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					태그 
				</th>
				<td>
					<div class="input-group">
						<input type="text" id="productTag" name="productTag" class="form-control" />
					</div>
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					할인율(% 최소:0 최대100)  <span class="text-danger"><i class="bi bi-check-lg"></i></span>
				</th>
				<td>
						<input type="number" id="discountRate" name="discountRate" max="100" min="0" value="0" class="form-control" />
				</td>
			</tr>
			<tr>
				<th class="bg-dark-subtle">
					상품사진  <span class="text-danger"><i class="bi bi-check-lg"></i></span><br/>
					jpg,gif,png,webp만 가능
				</th>
				<td>
						<div class="input-group">
		  				<span class="input-group-text">메인이미지</span>
						  <input type="file" name="mainImage" id="mainImage" accept=".jpg, .webp, .png, .gif" class="form-control" />
						</div>
						<div style="width: 500px;" class="d-flex justify-content-center my-3">
	  					<img id="previewImageMain" src="${ctp}/member/noimages.jpg" style="width: 100%; height: auto; display: none;">
	  				</div>
						<div class="input-group">
		  				<span class="input-group-text">세부이미지</span>
						  <input type="file" name="detailedImage" id="detailedImage" accept=".jpg, .webp, .png, .gif" class="form-control" />
						</div>
						<div style="width: 500px;" class="d-flex justify-content-center my-3">
	  					<img id="previewImageDetail" src="${ctp}/member/noimages.jpg" style="width: 100%; height: auto; display: none;">
	  				</div>
	  				<div class="text-center">
	  					<small class="form-text text-muted my-0 fs-7">
				  			※최대용량은 각 10MB입니다
							</small>
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
			<button type="button" onclick="location.href='${ctp}/admin/adminProductDataList'" class="btn btn-danger">
				돌아가기
			</button>
		</div>
		<input type="hidden" name="mainImageCheck" id="mainImageCheck" />
		<input type="hidden" name="detailImageCheck" id="detailImageCheck" />
		<input type="hidden" name="plantIdx" id="plantIdx" value="0" />
	</form>
</div>

<!--상품 데이터 목록 보기 모달-->
<div class="modal fade" id="productDataModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">상품 데이터 불러오기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      	<div class="input-group">
      		<span class="input-group-text">
      			상품명
      		</span>
      		<input id="productName" name="productName" placeholder="상품명을 검색해주세요" class="form-control" />
      		<button type="button" onclick="getProductDataListByName()" class="btn btn-success">
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

<!--판매 상품 데이터 모달  -->
<div class="modal fade" id="productDataModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">상품 데이터 불러오기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      	<div class="input-group">
      		<span class="input-group-text">
      			상품명
      		</span>
      		<input id="searchProductName" name="searchProductName" placeholder="상품명을 검색해주세요" class="form-control" />
      		<button type="button" onclick="getProductDataListByName()" class="btn btn-success">
      			상품검색
      		</button>
      	</div>
      	<hr/>
      	<div id="productDataList">
      	</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!--판매 상품(식물) 데이터 모달  -->
<div class="modal fade" id="plantDataModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">상품(식물) 데이터 불러오기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      	<div class="input-group">
      		<span class="input-group-text">
      			상품(식물)명
      		</span>
      		<input id="searchPlantName" name="searchPlantName" placeholder="상품(식물)명을 검색해주세요" class="form-control" />
      		<button type="button" onclick="getPlantDataListByName()" class="btn btn-success">
      			상품(식물)검색
      		</button>
      	</div>
      	<hr/>
      	<div id="plantDataList">
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
	
	//상품정보 데이터 가져오기
	function getProductDataListByName() {
		let productName = document.getElementById("searchProductName");
		let searchWord = productName.value; 
		$.ajax({
			type : "post",
			url : "${ctp}/admin/adminProductDataListByName",
			data: {
				searchWord : searchWord
			},
			dataType: "json", // JSON 데이터 받기
			success: function(res) {
				if(res != 0){
					let dataList = document.getElementById('productDataList');
					let table = document.createElement('table');
					table.classList.add('table', 'table-hover', 'text-center'); // Bootstrap 스타일 적용 (선택 사항)
					
					// JSON 데이터의 첫 번째 객체에서 필드명 추출 (모든 객체가 동일한 필드를 가진다고 가정)
					let headers = Object.keys(res[0]);
					
					// 헤더 행 추가
					let headerRow = table.insertRow();
					headers.forEach(headerText => {
					  let headerCell = document.createElement('th'); // <th> 요소 생성
					  headerCell.textContent = headerText;
					  headerRow.appendChild(headerCell);
					});

					  // 데이터 행 추가 (이전 코드와 동일)
					  data.forEach(item => {
					    let row = table.insertRow();
					    headers.forEach(header => { // headers 배열 순회
					      let cell = row.insertCell();
					      cell.textContent = item[header]; // item 객체의 header 속성 값 추가
					    });
					  });
						
					dataList.appendChild(table);
					
					addClickEventToProductName(table, res); // commonName 셀에 클릭 이벤트 추가
				}else{
					alert("상품 데이터가 없거나 오류입니다")
				}
			},error: function() {
				alert("전송오류(상품)");
			}
		});
	}
	
	//상품(식물)정보 데이터 가져오기
	function getPlantDataListByName() {
		let searchName = document.getElementById("searchPlantName");
		let searchWord = searchName.value; 
		$.ajax({
			type : "post",
			url : "${ctp}/admin/getAdminPlantDataListByName",
			data: {
				searchWord : searchWord,
				dataType : "품종"
			},
			dataType: "json", // JSON 데이터 받기
			success: function(res) {
				if(res !== "0" && res && res.length > 0){
					let dataList = document.getElementById('plantDataList');
					let table = document.createElement('table');
					table.classList.add('table', 'table-hover', 'text-center'); // Bootstrap 스타일 적용 (선택 사항)
					// JSON 데이터의 첫 번째 객체에서 필드명 추출 (모든 객체가 동일한 필드를 가진다고 가정)
					let headers = Object.keys(res[0]);
					
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
					
					addClickEventToPlantName(table, res); // commonName 셀에 클릭 이벤트 추가
				}else{
					alert("상품(식물) 데이터가 없거나 오류입니다")
				}
			},error: function() {
				alert("전송오류(식물)");
			}
		});
	}
	
	function addClickEventToPlantName(table, res) {
		  let rows = table.querySelectorAll('tr');

		  rows.forEach(row => {
		    // 헤더 행은 클릭 이벤트 추가하지 않음
		    if (row.rowIndex > 0) {
		      let commonNameCell = row.querySelector('td:nth-child(2)');
		      if (commonNameCell) {
		        commonNameCell.addEventListener('click', (function(item) {
		          return function() {
		            let productPlantName = document.getElementById("productPlantName");
		            let plantIdx = document.getElementById("plantIdx");
		            
		            productPlantName.value = item.plantName;
		            plantIdx.value = item.idx;
								
		          };
		        })(res[row.rowIndex - 1]));
		      }
		    }
		  });
		}
	
	function addClickEventToProductName(table, res) {
		  let rows = table.querySelectorAll('tr');

		  rows.forEach(row => {
		    // 헤더 행은 클릭 이벤트 추가하지 않음
		    if (row.rowIndex > 0) {
		      let commonNameCell = row.querySelector('td:nth-child(2)');
		      if (commonNameCell) {
		        commonNameCell.addEventListener('click', (function(item) {
		          return function() {
		            let productPlantName = document.getElementById("productPlantName");
		            let plantIdx = document.getElementById("plantIdx");
								
		            $.ajax({
		            	type: "post",
		            	url: "${ctp}/admin/adminPlantDataByIdx",
		            	data: {
		            		idx : item.productPlantIdx
		            	},dataType: "json", // JSON 데이터 받기
		            	success: function (res) {
		            		alert("idx 가져오기 : "+res);
										if(res != 0){
				     	  	    productPlantName.value = res.plantName;
					            plantIdx.value = res.idx;
										}else{
											alert("데이터가 없거나 오류입니다");
										}
									},error: function() {
										alert("전송오류(식물명)");
									}
		            })
		          };
		        })(res[row.rowIndex - 1]));
		      }
		    }
		  });
		}
	
	//이미지 미리보기
	let mainImage = document.getElementById('mainImage');
	let detailedImage = document.getElementById('detailedImage');
	let previewImageMain = document.getElementById('previewImageMain');
	let previewImageDetail = document.getElementById('previewImageDetail');
	
	mainImage.addEventListener('change', (event) => {
	    const file = event.target.files[0];
	
	    if (file) {
	        const imageUrl = URL.createObjectURL(file);
	        previewImageMain.src = imageUrl;
	        previewImageMain.style.display = 'block';
	    } else {
	    	previewImageMain.src = '#';
	    	previewImageMain.style.display = 'none';
	    }
	});
	
	detailedImage.addEventListener('change', (event) => {
	    const file = event.target.files[0];
	
	    if (file) {
	        const imageUrl = URL.createObjectURL(file);
	        previewImageDetail.src = imageUrl;
	        previewImageDetail.style.display = 'block';
	    } else {
	    	previewImageDetail.src = '#';
	    	previewImageDetail.style.display = 'none';
	    }
	});
	
</script>
</body>
</html>