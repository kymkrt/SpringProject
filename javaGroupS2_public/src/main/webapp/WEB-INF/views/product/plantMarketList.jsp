<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>plantMarketList.jsp</title>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
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
	'use strict'
	
    function fCheck() {
      // 폼 요소 가져오기
      var form = document.getElementById('myform');
      var criteriaFound = false; // 하나라도 조건이 있으면 true로 변경

      // 폼 내의 모든 체크박스(비활성화되지 않은 것) 가져오기
      var checkboxes = form.querySelectorAll("input[type='checkbox']:not(:disabled)");
      checkboxes.forEach(function(cb) {
          if (cb.checked) {
              criteriaFound = true;
          }
      });

      // 할인율 입력란 체크 (할인율 필터가 활성화 되어 있을 때만)
      var discountRateCheck = document.getElementById('discountRateCheck');
      if (discountRateCheck && !discountRateCheck.disabled) {
          // 입력값이 공백이 아니고 0보다 큰 경우 조건으로 인정
          if (discountRateCheck.value.trim() !== "" && parseInt(discountRateCheck.value) > 0) {
              criteriaFound = true;
          }
      }

      // 조건이 하나도 없으면 alert 후 submit 중단
      if (!criteriaFound) {
          alert("검색 조건을 하나 이상 선택해주세요.");
          return false;
      }

      // 하나라도 조건이 있으면 submit
      form.submit();
    }
