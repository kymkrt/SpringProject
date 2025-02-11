package com.spring.javaGroupS2.service;

import java.util.List;

import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;

public interface MainService {

	List<ProductDataVO> getProductDataMain(String type);

	ProductImageVO getProductImgMain(int idx);

}
