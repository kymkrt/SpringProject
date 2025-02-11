package com.spring.javaGroupS2.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.spring.javaGroupS2.common.CommonClass;
import com.spring.javaGroupS2.pagenation.PageProcess;
import com.spring.javaGroupS2.pagenation.PageVO;
import com.spring.javaGroupS2.service.AdminService;
import com.spring.javaGroupS2.service.MemberService;
import com.spring.javaGroupS2.vo.MemberVO;
import com.spring.javaGroupS2.vo.OrderItemsVO;

@Controller
@RequestMapping("/member")
public class MemberController {
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	CommonClass commonClass;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	JavaMailSender mailSender; //인터페이스로 가져오기
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder; //엔코더, 매치스 사용
	
	//멤버 로그인 창 이동
	@RequestMapping(value = "/memberLogin", method = RequestMethod.GET)
	public String memberLoginGet(HttpServletRequest request) {
		
	//로그인창의 아이디 체크 유무에 대한처리(쿠키)
		Cookie[] cookies = request.getCookies();
		
		if(cookies != null) {
			for(int i=0;i<cookies.length; i++) {
				if(cookies[i].getName().equals("cMid")) { //앞에 c 붙이는거 우리 규칙임 실무는 다를수 있다
					request.setAttribute("mid", cookies[i].getValue());
					break;
				}
			}
		}
		
		return "/member/memberLogin";
	}
	
