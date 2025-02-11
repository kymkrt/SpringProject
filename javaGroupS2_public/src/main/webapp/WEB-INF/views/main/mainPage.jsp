<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>mainPage.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <style type="text/css">
		body {
	    display: flex; 
	    flex-direction: column; 
	    min-height: 100vh; 
		}

		main {
		    flex: 1; 
		}
		footer {
		    margin-top: auto; 
		}
	</style>

</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p id="top"><br/></p>
<div id="container" class="container">
	<h2 class="text-center mb-3">신규상품</h2>
	<div id="new" class="row">
	<c:if test="${empty newDataVOS}">
		<span class="text-center fs-4 fw-bold">신규 상품이 없습니다</span>
	</c:if>
	<c:if test="${!empty newDataVOS}">
		<c:forEach var="vo" items="${newDataVOS}" varStatus="st">
			<c:forEach var="vo2" items="${newDataImgVOS}" varStatus="st">
				<c:if test="${vo.idx * 1 eq vo2.productIdx * 1}">
					<div class="col-3">
							<figure class="figure">
								<a href="${ctp}/product/productDetailInfo?idx=${vo.idx}">
								<c:if test="${!empty vo2.mainImage}">
				  				<img src="${ctp}/product/${vo2.mainImage}" class="figure-img img-fluid rounded" alt="...">
								</c:if>
								<c:if test="${empty vo2.mainImage}">
				  				<img src="${ctp}/member/noimage.jpeg" class="figure-img img-fluid rounded" alt="...">
								</c:if>
								</a>
				  			<figcaption class="figure-caption text-end fs-3" title="태그">
				  				<c:if test="${vo.hotLabel != 0}">
						  			<i class="fa-solid fa-fire text-danger" data-bs-toggle="tooltip" data-bs-title="인기상품"></i>
				  				</c:if>
					  			<i class="fa-solid fa-n text-info" data-bs-toggle="tooltip" data-bs-title="신규상품"></i>
	             		<c:if test="${vo.deliLabel != 0}">
		                <i class="fa-solid fa-truck-fast text-dark" data-bs-toggle="tooltip" data-bs-title="무료배송"></i>
		              </c:if>
		              <c:if test="${vo.tempType == 'hte'}">
		              	<i class="bi bi-thermometer-sun fw-bold text-warning"  data-bs-toggle="tooltip" data-bs-title="고온"></i>
		              </c:if>
		              <c:if test="${vo.tempType == 'lte'}">
		              	<i class="bi bi-thermometer-snow fw-bold text-primary"  data-bs-toggle="tooltip" data-bs-title="저온"></i>
		              </c:if>
		              <c:if test="${vo.tempType == 'nn'}">
		              	<i class="bi bi-thermometer-half fw-bold text-secondary"  data-bs-toggle="tooltip" data-bs-title="중온"></i>
		              </c:if>
		              <c:if test="${vo.humiType == 'hhu'}">
		              	<i class="bi bi-droplet-fill fw-bold text-primary-emphasis"  data-bs-toggle="tooltip" data-bs-title="다습"></i>
		              </c:if>
		              <c:if test="${vo.humiType == 'lhu'}">
		              	<i class="bi bi-droplet fw-bold text-danger-emphasis"  data-bs-toggle="tooltip" data-bs-title="저습"></i>
		              </c:if>
		              <c:if test="${vo.humiType == 'nn'}">
		              	<i class="bi bi-droplet-half fw-bold text-secondary"  data-bs-toggle="tooltip" data-bs-title="중습"></i>
		              </c:if>
		              <c:if test="${vo.phType == 'lph'}">
		              	<i class="fa-solid fa-temperature-low fw-bold text-success-emphasis"  data-bs-toggle="tooltip" data-bs-title="산성"></i>
		              </c:if>
		              <c:if test="${vo.phType == 'hph'}">
		              	<i class="fa-solid fa-temperature-high fw-bold text-info-emphasis"  data-bs-toggle="tooltip" data-bs-title="염기성"></i>
		              </c:if>
		              <c:if test="${vo.phType == 'nph'}">
		              	<i class="bi bi-7-circle fw-bold text-secondary"  data-bs-toggle="tooltip" data-bs-title="중성"></i>
		              </c:if>
				  			</figcaption>
							</figure>
							<span class="text-center fs-3"><strong>${vo.productName}</strong></span> &nbsp;
							<c:if test="${vo.discountRate != 0}">
								<span class="badge bg-danger me-2">-${vo.discountRate}%</span>
							</c:if>
							  <c:if test="${vo.discountRate != 0}">
									<div class="d-flex justify-content-between align-items-center">
									  <c:set var="discountedPrice" value="${vo.productPrice * (100 - vo.discountRate) / 100}" />
									  <div class="text-wrap">
									    <span class="fs-5"><strong><fmt:formatNumber value="${discountedPrice}" pattern="#,###" />원</strong></span> &nbsp; <span style="text-decoration: line-through;"><fmt:formatNumber value="${vo.productPrice}" pattern="#,###" />원</span> &nbsp; <span class="fs-6">${vo.salesCount} 판매됨</span>
									  </div>
									  <div class="d-flex align-items-center">
									    <button type="button" onclick="addToCart(${vo.idx})" class="btn btn-outline-primary"data-bs-toggle="tooltip" data-bs-title="장바구니추가"><i class="bi bi-cart-plus"></i></button>
									  </div>
									</div>
							  </c:if>
							  <c:if test="${vo.discountRate == 0}">
									<div class="d-flex justify-content-between align-items-center">
									  <div>
									    <span class="fs-5"><strong><fmt:formatNumber value="${vo.productPrice}" pattern="#,###" />원</strong></span> &nbsp; <span class="fs-6">${vo.salesCount} 판매됨</span>
									  </div>
									  <div class="d-flex align-items-center">
									    <button type="button" onclick="addToCart(${vo.idx})" class="btn btn-outline-primary" data-bs-toggle="tooltip" data-bs-title="장바구니추가"><i class="bi bi-cart-plus"></i></button>
									  </div>
									</div>
							  </c:if>
						</div>
					</c:if>
				</c:forEach>		
			</c:forEach>
		</c:if>
	</div>
	<h2 class="text-center my-5">인기상품</h2>
	<div id="popular" class="row">
		<c:if test="${empty hotDataVOS}">
			<span class="text-center fs-4 fw-bold">인기 상품이 없습니다</span>
		</c:if>
		<c:if test="${!empty hotDataVOS}">
		<c:forEach var="vo" items="${hotDataVOS}" varStatus="st">
			<c:forEach var="vo2" items="${hotDataImgVOS}" varStatus="st">
				<c:if test="${vo.idx * 1 eq vo2.productIdx * 1}">
					<div class="col-3">
							<figure class="figure">
								<a href="${ctp}/product/productDetailInfo?idx=${vo.idx}">
								<c:if test="${!empty vo2.mainImage}">
				  				<img src="${ctp}/product/${vo2.mainImage}" class="figure-img img-fluid rounded" alt="...">
								</c:if>
								<c:if test="${empty vo2.mainImage}">
				  				<img src="${ctp}/member/noimage.jpeg" class="figure-img img-fluid rounded" alt="...">
								</c:if>
								</a>
				  			<figcaption class="figure-caption text-end fs-3" title="태그">
				  				<c:if test="${vo.hotLabel != 0}">
						  			<i class="fa-solid fa-fire text-danger" data-bs-toggle="tooltip" data-bs-title="인기상품"></i>
				  				</c:if>
					  			<i class="fa-solid fa-n text-info" data-bs-toggle="tooltip" data-bs-title="신규상품"></i>
             			<c:if test="${vo.deliLabel != 0}">
		                <i class="fa-solid fa-truck-fast text-primary" data-bs-toggle="tooltip" data-bs-title="무료배송"></i>
		              </c:if>
		              <c:if test="${vo.tempType == 'hte'}">
		              	<i class="bi bi-thermometer-sun fw-bold text-warning"  data-bs-toggle="tooltip" data-bs-title="고온"></i>
		              </c:if>
		              <c:if test="${vo.tempType == 'lte'}">
		              	<i class="bi bi-thermometer-snow fw-bold text-primary"  data-bs-toggle="tooltip" data-bs-title="저온"></i>
		              </c:if>
		              <c:if test="${vo.tempType == 'nn'}">
		              	<i class="bi bi-thermometer-half fw-bold text-secondary"  data-bs-toggle="tooltip" data-bs-title="중온"></i>
		              </c:if>
		              <c:if test="${vo.humiType == 'hhu'}">
		              	<i class="bi bi-droplet-fill fw-bold text-primary-emphasis"  data-bs-toggle="tooltip" data-bs-title="다습"></i>
		              </c:if>
		              <c:if test="${vo.humiType == 'lhu'}">
		              	<i class="bi bi-droplet fw-bold text-danger-emphasis"  data-bs-toggle="tooltip" data-bs-title="저습"></i>
		              </c:if>
		              <c:if test="${vo.humiType == 'nn'}">
		              	<i class="bi bi-droplet-half fw-bold text-secondary"  data-bs-toggle="tooltip" data-bs-title="중습"></i>
		              </c:if>
		              <c:if test="${vo.phType == 'lph'}">
		              	<i class="fa-solid fa-temperature-low fw-bold text-success-emphasis"  data-bs-toggle="tooltip" data-bs-title="산성"></i>
		              </c:if>
		              <c:if test="${vo.phType == 'hph'}">
		              	<i class="fa-solid fa-temperature-high fw-bold text-info-emphasis"  data-bs-toggle="tooltip" data-bs-title="염기성"></i>
		              </c:if>
		              <c:if test="${vo.phType == 'nph'}">
		              	<i class="bi bi-7-circle fw-bold text-secondary"  data-bs-toggle="tooltip" data-bs-title="중성"></i>
		              </c:if>
				  			</figcaption>
							</figure>
							<span class="text-center fs-3"><strong>${vo.productName}</strong></span> &nbsp;
							<c:if test="${vo.discountRate != 0}">
								<span class="badge bg-danger me-2">-${vo.discountRate}%</span>
							</c:if>
							  <c:if test="${vo.discountRate != 0}">
									<div class="d-flex justify-content-between align-items-center">
									  <c:set var="discountedPrice" value="${vo.productPrice * (100 - vo.discountRate) / 100}" />
									  <div class="text-wrap">
									    <span class="fs-5"><strong><fmt:formatNumber value="${discountedPrice}" pattern="#,###" />원</strong></span> &nbsp; <span style="text-decoration: line-through;"><fmt:formatNumber value="${vo.productPrice}" pattern="#,###" />원</span> &nbsp; <span class="fs-6">${vo.salesCount} 판매됨</span>
									  </div>
									  <div class="d-flex align-items-center">
									    <button type="button" onclick="addToCart(${vo.idx})" class="btn btn-outline-primary" data-bs-toggle="tooltip" data-bs-title="장바구니추가"><i class="bi bi-cart-plus"></i></button>
									  </div>
									</div>
							  </c:if>
							  <c:if test="${vo.discountRate == 0}">
									<div class="d-flex justify-content-between align-items-center">
									  <div>
									    <span class="fs-5"><strong><fmt:formatNumber value="${vo.productPrice}" pattern="#,###" />원</strong></span> &nbsp; <span class="fs-6">${vo.salesCount} 판매됨</span>
									  </div>
									  <div class="d-flex align-items-center">
									    <button type="button" onclick="addToCart(${vo.idx})" class="btn btn-outline-primary" data-bs-toggle="tooltip" data-bs-title="장바구니추가"><i class="bi bi-cart-plus"></i></button>
									  </div>
									</div>
							  </c:if>
					</div>
				</c:if>
			</c:forEach>		
		</c:forEach>
		</c:if>
	</div>
	<h2 class="text-center my-5">농업뉴스</h2>
	<div id="news" class="row">
		<c:if test="${empty newsDataVOS}">
			<span class="text-center fs-4 fw-bold">농업 뉴스가 없습니다</span>
		</c:if>
	</div>
</div>
<div style="display: none;">
	<a href="#top"><i id="topBtn" class="bi bi-arrow-up-square fs-6"></i></a>
	<br>
	<a href="#bottom"><i id="bottomBtn" class="bi bi-arrow-down-square fs-6"></i></a>
</div>

<p><br/></p>
<footer id="bottom" class="footer">
	<jsp:include page="/WEB-INF/views/include/footer2.jsp" />
</footer>
	<script type="text/javascript">
		'use strict';
		
		function addToCart(idx) {
			
			if(${sLevel==null}){
				alert("로그인후 사용가능합니다");
				return false;
			}
			
			$.ajax({
				type: "post",
				url: "${ctp}/product/addToCart",
				data : { idx : idx },
				success: function(res) {
					if(res != 0){
						alert("상품을 장바구니에 추가하였습니다");
					}else if(res == '아이디'){
						alert("로그인후 해주세요");
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
		
		const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
		const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
		
	</script>
</body>
</html>