<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>paymentOk.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
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
		//에크마6를 쓰지 않을것이다 = 브라우저마다 결제 지원이 다름  = use strict 안씀 	
		IMP.init("xxxxxxxxxxxxxxxxx"); // 예: 'imp00000000'
		
		IMP.request_pay(
		  {
		    //channelKey: "{콘솔 내 연동 정보의 채널키}", 위의 키 하나로 처리가 가능해서 필요없음
		    pg: "html5_inicis.INIpayTest", //위 대신 이거 사용(키 2개가 합쳐진것)
		    pay_method: "card",
		    merchant_uid: "javaGroupS2"+ new Date().getTime(), // 상점 아이디
		    name: "${payMentVO.name}",
		    //amount: ${amountInt}, //숫자라서 빼도됨
		    amount: 10, //숫자라서 빼도됨
		    buyer_email: "${payMentVO.buyer_email}",
		    buyer_name: "${payMentVO.buyer_name}",
		    buyer_tel: "${payMentVO.buyer_tel}",
		    buyer_addr: "${payMentVO.buyer_addr}",
		    buyer_postcode: "${payMentVO.buyer_postcode}",
		  },
		  
		  function (res) {
			  var paySw = 'no';
		    // 결제 종료 시 호출되는 콜백 함수
		    // response.imp_uid 값으로 결제 단건조회 API를 호출하여 결제 결과를 확인하고,
		    // 결제 결과를 처리하는 로직을 작성합니다.
		    if(res.success){
    	   var msg = '결제가 완료되었습니다.';
/* 	        msg += '\n고유ID : ' + res.imp_uid;
	        msg += '\n상점 거래ID : ' + res.merchant_uid;
	        msg += '\n결제 금액 : ' + res.paid_amount;
	        msg += '\n카드 승인번호 : ' + res.apply_num; */
	        paySw = 'ok';
		    }
		    else{
					var msg = "결재에 실패하였습니다";
					msg += "에러내용 : "+res.error_msg;
		    }
		    alert(msg);
		    if(paySw == 'no') {
			    alert("다시 장바구니창으로 이동합니다.");
		    	location.href='${ctp}/product/memberCartList';
		    }
		    else {
					var temp = "";
					temp += '?name=${payMentVO.name}';
					temp += '&amount=${payMentVO.amount}';
					temp += '&buyer_email=${payMentVO.buyer_email}';
					temp += '&buyer_name=${payMentVO.buyer_name}';
					temp += '&buyer_tel=${payMentVO.buyer_tel}';
					temp += '&buyer_addr=${payMentVO.buyer_addr}';
					temp += '&buyer_postcode=${payMentVO.buyer_postcode}';
					temp += '&imp_uid=' + res.imp_uid;
					temp += '&merchant_uid=' + res.merchant_uid;
					temp += '&paid_amount=' + res.paid_amount;
					temp += '&apply_num=' + res.apply_num;
					
					location.href='${ctp}/product/productPurchaseTwo'+temp;
	    	}
		  },
		);
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
	<h3 class="text-center">현재 결제가 진행중입니다.</h3>
  <div>
  		<img src="${ctp}/images/watingpay.jpeg" class="img-fluid"/>
  </div>
  <hr/>
</div>
<p><br/></p>
<footer id="bottom" class="footer">
    <jsp:include page="/WEB-INF/views/include/footer2.jsp" />
</footer>
</body>
</html>