package com.spring.javaGroupS2.vo;

import lombok.Data;

@Data
public class ChartDataCheckVO {
	
	private int idx;
	
	//all new withdraw
	private String typeFlag;
	
	private String time;
	private boolean male;
  private boolean female;
  private boolean normal;
  private boolean kakao;
  private boolean naver;
  private boolean twenties;
  private boolean thirties;
  private boolean forties;
  private boolean fifties;
  private boolean sixties;
  private boolean sevties;
}