</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
	
	<h1 class="text-center" onclick="location.href='${ctp}/product/plantMarketList'" style="cursor: pointer;">상품(식물)게시판</h1>
	
	<form id="myform" name="myform" action="${ctp}/product/plantMarketList" method="post">
		<div class="accordion my-4" id="accordionCheck">
		  <div class="accordion-item">
		    <h2 class="accordion-header">
		      <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
		        세부 옵션 검색
		      </button>
		    </h2>
		    <div id="collapseOne" class="accordion-collapse collapse show" data-bs-parent="#accordionCheck">
		      <div class="accordion-body">
		      	<div class="row mb-1">
			      	<div class="col-3">
				      	<span class="btn btn-secondary">
				      		카테고리
				      	</span>
			      	</div>
			      	<div class="col-3">
							  <input class="form-check-input" type="checkbox" name="plantCate" id="plantCate" value="plantCate" />
							  <label class="form-check-label" for="plantCate">
							    식물
							  </label>
							</div>
							<div class="col-3">
							  <input class="form-check-input" type="checkbox" name="supplyCate" id="supplyCate" value="supplyCate" />
							  <label class="form-check-label" for="supplyCate">
							    부자재
							  </label>
							</div>
							<div class="col-3">
							  <input class="form-check-input" type="checkbox" name="etcCate" id="etcCate" value="etcCate" />
							  <label class="form-check-label" for="etcCate">
							    기타
							  </label>
							</div>
		      	</div>
		        <hr class="border border-success border-1 opacity-75">
		      	<div class="row mb-1">
		      		<div class="col-4">
				      	<span class="btn btn-secondary">
				      		배송비 유무
				      	</span>
		      		</div>
			      	<div class="col-4">
							  <input class="form-check-input" type="checkbox" name="freeDeli" id="freeDeli" value="freeDeli" />
							  <label class="form-check-label" for="freeDeli">
							    무료배송
							  </label>
							</div>
							<div class="col-4">
							  <input class="form-check-input" type="checkbox" name="noneFreeDeli" id="noneFreeDeli" value="noneFreeDeli" />
							  <label class="form-check-label" for="noneFreeDeli">
							    유료배송
							  </label>
							</div>
		      	</div>
		        <hr class="border border-success border-1 opacity-75">
		      	<div class="d-flex justify-content-between mb-1">
			      	<div class="">
				      	<span class="btn btn-secondary">
				      		식물 특징
				      	</span>
			      	</div>
			      	<div class="">
							  <input class="form-check-input" type="checkbox" name="hite" id="hite" value="hite" />
							  <label class="form-check-label" for="hite">
							    고온
							  </label>
							</div>
							<div class="">
							  <input class="form-check-input" type="checkbox" name="lote" id="lote" value="lote" />
							  <label class="form-check-label" for="lote">
							    저온
							  </label>
							</div>
							<div class="">
							  <input class="form-check-input" type="checkbox" name="hihu" id="hihu" value="hihu" />
							  <label class="form-check-label" for="hihu">
							    다습
							  </label>
							</div>
							<div class="">
							  <input class="form-check-input" type="checkbox" name="lohu" id="lohu" value="lohu" />
							  <label class="form-check-label" for="lohu">
							    저습
							  </label>
							</div>
							<div class="">
							  <input class="form-check-input" type="checkbox" name="hph" id="hph" value="hph" />
							  <label class="form-check-label" for="hph">
							    염기성
							  </label>
							</div>
							<div class="">
							  <input class="form-check-input" type="checkbox" name="nph" id="nph" value="nph" />
							  <label class="form-check-label" for="nph">
							    중성
							  </label>
							</div>
							<div class="">
							  <input class="form-check-input" type="checkbox" name="lph" id="lph" value="hph" />
							  <label class="form-check-label" for="lph">
							    산성
							  </label>
							</div>
		      	</div>
		        <hr class="border border-success border-1 opacity-75">
		        <button type="button" onclick="fCheck()" class="btn btn-info form-control">
		        	검색
		        </button>
		      </div>
		    </div>
		  </div>
		</div>
	</form>
	
	<c:if test="${empty DataVOS}">
		<div class="text-center mb-4">
  	  <span class="text-center fs-4 fw-bold">
  	  	${view=='search'? '찾으시는':'현재 매대에 '} 상품이 없습니다
  	  </span>
		</div>
	</c:if>
	<c:if test="${!empty DataVOS}">
	    <!-- row 클래스로 감싸면 bootstrap이 자동으로 줄바꿈을 해줍니다 -->
	    <div class="row">
	        <c:forEach var="vo" items="${DataVOS}" varStatus="st">
	            <c:forEach var="vo2" items="${DataImgVOS}" varStatus="st">
	                <c:if test="${vo.idx * 1 eq vo2.productIdx * 1}">
	                    <div class="col-12 col-sm-6 col-md-4 col-lg-3 mb-4">
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
	                                <c:if test="${vo.newLabel != 0}">
		                                <i class="fa-solid fa-n text-info" data-bs-toggle="tooltip" data-bs-title="신규상품"></i>
	                                </c:if>
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
	                                    <span class="fs-5"><strong>
	                                        <fmt:formatNumber value="${discountedPrice}" pattern="#,###" />원
	                                    </strong></span> &nbsp;
	                                    <span style="text-decoration: line-through;">
	                                        <fmt:formatNumber value="${vo.productPrice}" pattern="#,###" />원
	                                    </span> &nbsp;
	                                    <span class="fs-6">${vo.salesCount} 판매됨</span>
	                                </div>
	                                <div class="d-flex align-items-center">
	                                    <button type="button" onclick="addToCart(${vo.idx})" class="btn btn-outline-primary" data-bs-toggle="tooltip" data-bs-title="장바구니추가">
	                                        <i class="bi bi-cart-plus"></i>
	                                    </button>
	                                </div>
	                            </div>
	                        </c:if>
	                        <c:if test="${vo.discountRate == 0}">
	                            <div class="d-flex justify-content-between align-items-center">
	                                <div>
	                                    <span class="fs-5"><strong>
	                                        <fmt:formatNumber value="${vo.productPrice}" pattern="#,###" />원
	                                    </strong></span> &nbsp;
	                                    <span class="fs-6">${vo.salesCount} 판매됨</span>
	                                </div>
	                                <div class="d-flex align-items-center">
	                                    <button type="button" onclick="addToCart(${vo.idx})" class="btn btn-outline-primary" data-bs-toggle="tooltip" data-bs-title="장바구니추가">
	                                        <i class="bi bi-cart-plus"></i>
	                                    </button>
	                                </div>
	                            </div>
	                        </c:if>
	                    </div>
	                </c:if>
	            </c:forEach>		
	        </c:forEach>
	    </div>
	</c:if>
	
	
		  <!--검색기 시작  -->
  <div class="row mb-4">
    <div class="col-md-6 offset-md-3">
      <form name="searchForm" method="get">
        <div class="input-group">
          <span class="input-group-text">검색</span>
          <select name="part" id="part" class="form-select">
            <option value="productName" ${part=='productName'?'selected':''}>상품명</option>
            <option value="productTag" ${part=='productTag'?'selected':''}>태그</option>
            <option value="productDescription" ${part=='productDescription'?'selected':''}>상세정보</option>
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
		  <c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link text-secondary" href="plantMarketList?pageSize=${pageVO.pageSize}&pag=1">첫페이지</a></li></c:if>
		  <c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link text-secondary" href="plantMarketList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li></c:if>
		  <c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize)+1}" end="${(pageVO.curBlock*pageVO.blockSize) + pageVO.blockSize}" varStatus="st">
		    <c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link bg-secondary border-secondary" href="plantMarketList?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li></c:if>
		   	<!-- 배타적 처리 필요 -->
		    <c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link text-secondary" href="plantMarketList?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li></c:if>
		  </c:forEach>
			  <c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link text-secondary" href="plantMarketList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}">다음블록</a></li></c:if>
			  <c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link text-secondary" href="plantMarketList?pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}">마지막페이지</a></li></c:if>
	  	</ul>
		</div>
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
	
	//툴팁초기화 처리- 이거 없으면 툴팁안됨
	const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
	const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
	
</script>
</body>
</html>