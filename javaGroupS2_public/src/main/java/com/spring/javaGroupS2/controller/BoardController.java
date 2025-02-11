package com.spring.javaGroupS2.controller;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.javaGroupS2.pagenation.PageProcess;
import com.spring.javaGroupS2.service.BoardService;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Autowired
	BoardService boardService;
	
	@Autowired
	PageProcess pageProcess;
	
	//식물상담 게시판
	@RequestMapping(value = "/plantDoctorBoardList",method = RequestMethod.GET)
	public String plantDoctorBoardListGet() {
		return "/board/plantDoctorBoardList";
	}
	
	//qna 게시판
	@RequestMapping(value = "/QNABoardList",method = RequestMethod.GET)
	public String QNABoardListGet() {
		return "/board/QNABoardList";
	}
	
	//플랜트마켓 게시판
	@RequestMapping(value = "/plantMarketBoardList",method = RequestMethod.GET)
	public String plantMarketBoardListGet() {
		
		return "/board/plantMarketBoardList";
	}
	
	
}