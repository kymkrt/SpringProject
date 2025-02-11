package com.spring.javaGroupS2.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaGroupS2.dao.MemberDAO;
import com.spring.javaGroupS2.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	MemberDAO memberDAO;
	
//회원가입시 아이디 중복체크
	@Override
	public MemberVO getMemberIdDuplicateCheck(String mid) {
		return memberDAO.getMemberIdDuplicateCheck(mid);
	}
	
//회원가입시 닉네임 중복체크
	@Override
	public MemberVO getMemberNickNameDuplicateCheck(String nickName) {
		return memberDAO.getMemberNickNameDuplicateCheck(nickName);
	}
	
	//회원가입 처리
	@Override
	public int setMemberJoinOk(MemberVO vo) {
		return memberDAO.setMemberJoinOk(vo);
	}

	//로그인용 비밀번호 가져오기
	@Override
	public MemberVO getMemberLoginIdCheck(String mid) {
		return memberDAO.getMemberLoginIdCheck(mid);
	}

	//로그인시 적용하는 정보들(방문횟수)
	@Override
	public void setMemberLoginInfoUpdate(String mid, int todayCnt) {
		memberDAO.setMemberLoginInfoUpdate(mid, todayCnt);
	}

	//멤버정보수정
	@Override
	public int setMemberInfoUpdateOk(MemberVO vo) {
		return memberDAO.setMemberInfoUpdateOk(vo);
	}

	//멤버 부분 아이디 찾기
	@Override
	public MemberVO getMemberPartId(String email, String tel) {
		return memberDAO.getMemberPartId(email, tel);
	}

	//이메일로 전체 아이디 찾기
	@Override
	public MemberVO getMemberWholeMidByEmail(String email) {
		return memberDAO.getMemberWholeMidByEmail(email);
	}

	//멤버 임시비밀번호을 위한 확인처리
	@Override
	public MemberVO getMemberCheckForPwdTempChange(String mid, String email, String tel) {
		return memberDAO.getMemberCheckForPwdTempChange(mid, email, tel);
	}

	//임시비밀번호 입력처리
	@Override
	public void setMemberTempPwd(String mid, String tempPwd) {
		memberDAO.setMemberTempPwd(mid, tempPwd);
	}

	//비밀번호 변경처리
	@Override
	public int setMemberPwdChange(String mid, String pwdChanged) {
		return memberDAO.setMemberPwdChange(mid, pwdChanged);
	}

	//회원 존재 확인-아이디 비밀번호(비번)
	@Override
	public MemberVO getMemberCheck(String mid, String pwdChanged) {
		return memberDAO.getMemberCheck(mid, pwdChanged);
	}

	//멤버테이블 회원 탈퇴 처리
	@Override
	public int setMemberWithdrawOk(String mid) {
		return memberDAO.setMemberWithdrawOk(mid);
	}

	//탈퇴회원 테이블에 입력
	@Override
	public void setDeleteMemberInputOk(String mid, String type, String reason, String comment) {
		memberDAO.setDeleteMemberInputOk(mid, type, reason, comment);
	}

	@Override
	public MemberVO getMemberNickNameEmailCheck(String nickName, String email) {
		return memberDAO.getMemberNickNameEmailCheck(nickName, email);
	}

	//아이디 존재여부 아이디(탈퇴제외) 체크- 카카오
	@Override
	public MemberVO getMemberIdCheck(String mid) {
		return memberDAO.getMemberIdCheck(mid);
	}

	//카카오 신규회원 회원가입처리
	@Override
	public void setKakaoMemberInput(String mid, String nickName, String email, String pwd) {
		memberDAO.setKakaoMemberInput(mid, nickName, email, pwd);
	}

}
