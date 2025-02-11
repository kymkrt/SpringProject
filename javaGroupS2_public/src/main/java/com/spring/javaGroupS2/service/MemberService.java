package com.spring.javaGroupS2.service;

import com.spring.javaGroupS2.vo.MemberVO;

public interface MemberService {
	
	MemberVO getMemberIdDuplicateCheck(String mid);

	MemberVO getMemberNickNameDuplicateCheck(String nickName);

	int setMemberJoinOk(MemberVO vo);

	MemberVO getMemberLoginIdCheck(String mid);

	void setMemberLoginInfoUpdate(String mid, int todayCnt);

	int setMemberInfoUpdateOk(MemberVO vo);

	MemberVO getMemberPartId(String email, String tel);

	MemberVO getMemberWholeMidByEmail(String email);

	MemberVO getMemberCheckForPwdTempChange(String mid, String email, String tel);

	void setMemberTempPwd(String mid, String tempPwd);

	int setMemberPwdChange(String mid, String pwdChanged);

	MemberVO getMemberCheck(String mid, String pwdChanged);

	int setMemberWithdrawOk(String mid);

	void setDeleteMemberInputOk(String mid, String type, String reason, String comment);

	MemberVO getMemberNickNameEmailCheck(String nickName, String email);

	MemberVO getMemberIdCheck(String mid);

	void setKakaoMemberInput(String mid, String nickName, String email, String pwd);
	
}
