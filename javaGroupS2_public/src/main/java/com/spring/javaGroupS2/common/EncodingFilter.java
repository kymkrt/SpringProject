package com.spring.javaGroupS2.common;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;

@WebFilter
public class EncodingFilter implements Filter{

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
			throws IOException, ServletException {

		//다운 캐스팅
		HttpServletRequest httpRequest =(HttpServletRequest) request;
		String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length()); 
		
		if(!path.startsWith("/css") && !path.startsWith("/js")) { 
			request.setCharacterEncoding("utf-8");
			response.setContentType("text/html; charset=utf-8");
		}
		
		chain.doFilter(request, response); 
		
	}

	@Override
	public void destroy() {
	}
	
	
}
