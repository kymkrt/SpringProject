package com.spring.javaGroupS2.pagenation;

import lombok.Data;

@Data
public class PageVO {
	
	//칼럼명
	private String table;
	//현재 페이지 번호
	private int pag;
	//한페이지 분량
	private int pageSize;
	//총 페이지수 레코드수
	private int totRecCnt;
	//총페이지 수 (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
	private int totPage;
	//현재 페이지에서 출력되는 '시작 인덱스 번호' 0번부터 (pag - 1) * pageSize
	private int startIndexNo;
	//현재 표시할 화면에서 시작되는 시작번호를 구한다 totRecCnt - startIndexNo
	private int curScrStartNo;
//블럭페이징처리 (시작블록을 0으로 처리 1로하는곳도 많음)
		//이 3가지는 그냥 공식처럼 생각하면 된다 이거 말고도 알고리즘은 많음
		//1. 블럭의 크기를 결정 
	private int blockSize;
//2. 현재페이지가 속한 블록의 번호를 구한다. (예: 총레코드 수가 38개일경우 1페이지 분량 5개라면 총페이지수는 8개이다
		// 이때 0 블록은 1/2/3 1블록은 4/5/6 2블록은 7/8  (pag - 1) / blockSize;
	private int curBlock;
	//마지막 블록 (totPage - 1) / blockSize;
	private int lastBlock;
	
	private String search;
	private String searchString;
	private String searchTitle;
	//private int searchCnt;
	
	private String part;
	
}
