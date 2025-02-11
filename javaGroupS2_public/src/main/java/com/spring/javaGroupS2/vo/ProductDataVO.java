package com.spring.javaGroupS2.vo;

import lombok.Data;

@Data
public class ProductDataVO {
	
		private int idx;
		private String productName;
		private String productCategory;
		private int productPlantIdx;
		private double productPrice;
		private int deliveryCost;
		private int productStock;
		private String productDescription;
		private String productStatus;
		private String productTag;
		private int salesCount;
		private int discountRate;
		private String postDate;
		
		private int discountPrice;
		private int newLabel;
		private int hotLabel;
		private int deliLabel;
		private String tempType;
		private String humiType;
		private String phType;// hthh고온다습 lthh저온다습 htlh고온저습 ltlh저온저습 hph산성 nph중성 lph염기성
}
