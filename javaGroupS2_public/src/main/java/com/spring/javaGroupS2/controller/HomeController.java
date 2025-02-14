package com.spring.javaGroupS2.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "redirect:/main/mainPage";
	}
	
	@RequestMapping(value = "test/regexTest", method = RequestMethod.GET)
	public String regexTestGet() {
		return "test/regexTest";
	}
	
	@RequestMapping(value = "test/es-gangul", method = RequestMethod.GET)
	public String es_gangulGet() {
		return "test/es-gangul";
	}
	
	@RequestMapping(value = "test/anime_lib", method = RequestMethod.GET)
	public String anime_libGet() {
		return "test/anime_lib";
	}
	
	@RequestMapping(value = "test/tailwind", method = RequestMethod.GET)
	public String tailwindGet() {
		return "test/tailwind";
	}
	
	@RequestMapping(value = "test/footer", method = RequestMethod.GET)
	public String footerGet() {
		return "test/footer";
	}
	
	@RequestMapping(value = "test/test", method = RequestMethod.GET)
	public String testGet() {
		return "test/test";
	}
	
}
