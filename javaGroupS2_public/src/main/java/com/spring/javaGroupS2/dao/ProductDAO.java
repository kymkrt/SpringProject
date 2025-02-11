package com.spring.javaGroupS2.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javaGroupS2.vo.CartVO;
import com.spring.javaGroupS2.vo.OrderItemsVO;
import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;
import com.spring.javaGroupS2.vo.ProductMarketDataCheckVO;

public interface ProductDAO {

	int setAddToCartByIdx(@Param("idx") int idx,@Param("mid") String mid,@Param("quantity") int quantity);

	CartVO getCartCheckByIdxAndMid(@Param("idx") int idx, @Param("mid") String mid);

	int setPlusQuantityToCartByIdx(@Param("idx") int idx,@Param("mid") String mid,@Param("quantity") int quantity);

	ProductDataVO getProductDataByIdx(@Param("idx") int idx);

	ProductImageVO getProductImgDataByIdx(@Param("idx") int idx);

	List<CartVO> getCartDataListByMidPage(@Param("mid") String mid,@Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize,@Param("searchCategory") String searchCategory);

	List<CartVO> getCartDataSearchListByMidPage(@Param("mid") String mid,@Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize,@Param("part") String part,@Param("searchString") String searchString);

	List<CartVO> getCartDataListByMid(@Param("mid") String mid);

	int setCartDeleteByIdx(@Param("idx") int idx);

	int getProductPlantDataListCount(@Param("option") String option,@Param("subOption") String subOption,@Param("part") String part,@Param("searchString") String searchString,@Param("viewCheckOption") String viewCheckOption);

	List<ProductDataVO> getProductMarketList(@Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize,@Param("category") String category);

	List<ProductDataVO> getProductMarketSearchList(@Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize,@Param("part") String part,@Param("searchString") String searchString);

	ProductImageVO getProductMarketImgList(@Param("idx") int idx);

	List<ProductDataVO> getProductMarketTermList(@Param("checkVO") ProductMarketDataCheckVO checkVO);

	int setOrderDataInsert(@Param("item") OrderItemsVO item,@Param("mid") String mid);

	int setCartDeleteByIdxAndMid(@Param("productIdx") Integer productIdx, @Param("mid") String mid);


}
