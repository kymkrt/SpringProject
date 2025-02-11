package com.spring.javaGroupS2.interceptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
public class Level3Interceptor extends HandlerInterceptorAdapter{ //인터셉터는 핸들러인터셉터아답터를 상속받는다
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession(); 
		int level = session.getAttribute("sLevel")==null ? 999 : (int) session.getAttribute("sLevel");
		
		//로그인 하지 않은 회원은 로그인 창으로 이동
		if (level > 3) {
			RequestDispatcher dispatcher = request.getRequestDispatcher("/message/loginNo");
			dispatcher.forward(request, response);
			return false;
		}
		
		return true; 
	}
}
