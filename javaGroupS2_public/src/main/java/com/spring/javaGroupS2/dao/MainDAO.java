package com.spring.javaGroupS2.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;

public interface MainDAO {

	List<ProductDataVO> getProductDataMain(@Param("type") String type);

	ProductImageVO getProductImgMain(@Param("idx") int idx);
	
	
	
}
