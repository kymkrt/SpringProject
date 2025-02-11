<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>memberCartList.jsp</title>
    <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
    <style type="text/css">
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        main { flex: 1; }
        footer { margin-top: auto; }
    </style>
	<script type="text/javascript">
	    'use strict';
	    
	    document.addEventListener('DOMContentLoaded', function() {
	        let productCheckBtns = document.querySelectorAll("input[name='productCheck']");
	        productCheckBtns.forEach(function(checkbox) {
	            checkbox.checked = true;
	        });
	        
	        let cartItems = document.querySelectorAll(".cart-item");
	        cartItems.forEach(function(item) {
	            let itemId = item.getAttribute("data-item-id");
	            if (itemId) {
	                updatePriceAndQuantity('init', itemId);
	            }
	        });
	        
	        let allCheckBtn = document.getElementById("allCheck");
	        if(allCheckBtn) {
	            allCheckBtn.checked = true;
	        }
	        recalcSummary(); // 초기 합계 계산
	    });
	    
	    //장바구니 상품 삭제
	    function cartDeleteByIdx(idx) {
				
	    	let ans = confirm("장바구니에서 상품을 삭제하시겠습니까?");
	    	
	    	if(ans){
		    	$.ajax({
		    		type: "post",
		    		url: "${ctp}/product/cartDeleteByIdx",
		    		data: {
		    			idx : idx
		    		},
		    		success: function(res) {
						if(res != 0){
							alert("장바구니에서 상품이 삭제되었습니다");
							location.reload();
						}else{
							alert("장바구니 상품 삭제 실패");
						}
					},error: function() {
						alert("전송실패");
					}
		    	})
	    	}
			}
	    
	    // 전체 체크 및 전체 해제
	    function allChecking() {
	        let productCheckBtns = document.querySelectorAll("input[name='productCheck']");
	        let allCheckBtn = document.getElementById("allCheck");
	        productCheckBtns.forEach(function(checkbox) {
	            checkbox.checked = allCheckBtn.checked;
	        });
	        recalcSummary();
	    }
	    
	    // 플러스/마이너스 및 가격 변경 (itemIdx: 각 상품의 고유 id)
