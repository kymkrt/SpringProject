package com.spring.javaGroupS2.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/errorPage")
public class ErrorController {
	
//에러 연습 폼 보기
	@RequestMapping(value = "/errorMain", method = RequestMethod.GET)
	public String errorMainGet() {
		
		return "errorPage/errorMain";
	}
	
	//JSP 페이지에서의 서블릿 에러 발생시 에러페이지로 이동처리하기
	@RequestMapping(value = "/error1", method = RequestMethod.GET)
	public String error1Get() {
		
		return "errorPage/error1";
	}
	
	//컨트롤러를 통해서 에러페이지로 이동처리하기
	@RequestMapping(value = "/errorMessage1", method = RequestMethod.GET)
	public String errorMessage1Get() {
		
		return "errorPage/errorMessage1";
	}
	
	//web.xml을 통해서 400에러 발생시 이동처리하기
	@RequestMapping(value = "/errorTest400", method = RequestMethod.GET)
	//UserVO vo
	public String errorTest400Get() { //이거 서버에서 못잡아줌 그래서 프로그래머가 찾아야 한다
	//public String error400Get() {
		
		return "errorPage/error400";
	}
	
	//web.xml을 통해서 400에러 발생시 이동처리하기
	@RequestMapping(value = "/error400", method = RequestMethod.GET)
//	public String error400Get(UserVO vo) { //이거 서버에서 못잡아줌 그래서 프로그래머가 찾아야 한다
	public String error400Get() {
		
		return "errorPage/error400";
	}
	
	//web.xml을 통해서 404에러 발생시 이동처리하기
	@RequestMapping(value = "/error404", method = RequestMethod.GET)
	public String error404Get() {
		
		return "errorPage/error404";
	}
	
	@RequestMapping(value = "/errorTest405", method = RequestMethod.POST)
	public String errorTest405Post() { 
		
		return "errorPage/error405";
	}
	
	//web.xml을 통해서 405에러 발생시 이동처리하기
	@RequestMapping(value = "/error405", method = RequestMethod.GET)
	public String error405Get() { 
		
		return "errorPage/error405";
	}
	
	@RequestMapping(value = "/errorTest500", method = RequestMethod.GET)
	public String errorTest500Get() { //UserVO vo
		//이렇게 미리 에러들을 알아보고 처리한다
		
		return "errorPage/errorMain";
	}
	
	//web.xml을 통해서 500에러 발생시 이동처리하기
	@RequestMapping(value = "/error500", method = RequestMethod.GET)
	public String error500Get() { 
		
		return "errorPage/error500";
	}
	
	//web.xml을 통해서 ArithmeticException에러 발생시 이동처리하기
	@RequestMapping(value = "/errorArithmeticException", method = RequestMethod.GET)
	public String errorArithmeticExceptionGet() { 
		return "errorPage/errorArithmeticException";
	}
	//web.xml을 통해서 NumberFormatException에러 발생시 이동처리하기
	@RequestMapping(value = "/errorNumberFormatException", method = RequestMethod.GET)
	public String errorNumberFormatExceptionGet() { 
		return "errorPage/errorNumberFormatException";
	}
	//web.xml을 통해서 NullPointerException에러 발생시 이동처리하기
	@RequestMapping(value = "/errorNullPointerException", method = RequestMethod.GET)
	public String errorNullPointerExceptionGet() { 
		return "errorPage/errorNullPointerException";
	}
	//web.xml을 통해서 ArithmeticException에러 발생시 이동처리하기
	@RequestMapping(value = "/errorArrayIndexOutOfBoundsException", method = RequestMethod.GET)
	public String errorArrayIndexOutOfBoundsExceptionGet() { 
		return "errorPage/errorArrayIndexOutOfBoundsException";
	}
}