	//멤버 로그인 처리
	@RequestMapping(value = "/memberLoginOk", method = RequestMethod.POST)
	public String memberLoginOkPost(HttpServletRequest request, HttpServletResponse response, HttpSession session,
			@RequestParam(name = "mid", defaultValue = "hkd1234", required = false) String mid,
			@RequestParam(name = "pwd", defaultValue = "1234", required = false) String pwd,
			@RequestParam(name = "idSave", defaultValue = "", required = false) String idSave
			) {
		MemberVO vo = memberService.getMemberLoginIdCheck(mid);
		
		if(vo == null) {
			return "redirect:/message/memberExistNo";
		}
		else if(vo.getPwd()==null || vo.getPwd().equals("")) {
			return "redirect:/message/memberLoginNo";
		}else if(!passwordEncoder.matches(pwd, vo.getPwd())) {
			return "redirect:/message/memberLoginNo";
		}else if(vo.getUserDel().equals("OK")) {
			return "redirect:/message/memberWithdraw";
		}
		
		String strLevel = "";
		if(vo.getLevel() == 0) strLevel = "관리자";
		else if(vo.getLevel() == 3) strLevel = "우수회원";
		else if(vo.getLevel() == 2) strLevel = "정회원";
		else if(vo.getLevel() == 1) strLevel = "준회원";
		
		session.setAttribute("sImge", vo.getPhoto());
		session.setAttribute("sMid", mid);
		session.setAttribute("sNickName", vo.getNickName());
		session.setAttribute("sLevel", vo.getLevel());
		session.setAttribute("strLevel", strLevel);
		//로그인 타입 저장
		session.setAttribute("sLogin", "일반로그인");
		
		//로그인창의 아이디 체크 유무에 대한처리(쿠키 저장/삭제)
		if(idSave.equals("on")) {
			Cookie cookieMid = new Cookie("cMid", mid);
			//쿠키 팁 쿠키의 저장 위치를 루트부터 주겠다
			cookieMid.setPath("/");
			
			cookieMid.setMaxAge(60*60*24*7);
			response.addCookie(cookieMid);
		}
		else {
			Cookie[] cookies = request.getCookies();
			//리퀘스트를 이미 사용했기 때문에 굳이 model안써도 됨
			if(cookies != null) {
				for(int i=0;i<cookies.length; i++) {
					if(cookies[i].getName().equals("cMid")) { //앞에 c 붙이는거 우리 규칙임 실무는 다를수 있다
						cookies[i].setPath("/");
						cookies[i].setMaxAge(0);
						response.addCookie(cookies[i]);
						break;
					}
				}
			}
		}
		
		//오늘 방문 횟수처리
		Date nowDate = new Date(); //util로 올려야함 sql로 올리면 안된다
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String strDate = sdf.format(nowDate);
		
		int todayCnt = 0;
		if(vo.getLastDate().substring(0, 10).equals(strDate)) {
			todayCnt = vo.getTodayCnt()+1;
		}
		else todayCnt = 1;
		
		memberService.setMemberLoginInfoUpdate(mid, todayCnt);
		
		return "redirect:/message/memberLoginOk?mid="+mid;
	}
	
//카카오 로그인 인증 처리
	@RequestMapping(value = "/kakaoLogin", method = RequestMethod.GET)
	//리퀘스트는 세션 때문에 리스폰스는 쿠키 때문에 사용 근데 우리는 세션에 저장할거라 세션만 필요 
	public String kakaoLoginGet(HttpSession session,HttpServletRequest request,
			String nickName, String email, String accessToken
			) throws MessagingException {
		
		session.setAttribute("sAccessToken", accessToken); //이거 굳이 필요없음 
		session.setAttribute("sLogin", "kakao");//학습 차원에서 넣음 
		
		//카카오 회원이 우리 회원인지 조사?
		MemberVO vo = memberService.getMemberNickNameEmailCheck(nickName, email);
		
		//카카오회원이 우리 회원이 아니라면 자동으로 우리 회원에 가입처리한다
		//필수 입력: 아아디, 닉네임, 이메일, 성명(닉네임으로 대체), 비밀번호 (임시비밀번호 발급 처리)	, 레벨 준회원(1)	
		String newMember = "NO"; //신규회원은 OK 기존회원은 NO
		if(vo == null) {
			//신규회원인지에 대한 체크하기
			String mid = email.substring(0, email.indexOf("@"));
			MemberVO vo2 = memberService.getMemberIdCheck(mid);
			
			if(vo2 != null) {
				//같은 아이디가 있으니 새로 가입하던지 아이디 바꾸던지 고르게 해야한다
				return "recirect:/message/memberIdSameCheck";
			}
			
			//임시 비밀번호 발급 처리(메일)
			String pwd = UUID.randomUUID().toString().substring(0, 8);
			session.setAttribute("sImsiPwd", pwd);

			String imsiPwd = passwordEncoder.encode(pwd);//임의 비번
			//스프링 시큐리티 쓰면 그냥 인코더 쓰면 끝이다 
			memberService.setKakaoMemberInput(mid, nickName, email, imsiPwd);//강제 가입이라 메시지 필요없음
			
			//새로 발급받은 임시비밀번호를 이메일로 전송 이메일 처리 자주나오니까 자바그룹프로바이더에 이메일 넣기
			commonClass.mailSend(email, "임시비밀번호발급_카카오", "임시비밀번호발급_카카오", pwd);
			
			//세션에 넣어야 하는것들때문에 다시 가져옴?
			vo = memberService.getMemberIdCheck(mid);
			
			//처음 와서 강제 가입했으니까 회원정보 제대로 된거로 바꾸려는것
			session.setAttribute("sLoginNew", "OK");
			newMember = "OK";
			
		}
		session.setAttribute("sLoginNew", "NO");
		
		//로그인 인증 완료시 세션처리
		String strLevel = "";
		if(vo.getLevel() == 0) strLevel = "관리자";
		else if(vo.getLevel() == 1) strLevel = "우수회원";
		else if(vo.getLevel() == 2) strLevel = "정회원";
		else if(vo.getLevel() == 3) strLevel = "준회원";
		
		session.setAttribute("sMid", vo.getMid());
		session.setAttribute("sNickName", vo.getNickName());
		session.setAttribute("sLevel", vo.getLevel());
		session.setAttribute("strLevel", strLevel);
		
		//DB처리 내용 작업하기(방문포인트(?), 총방문횟수, 오늘방문횟수, 마지막 방문일자)
		//오늘 방문 횟수처리
		Date nowDate = new Date(); //util로 올려야함 sql로 올리면 안된다
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String strDate = sdf.format(nowDate);
		
		int todayCnt = 0;
		if(vo.getLastDate().substring(0, 10).equals(strDate)) {
			todayCnt = vo.getTodayCnt()+1;
		}
		else todayCnt = 1;
		
		memberService.setMemberLoginInfoUpdate(vo.getMid(), todayCnt);
		System.out.println("new member : "+newMember);
		//신규회원 아닐때 - 일반 로그인하고 똑같이 본다 
		if(newMember.equals("NO")) return "redirect:/message/memberLoginOk?mid="+vo.getMid(); //model로 넘겨도됨 get방식으로 가져온다?
		else {
			//비회원 처리
			return "redirect:/message/memberLoginNewOk?mid="+vo.getMid(); //model로 넘겨도됨 get방식으로 가져온다?
		}
		
	}
	
//멤버 메인 페이지 이동
	@RequestMapping(value = "/memberMain", method = RequestMethod.GET)
	public String memberMainGet(Model model ,HttpSession session,
			@RequestParam(name="category", defaultValue = "", required = false) String category,
			@RequestParam(name="section", defaultValue = "", required = false) String section
			) {
		if(session.getAttribute("sMid")==null) {
			return "redirect:/message/memberLogout";
		}
		String mid = session.getAttribute("sMid").toString();
		
		MemberVO vo = memberService.getMemberLoginIdCheck(mid);
		model.addAttribute("category", category);
		model.addAttribute("section", section);
		model.addAttribute("vo", vo);
		
		return "/member/memberMain";
	}
	
