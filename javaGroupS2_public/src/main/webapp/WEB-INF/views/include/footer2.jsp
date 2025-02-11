<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- <script src="https://cdn.tailwindcss.com"></script> -->

<style>
    body {
      margin: 0;
      padding: 0;
    }
    footer {
      background-color: #333;
      padding: 20px 0;
    }
    .footer-logo img {
      max-width: 100%;
      height: 200px;
    }
    footer p, footer a {
      margin: 0;
      color: #ddd;
      font-size: 14px;
      line-height: 1.6;
    }
    footer a:hover {
      color: #fff;
      text-decoration: none;
    }
    .footer-divider {
      border-top: 1px solid #555;
      margin-top: 20px;
    }
</style>
<body>

<footer>
  <div class="container">
    <div class="row">
      <div class="col-md-3 footer-logo">
    		<img src="${ctp}/images/plantlogo.jpg">
      </div>
      <div class="col-md-3">
        <div class="text-white" style="color: white">식물나무</div>
        <p>㈜식물나무 | 대표: 김영문 | 개인정보보호책임자: 김영완</p>
        <p>통신판매업신고번호: 제2015-서울마포-1058호</p>
        <p>사업자등록번호: 105-87-81968 사업자정보 확인</p>
        <p>호스팅 제공: ㈜식물나무</p>
      </div>
      <div class="col-md-3">
        <h5 class="text-white" style="color: white">Contact Us</h5>
        <p>서울특별시 마포구 월드컵북로 396, 15층 (상암동, 누리꿈스퀘어 비즈니스타워)</p>
        <p>FAX: 02-1234-1234</p>
        <p>E-mail: <a href="mailto:admin@foodnamoo.com">admin@plantnamoo.com</a></p>
      </div>
      <div class="col-md-3">
        <p class="text-white" style="color: white">02-6405-8088</p>
        <p>전화업무: 평일 09:00 ~ 18:00</p>
        <p>실시간 채팅: 평일 09:00 ~ 18:00</p>
        <p>점심시간: 12:00 ~ 13:00</p>
      </div>
    </div>
    <div class="footer-divider"></div>
    <div class="text-center mt-3">
      <p>Copyright © 식물판매 All rights reserved. | Design by SpringS2</p>
    </div>
  </div>
</footer>

</body>