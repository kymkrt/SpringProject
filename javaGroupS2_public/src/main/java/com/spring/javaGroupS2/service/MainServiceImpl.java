package com.spring.javaGroupS2.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaGroupS2.common.CommonClass;
import com.spring.javaGroupS2.dao.MainDAO;
import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;

@Service
public class MainServiceImpl implements MainService {

	@Autowired
	MainDAO mainDAO;
	
	@Autowired
	CommonClass commonClass;

	//메인 상품 데이터 가져오기
	@Override
	public List<ProductDataVO> getProductDataMain(String type) {
		return mainDAO.getProductDataMain(type);
	}
	//상품 이미지데이터 가져오기 -idx
	@Override
	public ProductImageVO getProductImgMain(int idx) {
		return mainDAO.getProductImgMain(idx);
	}
	
	
}
