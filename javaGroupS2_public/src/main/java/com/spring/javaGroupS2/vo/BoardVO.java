package com.spring.javaGroupS2.vo;

import lombok.Data;

@Data
public class BoardVO {
	private int idx;
	private String mid;
	private String category;
	private String nickName;
	private String title;
	private String content;
	private String hostIp;
	private String openSw;
	private int viewCnt;
	private int good;
	private String file;
	private String postDate;
	private String claim;
	private String boardType;
	
	//추가된 필드(테이블에는 없음)
	private int date_diff; //작성된 게시물의 날짜 비교값
	private int time_diff; //작성된 게시물의 시간 비교값
	private int replyCnt; //댓글의 갯수
	
	
	
}
