package com.spring.javaGroupS2.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaGroupS2.dao.ProductDAO;
import com.spring.javaGroupS2.vo.CartVO;
import com.spring.javaGroupS2.vo.OrderItemsVO;
import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;
import com.spring.javaGroupS2.vo.ProductMarketDataCheckVO;

@Service
public class ProductServiceImpl implements ProductService {
	
	@Autowired
	ProductDAO productDAO;

	//장바구니 추가
	@Override
	public int setAddToCartByIdx(int idx, String mid, int quantity) {
		return productDAO.setAddToCartByIdx(idx, mid, quantity);
	}
	//장바구니 중복체크
	@Override
	public CartVO getCartCheckByIdxAndMid(int idx, String mid) {
		return productDAO.getCartCheckByIdxAndMid(idx, mid);
	}
	//중복 장바구니 숫자 증가
	@Override
	public int setPlusQuantityToCartByIdx(int idx, String mid, int quantity) {
		return productDAO.setPlusQuantityToCartByIdx(idx, mid, quantity);
	}
	//상품데이터 가져오기
	@Override
	public ProductDataVO getProductDataByIdx(int idx) {
		return productDAO.getProductDataByIdx(idx);
	}
	//상품 이미지 데이터 가져오기
	@Override
	public ProductImageVO getProductImgDataByIdx(int idx) {
		return productDAO.getProductImgDataByIdx(idx);
	}
	//장바구니 데이터 가져오기 - 페이지
	@Override
	public List<CartVO> getCartDataListByMidPage(String mid, int startIndexNo, int pageSize, String searchCategory) {
		return productDAO.getCartDataListByMidPage(mid, startIndexNo, pageSize, searchCategory);
	}
	//장바구니 데이터 검색 리스트 - 페이지
	@Override
	public List<CartVO> getCartDataSearchListByMidPage(String mid, int startIndexNo, int pageSize, String part,
			String searchString) {
		return productDAO.getCartDataSearchListByMidPage(mid, startIndexNo, pageSize, part,
				searchString);
	}
	//장바구니 데이터 가져오기
	@Override
	public List<CartVO> getCartDataListByMid(String mid) {
		return productDAO.getCartDataListByMid(mid);
	}
	//카트 데이터 삭제 장바구니
	@Override
	public int setCartDeleteByIdx(int idx) {
		return productDAO.setCartDeleteByIdx(idx);
	}
	//상품 페이지 상품 리스트 가져오기
	@Override
	public List<ProductDataVO> getProductMarketList(int startIndexNo, int pageSize, String category) {
		return productDAO.getProductMarketList(startIndexNo, pageSize, category);
	}
	//상품 페이지 상품 검색 리스트 가져오기
	@Override
	public List<ProductDataVO> getProductMarketSearchList(int startIndexNo, int pageSize, String part,
			String searchString) {
		return productDAO.getProductMarketSearchList(startIndexNo, pageSize, part,
				searchString);
	}
	//상품 페이지 상품 이미지 리스트 가져오기
	@Override
	public ProductImageVO getProductMarketImgList(int idx) {
		return productDAO.getProductMarketImgList(idx);
	}
	//페이지 카운트 가져오기 식물 상품 데이터
	@Override
	public int getProductPlantDataListCount(String option, String subOption, String part, String searchString, String viewCheckOption) {
		return productDAO.getProductPlantDataListCount(option, subOption, part, searchString,viewCheckOption);
	}
	//조건 상품 리스트 가져오기
	@Override
	public List<ProductDataVO> getProductMarketTermList(ProductMarketDataCheckVO checkVO) {
		return productDAO.getProductMarketTermList(checkVO);
	}
	//구매내역 추가하기
	@Override
	public int setOrderDataInsert(OrderItemsVO item, String mid) {
		return productDAO.setOrderDataInsert(item, mid);
	}
	//구매후 카트 데이터 삭제- idx, mid
	@Override
	public int setCartDeleteByIdxAndMid(Integer productIdx, String mid) {
		return productDAO.setCartDeleteByIdxAndMid(productIdx, mid);
	}
}
