package com.spring.javaGroupS2.vo;

import lombok.Data;

@Data
public class OrderItemsVO {

	private Integer idx;
	private Integer productIdx;
	private String customerMid;
	private Integer totalPrice;
	private Integer quantity;
	private Integer normalPrice;
	private Integer discountRate;
	private Integer discountAmount;
	private Integer discountPrice;
	private Integer deliveryCost;
	private String productName;
	private String address;
	private String orderStatus;
	private String postDate;
	
	//상품이름
	private String productCartName;
	
	private int newLabel;
}
