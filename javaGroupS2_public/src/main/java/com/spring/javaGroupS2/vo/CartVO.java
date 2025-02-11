package com.spring.javaGroupS2.vo;

import lombok.Data;

@Data
public class CartVO {
	
	private int idx;
	private int productIdx;
	private String userMid;
	private int quantity;
	private String postDate;
}
