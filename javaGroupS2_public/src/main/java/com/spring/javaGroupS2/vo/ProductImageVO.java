package com.spring.javaGroupS2.vo;

import lombok.Data;

@Data
public class ProductImageVO  {
	
	private int idx;
	private int productIdx;
	private String category; 
	private String mainImage; 
	private String detailedImage; 
	private String thumbImage; 
	private String postDate; 
}
