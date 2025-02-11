package com.spring.javaGroupS2.vo;

import lombok.Data;

@Data
public class DeleteMemberVO {
	
	private int idx;
	private String deleteMid;
	private String deleteType;
	private String deleteReason;
	private String deleteDate;
	private String deleteComment;
	
}
