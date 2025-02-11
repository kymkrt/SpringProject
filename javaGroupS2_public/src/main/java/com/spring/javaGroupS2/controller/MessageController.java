package com.spring.javaGroupS2.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MessageController {
	//메세지 컨트롤러 집약
	@RequestMapping(value = "/message/{msgFlag}", method = RequestMethod.GET, produces="application/text; charset=utf8")
	public String getMessage(Model model, 
		@PathVariable String msgFlag,
		//더받고 싶은게 있으면 여기 추가하면 된다
		//값이 안넘어올수도 있기 때문에 이렇게 처리
		@RequestParam(name="mid", defaultValue = "", required = false) String mid,
		@RequestParam(name="idx", defaultValue = "0", required = false) int idx, //전부 문자로 넘어오기 때문에 ""를 써야함
		@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
		@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize,
		@RequestParam(name="mSw", defaultValue = "1", required = false) int mSw,
		@RequestParam(name="flag", defaultValue = "", required = false) String flag
		) {
		
		if(msgFlag.equals("memberLoginNo")) {
			model.addAttribute("message", "로그인 실패");
			model.addAttribute("url", "member/memberLogin");
		}
		else if(msgFlag.equals("memberExistNo")) {
			model.addAttribute("message", "아이디가 없습니다");
			model.addAttribute("url", "/member/memberLogin");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberWithdraw")) {
			model.addAttribute("message", "탈퇴회원입니다 6개월간 같은 아이디 사용불가입니다");
			model.addAttribute("url", "/member/memberLogin");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("loginNo")) {
			model.addAttribute("message", "로그인 후 사용하세요");
			model.addAttribute("url", "/member/memberLogin");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberPwdCheckNo")) {
			model.addAttribute("message", "비밀번호를 확인해주세요");
			model.addAttribute("url", "/member/memberPwdCheck?flag="+flag);//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberLoginOk")) {
			if(mid.equalsIgnoreCase("admin")) {
				model.addAttribute("message", mid+" 관리자님 로그인 되셨습니다");
				model.addAttribute("url", "/admin/adminMain");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
			}else {
				model.addAttribute("message", mid+" 회원님 로그인 되셨습니다");
				model.addAttribute("url", "/member/memberMain");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
			}
		}
		else if(msgFlag.equals("memberLoginNewOk")) {
			model.addAttribute("message", mid+" 회원님 로그인 되셨습니다\\n신규 비밀번호가 이메일로 전송되었습니다\\n 회원정보를 변경해주셔야만 결제가 가능합니다");
			model.addAttribute("url", "/member/memberMain");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberLogout")) {
			model.addAttribute("message", "로그아웃 되셨습니다");
			model.addAttribute("url", "/member/memberLogin");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberLevelNo")) {
			model.addAttribute("message", "회원등급을 확인하세요");
			model.addAttribute("url", "/main/mainPage");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("userInputOk")) {
			model.addAttribute("message", "회원에 가입 되셨습니다");
			model.addAttribute("url", "/user/userMain");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("dbtestDeleteNo")) {
			model.addAttribute("message", "회원삭제 실패");
			model.addAttribute("url", "/user/userList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("userUpdateNo")) {
			model.addAttribute("message", "회원 정보 수정 실패");
			model.addAttribute("url", "/user/userUpate?idx="+idx);//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminLevelNo")) {
			model.addAttribute("message", "관리자만 접속 가능합니다");
			model.addAttribute("url", "/main/mainPage");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminProductDataInsertOk")) {
			model.addAttribute("message", "상품이 등록되었습니다\\n판매상태를 확인해주세요");
			model.addAttribute("url", "/admin/adminProductDataList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminProductDataInsertNo")) {
			model.addAttribute("message", "상품 등록 실패");
			model.addAttribute("url", "/admin/adminProductDataList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminProductDataUpdateOk")) {
			model.addAttribute("message", "상품정보가 수정되었습니다\\n확인해주세요");
			model.addAttribute("url", "/admin/adminProductDataList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminProductDataUpdateNo")) {
			model.addAttribute("message", "상품 정보 수정 실패");
			model.addAttribute("url", "/admin/adminProductDataList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminProductDataImgUpdateNo")) {
			model.addAttribute("message", "상품 정보 이미지 수정 실패");
			model.addAttribute("url", "/admin/adminProductDataList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminProductDataDeleteOk")) {
			model.addAttribute("message", "상품정보가 삭제되었습니다\\n확인해주세요");
			model.addAttribute("url", "/admin/adminProductDataList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminProductDataDeleteNo")) {
			model.addAttribute("message", "상품 정보 삭제 실패");
			model.addAttribute("url", "/admin/adminProductDataList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminProductDataImageDeleteNo")) {
			model.addAttribute("message", "상품 정보 이미지 삭제 실패");
			model.addAttribute("url", "/admin/adminProductDataList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberJoinOk")) {
			model.addAttribute("message", "회원가입 되셨습니다");
			model.addAttribute("url", "/member/memberLogin");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberJoinNo")) {
			model.addAttribute("message", "회원가입 실패");
			model.addAttribute("url", "/member/memberJoin");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberPwdChangeOk")) {
			model.addAttribute("message", "비밀번호 변경 성공");
			model.addAttribute("url", "/member/memberMain");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberPwdChangeNo")) {
			model.addAttribute("message", "비밀번호 변경 실패");
			model.addAttribute("url", "/member/memberPwdCheck/p");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberUpdate")) {
			model.addAttribute("message", "회원정보 수정창으로 이동합니다");
			model.addAttribute("url", "/member/memberInfoUpdate");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("nickNameCheckNo")) {
			model.addAttribute("message", "닉네임이 중복되었습니다 \\n 확인하세요");
			model.addAttribute("url", "/member/memberPwdCheck?flag=update");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberUpdateOk")) {
			model.addAttribute("message", "정보가 수정되었습니다");
			model.addAttribute("url", "/member/memberMain");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberUpdateNo")) {
			model.addAttribute("message", "정보수정실패");
			model.addAttribute("url", "/member/memberUpdate");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("boardInputOk")) {
			model.addAttribute("message", "게시판에 글이 등록되었습니다");
			model.addAttribute("url", "/board/boardList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminNoticBoardInputOk")) {
			model.addAttribute("message", "공지 게시판에 글이 등록되었습니다");
			model.addAttribute("url", "/admin/adminNoticeBoardList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("boardInputNo")) {
			model.addAttribute("message", "게시판 글 등록 실패");
			model.addAttribute("url", "/board/boardList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminNoticBoardInputNo")) {
			model.addAttribute("message", "공지 게시판 글 등록 실패");
			model.addAttribute("url", "/admin/adminNoticeBoardList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminNoticBoardContentDeleteOk")) {
			model.addAttribute("message", "공지 게시판에 글이 삭제되었습니다");
			model.addAttribute("url", "/admin/adminNoticeBoardList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminNoticBoardContentDeleteNo")) {
			model.addAttribute("message", "공지 게시판 글 삭제 실패");
			model.addAttribute("url", "/admin/adminNoticeBoardList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminNoticBoardFileDeleteNo")) {
			model.addAttribute("message", "공지게시판 파일 삭제 실패");
			model.addAttribute("url", "/admin/adminNoticeBoardList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("boardDeleteOk")) {
			model.addAttribute("message", "게시판에 글이 삭제되었습니다");
			model.addAttribute("url", "/board/boardList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("boardDeleteNo")) {
			model.addAttribute("message", "게시판 글 삭제 실패");
			model.addAttribute("url", "/board/boardContent?idx="+idx+"&pag="+pag+"&pageSize="+pageSize);//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("boardUpdateOk")) {
			model.addAttribute("message", "게시판 글이 수정되었습니다");
			model.addAttribute("url", "/board/boardContent?idx="+idx+"&pag="+pag+"&pageSize="+pageSize);//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminNoticeBoardContentUpdateNo")) {
			model.addAttribute("message", "공지 게시판 글 수정 실패");
			model.addAttribute("url", "/admin/adminNoticeBoardContent?idx="+idx);//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminNoticeBoardContentUpdateOk")) {
			model.addAttribute("message", "공지게시판 글이 수정되었습니다");
			model.addAttribute("url", "/admin/adminNoticeBoardContent?idx="+idx);//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("boardUpdateNo")) {
			model.addAttribute("message", "게시판 글 수정 실패");
			model.addAttribute("url", "/board/boardUpdate?idx="+idx+"&pag="+pag+"&pageSize="+pageSize);//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminPlantDataDeleteOk")) {
			model.addAttribute("message", "식물데이터 삭제에 성공하였습니다");
			model.addAttribute("url", "/admin/adminPlantDataList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminPlantDataDeleteNo")) {
			model.addAttribute("message", "식물 데이터 실패");
			model.addAttribute("url", "/admin/adminPlantDataDetailInfo?idx="+idx);//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminPlantDataInsertOk")) {
			model.addAttribute("message", "식물데이터 업로드 성공");
			model.addAttribute("url", "/admin/adminPlantDataList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminPlantDataInsertNo")) {
			model.addAttribute("message", "식물데이터 업로드 실패");
			model.addAttribute("url", "/admin/adminPlantDataList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminPlantDataUpdateOk")) {
			model.addAttribute("message", "식물 데이터 정보수정 성공");
			model.addAttribute("url", "/admin/adminPlantDataDetailInfo?idx="+idx);//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminPlantDataUpdateNo")) {
			model.addAttribute("message", "식물데이터 정보수정 실패");
			model.addAttribute("url", "/admin/adminPlantDataDetailInfo?idx="+idx);//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("memberIdSameCheck")) {
			model.addAttribute("message", "같은 아이디로 가입한적이 있습니다 \\n 아이디확인후 다시 로그인해주세요");
			model.addAttribute("url", "/member/memberLogin");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("adminMemberInfoUpdateOk")) {
			model.addAttribute("message", mid+"회원의 정보 수정에 성공하였습니다(관리자)");
			model.addAttribute("url", "/admin/adminAllMemberList");
		}
		else if(msgFlag.equals("adminMemberInfoUpdateNo")) {
			model.addAttribute("message", mid+"회원의 정보 수정에 실패하였습니다(관리자)");
			model.addAttribute("url", "/admin/adminAllMemberList");
		}
		else if(msgFlag.equals("adminMemberInfoUpdateNo")) {
			model.addAttribute("message", mid+"회원의 정보 수정에 실패하였습니다(관리자)");
			model.addAttribute("url", "/admin/adminAllMemberList");
		}
		else if(msgFlag.equals("paymentResNo")) {
			model.addAttribute("message", "장바구니 물건 구매에 실패하였습니다");
			model.addAttribute("url", "/product/memberCartList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("paymentDataResNo")) {
			model.addAttribute("message", "결제 데이터 삽입에 실패");
			model.addAttribute("url", "/product/memberOrderList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("cartDataDeleteNo")) {
			model.addAttribute("message", "장바구니 데이터 삭제 실패");
			model.addAttribute("url", "/product/memberCartList");//앞에서 /가 들어온 상태이기 때문에 안써도 됨
		}
		else if(msgFlag.equals("wrongAccess")) {
			model.addAttribute("message", "잘못된 접근입니다");
			model.addAttribute("url", "/main/mainPage");
		}
	
		return "include/message";
	}
}
