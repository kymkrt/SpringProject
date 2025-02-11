<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>productDetailInfo.jsp</title>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<!-- <script src="https://cdn.tailwindcss.com"></script> -->
	<style type="text/css">
	 .footer { 
     bottom: 0;
     width: 100%;
    	padding: 10px;
	  }
	    
	  html, body {
			height: 100%; /* html과 body의 높이를 100%로 설정 */
			margin: 0; /* 기본 여백을 제거 */
			padding: 0; /* 기본 패딩을 제거 */
			display: flex;
			flex-direction: column; /* 수직 방향으로 정렬 */
		}
		
		.container {
			flex: 1; /* 남는 공간을 차지하게 함 */
		}
	</style>
	<script type="text/javascript">
		'use strict';
		
		document.addEventListener('DOMContentLoaded', function() {
		    let productPart = document.getElementById("productPart");
		    if(productPart){
		    	 productPart.style.setProperty('display', 'none');//, 'important'
		    }
		});
		
		function showCard() {
			let productPart = document.getElementById("productPart");
			if (productPart) {
			    productPart.style.setProperty("display", "block"); // 또는 원하는 display 속성 값
			}
		}
		
		//장바구니 담기
		function addToCart(idx) {
			let pageQuantity = document.getElementById("pageQuantity").value;
			
			if(${sLevel==null}){
				alert("로그인후 사용가능합니다");
				return false;
			}
			
			$.ajax({
				type: "post",
				url: "${ctp}/product/addToCart",
				data : { 
					idx : idx,
					quantity : pageQuantity
				},
				success: function(res) {
					if(res == 'mid'){
						alert("로그인후 가능합니다");
					}else if(res != 0){
						alert("상품을 장바구니에 추가하였습니다");
					} 
					else {
						alert("장바구니 추가 실패");
					}
				},
				error: function() {
					alert("전송오류");
				}
			});
		}
		
		 // 할인율이 있을 경우 할인 가격, 없으면 원래 가격을 계산한 후 Math.round()로 반올림합니다.
	    let pageDiscountedPrice = Math.round(
	        <c:choose>
	            <c:when test="${dataVO.discountRate != 0}">
	                ${dataVO.productPrice * (100 - dataVO.discountRate) / 100}
	            </c:when>
	            <c:otherwise>
	                ${dataVO.productPrice}
	            </c:otherwise>
	        </c:choose>
	    );
		
		//플러스 마이너스 및 가격변경
		function updatePriceAndQuantity(ans) {
	    let quantity = document.getElementById("pageQuantity");
	    let stock = "${dataVO.productStock}";
	    let numberStock = parseInt(stock);
	
	    let currentQuantity = parseInt(quantity.value) || 0;
	
	    if (ans === 'plus') {
	        if (currentQuantity >= numberStock) {
	            alert("재고가 부족합니다.");
	            return false;
	        } else {
	            quantity.value = currentQuantity + 1;
	        }
	    } else if (ans === 'minus') {
	        if (currentQuantity <= 1) {
	            alert("최소 수량은 1개입니다.");
	            return false;
	        } else {
	            quantity.value = currentQuantity - 1;
	        }
	    }
	
	    // 변경된 최신 수량 값을 가져옴
	    let newQuantity = parseInt(quantity.value);
	
	    // 여기서 pageDiscountedPrice는 이미 숫자형 값입니다.
	    let numberPrice = parseFloat(pageDiscountedPrice);
	
	    // 수량 변경 후 총 가격 계산
	    let newTotalCost = newQuantity * numberPrice;
	
	    // 화면에 표시하는 요소 업데이트 (span은 textContent로 업데이트)
	    let totalCostElementA = document.getElementById("totalCostA");
	    let totalCostElementB = document.getElementById("totalCostB");
	    let totalCount = document.getElementById("totalCount");
	
	    if (totalCount) {
	        totalCount.textContent = newQuantity;
	    } else {
	        console.error("totalCount 요소를 찾을 수 없습니다.");
	    }
	
	    if (totalCostElementA) {
	        totalCostElementA.textContent = newTotalCost.toLocaleString() + " 원";
	    } else {
	        console.error("totalCostA 요소를 찾을 수 없습니다.");
	    }
	
	    if (totalCostElementB) {
	        totalCostElementB.textContent = newTotalCost.toLocaleString();
	    } else {
	        console.error("totalCostB 요소를 찾을 수 없습니다.");
	    }
	
	    // form에 있는 숨겨진 input 업데이트 (정가는 dataVO.productPrice로 설정)
	    let prePrice = "${dataVO.productPrice}";
	    let numberPrePrice = parseFloat(prePrice);
	    
	    document.getElementById("quantity").value = newQuantity;
	    document.getElementById("price").value = numberPrePrice;
	    document.getElementById("discountedPrice").value = numberPrice;
	    
	    return true;
	}
		
		/* 물건 바로 구매 */
		function directBuy() {
			let quantity = document.getElementById("pageQuantity");
		  let idx = "${dataVO.idx}";
		  if(${empty sMid}){
			 alert("로그인 후 이용가능합니다");
			 return false;
		  }else{
			  location.href="${ctp}/product/directBuy?productIdx="+idx+"&quantity="+quantity.value;
		  }
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
	<h2 class="text-center">상세정보</h2>
	<form id="myform" name="myform" action="${ctp}/product/directBuy" method="get">
	<div class="row">
		<div class="col-6">
			<img src="${ctp}/product/${dataImgVO.mainImage}" class="img-fluid" >
		</div>
		<div class="col-6">
			<div class="card">
        <div class="card-body">
            <h5 class="card-title display-3 fw-bold">${dataVO.productName}</h5>
            <div class="d-flex justify-content-between align-items-center">
                	<c:if test="${dataVO.discountRate == 0}">
	                	<div>
                     	<span style="font-size: 3em">
                     		<fmt:formatNumber value="${dataVO.productPrice}" pattern="#,###" />원
                     	</span>
                    </div>
                	</c:if>
                	<c:if test="${dataVO.discountRate != 0}">
	                	<c:set var="pageDiscountedPrice" value="${dataVO.productPrice * (100 - dataVO.discountRate) / 100}" />
	                	<div>
	                    <span style="font-size: 3em">
	                        <fmt:formatNumber value="${pageDiscountedPrice}" pattern="#,###" />원
	                    </span>
	                    <span style="text-decoration: line-through; font-size: 2em;">
	                    	<fmt:formatNumber value="${dataVO.productPrice}" pattern="#,###" />원
	                    </span>
	                	</div>
                	</c:if>
                <div class="d-flex align-items-center">
                    <span>
                    	재고 : ${dataVO.productStock} &nbsp;
                    </span>
                </div>
            </div>
            <div class="d-flex justify-content-between align-items-center mt-2">
	        		<c:if test="${dataVO.deliveryCost != 0}">
           	 		<span class="fs-5"><i class="bi bi-truck"></i> 배송비 <fmt:formatNumber value="${dataVO.deliveryCost}" pattern="#,###" />원</span>
            	</c:if>
	        		<c:if test="${dataVO.deliveryCost == 0}">
           	 		<span class="fs-5"><i class="bi bi-truck"></i>무료배송</span>
            	</c:if>
      	      <c:if test="${dataVO.discountRate != 0}">
              	<span class="btn btn-danger me-2">-${dataVO.discountRate}%</span>
              </c:if>
              <button type="button" onclick="addToCart(${dataVO.idx})" class="btn btn-outline-primary w-50" data-bs-toggle="tooltip" data-bs-title="장바구니 추가">
                <i class="bi bi-cart-plus"></i>
              </button>
            </div>
            <hr/>
            <div>
            	<!-- 상품 옵션 및 구매 버튼 수량 선택버튼 -->
            	<select id="productSelect" name="productSelect" class="form-select" onchange="showCard()">
            		<option value="" >선택하세요</option>
            		<option value="${dataVO.productName}" >${dataVO.productName}</option>
            	</select>
							<div id="productPart" class="row d-flex align-items-center justify-content-end mt-3">
					  	<div class="">
					   		<p class="fs-4 fw-bold">
					   			${dataVO.productName}&nbsp;
		              <c:if test="${dataVO.hotLabel != 0}">
		                <i class="fa-solid fa-fire text-danger" data-bs-toggle="tooltip" data-bs-title="인기상품"></i>
		              </c:if>
		              <c:if test="${dataVO.newLabel != 0}">
		                <i class="fa-solid fa-n text-info" data-bs-toggle="tooltip" data-bs-title="신규상품"></i>
		              </c:if>
		              <c:if test="${dataVO.deliLabel != 0}">
		                <i class="fa-solid fa-truck-fast text-dark" data-bs-toggle="tooltip" data-bs-title="무료배송"></i>
		              </c:if>
	             	  <c:if test="${dataVO.tempType == 'hte'}">
		              	<i class="bi bi-thermometer-sun fw-bold text-warning"  data-bs-toggle="tooltip" data-bs-title="고온"></i>
		              </c:if>
		              <c:if test="${dataVO.tempType == 'lte'}">
		              	<i class="bi bi-thermometer-snow fw-bold text-primary"  data-bs-toggle="tooltip" data-bs-title="저온"></i>
		              </c:if>
		              <c:if test="${dataVO.tempType == 'nn'}">
		              	<i class="bi bi-thermometer-half fw-bold text-secondary"  data-bs-toggle="tooltip" data-bs-title="중온"></i>
		              </c:if>
		              <c:if test="${dataVO.humiType == 'hhu'}">
		              	<i class="bi bi-droplet-fill fw-bold text-primary-emphasis"  data-bs-toggle="tooltip" data-bs-title="다습"></i>
		              </c:if>
		              <c:if test="${dataVO.humiType == 'lhu'}">
		              	<i class="bi bi-droplet fw-bold text-danger-emphasis"  data-bs-toggle="tooltip" data-bs-title="저습"></i>
		              </c:if>
		              <c:if test="${dataVO.humiType == 'nn'}">
		              	<i class="bi bi-droplet-half fw-bold text-secondary"  data-bs-toggle="tooltip" data-bs-title="중습"></i>
		              </c:if>
		              <c:if test="${dataVO.phType == 'lph'}">
		              	<i class="fa-solid fa-temperature-low fw-bold text-success-emphasis"  data-bs-toggle="tooltip" data-bs-title="산성"></i>
		              </c:if>
		              <c:if test="${dataVO.phType == 'hph'}">
		              	<i class="fa-solid fa-temperature-high fw-bold text-info-emphasis"  data-bs-toggle="tooltip" data-bs-title="염기성"></i>
		              </c:if>
		              <c:if test="${dataVO.phType == 'nph'}">
		              	<i class="bi bi-7-circle fw-bold text-secondary"  data-bs-toggle="tooltip" data-bs-title="중성"></i>
		              </c:if>
					   		</p> 
					  	</div>
						  <div class="col-md-5 d-flex align-items-center justify-content-end"> 
						  	<div class="input-group me-2"> 
						  		<button onclick="updatePriceAndQuantity('minus')" class="btn btn-outline-secondary" type="button"><i class="bi bi-dash-lg"></i></button> 
						  			<input id="pageQuantity" name="pageQuantity" type="number" class="form-control text-center" value="0" readonly > 
						  		<button onclick="updatePriceAndQuantity('plus')" class="btn btn-outline-secondary" type="button"><i class="bi bi-plus-lg"></i></button>
						  	</div> 
						  </div>
						  <div class="col-4 text-end">
					  	 <span class="fs-5 me-2">
					  	 	 	<span id="totalCostA">
          					<fmt:formatNumber value="0" pattern="#,###" /> 원
          				</span>
					  	 </span> 
						  </div>
							  <div class="col-3 text-end">
							  	 <button type="button" onclick="location.reload()" class="btn btn-outline-danger btn-sm" data-bs-toggle="tooltip" data-bs-title="선택상품삭제"><i class="bi bi-x-lg"></i></button> 
							  </div>
							</div>
							<div class="my-3">
							  <div class="card">
							    <div class="card-header">
							      상세 정보
							    </div>
							    <div class="card-body">
							    <c:if test="${empty dataVO.productDescription}">
							    	<span>상세정보가 없습니다</span>
							    </c:if>
							    <c:if test="${!empty dataVO.productDescription}">
							      <span>${dataVO.productDescription}</span>
							    </c:if>
							    </div>
							  </div>
							  <div class="card mt-3">
							    <div class="card-header">
							      태그 (${dataVO.productCategory})
							    </div>
							    <div class="card-body">
								    <c:if test="${empty dataVO.productTag}">
								    	<span>태그가 없습니다</span>
								    </c:if>
								    <c:if test="${!empty dataVO.productTag}">
								      <span>${dataVO.productTag}</span>
								    </c:if>
							    </div>
							  </div>
							</div>
            	<div class="my-2 d-flex align-items-center justify-content-between">
            		<span data-bs-toggle="tooltip" data-bs-title="배송비 미포함">총상품금액 <i class="bi bi-question-circle"></i></span>
            		<span>총 수량 
	            		<span id="totalCount">
	            			<fmt:formatNumber value="0" pattern="#,###" />
	            		</span> 개
            		</span> 
            		<span class="fs-3 fw-bold">
            			<i class="bi bi-pause"></i> 
            			<span class="text-danger text-end">
            				<span id="totalCostB">
            					<fmt:formatNumber value="0" pattern="#,###" />
            				</span>
            			원
            			</span>
            		</span>
            	</div>
            </div>
            <div class="">
            	<button type="button" onclick="directBuy()" class="btn btn-info form-control mb-3">바로구매</button>
            	<button type="button" onclick="location.href='${ctp}/product/memberCartList'" class="btn btn-primary form-control">장바구니 보기</button>
            </div>
        </div>
    	</div>
		</div>
	</div>
	<hr/>
	<div class="text-center">
		<img src="${ctp}/product/${dataImgVO.detailedImage}" class="img-fluid">
	</div>
	<input type="hidden" id="productIdx" name="productIdx" value="${dataVO.idx}" />
	<input type="hidden" id="quantity" name="quantity" />
	<input type="hidden" id="price" name="price" />
	<input type="hidden" id="discountedPrice" name="discountedPrice" />
	<input type="hidden" id="discountRate" name="discountRate" value="${dataVO.discountRate}" />
	</form>
</div>
<p><br/></p>
<footer class="footer">
	<jsp:include page="/WEB-INF/views/include/footer2.jsp" />
</footer>
<script type="text/javascript">

	const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
	const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))

</script>
</body>
</html>