package com.spring.javaGroupS2.service;

import java.util.List;

import com.spring.javaGroupS2.vo.CartVO;
import com.spring.javaGroupS2.vo.OrderItemsVO;
import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;
import com.spring.javaGroupS2.vo.ProductMarketDataCheckVO;

public interface ProductService {

	int setAddToCartByIdx(int idx, String mid, int quantity);

	CartVO getCartCheckByIdxAndMid(int idx, String mid);

	int setPlusQuantityToCartByIdx(int idx, String mid, int quantity);

	ProductDataVO getProductDataByIdx(int idx);

	ProductImageVO getProductImgDataByIdx(int idx);

	List<CartVO> getCartDataListByMidPage(String mid, int startIndexNo, int pageSize, String searchCategory);

	List<CartVO> getCartDataSearchListByMidPage(String mid, int startIndexNo, int pageSize, String part, String searchString);

	List<CartVO> getCartDataListByMid(String mid);

	int setCartDeleteByIdx(int idx);

	List<ProductDataVO> getProductMarketList(int startIndexNo, int pageSize, String category);

	List<ProductDataVO> getProductMarketSearchList(int startIndexNo, int pageSize, String part, String searchString);

	ProductImageVO getProductMarketImgList(int idx);

	int getProductPlantDataListCount(String option, String subOption, String part, String searchString, String viewCheckOption);
	
	List<ProductDataVO> getProductMarketTermList(ProductMarketDataCheckVO checkVO);

	int setOrderDataInsert(OrderItemsVO item, String mid);

	int setCartDeleteByIdxAndMid(Integer productIdx, String mid);
	
}
