package com.spring.javaGroupS2.vo;

import lombok.Data;

@Data
public class ProductMarketDataCheckVO {
	
	private int idx;
	private Integer discountRateCheck; //1-100
	private String plantCate; //식물카테고리
	private String supplyCate; //부자재 카테고리
	private String etcCate; //기타 카테고리
	private String discountRateUseCheck; //체크되면 미사용 넘어옴
	private String freeDeli; //무료배송
	private String noneFreeDeli; //유료배송
	private String hite; //고온
	private String lote; //저온
	private String hihu; //다습
	private String lohu; //저습
	private String hph; //염기성
	private String nph; //중성
	private String lph; //산성
	
//	private String productCatrgoryCheck; //plantCate supplyCate etcCate
//	private String deliveryCostCheck;// freeDeli noneFreeDeli
//	private String plantType;// hthh고온다습 lthh저온다습 htlh고온저습 ltlh저온저습 hph산성 nph중성 lph염기성
	
}
