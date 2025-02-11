package com.spring.javaGroupS2.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaGroupS2.dao.BoardDAO;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	BoardDAO boardDAO;

	
	@Override
	public int setPnu10FInput(String code, String name, String status) {
		return boardDAO.setPnu10FInput(code, name, status);
	}
	
	
}
