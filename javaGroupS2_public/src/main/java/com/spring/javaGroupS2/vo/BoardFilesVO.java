package com.spring.javaGroupS2.vo;

import lombok.Data;

@Data
public class BoardFilesVO {
	
	private int idx;
	private int postIdx;
	private String postMid;
	private String postNickName;
	private String originalName;
	private String serverName;
	private int fileSize;
	private String filePath;
	private int downCount;
	private String postDate;
	private String downloadIp;
	
}
