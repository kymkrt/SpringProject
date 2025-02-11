package com.spring.javaGroupS2.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.javaGroupS2.common.CommonClass;
import com.spring.javaGroupS2.pagenation.PageProcess;
import com.spring.javaGroupS2.service.AdminService;
import com.spring.javaGroupS2.service.MainService;
import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;

@Controller
@RequestMapping("/main")
public class MainController {
	
	@Autowired
	AdminService adminService;

	@Autowired
	MainService mainService;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	CommonClass commonClass;
	
	@Autowired
	JavaMailSender mailSender; //인터페이스로 가져오기
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder; //엔코더, 매치스 사용
	
	@RequestMapping(value = "/mainPage", method = RequestMethod.GET)
	public String mainPageGet(Model model, 
			@RequestParam(name="type", defaultValue = "", required = false) String type
			) {
		//상품 vos 최신, 인기, 크롤링 뉴스 데이터
		List<ProductDataVO> newDataVOS = mainService.getProductDataMain("new");
		List<ProductDataVO> hotDataVOS = mainService.getProductDataMain("hot");
		List<ProductImageVO> newDataImgVOS = new ArrayList<>(); // ArrayList로 초기화
		List<ProductImageVO> hotDataImgVOS = new ArrayList<>(); // ArrayList로 초기화
		for(ProductDataVO vo:newDataVOS) {
			newDataImgVOS.add(mainService.getProductImgMain(vo.getIdx()));
		}
		for(ProductDataVO vo:hotDataVOS) {
			hotDataImgVOS.add(mainService.getProductImgMain(vo.getIdx()));
		}
		
		model.addAttribute("newDataVOS",newDataVOS);
		model.addAttribute("hotDataVOS",hotDataVOS);
		model.addAttribute("newDataImgVOS",newDataImgVOS);
		model.addAttribute("hotDataImgVOS",hotDataImgVOS);
		return "/main/mainPage";
	}
	
	
	
}
