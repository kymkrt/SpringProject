package com.spring.javaGroupS2.vo;

import java.util.List;

import lombok.Data;

@Data
public class OrdersVO {
	
	private List<OrderItemsVO> orderItems;
	
}
