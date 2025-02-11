<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>paymentRes.jsp</title>
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
		
		   function calcFinalPrice() {
		        let totalItemCost = 0;      // 할인 적용된 총 상품금액
		        let totalShipping = 0;      // 총 배송비
		        let totalOriginalCost = 0;  // 원래 상품금액 합계

		        // 모든 항목(div.cart-item)을 순회
		        let cartItems = document.querySelectorAll(".cart-item");
		        cartItems.forEach(function(item) {
		            // 각 항목의 고유 id
		            let itemId = item.getAttribute("data-item-id");

		            // 수량
		            let quantityElem = document.getElementById("pageQuantity_" + itemId);
		            let quantity = quantityElem ? parseInt(quantityElem.value) || 0 : 0;

		            // 상품가격, 할인율, 배송비 (hidden input)
		            let productPriceElem = document.getElementById("productPrice_" + itemId);
		            let discountRateElem = document.getElementById("discountRate_" + itemId);
		            let shippingCostElem = document.getElementById("shippingCost_" + itemId);
		            
		            if (!productPriceElem || !discountRateElem || !shippingCostElem) {
		                console.error("필요한 요소를 찾을 수 없습니다. itemId: " + itemId);
		                return;
		            }
		            
		            let productPrice = parseFloat(productPriceElem.value) || 0;
		            let discountRate = parseFloat(discountRateElem.value) || 0;
		            let shippingCost = parseFloat(shippingCostElem.value) || 0;
		            
		            // 할인 적용 가격 계산 (할인율이 0이 아니면 할인된 가격, 아니면 원래 가격)
		            let discountedPrice = (discountRate !== 0) ? productPrice * (100 - discountRate) / 100 : productPrice;

		            // 각 항목별 누적합 계산
		            totalItemCost += discountedPrice * quantity;
		            totalOriginalCost += productPrice * quantity;
		            totalShipping += shippingCost;
		        });

		        // 할인액 계산 (원래 가격과 할인된 가격의 차이)
		        let totalDiscount = totalOriginalCost - totalItemCost;
		        // 최종 주문금액은 상품금액(할인적용)과 배송비의 합계
		        let finalOrderAmount = totalItemCost + totalShipping;

		        // 반올림 후 화면에 표시 (각 summary id 요소의 textContent 업데이트)
		        document.getElementById("summaryItemCost").textContent = Math.round(totalItemCost).toLocaleString() + " 원";
		        document.getElementById("summaryShipping").textContent = Math.round(totalShipping).toLocaleString() + " 원";
		        document.getElementById("summaryDiscount").textContent = Math.round(totalDiscount).toLocaleString() + " 원";
		        document.getElementById("summaryFinalAmount").textContent = Math.round(finalOrderAmount).toLocaleString() + " 원";
		    }

		    // 페이지 로드 후 바로 계산 실행 (필요에 따라 호출 시점을 조절하세요)
		    document.addEventListener('DOMContentLoaded', calcFinalPrice);
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
	<h1 class="text-center">결제에 성공하였습니다!</h1>
	        <div class="container mt-4">
            <div class="card p-4">
                <div class="d-flex align-items-center">
                    <span class="fw-bold fs-5">구매 록록</span>
                </div>
                <hr>
                <c:if test="${empty orderListVO}">
                    <p class="text-center">결제 상품이 없습니다</p>
                </c:if>
                <c:forEach var="vo" items="${orderListVO}" varStatus="st">
                    <c:forEach var="vo2" items="${productDataVOS}" varStatus="st2">
                        <c:forEach var="vo3" items="${imageVOS}" varStatus="st3">
                            <c:choose>
                                <c:when test="${vo.productIdx == vo2.idx and vo2.idx == vo3.productIdx and (sMid == vo.customerMid or sMid == 'admin')}">
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
                                                    <span class="text-decoration-line-through">(<fmt:formatNumber value="${vo2.productPrice}" pattern="#,###"  />원)</span>
																						        &nbsp;<span>배송비포함가격</span>
                                                </p>
                                            </c:if>
                                            <!-- 고유 id를 가진 수량 입력 -->
                                            <div class="input-group fs-5 fw-bold mb-3">
                                                <span class="input-group-text">수량</span>
                                                <input id="pageQuantity_${vo.idx}" name="pageQuantity" type="number" class="form-control text-center" value="${vo.quantity}" readonly>
                                            </div>
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
                    <div class="d-flex justify-content-around">
	                    <button type="button" onclick="location.href='${ctp}/member/memberOrderList'" class="btn btn-success">주문목록 확인하기</button>
	                    <button type="button" onclick="location.href='${ctp}/product/plantMarketList'" class="btn btn-info">상품 더 둘러보기</button>
                    </div>
                </div>
            </div>
        </div>
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