	//멤버 회원가입 창 이동
	@RequestMapping(value = "/memberJoin", method = RequestMethod.GET)
	public String memberJoinGet() {
		return "/member/memberJoin";
	}
	
	//회원 아이디 중복 체크 AJAX
	@ResponseBody
	@RequestMapping(value = "/memberIdDuplicateCheck", method = RequestMethod.POST)
	public String memberIdDuplicateCheckPost(String mid) {
		MemberVO vo = memberService.getMemberIdDuplicateCheck(mid);
		String str = "0";
		if(vo != null) {
			str = "1";
		}
		return str;
	}
	
//회원 닉네임 중복 체크 AJAX
	@ResponseBody
	@RequestMapping(value = "/memberNickNameDuplicateCheck", method = RequestMethod.POST)
	public String memberNicknameCheckPost(String nickName) {
		MemberVO vo = memberService.getMemberNickNameDuplicateCheck(nickName);
		String str = "0";
		if(vo != null) {
			str = "1";
		}
		return str;
	}
	
//회원가입
	@RequestMapping(value = "/MemberJoinOk", method = RequestMethod.POST)
	public String MemberJoinOkPost(MemberVO vo, @RequestParam("profileImage") MultipartFile profileImage,@RequestParam("imageCheck") String imageCheck) throws IOException {
		
		if(vo.getGender().equals("1") || vo.getGender().equals("3")) {
			vo.setGender("남자");
		}else if(vo.getGender().equals("2") || vo.getGender().equals("4")) {
			vo.setGender("여자");
		}
		
		//스프링 시큐리티 비빌번호 암호화
		vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		
		if(profileImage==null || imageCheck==null|| imageCheck.equals("")) {
			vo.setPhoto("noimages.jpg");
		}
		else {
			String sFileName = vo.getMid()+"_"+profileImage.getOriginalFilename();
			vo.setPhoto(sFileName);
		}
		vo.setContent(vo.getContent()
				.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;"));
		int res = memberService.setMemberJoinOk(vo);
		
		if(res != 0) {
			String path = "/resources/data/member/";
			String sFileName = vo.getPhoto();
			commonClass.writeFile(profileImage, sFileName, path,"memberJoin");
			return "redirect:/message/memberJoinOk";
		}
		else {
			return "redirect:/message/memberJoinNo";
		}
	}
	
	//멤버 아이디 찾기 폼 이동
	@RequestMapping(value = "/memberIdSearch", method = RequestMethod.GET)
	public String memberIdSearchGet() {
		return "/member/memberIdSearch";
	}
	
	//멤버 부분 아이디 찾기 ajax
	@ResponseBody
	@RequestMapping(value = "/memberPartIdSearch", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String memberPartIdSearchPost(String email, String tel) {
		
		MemberVO vo = memberService.getMemberPartId(email, tel);
		String newMid = null;
		String mid = null;
		// Strings.isNullOrEmpty(vo.getMid())
		if(vo == null) {
			newMid = "없음";
		}
		else {
			mid = vo.getMid();
			char[] temp = mid.toCharArray();
			for(int i=0;i<mid.length();i++) {
				if(i%2 ==0) {
					temp[i] = '*';	
				}
			}
			newMid = new String(temp);
		}
		return newMid;
	}
	
//멤버 전체 아이디 찾기를 위한 이메일 키 전송
	@ResponseBody
	@RequestMapping(value = "/fullMidSearch", method = RequestMethod.POST)
	public String fullMidSearchPost(String email) throws MessagingException {
		String res = "0";
		
		MemberVO vo = memberService.getMemberWholeMidByEmail(email);
		if(vo == null) {
			res = "0";
		}
		else {
			commonClass.mailSend(email, "인증번호", "인증번호", "");//메일주소, 메일제목, 메일내용
			res = "1";
		}
		
		return res;
	}
	
//멤버 전체 아이디 찾기 이메일 키 인증 및 확인
	@ResponseBody
	@RequestMapping(value = "/emailKeyCheck", method = RequestMethod.POST)
	public String emailKeyCheckPost(String code, String email, HttpSession session) throws MessagingException {
		String res = "";
		if(session.getAttribute("sEmailkey")==null) {
			res = "다름";
		}
		else {
			String temp = session.getAttribute("sEmailkey").toString();
			if(code.equals(temp)) {
				MemberVO vo = memberService.getMemberWholeMidByEmail(email);
				res = vo.getMid();
				session.removeAttribute("sEmailKey");
			}
			else {
				res = "다름";
			}
		}
		
		return res;
	}
	
	//멤버 비밀번호 찾기 폼 이동
	@RequestMapping(value = "/memberPwdSearch", method = RequestMethod.GET)
	public String memberPwdSearchGet() {
		return "/member/memberPwdSearch";
	}
	
	//멤버 임시비밀번호 발급
	@ResponseBody
	@RequestMapping(value = "/pwdTempChange", method = RequestMethod.POST)
	public String pwdTempChangePost(String mid, String email, String tel, HttpSession session) throws MessagingException {
		String res = "";
		
		MemberVO vo = memberService.getMemberCheckForPwdTempChange(mid, email, tel);
		if(vo == null) {
			res = "0";
		}else {
			res = "1";
			commonClass.mailSend(email, "임시비밀번호발급", "임시비밀번호발급", "");
			String sTempPwd = session.getAttribute("sTempPwd").toString();
			
			String tempPwd = passwordEncoder.encode(sTempPwd);
			
			memberService.setMemberTempPwd(mid, tempPwd);
			session.removeAttribute("sTempPwd");
		}
		
		return res;
	}
	
	//비밀번호 체크 페이지 이동
	@RequestMapping(value = "/memberPwdCheck", method = RequestMethod.GET)
	public String memberPwdCheckGet(Model model,String flag,
			@RequestParam(name="category", defaultValue = "member", required = false) String category,
			@RequestParam(name="section", defaultValue = "", required = false) String section
			) {
		model.addAttribute("category", category);
		model.addAttribute("section", flag);
		model.addAttribute("flag",flag);
		return "/member/memberPwdCheck";
	}
	
	//회원정보수정 폼 페이지 이동
	@RequestMapping(value = "/memberInfoUpdate", method = RequestMethod.POST)
	public String memberInfoUpdatePost(Model model,HttpSession session,String pwd,
			@RequestParam(name="category", defaultValue = "member", required = false) String category,
			@RequestParam(name="section", defaultValue = "update", required = false) String section
			) {
		if(session.getAttribute("sMid")==null) {
			return "redirect:/message/memberLogout";
		}
		String mid = session.getAttribute("sMid").toString();
		
		MemberVO vo = memberService.getMemberLoginIdCheck(mid);

		if(vo == null) {
			return "redirect:/message/memberPwdCheckNo?flag=update";
		}
		else if(vo == null || !passwordEncoder.matches(pwd, vo.getPwd())) {
      return "redirect:/message/memberPwdCheckNo?flag=update";
    }
		
		if(vo.getTel() != null && vo.getAddress() != null) {
			String[] tels = vo.getTel().split("-");
			String[] addresss = vo.getAddress().split("/");
			
			vo.setTel1(tels[0]);
			vo.setTel2(tels[1]);
			vo.setTel3(tels[2]);

			vo.setPostcode(addresss[0]);
			vo.setAddress(addresss[1]);
			vo.setDetailAddress(addresss[2]);
			vo.setExtraAddress(addresss[3]);
		}
		
		String[] emails = vo.getEmail().split("@");
		vo.setEmail1(emails[0]);
		vo.setEmail2(emails[1]);
		
		model.addAttribute("category", category);
		model.addAttribute("section", section);
		model.addAttribute("vo", vo);
		
		return "/member/memberInfoUpdate";
	}
	
//회원정보수정 처리 업데이트
	@RequestMapping(value = "/memberInfoUpdateOk", method = RequestMethod.POST)
	public String memberInfoUpdateOkPost(Model model, HttpSession session, MemberVO vo,@RequestParam("profileImage") MultipartFile profileImage,@RequestParam("imageCheck")  String imageCheck){
		//닉네임 체크
		if(memberService.getMemberNickNameDuplicateCheck(vo.getNickName()) != null && !vo.getNickName().equals(session.getAttribute("sNickName"))) return "redirect:/message/nickNameCheckNo";
		String mid = session.getAttribute("sMid").toString();
		
		if(mid ==null || mid.equals("")) {
			return "redirec:/message/loginNo";
		}
		
		MemberVO vo2 = memberService.getMemberIdCheck(mid);
		
		//사진 확인
		if(imageCheck.equals("")) {//profileImage == null || 
			vo.setPhoto(vo2.getPhoto());
		}else {
			String sFileName = vo2.getRemainMid()+"_"+profileImage.getOriginalFilename();
			vo.setPhoto(sFileName);
		}
		vo.setContent(vo.getContent()
				.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;"));
		//회원 정보 수정
		int res = memberService.setMemberInfoUpdateOk(vo);
		
		if(res != 0) {
			session.setAttribute("sNickName", vo.getNickName());
			
			String path = "/resources/data/member/";
			if(imageCheck.equals("파일있음")) {
				//회원 사진 삭제후 저장
				try {
					commonClass.deleteFile(profileImage, vo2.getPhoto(), path);
					commonClass.writeFile(profileImage, vo.getPhoto(), path, "memberInfoUpdate");
				} catch (IOException e) {
					System.out.println("memberInfoUpdateOk에러 회원멤버정보수정 :");
					e.printStackTrace();
				}
			}
			
			return "redirect:/message/memberUpdateOk";
		}
		else return "redirect:/message/memberUpdateNo";
	}
	
	
	//비밀번호 변경/수정 페이지 이동
	@RequestMapping(value = "/memberPwdUpdate", method = RequestMethod.POST)
	public String memberPwdUpdatePost(Model model,HttpSession session,String pwd,
			@RequestParam(name="category", defaultValue = "member", required = false) String category,
			@RequestParam(name="section", defaultValue = "pwd", required = false) String section
			) {
		if(session.getAttribute("sMid")==null) {
			return "redirect:/message/memberLogout";
		}
		String mid = session.getAttribute("sMid").toString();
		
		MemberVO vo = memberService.getMemberLoginIdCheck(mid);
		
		if(vo == null) {
			return "redirect:/message/memberPwdCheckNo?flag=pwd";
		}
		else if(vo.getPwd()==null || vo.getPwd().equals("")) {
			return "redirect:/message/memberPwdCheckNo?flag=pwd";
		}else if(!passwordEncoder.matches(pwd, vo.getPwd())) {
			return "redirect:/message/memberPwdCheckNo?flag=pwd";
		}
		model.addAttribute("category", category);
		model.addAttribute("section", section);
		return "/member/memberPwdUpdate";
	}
	
//회원 비밀번호 변경/수정 처리
	@ResponseBody
	@RequestMapping(value = "/memberPwdChange", method = RequestMethod.POST)
	public String memberPwdChangePost(HttpSession session, String pwd) {
		if(session.getAttribute("sMid")==null) {
			return "redirect:/message/memberLogout";
		}
		String mid = session.getAttribute("sMid").toString();
		
		String pwdChanged = passwordEncoder.encode(pwd);
		
		int res = memberService.setMemberPwdChange(mid, pwdChanged);
		
		return res+"";
	}
	
	//회원탈퇴 페이지 이동
	@RequestMapping(value = "/memberWithdraw", method = RequestMethod.POST)
	public String memberWithdrawPost(Model model,HttpSession session,String pwd,
			@RequestParam(name="category", defaultValue = "member", required = false) String category,
			@RequestParam(name="section", defaultValue = "withdraw", required = false) String section
			) {
		if(session.getAttribute("sMid")==null) {
			return "redirect:/message/memberLogout";
		}
		String mid = session.getAttribute("sMid").toString();
		
		MemberVO vo = memberService.getMemberLoginIdCheck(mid);
		
		if(vo == null) {
			return "redirect:/message/memberPwdCheckNo?flag=withdraw";
		}
		else if(vo.getPwd()==null || vo.getPwd().equals("")) {
			return "redirect:/message/memberPwdCheckNo?flag=withdraw";
		}else if(!passwordEncoder.matches(pwd, vo.getPwd())) {
			return "redirect:/message/memberPwdCheckNo?flag=withdraw";
		}
		model.addAttribute("category", category);
		model.addAttribute("section", section);
		return "/member/memberWithdraw";
	}
	
	//회원 탈퇴 처리
	@ResponseBody
	@RequestMapping(value = "/memberWithdrawOk", method = RequestMethod.POST)
	public String memberWithdrawPost(HttpSession session, String mid, String pwd, String type, String reason) {
		String res = "0";
		
		MemberVO vo = memberService.getMemberLoginIdCheck(mid);
		reason = reason
				.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
		if(vo == null || !passwordEncoder.matches(pwd, vo.getPwd())) {
			res = "0";
		}else {
			int res2 = memberService.setMemberWithdrawOk(mid);
			if (res2 != 0) {
				memberService.setDeleteMemberInputOk(mid, type, reason, "");
				res="1";
			}
			else {
				res = "0";
			}
		}
		return res+"";
	}
	
//로그아웃시 처리
	@RequestMapping(value = "/memberLogout", method = RequestMethod.GET)
	public String memberLogoutGet(HttpSession session) {
		session.invalidate();
		return "redirect:/message/memberLogout";
	}
	
//멤버 최근 주문 목록
	@RequestMapping(value = "/memberOrderList", method = RequestMethod.GET)
	public String memberOrderListGet(Model model,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "15", required = false) int pageSize,
			@RequestParam(name="boardType", defaultValue = "ordersDataAdmin", required = false) String boardType, //notice
			@RequestParam(name="category", defaultValue = "all", required = false) String category,
			@RequestParam(name="option", defaultValue = "all", required = false) String option,
			@RequestParam(name="subOption", defaultValue = "", required = false) String subOption,
			@RequestParam(name="part", defaultValue = "", required = false) String part, //검색용 분류
			@RequestParam(name="searchString", defaultValue = "", required = false) String searchString, //검색용단어
			@RequestParam(name="viewCheckOption", defaultValue = "", required = false) String viewCheckOption//분류별 보기 2번째 체크 단어
			) {
		String section = "최근주문리스트";//product
		
		category = "orders";
		boardType = "ordersDataAdmin";
		
		PageVO pageVO = pageProcess.totBoardRecCnt(pag, pageSize, boardType,category, option,subOption,part, searchString,viewCheckOption);//뒷부분 비어있는건 확장성을 위한 보조필드
		
		List<OrderItemsVO> vos = adminService.getAdminOrderList(option,subOption,part, searchString,pageVO.getStartIndexNo(), pageSize);
		
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("section",section);
		model.addAttribute("category","orders");
		
		model.addAttribute("vos", vos);
		return "member/memberOrderList";
	}
	
	//주문 데이터 옵션 리스트 가져오기
	@ResponseBody
	@RequestMapping(value = "/memberOrderOptionDataList", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String memberOrderOptionDataListPost(String optionData) {
		if(!optionData.equalsIgnoreCase("productName")&&!optionData.equalsIgnoreCase("customerMid")) {
			return "redirect://message/wrongAccess";
		}
		
		List<String> optionDataList = adminService.getAdminOrderOptionDataList(optionData);
		
		Gson gson = new Gson();
		
		String res =  gson.toJson(optionDataList);
		
		return res;
	}
	
//멤버 유저 주문 데이터 전체 리스트 파이차트용 
	@ResponseBody
	@RequestMapping(value = "/memberOrderDataChartCountList", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String memberOrderDataChartCountListPost(String chartSelectValue, String chartType, String listType) {
		//chartSelectValue = 선택타입 차트타입=파이 리스트타입=all
		HashMap<String, Integer> dataMap = new HashMap<String, Integer>();
		List<String> LabelList = new ArrayList<String>();
    HashMap<String, String> colorMap = new HashMap<String, String>();
    List<String> optionList = new ArrayList<String>();
    
		if(chartType.equalsIgnoreCase("pie")) {
			switch (chartSelectValue) {
				case "productName":
						optionList = adminService.getAdminOrderDataOptionSearchOptionList(chartSelectValue, "all");
						for (String option : optionList) {
							LabelList.add(option);
							dataMap.put(option, adminService.getAdminOrderDataCountListChart(chartSelectValue,option ,listType,chartType));
							
							Random random = new Random();

							int r = random.nextInt(256); // 0부터 255 사이의 난수 생성
							int g = random.nextInt(256); // 0부터 255 사이의 난수 생성
							int b = random.nextInt(256); // 0부터 255 사이의 난수 생성

							String rgbColor = "rgb("+r+", "+g+", "+b+")";
							colorMap.put(option,rgbColor);
							
						}
					break;
				case "customerMid":
					optionList = adminService.getAdminOrderDataOptionSearchOptionList(chartSelectValue, "all");
					for(String option : optionList) {
						LabelList.add(option);
						dataMap.put(option, adminService.getAdminOrderDataCountListChart(chartSelectValue, option ,listType,chartType));
				
						Random random = new Random();

						int r = random.nextInt(256); // 0부터 255 사이의 난수 생성
						int g = random.nextInt(256); // 0부터 255 사이의 난수 생성
						int b = random.nextInt(256); // 0부터 255 사이의 난수 생성

						String rgbColor = "rgb("+r+", "+g+", "+b+")";
						colorMap.put(option,rgbColor);
					}
					break;
				default:
					System.out.println("없음");
					break;
			}
		}else {} //if 처리 가능	}
		HashMap<String, Object> totalData = new HashMap<String, Object>();
		totalData.put("data", dataMap);
		totalData.put("Label", LabelList);
		totalData.put("colorMap", colorMap);
		
		Gson gson = new Gson();
		String totalJson = gson.toJson(totalData);
		
		return totalJson;
	}
	
}
