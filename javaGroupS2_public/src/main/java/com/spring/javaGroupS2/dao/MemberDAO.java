package com.spring.javaGroupS2.dao;

import org.apache.ibatis.annotations.Param;

import com.spring.javaGroupS2.vo.MemberVO;

public interface MemberDAO {
	
	MemberVO getMemberIdDuplicateCheck(@Param("mid") String mid);
	
	MemberVO getMemberNickNameDuplicateCheck(@Param("nickName") String nickName);

	int setMemberJoinOk(@Param("vo") MemberVO vo);

	MemberVO getMemberLoginIdCheck(@Param("mid") String mid);

	void setMemberLoginInfoUpdate(@Param("mid") String mid,@Param("todayCnt") int todayCnt);

	int setMemberInfoUpdateOk(@Param("vo") MemberVO vo);

	MemberVO getMemberPartId(@Param("email") String email,@Param("tel") String tel);

	MemberVO getMemberWholeMidByEmail(@Param("email") String email);

	MemberVO getMemberCheckForPwdTempChange(@Param("mid") String mid,@Param("email") String email,@Param("tel") String tel);

	void setMemberTempPwd(@Param("mid") String mid,@Param("tempPwd") String tempPwd);

	int setMemberPwdChange(@Param("mid") String mid,@Param("pwdChanged") String pwdChanged);

	MemberVO getMemberCheck(@Param("mid") String mid,@Param("pwdChanged") String pwdChanged);

	int setMemberWithdrawOk(@Param("mid") String mid);

	void setDeleteMemberInputOk(@Param("mid") String mid, @Param("type") String type, @Param("reason") String reason, @Param("comment") String comment);

	MemberVO getMemberNickNameEmailCheck(@Param("nickName") String nickName,@Param("email") String email);

	MemberVO getMemberIdCheck(@Param("mid") String mid);

	void setKakaoMemberInput(@Param("mid") String mid,@Param("nickName") String nickName,@Param("email") String email,@Param("pwd") String pwd);
}
