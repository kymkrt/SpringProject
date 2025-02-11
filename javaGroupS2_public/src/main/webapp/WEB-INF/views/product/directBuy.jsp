<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>directBuy.jsp</title>
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
            // 체크박스 자동 체크
            let productCheckBtns = document.querySelectorAll("input[name='productCheck']");
            productCheckBtns.forEach(function(checkbox) {
                checkbox.checked = true;
            });
            let allCheckBtn = document.getElementById("allCheck");
            if(allCheckBtn) { allCheckBtn.checked = true; }
            recalcSummary(); // 초기 합계 계산
        });

        // 전체 체크 및 해제 (단일상품 페이지지만 기존 코드를 그대로 사용)
        function allChecking() {
            let productCheckBtns = document.querySelectorAll("input[name='productCheck']");
            let allCheckBtn = document.getElementById("allCheck");
            productCheckBtns.forEach(function(checkbox) {
                checkbox.checked = allCheckBtn.checked;
            });
            recalcSummary();
        }

        // 수량 증감 및 동적 가격 업데이트 (단일상품, 고유 id 없이 기본 id 사용)
        function updatePriceAndQuantity(ans) {
            let quantityElem = document.getElementById("pageQuantity");
            if (!quantityElem) {
                console.error("Quantity element not found for id: pageQuantity");
                return;
            }
            let stockElem = document.getElementById("maxStock");
            let maxStock = stockElem ? parseInt(stockElem.value) : 0;
            let currentQuantity = parseInt(quantityElem.value) || 0;

            if (ans === 'plus') {
                if (currentQuantity >= maxStock) {
                    alert("재고가 부족합니다.");
                    return false;
                } else {
                    quantityElem.value = currentQuantity + 1;
                }
            } else if (ans === 'minus') {
                if (currentQuantity <= 1) {
                    alert("최소 수량은 1개입니다.");
                    return false;
                } else {
                    quantityElem.value = currentQuantity - 1;
                }
            }
            let newQuantity = parseInt(quantityElem.value);

            // 제품 가격 및 할인율 요소
            let productPriceElem = document.getElementById("productPrice");
            let discountRateElem = document.getElementById("discountRate");
            if (!productPriceElem || !discountRateElem) {
                console.error("상품 가격이나 할인율 요소를 찾을 수 없습니다.");
                return;
            }
            let productPrice = parseFloat(productPriceElem.value);
            let discountRate = parseFloat(discountRateElem.value);
            let discountedPrice = (discountRate != 0) ? (productPrice * (100 - discountRate) / 100.0) : productPrice;

            // 동적 총액 계산 및 반올림 처리
            let totalCost = newQuantity * discountedPrice;
            let roundedTotalCost = Math.round(totalCost);

            // 동적 가격 업데이트
            let dynamicPriceElem = document.getElementById("dynamicPrice");
            if (dynamicPriceElem) {
                dynamicPriceElem.textContent = roundedTotalCost.toLocaleString() + " 원";
            }

            // Hidden input 업데이트 (필요시 서버 전송용)
            let hiddenQuantityElem = document.getElementById("hiddenQuantity");
            if (hiddenQuantityElem) {
                hiddenQuantityElem.value = newQuantity;
            }
            let hiddenDiscountedPriceElem = document.getElementById("hiddenDiscountedPrice");
            if (hiddenDiscountedPriceElem) {
                hiddenDiscountedPriceElem.value = discountedPrice;
            }
            
            recalcSummary();
            return true;
        }

        // 전체 합계 재계산 (단일상품 기준)
        function recalcSummary() {
            // 체크박스가 체크되어 있지 않으면 합계는 0
            let checkbox = document.querySelector("input[name='productCheck']");
            if (!checkbox || !checkbox.checked) {
                document.getElementById("summaryItemCost").textContent = "0 원";
                document.getElementById("summaryShipping").textContent = "0 원";
                document.getElementById("summaryDiscount").textContent = "0 원";
                document.getElementById("summaryFinalAmount").textContent = "0 원";
                return;
            }
            let quantity = parseInt(document.getElementById("pageQuantity").value) || 0;
            let productPrice = parseFloat(document.getElementById("productPrice").value);
            let discountRate = parseFloat(document.getElementById("discountRate").value);
            let shippingCost = parseFloat(document.getElementById("shippingCost").value) || 0;
            let discountedPrice = (discountRate != 0) ? (productPrice * (100 - discountRate) / 100.0) : productPrice;
            
            let totalItemCost = Math.round(quantity * discountedPrice);
            let totalOriginalCost = Math.round(quantity * productPrice);
            let totalDiscount = totalOriginalCost - totalItemCost;
            let finalOrderAmount = totalItemCost + shippingCost;
            
            document.getElementById("summaryItemCost").textContent = totalItemCost.toLocaleString() + " 원";
            document.getElementById("summaryShipping").textContent = Math.round(shippingCost).toLocaleString() + " 원";
            document.getElementById("summaryDiscount").textContent = totalDiscount.toLocaleString() + " 원";
            document.getElementById("summaryFinalAmount").textContent = Math.round(finalOrderAmount).toLocaleString() + " 원";
        }

        // "구매 취소" 시 이전 상품 상세 페이지로 이동
        function goBack() {
            let idx = "${productDataVO.idx}";
            let ans = confirm("구매를 취소하시겠습니까?");
            if (ans) {
                location.href = "${ctp}/product/productDetailInfo?idx=" + idx;
            } else {
                return false;
            }
        }
    </script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/include/nav2.jsp" />
    <p><br/></p>
    <div class="container">
        <div class="container mt-4">
            <div class="card p-4">
                <div class="d-flex align-items-center">
                    <input class="form-check-input me-2" type="checkbox" id="allCheck" onclick="allChecking()">
                    <label class="fw-bold fs-5" for="allCheck">전체 선택</label>
                </div>
                <hr>
                <c:if test="${empty productDataVO}">
                    <p class="text-center">상품 정보가 없습니다</p>
                </c:if>
                <c:if test="${!empty productDataVO}">
                    <div class="cart-item d-flex align-items-start p-3 border rounded mb-3">
                        <input class="form-check-input me-3" type="checkbox" name="productCheck">
                        <img src="${ctp}/product/${productImageVO.mainImage}" alt="상품${productDataVO.idx}" class="img-thumbnail" width="80" height="100">
                        <div class="ms-3">
                            <p class="${productDataVO.productCategory=='식물'?'text-success':'text-danger-emphasis'} fw-bold">
                                ${productDataVO.productCategory}
                            </p>
                            <p class="fw-bold">${productDataVO.productName}</p>
                            <c:if test="${productDataVO.discountRate != 0}">
                                <c:set var="pageDiscountedPrice" value="${productDataVO.productPrice * (100 - productDataVO.discountRate) / 100.0}" />
                                <p class="fs-5 fw-bold">
                                    <span id="dynamicPrice">
                                        <fmt:formatNumber value="${pageDiscountedPrice}" pattern="#,###" />원
                                    </span>
                                    (<span class="text-decoration-line-through"><fmt:formatNumber value="${productDataVO.productPrice}" pattern="#,###" />원</span>)
                                    &nbsp;<span class="badge bg-danger me-2">-${productDataVO.discountRate}%</span>
                                </p>
                            </c:if>
                            <c:if test="${productDataVO.discountRate == 0}">
                                <p class="fs-5 fw-bold">
                                    <span id="dynamicPrice">
                                        <fmt:formatNumber value="${productDataVO.productPrice}" pattern="#,###" />원
                                    </span>
                                    (<fmt:formatNumber value="${productDataVO.productPrice}" pattern="#,###" />원)
                                </p>
                            </c:if>
                            <!-- 수량 입력 -->
                            <div class="input-group fs-5 fw-bold mb-3">
                                <span class="input-group-text">수량</span>
                                <button onclick="updatePriceAndQuantity('minus')" class="btn btn-outline-secondary" type="button">
                                    <i class="bi bi-dash-lg"></i>
                                </button>
                                <input id="pageQuantity" name="pageQuantity" type="number" class="form-control text-center" value="${quantity}" readonly>
                                <button onclick="updatePriceAndQuantity('plus')" class="btn btn-outline-secondary" type="button">
                                    <i class="bi bi-plus-lg"></i>
                                </button>
                                <span class="input-group-text">${productDataVO.productStock}</span>
                            </div>
                            <div class="btn-group">
                                <button type="button" onclick="goBack()" class="btn btn-outline-danger btn-sm">돌아가기</button>
                                <button type="button" class="btn btn-outline-secondary btn-sm">주문수정</button>
                            </div>
                        </div>
                        <div class="ms-auto text-end">
                            <p class="text-muted">배송비</p>
                            <p class="fw-bold">
                                <fmt:formatNumber value="${productDataVO.deliveryCost}" pattern="#,###" />원
                            </p>
                            <input type="hidden" id="shippingCost" value="${productDataVO.deliveryCost}" />
                            <button class="btn btn-success">주문하기</button>
                        </div>
                        <!-- Hidden inputs for 계산에 필요한 값들 -->
                        <input type="hidden" id="productPrice" value="${productDataVO.productPrice}" />
                        <input type="hidden" id="discountRate" value="${productDataVO.discountRate}" />
                        <input type="hidden" id="maxStock" value="${productDataVO.productStock}" />
                        <input type="hidden" id="hiddenQuantity" name="quantity" value="${quantity}" />
                        <input type="hidden" id="hiddenDiscountedPrice" name="discountedPrice" value="${pageDiscountedPrice}" />
                    </div>
                </c:if>
                
                <!-- Summary Section (동적 업데이트 대상) -->
                <div class="border-top pt-3">
                    <p>선택상품금액 <span id="summaryItemCost" class="fw-bold">0 원</span></p>
                    <p>총 배송비 <span id="summaryShipping" class="fw-bold">0 원</span></p>
                    <p class="text-danger">즉시할인예상금액 <span id="summaryDiscount" class="fw-bold">0 원</span></p>
                    <p class="fs-5 fw-bold">주문금액 <span id="summaryFinalAmount">0 원</span></p>
                    <button class="btn btn-success w-100">상품 즉시 주문하기</button>
                </div>
            </div>
        </div>
    </div>
    <p><br/></p>
    <footer id="bottom" class="footer">
        <jsp:include page="/WEB-INF/views/include/footer2.jsp" />
    </footer>
</body>
</html>