function updatePriceAndQuantity(ans, itemIdx) {
    let quantityElem = document.getElementById("pageQuantity_" + itemIdx);
    if (!quantityElem) {
        console.error("Quantity element not found for id: pageQuantity_" + itemIdx);
        return;
    }
    let currentQuantity = parseInt(quantityElem.value) || 0;
    
    if (ans === 'plus') {
        let stockElem = document.getElementById("maxStock_" + itemIdx);
        let maxStock = stockElem ? parseInt(stockElem.value) : 0;
        if (currentQuantity >= maxStock) {
            alert("재고가 부족합니다.");
            return false;
        }
        quantityElem.value = currentQuantity + 1;
    } else if (ans === 'minus') {
        if (currentQuantity <= 1) {
            alert("최소 수량은 1개입니다.");
            return false;
        }
        quantityElem.value = currentQuantity - 1;
    } else if (ans === 'init') {
        // 초기화 모드: 수량 변경 없이 계산만 수행
    }
    
    let newQuantity = parseInt(quantityElem.value);
    
    let productPriceElem = document.getElementById("productPrice_" + itemIdx);
    let discountRateElem = document.getElementById("discountRate_" + itemIdx);
    let shippingCostElem = document.getElementById("shippingCost_" + itemIdx);
    if (!productPriceElem || !discountRateElem || !shippingCostElem) {
        console.error("필요한 요소를 찾을 수 없습니다.");
        return;
    }
    let productPrice = parseFloat(productPriceElem.value);
    let discountRate = parseFloat(discountRateElem.value);
    let shippingCost = parseFloat(shippingCostElem.value) || 0;
    
    let discountedPrice, discountAmount;
    if (discountRate != 0) {
        discountedPrice = productPrice * (100 - discountRate) / 100.0;
        discountAmount = (productPrice - discountedPrice) * newQuantity;
    } else {
        discountedPrice = productPrice;
        discountAmount = 0;
    }
    
    let totalCost = discountedPrice * newQuantity + shippingCost;
    let roundedTotalCost = Math.round(totalCost);
    
    let dynamicPriceElem = document.getElementById("dynamicPrice_" + itemIdx);
    if (dynamicPriceElem) {
        dynamicPriceElem.textContent = roundedTotalCost.toLocaleString() + " 원";
    }
    
    // Hidden input 업데이트 (동일)
    let hiddenQuantityElem = document.getElementById("quantity" + itemIdx);
    if (hiddenQuantityElem) { hiddenQuantityElem.value = newQuantity; }
    let hiddenNormalPriceElem = document.getElementById("normalPrice" + itemIdx);
    if (hiddenNormalPriceElem) { hiddenNormalPriceElem.value = productPrice; }
    let hiddenDiscountPriceElem = document.getElementById("discountPrice" + itemIdx);
    if (hiddenDiscountPriceElem) { hiddenDiscountPriceElem.value = discountedPrice; }
    let hiddenDiscountRateElem = document.getElementById("discountRate" + itemIdx);
    if (hiddenDiscountRateElem) { hiddenDiscountRateElem.value = discountRate; }
    let hiddenDiscountAmountElem = document.getElementById("discountAmount" + itemIdx);
    if (hiddenDiscountAmountElem) { hiddenDiscountAmountElem.value = Math.round(discountAmount); }
    let hiddenDeliveryCostElem = document.getElementById("deliveryCost" + itemIdx);
    if (hiddenDeliveryCostElem) { hiddenDeliveryCostElem.value = shippingCost; }
    let hiddenTotalPriceElem = document.getElementById("totalPrice" + itemIdx);
    if (hiddenTotalPriceElem) { hiddenTotalPriceElem.value = roundedTotalCost; }
    
    recalcSummary();
    return true;
}
	    
	    // 전체 합계 재계산 (체크된 항목만)
	    function recalcSummary() {
	        let totalItemCost = 0;
	        let totalShipping = 0;
	        let totalOriginalCost = 0;
	        let cartItems = document.querySelectorAll(".cart-item");
	        
	        cartItems.forEach(function(item) {
	            let checkbox = item.querySelector("input[name='productCheck']");
	            if (checkbox && checkbox.checked) {
	                let itemId = item.getAttribute("data-item-id");
	                let quantityElem = document.getElementById("pageQuantity_" + itemId);
	                let quantity = quantityElem ? parseInt(quantityElem.value) || 0 : 0;
	                let productPrice = parseFloat(document.getElementById("productPrice_" + itemId).value);
	                let discountRate = parseFloat(document.getElementById("discountRate_" + itemId).value);
	                let shippingCost = parseFloat(document.getElementById("shippingCost_" + itemId).value) || 0;
	                let discountedPrice = (discountRate != 0) ? (productPrice * (100 - discountRate) / 100.0) : productPrice;
	                
	                totalItemCost += quantity * discountedPrice;
	                totalOriginalCost += quantity * productPrice;
	                totalShipping += shippingCost;
	            }
	        });
	        
	        let totalDiscount = totalOriginalCost - totalItemCost;
	        let finalOrderAmount = totalItemCost + totalShipping;
	        
	        // 반올림 처리 후 업데이트
	        document.getElementById("summaryItemCost").textContent = Math.round(totalItemCost).toLocaleString() + " 원";
	        document.getElementById("summaryShipping").textContent = Math.round(totalShipping).toLocaleString() + " 원";
	        document.getElementById("summaryDiscount").textContent = Math.round(totalDiscount).toLocaleString() + " 원";
	        document.getElementById("summaryFinalAmount").textContent = Math.round(finalOrderAmount).toLocaleString() + " 원";
	    }
	    
	    //수량 체크 처리
	    function checkPageQuantity() {
	    	  const pageQuantityInputs = document.querySelectorAll('input[name="pageQuantity"]');
	    	  let hasValue = false;
	    	  let allZero = true;

	    	  pageQuantityInputs.forEach(input => {
	    	    const value = parseInt(input.value) || 0; // 숫자로 변환, 값이 없으면 0으로 처리

	    	    if (value > 0) {
	    	      hasValue = true;
	    	      allZero = false;
	    	    } else if (value !== 0) { // 0이 아닌 다른 값이 있다면
	    	      allZero = false;
	    	    }
	    	  });

	    	  if (!hasValue || allZero) {
	    	    return false; // 값이 없거나 모두 0이면 false 반환
	    	  }

	    	  return true; // 그렇지 않으면 true 반환
	    	}
	    
	    //구매처리
			function fCheck() {
			    // 재고 체크: 모든 cart-item의 maxStock을 확인 (재고가 0이면 결제 진행 불가)
			    let cartItems = document.querySelectorAll(".cart-item");
			    for (let item of cartItems) {
			        let itemId = item.getAttribute("data-item-id");
			        let maxStockElem = document.getElementById("maxStock_" + itemId);
			        if (maxStockElem) {
			            let stock = parseInt(maxStockElem.value) || 0;
			            if (stock <= 0) {
			                alert("일부 상품의 재고가 부족합니다. 결제할 수 없습니다.");
			                return false;
			            }
			        }
			    }
			
			    let cartVOS = "<c:out value='${cartVOS}'/>";
			    let productDataVOS = "<c:out value='${productDataVOS}'/>";
			    let productImageVOS = "<c:out value='${productImageVOS}'/>";
			
			    if (cartVOS == null || cartVOS.length == 0 || 
			        productDataVOS == null || productDataVOS.length == 0 || 
			        productImageVOS == null || productImageVOS.length == 0) {
			        alert("상품이 없습니다. 다시 확인해주세요");
			        return false;
			    } else if (!checkPageQuantity()) {
			        alert("수량 값을 확인해주세요.");
			        return false; // 폼 제출 취소
			    }
			    myform.submit();
			}
	</script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/include/nav2.jsp" />
    <p><br/></p>
    <div class="container">
    	<form id="myform" name="myform" action="${ctp}/product/productPurchaseOne" method="post">
    	<h1 class="text-center">장바구니</h1>
        <div class="container mt-4">
            <div class="card p-4">
                <div class="d-flex align-items-center justify-content-between">
                    <input class="form-check-input me-2" type="checkbox" id="allCheck" onclick="allChecking()">
                    <label class="fw-bold fs-5" for="allCheck">전체 선택</label>
                    
                    <a href="${ctp}/member/memberMain" class="btn btn-info">메인페이지 이동</a>
                </div>
                <hr>
                <c:if test="${empty cartVOS}">
                    <p class="text-center">장바구니에 상품이 없습니다</p>
                </c:if>
                <c:forEach var="vo" items="${cartVOS}" varStatus="st">
                    <c:forEach var="vo2" items="${productDataVOS}" varStatus="st2">
                        <c:forEach var="vo3" items="${productImageVOS}" varStatus="st3">
                            <c:choose>
                                <c:when test="${vo.productIdx == vo2.idx and vo2.idx == vo3.productIdx and (sMid == vo.userMid or sMid == 'admin')}">
                                    <!-- 각 cart-item에 data-item-id로 vo.idx 지정 -->
                                    <div class="cart-item d-flex align-items-start p-3 border rounded mb-3" data-item-id="${vo.idx}">
                                        <input class="form-check-input me-3" type="checkbox" name="productCheck">
                                        <img src="${ctp}/product/${vo3.mainImage}" alt="상품${vo.idx}" class="img-thumbnail" width="80" height="100">
                                        <div class="ms-3">
                                            <p class="${vo2.productCategory == '식물' ? 'text-success' : 'text-danger-emphasis'} fw-bold">
                                                ${vo2.productCategory}
                                            </p>
                                            <p class="fw-bold">${vo2.productName}</p>
																						<c:if test="${vo2.discountRate != 0}">
																						    <!-- 할인 적용 가격 계산 (소수점 연산을 위해 100.0 사용) -->
																						    <c:set var="pageDiscountedPrice" value="${vo2.productPrice * (100 - vo2.discountRate) / 100.0}" />
																						    <c:set var="pageDiscountedPriceCalc" value="${pageDiscountedPrice * vo.quantity}" />
																						    <p class="fs-5 fw-bold">
																						        <span id="dynamicPrice_${vo.idx}">
																						            <fmt:formatNumber value="${pageDiscountedPriceCalc}" pattern="#,###" />원
																						        </span>
																						        (<span class="text-decoration-line-through">
																						            <fmt:formatNumber value="${vo2.productPrice}" pattern="#,###" />원
																						        </span>)
																						        &nbsp;<span class="badge bg-danger me-2">-${vo2.discountRate}%</span>
																						        &nbsp;<span>배송비포함가격</span>
																						    </p>
																						</c:if>
                                            <c:if test="${vo2.discountRate == 0}">
                                                <p class="fs-5 fw-bold">
                                                    <span id="dynamicPrice_${vo.idx}">
                                                        <fmt:formatNumber value="${vo2.productPrice * vo.quantity}" pattern="#,###" />원
                                                    </span>
                                                    <%-- <span class="text-decoration-line-through">(<fmt:formatNumber value="${vo2.productPrice}" pattern="#,###"  />원)</span> --%>
																						        &nbsp;<span>배송비포함가격</span>
                                                </p>
                                            </c:if>
                                            <!-- 고유 id를 가진 수량 입력 -->
                                            <div class="input-group fs-5 fw-bold mb-3">
                                                <span class="input-group-text">수량</span>
                                                <button onclick="updatePriceAndQuantity('minus', '${vo.idx}')" class="btn btn-outline-secondary" type="button">
                                                    <i class="bi bi-dash-lg"></i>
                                                </button>
                                                <input id="pageQuantity_${vo.idx}" name="pageQuantity" type="number" class="form-control text-center" value="${vo.quantity}" readonly>
                                                <button onclick="updatePriceAndQuantity('plus', '${vo.idx}')" class="btn btn-outline-secondary" type="button">
                                                    <i class="bi bi-plus-lg"></i>
                                                </button>
                                                <span class="input-group-text">${vo2.productStock}</span>
                                            </div>
                                            <div class="ms-3">
                                                <button type="button" onclick="cartDeleteByIdx('${vo.idx}')" class="btn btn-outline-danger btn-sm">상품삭제</button>
                                                <button type="button" class="btn btn-outline-secondary btn-sm">주문수정</button>
                                            </div>
                                            <!-- 서버로 보내는값  -->
                                            <input type="hidden" id="productIdx${vo.idx}" name="orderItems[${st.index}].productIdx" value="${vo2.idx}" />
                                            <input type="hidden" id="totalPrice${vo.idx}" name="orderItems[${st.index}].totalPrice" value="0" />
                                            <input type="hidden" id="quantity${vo.idx}" name="orderItems[${st.index}].quantity" value="${vo.quantity}" />
                                            <input type="hidden" id="normalPrice${vo.idx}" name="orderItems[${st.index}].normalPrice" value="${vo2.productPrice}" />
                                            
                                            <%-- <input type="hidden" id="discountPrice${vo.idx}" name="orderItems[${st.index}].discountPrice" value="0" /> --%>
                                            
                                            <input type="hidden" id="discountRate${vo.idx}" name="orderItems[${st.index}].discountRate" value="${vo2.discountRate}" />
                                            <input type="hidden" id="discountAmount${vo.idx}" name="orderItems[${st.index}].discountAmount" value="0" />
                                            <input type="hidden" id="deliveryCost${vo.idx}" name="orderItems[${st.index}].deliveryCost" value="${vo2.deliveryCost}" />
                                            <input type="hidden" id="productCartName${vo.idx}" name="orderItems[${st.index}].productCartName" value="${vo2.productName}" />
                                            
                                            <!-- Hidden inputs for 계산에 필요한 값들 -->
                                            <input type="hidden" id="productPrice_${vo.idx}" value="${vo2.productPrice}" />
                                            <input type="hidden" id="discountRate_${vo.idx}" value="${vo2.discountRate}" />
                                            <input type="hidden" id="maxStock_${vo.idx}" value="${vo2.productStock}" />
                                            <input type="hidden" id="hiddenQuantity_${vo.idx}" value="${vo.quantity}" />
                                            <input type="hidden" id="hiddenDiscountedPrice_${vo.idx}" value="${pageDiscountedPrice}" />
                                        </div>
                                        <div class="ms-auto text-end">
                                            <p class="text-muted">배송비</p>
                                            <p class="fw-bold">
                                                <fmt:formatNumber value="${vo2.deliveryCost}" pattern="#,###" />원
                                            </p>
                                            <input type="hidden" id="shippingCost_${vo.idx}" value="${vo2.deliveryCost}" />
                                            <input type="hidden" id="cartIdx${vo.idx}" value="${vo.idx}" />
                                            <input type="hidden" id="productIdx${vo.idx}" value="${vo2.idx}" />
                                        </div>
                                    </div>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </c:forEach>
                </c:forEach>
                
                <!--최종가격  -->
			          <input type="hidden" id="shippingCost_${vo.idx}" name="shippingCost" value="${vo2.deliveryCost}" />
			          <input type="hidden" id="cartIdx${vo.idx}" name="cartIdx" value="${vo.idx}" />
			          <input type="hidden" id="productIdx${vo.idx}" name="productIdx" value="${vo2.idx}" />
                <!-- Summary Section (동적 업데이트 대상) -->
                <div class="border-top pt-3">
                    <p>선택상품금액 <span id="summaryItemCost" class="fw-bold">0 원</span></p>
                    <p>총 배송비 <span id="summaryShipping" class="fw-bold">0 원</span></p>
                    <p class="text-danger">즉시할인예상금액 <span id="summaryDiscount" class="fw-bold">0 원</span></p>
                    <p class="fs-5 fw-bold">주문금액 <span id="summaryFinalAmount">0 원</span></p>
                    <div class="text-center my-4">
                    	<span>주소, 연락처 등은 등록된 회원정보로 적용됩니다</span>
                    </div>
                    <button type="button" onclick="fCheck()" class="btn btn-success w-100">상품 주문하기</button>
                </div>
            </div>
        </div>
      </form>
    </div>
    <p><br/></p>
    <footer id="bottom" class="footer">
        <jsp:include page="/WEB-INF/views/include/footer2.jsp" />
    </footer>
    <script type="text/javascript">
        // 페이지 로드 시 초기 합계 계산 (이미 DOMContentLoaded에서 호출)
        // recalcSummary();
    </script>
</body>
</html>
