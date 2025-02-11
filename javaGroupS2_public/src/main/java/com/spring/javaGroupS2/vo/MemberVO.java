package com.spring.javaGroupS2.vo;

import lombok.Data;

@Data
public class MemberVO {
	
	private int idx;
	private String mid;
	private String pwd;
	private String nickName;
	private String name;
	private String gender;
	private String birthday;
	private String tel;
	private String address;
	private String email;
	private String content;
	private String photo;
	private int level;
	private String userInfor;
	private String userDel;
	private int point;
	private int visitCnt;
	private int todayCnt;
	private String startDate;
	private String lastDate;
	private String loginType;
	private String remainMid;
	
	private int newLabel;
	private int birthdayFormat;
	private int genderNumber;
	private String currentMid;
	
	//테이블에 정의하지 않은 필드  VO에 추가하고 게터세터와 toString까지 다시 올려야 사용할 준비가 된다
	private String tempMid; //아이디 중복체크를 위한 임시 아이디. 추가된 필드
	private String tempNickName; //아이디 중복체크를 위한 임시 아이디. 추가된 필드
	private int elapsed_date; //최종접속 경과일(탈퇴시 사용) 숫자로 반환 추가된 필드
	private String strLevel; //회원 등급명 추가된 필드
	//private String strUserDel; //OK: 탈퇴신청, NO: 활동중
	
	private String tel1;
	private String tel2;
	private String tel3;
	private String email1;
	private String email2;
	private String postcode;
	private String address2;
	private String detailAddress;
	private String extraAddress;
}
