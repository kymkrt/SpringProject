package com.spring.javaGroupS2.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javaGroupS2.common.CommonClass;
import com.spring.javaGroupS2.pagenation.PageProcess;
import com.spring.javaGroupS2.pagenation.PageVO;
import com.spring.javaGroupS2.service.MemberService;
import com.spring.javaGroupS2.service.ProductService;
import com.spring.javaGroupS2.vo.CartVO;
import com.spring.javaGroupS2.vo.MemberVO;
import com.spring.javaGroupS2.vo.OrderItemsVO;
import com.spring.javaGroupS2.vo.OrdersVO;
import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;
import com.spring.javaGroupS2.vo.ProductMarketDataCheckVO;
import com.spring.javaGroupS2.vo.ProductPayMentVO;

@Controller
@RequestMapping("/product")
public class ProductController {

	@Autowired
	ProductService productService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	CommonClass commonClass;
	
	@Autowired
	JavaMailSender mailSender; //인터페이스로 가져오기
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder; //엔코더, 매치스 사용
	
	//장바구니 추가
	@ResponseBody
	@RequestMapping(value = "/addToCart", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String addToCartPost(int idx,HttpSession session,
			@RequestParam(name="quantity", defaultValue = "1", required = false) int quantity
			) {
		String mid = (String) session.getAttribute("sMid"); // 명시적 형변환 추가
		if(mid == null) {
			return "mid";
		}
		if(quantity ==0) quantity =1; 
		int res = 0;
		CartVO vo = productService.getCartCheckByIdxAndMid(idx,mid);
		if(vo == null) {
			res = productService.setAddToCartByIdx(idx, mid, quantity);
		}else {
			res = productService.setPlusQuantityToCartByIdx(idx, mid, quantity);
		}
		return res+"";
	}
	
	//상품 상세페이지
	@RequestMapping(value = "/productDetailInfo", method = RequestMethod.GET)
	public String productDetailInfoGet(Model model,int idx) {
		
		ProductDataVO dataVO = productService.getProductDataByIdx(idx); 
		ProductImageVO dataImgVO = productService.getProductImgDataByIdx(idx); 
		
		model.addAttribute("dataVO",dataVO);
		model.addAttribute("dataImgVO",dataImgVO);
		
		return "product/productDetailInfo";
	}
	
	//장바구니 리스트
	@RequestMapping(value = "/memberCartList", method = RequestMethod.GET)
	public String productCartGet(Model model,HttpSession session,
			@RequestParam(name="category", defaultValue = "orders", required = false) String category,
			@RequestParam(name="section", defaultValue = "cartList", required = false) String section
			) {
		
		String mid = (String) session.getAttribute("sMid"); // 명시적 형변환 추가
		if(mid == null) {
			return "redirect:/message/loginNo";
		}
		
		List<ProductDataVO> productDataVOS = new ArrayList<ProductDataVO>();
		List<ProductImageVO> productImageVOS = new ArrayList<ProductImageVO>();
		List<CartVO> cartVOS = new ArrayList<CartVO>();
		
		cartVOS = productService.getCartDataListByMid(mid);
		
		for(CartVO vo : cartVOS) {
			productDataVOS.add(productService.getProductDataByIdx(vo.getProductIdx()));
			productImageVOS.add(productService.getProductImgDataByIdx(vo.getProductIdx()));
		}
		
		
		model.addAttribute("productDataVOS",productDataVOS);
		model.addAttribute("productImageVOS",productImageVOS);
		model.addAttribute("cartVOS",cartVOS);
		model.addAttribute("category", category);
		return "product/memberCartList";
	}
	//상품 장바구니 카트 삭제하기-idx 
	@ResponseBody
	@RequestMapping(value = "/cartDeleteByIdx", method = RequestMethod.POST)
	public String cartDeleteByIdx(int idx) {
		int res = 0;
		res = productService.setCartDeleteByIdx(idx);
		return res+"";
	}
	
	//물건 바로 구매 페이지
	@RequestMapping(value = "/directBuy", method = RequestMethod.GET)
	public String directBuyGet(Model model,HttpSession session,
			@RequestParam(name="productIdx", defaultValue = "0", required = false) int idx,
			@RequestParam(name="quantity", defaultValue = "1", required = false) int quantity,
			@RequestParam(name="category", defaultValue = "orders", required = false) String category,
			@RequestParam(name="section", defaultValue = "cartList", required = false) String section
			) {
		String mid = (String) session.getAttribute("sMid"); // 명시적 형변환 추가
		if(mid == null) {
			return "redirect:/message/loginNo";
		}
		ProductDataVO productDataVO = productService.getProductDataByIdx(idx);
		ProductImageVO productImageVO = productService.getProductImgDataByIdx(idx);
		
		model.addAttribute("productDataVO",productDataVO);
		model.addAttribute("productImageVO",productImageVO);
		
		if(quantity ==0) quantity =1; 
		
		model.addAttribute("quantity", quantity);
		model.addAttribute("category", category);
		model.addAttribute("section", section);
		return "product/directBuy";
	}
	
	//상품 구매 전단계
	@RequestMapping(value = "/productPurchaseOne", method = RequestMethod.POST)
	public String productPurchaseOnePost(Model model,HttpSession session,OrdersVO orderListVOS) {
		System.out.println("첫단계");
		String mid = (String) session.getAttribute("sMid"); // 명시적 형변환 추가
		if(mid == null) {
			return "redirect:/message/loginNo";
		}
		//return "product/paymentOk";
		
		//결제용 vo
		ProductPayMentVO paymentVO = new ProductPayMentVO();
		List<ProductImageVO> imageVOS = new ArrayList<ProductImageVO>();
		MemberVO memberVO = new MemberVO();
		memberVO = memberService.getMemberIdCheck(mid);
		Integer totPay = 0;
		String totName = "";
		int count = 0;
		List<OrderItemsVO> items = orderListVOS.getOrderItems();
		if (items != null && !items.isEmpty()) {
		    for (OrderItemsVO item : items) {
		        // item의 필드를 사용하여 작업 수행
		    		item.setCustomerMid(mid);
		    		totPay += item.getTotalPrice();
		    		totName+= item.getProductCartName()+"/";
		    		count++;
		    		imageVOS.add(productService.getProductImgDataByIdx(item.getProductIdx()));
		    		
		    		ProductDataVO dataVO = productService.getProductDataByIdx(item.getProductIdx());
		    		int disRra = dataVO.getDiscountRate();
		    		int pri = (int) dataVO.getProductPrice();
		  			int disPri = (int) (pri * (100 - disRra) / 100.0);
		    		
		    		item.setDiscountPrice(disPri);
		    		item.setAddress(memberVO.getAddress());
		    }
		} else {
		    System.out.println("주문 항목이 없습니다.");
		    return "redirect:/message/paymentResNo";
		}
		
		
		paymentVO.setName(totName.substring(0, 5).replace("/", " ")+" 등 "+count+"개");
		paymentVO.setAmount(totPay);
		paymentVO.setBuyer_email(memberVO.getEmail());
		paymentVO.setBuyer_name(memberVO.getName());
		paymentVO.setBuyer_tel(memberVO.getTel());
		int firstSlashIndex = memberVO.getAddress().indexOf("/"); // 첫 번째 "/" 위치 찾기
		paymentVO.setBuyer_addr((memberVO.getAddress().substring(firstSlashIndex+1)).replace("/", ""));
		String postCode = memberVO.getAddress().substring(0,memberVO.getAddress().indexOf("/")).trim();
		paymentVO.setBuyer_postcode(postCode);
		
		session.setAttribute("sPaymentVO", paymentVO);//페이먼트
		session.setAttribute("sMemberVO",memberVO );//멤버
		session.setAttribute("sOrderList", items);//오더
		
		int amountIn = paymentVO.getAmount();
		
		model.addAttribute("amountInt", amountIn);
		model.addAttribute("payMentVO", paymentVO);
		return "product/paymentOk";
	}
	
	//상품 구매 처리 - db입력
	@RequestMapping(value = "/productPurchaseTwo", method = RequestMethod.GET)
	public String productPurchaseGet(Model model,HttpSession session,ProductPayMentVO paymentVO) {
		System.out.println("2번째");
		String mid = (String) session.getAttribute("sMid"); // 명시적 형변환 추가
		if(mid == null) {
			return "redirect:/message/loginNo";
		}
		int orderRes = 0;
		int cartRes = 0;
		
		List<ProductImageVO> imageVOS = new ArrayList<ProductImageVO>();
		MemberVO memberVO = (MemberVO) session.getAttribute("sMemberVO");
		List<OrderItemsVO> orderListVOS = (List<OrderItemsVO>) session.getAttribute("sOrderList");
		//결제용 vo
		
			if(orderListVOS != null) {
			 for (OrderItemsVO order : orderListVOS) { // ArrayList의 각 OrdersVO 객체에 접근
						 // item의 필드를 사용하여 작업 수행
				 		order.setCustomerMid(mid);
						 
						 imageVOS.add(productService.getProductImgDataByIdx(order.getProductIdx()));
						 
						 System.out.println("상품명: " + order.getProductCartName());
						 
						 orderRes = productService.setOrderDataInsert(order, mid);
						 cartRes = productService.setCartDeleteByIdxAndMid(order.getProductIdx(),mid);
						 if(orderRes ==0) {
							 return "redirect:/message/paymentDataResNo";
						 }else if(cartRes == 0){
							 return "redirect:/message/cartDataDeleteNo";
						 }
					 }
				 } else {
					 System.out.println("주문 항목이 없습니다.");
					 return "redirect:/message/paymentResNo";
				 }
		 
		
		if(orderRes !=0) {
			if(cartRes !=0) {
				return "redirect:/product/productPurchaseThree";
			}else {
				return "redirect:/message/cartDataDeleteNo";
			}
		}else {
			return "redirect:/message/paymentDataResNo";
		}
		
	}
	
	//상품 구매완료 페이지
	@RequestMapping(value = "/productPurchaseThree", method = RequestMethod.GET)
	//아래에서 받을것 
	public String productPurchaseResGet(Model model,HttpSession session) {
		System.out.println("3세번째");
		String mid = (String) session.getAttribute("sMid"); // 명시적 형변환 추가
		if(mid == null) {
			return "redirect:/message/loginNo";
		}
		
		List<ProductImageVO> imageVOS = new ArrayList<ProductImageVO>();
		MemberVO memberVO = (MemberVO) session.getAttribute("sMemberVO");
		List<OrderItemsVO> orderListVOS = (List<OrderItemsVO>) session.getAttribute("sOrderList");
		List<ProductDataVO> productDataVOS = new ArrayList<ProductDataVO>();
		
		if (orderListVOS != null && !orderListVOS.isEmpty()) {
			for (OrderItemsVO item : orderListVOS) {
				item.setCustomerMid(mid);
				
				System.out.println("상품번호: " + item.getProductIdx());
				System.out.println("아이디: " + item.getCustomerMid());
				System.out.println("총가격: " + item.getTotalPrice());
				System.out.println("수량: " + item.getQuantity());
				System.out.println("정가: " + item.getNormalPrice());
				System.out.println("할인율: " + item.getDiscountRate());
				System.out.println("할인한 가격: " + item.getDiscountAmount());
				System.out.println("할인가: " + item.getDiscountPrice());
				System.out.println("배송비: " + item.getDeliveryCost());
				productDataVOS.add(productService.getProductDataByIdx(item.getProductIdx()));
				imageVOS.add(productService.getProductImgDataByIdx(item.getProductIdx()));
				
			}
		} else {
			System.out.println("주문 항목이 없습니다.");
			return "redirect:/message/paymentResNo";
		}
		
		session.removeAttribute("sPaymentVO");
		session.removeAttribute("sMemberVO");
		session.removeAttribute("sOrderList");
		
		System.out.println("오더 : "+orderListVOS);
		System.out.println("상품 : "+productDataVOS);
		System.out.println("이미지 : "+imageVOS);
		
		model.addAttribute("orderListVO", orderListVOS);
		model.addAttribute("productDataVOS", productDataVOS);
		model.addAttribute("imageVOS", imageVOS);
		return "product/paymentRes";
	}
	
	//플랜트 마켓 게시판 일반
	@RequestMapping(value = "/plantMarketList",method = RequestMethod.GET)
	public String plantMarketListGet(Model model,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "16", required = false) int pageSize,
			@RequestParam(name="boardType", defaultValue = "all", required = false) String boardType, //notice
			@RequestParam(name="category", defaultValue = "all", required = false) String category,
			@RequestParam(name="part", defaultValue = "", required = false) String part, //검색용 분류
			@RequestParam(name="searchString", defaultValue = "", required = false) String searchString, //검색용단어
			@RequestParam(name="viewCheckOption", defaultValue = "plantCate", required = false) String viewCheckOption //상품 분류
			) {
		
		List<ProductDataVO> DataVOS = new ArrayList<ProductDataVO>();
		List<ProductImageVO> DataImgVOS = new ArrayList<>(); // ArrayList로 초기화
		
		boardType = "productPlant";
		if (!part.isBlank() && !part.equals("productName") && !part.equals("productTag")&& !part.equals("productDescription")) {
	    // part가 공백도 아니고 "title"도 아니고 "content"도 아닌 경우 실행할 코드
			return "redirect:/message/wrongAccess";
		}
		PageVO pageVO =pageProcess.totBoardRecCnt(pag, pageSize, boardType,category, "","",part, searchString, viewCheckOption);//뒷부분 비어있는건 확장성을 위한 보조필드
		String view = "all";
		if(part.equals("") && searchString.equals("")) {
			view = "all";
			DataVOS = productService.getProductMarketList(pageVO.getStartIndexNo(), pageSize, category);
			for(ProductDataVO vo:DataVOS) {
				DataImgVOS.add(productService.getProductMarketImgList(vo.getIdx()));
			}
		}else {
			view = "search";
			DataVOS = productService.getProductMarketSearchList(pageVO.getStartIndexNo(), pageSize, part, searchString);
			for(ProductDataVO vo:DataVOS) {
				DataImgVOS.add(productService.getProductMarketImgList(vo.getIdx()));
			}
		}
		
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("DataVOS", DataVOS);
		model.addAttribute("DataImgVOS", DataImgVOS);
		model.addAttribute("category", category);
		model.addAttribute("part", part);
		model.addAttribute("searchString", searchString);
		model.addAttribute("view", view);
		
		return "/product/plantMarketList";
	}
	
	//플랜트마켓 게시판 조건
	@RequestMapping(value = "/plantMarketList",method = RequestMethod.POST)
	public String plantMarketListPost(Model model,ProductMarketDataCheckVO checkVO
			) {
		//이건 그냥 다 불러와서 그냥 한페이지에 넣는다 페이지네이션 처리 안함
		List<ProductDataVO> DataVOS = new ArrayList<ProductDataVO>();
		List<ProductImageVO> DataImgVOS = new ArrayList<>(); // ArrayList로 초기화
		
		DataVOS = productService.getProductMarketTermList(checkVO);
		for(ProductDataVO vo:DataVOS) {
			DataImgVOS.add(productService.getProductMarketImgList(vo.getIdx()));
		}
		
		model.addAttribute("DataVOS", DataVOS);
		model.addAttribute("DataImgVOS", DataImgVOS);
		model.addAttribute("view", "search");
		
		return "/product/plantMarketList";
	}
	
}
