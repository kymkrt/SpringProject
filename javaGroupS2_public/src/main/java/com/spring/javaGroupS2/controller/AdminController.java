package com.spring.javaGroupS2.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
import com.spring.javaGroupS2.vo.BoardFilesVO;
import com.spring.javaGroupS2.vo.BoardVO;
import com.spring.javaGroupS2.vo.ChartDataCheckVO;
import com.spring.javaGroupS2.vo.ChartVO;
import com.spring.javaGroupS2.vo.DeleteMemberVO;
import com.spring.javaGroupS2.vo.MemberVO;
import com.spring.javaGroupS2.vo.OrderItemsVO;
import com.spring.javaGroupS2.vo.PlantDataVO;
import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;

@Transactional
@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	CommonClass commonClass;
	
	@Autowired
	JavaMailSender mailSender; 
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder; 
	
	//관리자 페이지 첫화면 메인
	@RequestMapping(value = "/adminMain", method = RequestMethod.GET)
	public String adminMainGet(HttpServletRequest request, Model model) {
		DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate now = LocalDate.now();
		
		List<Map<String, String>> dataNewList = new ArrayList<>();
		List<Map<String, String>> dataWithdrawList = new ArrayList<>();
		List<Map<String, String>> dataPurchaseList = new ArrayList<>();
	 for (int i = 180; i >= 0; i--) {
			 String day = now.minusDays(i).format(DATE_FORMATTER);
       int newCnt = adminService.getAdminMainCalendarInfoCnt("new", day);
       if(newCnt !=0) {
      	 HashMap<String, String> dataNewMemberMap = new HashMap<String, String>();
      	 dataNewMemberMap.put("title", "신규회원 : "+newCnt);
      	 dataNewMemberMap.put("start", day);
      	 dataNewMemberMap.put("color", "blue");
      	 dataNewMemberMap.put("display", "list-item");
      	 dataNewList.add(dataNewMemberMap);
       }
      }
		 
		 for (int i = 180; i >= 0; i--) {
			 String day = now.minusDays(i).format(DATE_FORMATTER);
			 int withdrawCnt = adminService.getAdminMainCalendarInfoCnt("withdraw", day);
			 if(withdrawCnt !=0) {
				 HashMap<String, String> dataWithdrawMemberMap = new HashMap<String, String>();
				 dataWithdrawMemberMap.put("title", "탈퇴회원 : "+withdrawCnt);
				 dataWithdrawMemberMap.put("start", day);
				 dataWithdrawMemberMap.put("color", "red");
				 dataWithdrawMemberMap.put("display", "list-item");
				 dataWithdrawList.add(dataWithdrawMemberMap);
			 }
		 }
		
		 for (int i = 180; i >= 0; i--) {
			 String day = now.minusDays(i).format(DATE_FORMATTER);
			 int purchaseCnt = adminService.getAdminMainCalendarInfoOrderCnt("order", day);
			 if(purchaseCnt !=0) {
				 HashMap<String, String> dataPurchaseMap = new HashMap<String, String>();
				 dataPurchaseMap.put("title", "구매수 : "+purchaseCnt);
				 dataPurchaseMap.put("start", day);
				 dataPurchaseMap.put("color", "green");
				 dataPurchaseMap.put("display", "list-item");
				 dataPurchaseList.add(dataPurchaseMap);
			 }
		 }
		 
	  Gson gson = new Gson();
	  String dataNew = gson.toJson(dataNewList);
	  String dataWithdraw = gson.toJson(dataWithdrawList);
	  String dataPurchase = gson.toJson(dataPurchaseList);
		
		model.addAttribute("dataNew",dataNew);
		model.addAttribute("dataWithdraw",dataWithdraw);
		model.addAttribute("dataPurchase",dataPurchase);
		model.addAttribute("category","");
		model.addAttribute("section","");
		return "/admin/adminMain";
	}
	
	//관리자 페이지 대시보드 주문경향/추세
	@RequestMapping(value = "/adminDashBoard/orderTrends", method = RequestMethod.GET)
	public String memberLoginGet(HttpServletRequest request, Model model) {
		
		model.addAttribute("category","dashboard");
		model.addAttribute("section","orderTrends");
		return "/admin/adminOrderTrends";
	}
	
	//관리자 페이지 대시보드 유저경향
	@RequestMapping(value = "/adminDashBoard/userTrends", method = RequestMethod.GET)
	public String userTrendsGet(HttpServletRequest request, Model model, ChartVO chartVo
			) {
		
		model.addAttribute("category","dashboard");
		model.addAttribute("section","userTrends");
		return "/admin/adminUserTrends";
	}
	
	//회원 데이터 가져오기
	@ResponseBody
	@RequestMapping(value = "/adminDashBoard/userTrends/getNewData", method = RequestMethod.GET, produces="application/text; charset=utf8")
	public String Get(ChartDataCheckVO CheckVo) {
		DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    DateTimeFormatter MONTH_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM");
    DateTimeFormatter YEAR_FORMATTER = DateTimeFormatter.ofPattern("yyyy");
    
		LocalDate now = LocalDate.now();
    List<String> dateList = new ArrayList<>();
    List<String> weekFirstList = new ArrayList<>();
    List<String> weekLastList = new ArrayList<>();
    List<String> conditionList = new ArrayList<>();
    String timeCheck = CheckVo.getTime();
    String typeFlag = CheckVo.getTypeFlag();
		List<String> LabelList = new ArrayList<String>();
    HashMap<String, String> colorMap = new HashMap<String, String>();
		
		//시간처리
		switch (timeCheck) {
      case "day":
        for (int i = -7; i <= 0; i++) {
         dateList.add(now.plusDays(i).format(DATE_FORMATTER));
        }
        break;
      case "week":
        WeekFields weekFields = WeekFields.of(Locale.getDefault());
        for (int i = -6; i <= 0; i++) {
          LocalDate adjustedDate = now.plusWeeks(i);
          LocalDate startOfWeek = adjustedDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
          LocalDate endOfWeek = adjustedDate.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
          weekFirstList.add(startOfWeek.format(DATE_FORMATTER));
          weekLastList.add(endOfWeek.format(DATE_FORMATTER));
          dateList.add(startOfWeek.format(DATE_FORMATTER) + " ~ " + endOfWeek.format(DATE_FORMATTER));
        }
        break;
      case "month":
        for (int i = -6; i <= 0; i++) {
          dateList.add(now.plusMonths(i).format(MONTH_FORMATTER));
        }
        break;
      case "year":
        for (int i = -5; i <= 0; i++) {
          dateList.add(now.plusYears(i).format(YEAR_FORMATTER));
        }
        break;
		}
		
		HashMap<String, List<Integer>> dataMap = new HashMap<String, List<Integer>>();
		
		//체크사항 조정 map을 써서 키에 종류 밸류에 count를 쓴다 
		if(CheckVo.isMale()==true) {
			List<Integer> maleDataList = new ArrayList<Integer>();
			conditionList.add("남자");
			LabelList.add("남자");
			if(!timeCheck.equals("week")) {
				for(String day :dateList) {
					maleDataList.add(adminService.getAdminMemberCountStats(day, "남자", timeCheck,typeFlag));
				}
			}else {
				for(int i=0;i<weekFirstList.size();i++) {
					String firstDate = weekFirstList.get(i);
				  String lastDate = weekLastList.get(i);
					maleDataList.add(adminService.getAdminMemberCountStatsWeek(firstDate,lastDate,"남자", timeCheck,typeFlag));
				}
			}
			dataMap.put("남자", maleDataList);
			colorMap.put("남자", "rgb(0,0,255)");
		}
		if(CheckVo.isFemale()==true) {
			List<Integer> femaleDataList = new ArrayList<Integer>();
			conditionList.add("여자");
			LabelList.add("여자");
			if(!timeCheck.equals("week")) {
				for(String day :dateList) {
					femaleDataList.add(adminService.getAdminMemberCountStats(day, "여자", timeCheck,typeFlag)); 
				}
			}else {
				for(int i=0;i<weekFirstList.size();i++) {
					String firstDate = weekFirstList.get(i);
				  String lastDate = weekLastList.get(i);
				  femaleDataList.add(adminService.getAdminMemberCountStatsWeek(firstDate,lastDate,"여자", timeCheck,typeFlag));
				}
			}
			dataMap.put("여자", femaleDataList);
			colorMap.put("여자", "rgb(255,0,0)");
		}
		if(CheckVo.isNormal()==true) {
			List<Integer> normalDataList = new ArrayList<Integer>();
			conditionList.add("일반회원");
			LabelList.add("일반회원");
			if(!timeCheck.equals("week")) {
				for(String day :dateList) {
					normalDataList.add(adminService.getAdminMemberCountStats(day, "일반회원", timeCheck,typeFlag)); 
				}
			}else {
				for(int i=0;i<weekFirstList.size();i++) {
					String firstDate = weekFirstList.get(i);
				  String lastDate = weekLastList.get(i);
				  normalDataList.add(adminService.getAdminMemberCountStatsWeek(firstDate,lastDate,"일반회원", timeCheck,typeFlag));
				}
			}
			dataMap.put("일반회원", normalDataList);
			colorMap.put("일반회원", "rgb(127,127,127)");
		}
		if(CheckVo.isKakao()==true) {
			List<Integer> kakaoDataList = new ArrayList<Integer>();
			conditionList.add("카카오회원");
			LabelList.add("카카오회원");
			if(!timeCheck.equals("week")) {
				for(String day :dateList) {
					kakaoDataList.add(adminService.getAdminMemberCountStats(day, "카카오회원", timeCheck,typeFlag)); 
				}
			}else {
				for(int i=0;i<weekFirstList.size();i++) {
					String firstDate = weekFirstList.get(i);
				  String lastDate = weekLastList.get(i);
				  kakaoDataList.add(adminService.getAdminMemberCountStatsWeek(firstDate,lastDate,"카카오회원", timeCheck,typeFlag));
				}
			}
			dataMap.put("카카오회원", kakaoDataList);
			colorMap.put("카카오회원", "rgb(250,225,0)");
		}
		if(CheckVo.isNaver()==true) {
			List<Integer> naverDataList = new ArrayList<Integer>();
			conditionList.add("네이버회원");
			LabelList.add("네이버회원");
			if(!timeCheck.equals("week")) {
				for(String day :dateList) {
					naverDataList.add(adminService.getAdminMemberCountStats(day, "네이버회원", timeCheck,typeFlag)); 
				}
			}else {
				for(int i=0;i<weekFirstList.size();i++) {
					String firstDate = weekFirstList.get(i);
					String lastDate = weekLastList.get(i);
					naverDataList.add(adminService.getAdminMemberCountStatsWeek(firstDate,lastDate,"네이버회원", timeCheck,typeFlag));
				}
			}
			dataMap.put("네이버회원", naverDataList);
			colorMap.put("네이버회원", "rgb(3,207,93)");
		}
		if(CheckVo.isTwenties()==true) {
			List<Integer> twenDataList = new ArrayList<Integer>();
			conditionList.add("_20대");
			LabelList.add("_20대");
			if(!timeCheck.equals("week")) {
				for(String day :dateList) {
					twenDataList.add(adminService.getAdminMemberCountStats(day, "20대", timeCheck,typeFlag)); 
				}
			}else {
				for(int i=0;i<weekFirstList.size();i++) {
					String firstDate = weekFirstList.get(i);
				  String lastDate = weekLastList.get(i);
				  twenDataList.add(adminService.getAdminMemberCountStatsWeek(firstDate,lastDate,"20대", timeCheck,typeFlag));
				}
			}
			dataMap.put("_20대", twenDataList);
			colorMap.put("_20대", "rgb(255,127,80)"); //산호색
		}
		if(CheckVo.isThirties()==true) {
			List<Integer> thirDataList = new ArrayList<Integer>();
			conditionList.add("_30대");
			LabelList.add("_30대");
			if(!timeCheck.equals("week")) {
				for(String day :dateList) {
					thirDataList.add(adminService.getAdminMemberCountStats(day, "30대", timeCheck,typeFlag)); 
				}
			}else {
				for(int i=0;i<weekFirstList.size();i++) {
					String firstDate = weekFirstList.get(i);
				  String lastDate = weekLastList.get(i);
				  thirDataList.add(adminService.getAdminMemberCountStatsWeek(firstDate,lastDate,"30대", timeCheck,typeFlag));
				}
			}
			dataMap.put("_30대", thirDataList);
			colorMap.put("_30대", "rgb(0,191,143)"); //에메랄드 그린
		}
		if(CheckVo.isForties()==true) {
			List<Integer> fourDataList = new ArrayList<Integer>();
			conditionList.add("_40대");
			LabelList.add("_40대");
			if(!timeCheck.equals("week")) {
				for(String day :dateList) {
					fourDataList.add(adminService.getAdminMemberCountStats(day, "40대", timeCheck,typeFlag)); 
				}
			}else {
				for(int i=0;i<weekFirstList.size();i++) {
					String firstDate = weekFirstList.get(i);
				  String lastDate = weekLastList.get(i);
				  fourDataList.add(adminService.getAdminMemberCountStatsWeek(firstDate,lastDate,"40대", timeCheck,typeFlag));
				}
			}
			dataMap.put("_40대", fourDataList);
			colorMap.put("_40대", "rgb(0,128,128)"); //짙은 청록
		}
		if(CheckVo.isFifties()==true) {
			List<Integer> fiftDataList = new ArrayList<Integer>();
			conditionList.add("_50대");
			LabelList.add("_50대");
			if(!timeCheck.equals("week")) {
				for(String day :dateList) {
					fiftDataList.add(adminService.getAdminMemberCountStats(day, "50대", timeCheck,typeFlag)); 
				}
			}else {
				for(int i=0;i<weekFirstList.size();i++) {
					String firstDate = weekFirstList.get(i);
				  String lastDate = weekLastList.get(i);
				  fiftDataList.add(adminService.getAdminMemberCountStatsWeek(firstDate,lastDate,"50대", timeCheck,typeFlag));
				}
			}
			dataMap.put("_50대", fiftDataList);
			colorMap.put("_50대", "rgb(128,0,32)"); //버건디
		}
		if(CheckVo.isSixties()==true) {
			List<Integer> sixtDataList = new ArrayList<Integer>();
			conditionList.add("_60대");
			LabelList.add("_60대");
			if(!timeCheck.equals("week")) {
				for(String day :dateList) {
					sixtDataList.add(adminService.getAdminMemberCountStats(day, "60대", timeCheck,typeFlag)); 
				}
			}else {
				for(int i=0;i<weekFirstList.size();i++) {
					String firstDate = weekFirstList.get(i);
				  String lastDate = weekLastList.get(i);
				  sixtDataList.add(adminService.getAdminMemberCountStatsWeek(firstDate,lastDate,"60대", timeCheck,typeFlag));
				}
			}
			dataMap.put("_60대", sixtDataList);
			colorMap.put("_60대", "rgb(0,0,128)"); //감색
		}
		if(CheckVo.isSevties()==true) {
			List<Integer> seveDataList = new ArrayList<Integer>();
			conditionList.add("_70대");
			LabelList.add("_70대");
			if(!timeCheck.equals("week")) {
				for(String day :dateList) {
					seveDataList.add(adminService.getAdminMemberCountStats(day, "70대", timeCheck,typeFlag)); 
				}
			}else {
				for(int i=0;i<weekFirstList.size();i++) {
					String firstDate = weekFirstList.get(i);
					String lastDate = weekLastList.get(i);
					seveDataList.add(adminService.getAdminMemberCountStatsWeek(firstDate,lastDate,"70대", timeCheck,typeFlag));
				}
			}
			dataMap.put("_70대", seveDataList);
			colorMap.put("_70대", "rgb(221,160,221)"); //연한보라색
		}
		HashMap<String, Object> totalData = new HashMap<String, Object>();
		totalData.put("data", dataMap);
		totalData.put("dates", dateList);
		totalData.put("Label", LabelList);
		
		Random random = new Random();

		int r = random.nextInt(256); // 0부터 255 사이의 난수 생성
		int g = random.nextInt(256); // 0부터 255 사이의 난수 생성
		int b = random.nextInt(256); // 0부터 255 사이의 난수 생성

		Object rgbColor = "rgb("+r+", "+g+", "+b+")";
		totalData.put("rgbColor", rgbColor);
		totalData.put("colorMap", colorMap);
		
		Gson gson = new Gson();
		String totalJson = gson.toJson(totalData);
		
		return totalJson+"";
	}
	
	//어드민 전체 멤버리스트(vo로 탈퇴회원 포함) 
	@RequestMapping(value = "/adminAllMemberList", method = RequestMethod.GET)
	public String adminAllMemberListGet(Model model,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "15", required = false) int pageSize,
			@RequestParam(name="viewCheckOption", defaultValue = "", required = false) String viewCheckOption,
			@RequestParam(name="viewCheckOption_2", defaultValue = "", required = false) String viewCheckOption_2,
			@RequestParam(name="part", defaultValue = "", required = false) String part,
			@RequestParam(name="searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO =pageProcess.totRecCnt(pag, pageSize, "adminMember","all", viewCheckOption,viewCheckOption_2, part, searchString);//뒷부분 비어있는건 확장성을 위한 보조필드

		List<MemberVO> adminAllMembers = adminService.getAdminAllMembers(viewCheckOption,viewCheckOption_2,part,searchString, pageVO.getStartIndexNo(), pageSize);
		model.addAttribute("adminAllMembers",adminAllMembers);
		model.addAttribute("pageVO",pageVO);
		model.addAttribute("part",part);
		model.addAttribute("searchString",searchString);
		model.addAttribute("viewCheckOption",viewCheckOption);
		model.addAttribute("viewCheckOption_2",viewCheckOption_2);
		model.addAttribute("category","customer");
		model.addAttribute("section","adminAllMemberList");
		return "admin/adminAllMemberList";
	}
	
	//어드민 관리자 전체 리스트 파이차트용 
	@ResponseBody
	@RequestMapping(value = "/adminMemberChartCountList", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String adminMemberChartCountListPost(String chartSelectValue, String chartType, String listType) {
		//chartSelectValue = 선택타입
		LocalDate now = LocalDate.now();
		DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		DateTimeFormatter YEAR_FORMATTER = DateTimeFormatter.ofPattern("yyyy");
		HashMap<String, Integer> dataMap = new HashMap<String, Integer>();
		List<String> LabelList = new ArrayList<String>();
    HashMap<String, String> colorMap = new HashMap<String, String>();
    List<String> optionList = new ArrayList<String>();
    
		if(chartType.equalsIgnoreCase("pie")) {
			switch (chartSelectValue) {
				case "time":
					if(listType.equalsIgnoreCase("all") || listType.equalsIgnoreCase("withdraw")) {
						for (int i = 5; i >= 0; i--) {
							String time = (now.minusYears(i).format(YEAR_FORMATTER));
							LabelList.add(time);
							dataMap.put(time, adminService.getAdminMemberCountListChart(chartSelectValue, time ,listType,chartType));
							
							Random random = new Random();
							
							int r = random.nextInt(256); // 0부터 255 사이의 난수 생성
							int g = random.nextInt(256); // 0부터 255 사이의 난수 생성
							int b = random.nextInt(256); // 0부터 255 사이의 난수 생성
							
							String rgbColor = "rgb("+r+", "+g+", "+b+")";
							//colorMap.put(time, rgbColor);
							
							if(i==0) colorMap.put(time, "rgb(251,246,233)");
							else if(i==1) colorMap.put(time, "rgb(242,133,133)");
							else if(i==2) colorMap.put(time, "rgb(255,164,71)");
							else if(i==3) colorMap.put(time, "rgb(255,252,155)");
							else if(i==4) colorMap.put(time, "rgb(183,229,180)");
							else if(i==5) colorMap.put(time, "rgb(255,168,184)");
							
						}
					}else if(listType.equalsIgnoreCase("new")) {
						for (int i = 7; i >= 0; i--) {
							String time = (now.minusDays(i).format(DATE_FORMATTER));
							LabelList.add(time);
							dataMap.put(time, adminService.getAdminMemberCountListChart(chartSelectValue, time ,listType,chartType));
							
							Random random = new Random();
							
							int r = random.nextInt(256); // 0부터 255 사이의 난수 생성
							int g = random.nextInt(256); // 0부터 255 사이의 난수 생성
							int b = random.nextInt(256); // 0부터 255 사이의 난수 생성
							
							String rgbColor = "rgb("+r+", "+g+", "+b+")";
							//colorMap.put(time, rgbColor);
							
							if(i==0) colorMap.put(time, "rgb(251,246,233)");
							else if(i==1) colorMap.put(time, "rgb(242,133,133)");
							else if(i==2) colorMap.put(time, "rgb(255,164,71)");
							else if(i==3) colorMap.put(time, "rgb(255,252,155)");
							else if(i==4) colorMap.put(time, "rgb(183,229,180)");
							else if(i==5) colorMap.put(time, "rgb(255,168,184)");
							else if(i==6) colorMap.put(time, "rgb(54,186,152)");
							else if(i==7) colorMap.put(time, "rgb(233,196,106)");
							else if(i==8) colorMap.put(time, "rgb(244,162,97)");
							
						}
						
					}
					break;
				case "gender":
					optionList = adminService.allMemberOptionSearchOptionList(chartSelectValue, "all");
					for(String option : optionList) {
						LabelList.add(option);
						dataMap.put(option, adminService.getAdminMemberCountListChart(chartSelectValue, option ,listType,chartType));
						if(option.equals("남자")) colorMap.put(option, "rgb(0,0,255)");
						else if(option.equals("여자")) colorMap.put(option, "rgb(255,0,0)");
						else if(option.equals("관리")) colorMap.put(option, "rgb(211,211,211)"); //더 밝은 은색
					}
					break;
				case "loginType":
					optionList = adminService.allMemberOptionSearchOptionList(chartSelectValue, "all");
					for(String option : optionList) {
						LabelList.add(option);
						dataMap.put(option, adminService.getAdminMemberCountListChart(chartSelectValue, option ,listType,chartType));
						if(option.equals("일반회원")) colorMap.put(option, "rgb(127,127,127)");
						else if(option.equals("카카오회원")) colorMap.put(option, "rgb(250,225,0)");
						else if(option.equals("네이버회원")) colorMap.put(option, "rgb(3,207,93)");
					}
					break;
				case "age":
					for(int i=2;i<9;i++) {
						String age = "_"+i+"0대";
						LabelList.add(age);
						
						dataMap.put(age, adminService.getAdminMemberCountListChart(chartSelectValue, age ,listType,chartType));
						
						if(i==2) colorMap.put(age, "rgb(177,240,247)");
						else if(i==3) colorMap.put(age, "rgb(126,191,218)");
						else if(i==4) colorMap.put(age, "rgb(245,240,205)");
						else if(i==5) colorMap.put(age, "rgb(250,218,122)");
						else if(i==6) colorMap.put(age, "rgb(55,127,225)");
						else if(i==7) colorMap.put(age, "rgb(245,244,179)");
						else if(i==8) colorMap.put(age, "rgb(76,201,254)");
						else if(i==9) colorMap.put(age, "rgb(255,254,203)");
					}
					break;
				case "":
					System.out.println("없음");
					break;
			}
		}else { //if 처리 가능
		}
		HashMap<String, Object> totalData = new HashMap<String, Object>();
		totalData.put("data", dataMap);
		totalData.put("Label", LabelList);
		totalData.put("colorMap", colorMap);
		
		Gson gson = new Gson();
		String totalJson = gson.toJson(totalData);
		
		return totalJson;
	}
	
	//신규가입 전체 멤버리스트(vo로 탈퇴회원 포함) 
	@RequestMapping(value = "/adminNewMemberList", method = RequestMethod.GET)
	public String newMemberListGet(Model model,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "15", required = false) int pageSize,
			@RequestParam(name="viewCheckOption", defaultValue = "", required = false) String viewCheckOption,
			@RequestParam(name="viewCheckOption_2", defaultValue = "", required = false) String viewCheckOption_2,
			@RequestParam(name="part", defaultValue = "", required = false) String part,
			@RequestParam(name="searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO =pageProcess.totRecCnt(pag, pageSize, "adminMember","new", viewCheckOption,viewCheckOption_2, part, searchString);//뒷부분 비어있는건 확장성을 위한 보조필드
		
		List<MemberVO> adminNewMembers = adminService.getAdminNewMembers(viewCheckOption,viewCheckOption_2,part,searchString, pageVO.getStartIndexNo(), pageSize);
		model.addAttribute("adminNewMembers",adminNewMembers);
		model.addAttribute("pageVO",pageVO);
		model.addAttribute("part",part);
		model.addAttribute("searchString",searchString);
		model.addAttribute("viewCheckOption",viewCheckOption);
		model.addAttribute("viewCheckOption_2",viewCheckOption_2);
		model.addAttribute("category","customer");
		model.addAttribute("section","adminNewMemberList");
		return "admin/adminNewMemberList";
	}
	
	//탈퇴회원 전체 멤버리스트
	@RequestMapping(value = "/adminWithdrawMemberList", method = RequestMethod.GET)
	public String adminWithdrawMemberListGet(Model model,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "15", required = false) int pageSize,
			@RequestParam(name="viewCheckOption", defaultValue = "", required = false) String viewCheckOption,
			@RequestParam(name="viewCheckOption_2", defaultValue = "", required = false) String viewCheckOption_2,
			@RequestParam(name="part", defaultValue = "", required = false) String part,
			@RequestParam(name="searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO =pageProcess.totRecCnt(pag, pageSize, "adminMember","withdraw", viewCheckOption,viewCheckOption_2, part, searchString);//뒷부분 비어있는건 확장성을 위한 보조필드
		List<MemberVO> adminWithdrawMembers = adminService.getAdminWithdrawMembers(viewCheckOption,viewCheckOption_2,part,searchString, pageVO.getStartIndexNo(), pageSize);
		model.addAttribute("adminWithdrawMembers",adminWithdrawMembers);
		model.addAttribute("pageVO",pageVO);
		model.addAttribute("part",part);
		model.addAttribute("searchString",searchString);
		model.addAttribute("viewCheckOption",viewCheckOption);
		model.addAttribute("viewCheckOption_2",viewCheckOption_2);
		model.addAttribute("category","customer");
		model.addAttribute("section","adminWithdrawMemberList");
		return "admin/adminWithdrawMemberList";
	}
	
	//관리자 검색용 옵션 가져오기
	@ResponseBody
	@RequestMapping(value = "/allMemberOptionSearchOptionList", produces="application/text; charset=utf8")
	public String allMemberOptionSearchOptionListPost(String option, String type) {
		
		List<String> optionList = adminService.allMemberOptionSearchOptionList(option, type);
		Gson gson = new Gson();
		String totalJson = gson.toJson(optionList);
		return totalJson;
	}
	
	//관리자 멤버 등급(레벨) 바꾸기 -idx
	@ResponseBody
	@RequestMapping(value = "/adminMemberLevelChangeByIdx", method = RequestMethod.POST)
	public String adminMemberLevelChangeByIdxPost(int level, int idx) {
		int res = 0;
		res = adminService.setAdminMemberLevelChangeByIdx(idx, level);
		
		return res+"";
	}
	
	//관리자 멤버 로그인타입 회원타입 바꾸기 -idx
	@ResponseBody
	@RequestMapping(value = "/adminMemberLoginTypeChangeByIdx", method = RequestMethod.POST)
	public String adminMemberLoginTypeChangeByIdxPost(String loginType, int idx) {
		int res = 0;
		res = adminService.setAdminMemberLoginTypeChangeByIdx(idx, loginType);
		
		return res+"";
	}
	
	//관리자 멤버 탈퇴회원 복구 -idx
	@ResponseBody
	@RequestMapping(value = "/adminMemberActivateByIdx", method = RequestMethod.POST)
	public String adminMemberActivateByIdxPost(int idx,
			@RequestParam(name="mid", defaultValue = "", required = false) String mid
			) {
		int res = 0;
		int res2 = 0;
		MemberVO vo =adminService.getAdminMemberInfoByIdx(idx); 
		mid = vo.getRemainMid();
		System.out.println("아이디" + vo.getMid());
		res = adminService.setAdminMemberActivateByIdx(idx);
		System.out.println("res : "+res);
		if(res != 0) {
			res2 = adminService.setAdminMemberDeleteTableRestore(mid);
			System.out.println("res2-1 : "+res);
		}
		System.out.println("res2-2 : "+res);
		
		return res2+"";
	}
	
	//관리자 멤버 탈퇴/정지 -mid
	@ResponseBody
	@RequestMapping(value = "/adminMemberDeleteByMid", method = RequestMethod.POST)
	public String adminMemberDeleteByMidPost(String mid, String deleteType,String deleteComment) {
		int res = 0;
		int res2 = 0;
		deleteComment = deleteComment
				.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
		res = adminService.setAdminMemberDeleteByMid(mid);
		System.out.println("res1 : "+res);
		if(res != 0) {
			res2 = adminService.setAdminMemberDeleteTableInsert(mid, deleteType, deleteComment);
			System.out.println("res2-1 : "+res);
		}
		System.out.println("res2-2 : "+res);
		return res2+"";
	}
	
	//관리자 멤버 탈퇴/정지 -idx
	@ResponseBody
	@RequestMapping(value = "/adminMemberDeleteByIdx", method = RequestMethod.POST)
	public String adminMemberDeleteByIdxPost(int idx) {
		int res = 0;
		res = adminService.setAdminMemberDeleteByIdx(idx);
		
		return res+"";
	}
	
	//관리자 멤버 탈퇴/정지 관련 정보 가져오기 1건 -mid
	@ResponseBody
	@RequestMapping(value = "/getAdminMemberDeleteTableByMid", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String getAdminMemberDeleteTableByMidPost(String mid) {
		DeleteMemberVO vo = adminService.getAdminMemberDeleteTableByMid(mid);
		Gson gson = new Gson();
		String data = gson.toJson(vo);
		return data;
	}
	
	//관리자 멤버 탈퇴/정지 관련 정보 수정하기 1건 -mid
	@ResponseBody
	@RequestMapping(value = "/adminMemberDeleteTableUpdateByMid", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String adminMemberDeleteTableUpdateByMidPost(String deleteMid, String deleteType, String deleteReason, String deleteComment) {
		int res = 0;
		res = adminService.setadminMemberDeleteTableUpdateByMid(deleteMid, deleteType, deleteReason, deleteComment);
		return res+"";
	}
	
	//관리자 멤버 세부정보 페이지 이동
	@RequestMapping(value = "/adminMemberDetailInfo", method = RequestMethod.GET)
	public String adminMemberDetailInfoGet(Model model, int idx) {
		MemberVO vo = adminService.getAdminMemberInfoByIdx(idx);
		//vo에 정보 가공해서 넣기
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
		
		if(vo.getBirthday().startsWith("2")) {
			if(vo.getGender().equals("남자")) {
				vo.setGenderNumber(3); // 1 2 3 4
			}else if(vo.getGender().equals("여자")){
				vo.setGenderNumber(4); // 1 2 3 4
			}
		}else {
			if(vo.getGender().equals("남자")) {
				vo.setGenderNumber(1); // 1 2 3 4
			}else if(vo.getGender().equals("여자")){
				vo.setGenderNumber(2); // 1 2 3 4
			}
		}
		
		String tempBirth =  vo.getBirthday().substring(0,10);
		String[] tempBirthArr = tempBirth.split("-");
		String birthdayFormat = tempBirthArr[0].substring(2)+tempBirthArr[1]+tempBirthArr[2];
		vo.setBirthdayFormat(Integer.parseInt(birthdayFormat)); // 123456 형식
		
		model.addAttribute("vo", vo);
		
		return "admin/adminMemberDetailInfo";
	}
	//관리자 멤버 세부 정보 수정
	@RequestMapping(value = "/adminMemberDetailInfoUpdateOk", method = RequestMethod.POST)
	public String adminMemberDetailInfoUpdateOkPost(MemberVO vo, @RequestParam("profileImage") MultipartFile profileImage,@RequestParam("imageCheck") String imageCheck,@RequestParam("imageCheck") String midCheck, int idx2) throws IOException {
		int res = 0;
		String pwdCheck="";
		MemberVO vo2 = adminService.getAdminMemberInfoByIdx(idx2);
		String userDelCheck = vo2.getUserDel();
		vo.setCurrentMid(vo2.getMid());
		if(!midCheck.toLowerCase().contains("remain")) {
			midCheck="변경";
		}
		if(vo.getPwd().toLowerCase().equalsIgnoreCase("remain")) {
			pwdCheck = "유지";
		}else {
			vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		}
		
		//성별처리
		if(vo.getGender().equals("1") || vo.getGender().equals("3")) {
			vo.setGender("남자");
		}else if(vo.getGender().equals("2") || vo.getGender().equals("4")) {
			vo.setGender("여자");
		}
		//자기소개 처리
		vo.setContent(vo.getContent()
				.replace("&", "&amp;")
				.replace("<", "&lt;")
				.replace(">", "&gt;")
				.replace("\"", "&quot;")
				.replace("'", "&#39;"));
		String path = "/resources/data/member/";
		
		//사진 확인
		if(imageCheck.equals("")) {
			vo.setPhoto(vo2.getPhoto());
		}else {
			String sFileName = vo2.getRemainMid()+"_"+profileImage.getOriginalFilename();
			vo.setPhoto(sFileName);
		}
		
		res = adminService.setAdminMemberInfoUpdate(vo,midCheck,pwdCheck,userDelCheck, idx2);
		
		if(res != 0) {
			if(imageCheck.equals("파일있음")) {
				//회원 사진 삭제후 저장
				commonClass.deleteFile(profileImage, vo2.getPhoto(), path);
				commonClass.writeFile(profileImage, vo.getPhoto(), path, "adminMemberInfoUpdate");
			}
			return "redirect:/message/adminMemberInfoUpdateOk?mid="+vo.getMid();
		}else {
			return "redirect:/message/adminMemberInfoUpdateNo?mid="+vo.getMid();
		}
	}
	
	
	//공지사항게시판
	@RequestMapping(value = "/adminNoticeBoardList",method = RequestMethod.GET)
	public String noticeBoardListGet(Model model,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "15", required = false) int pageSize,
			@RequestParam(name="boardType", defaultValue = "all", required = false) String boardType, //notice
			@RequestParam(name="category", defaultValue = "all", required = false) String category,
			@RequestParam(name="part", defaultValue = "", required = false) String part, //검색용 분류
			@RequestParam(name="searchString", defaultValue = "", required = false) String searchString //검색용단어
			) {
		List<BoardVO> vos = new ArrayList<BoardVO>();
		boardType = "notice";
		if (!part.isBlank() && !part.equals("title") && !part.equals("content")) {
	    // part가 공백도 아니고 "title"도 아니고 "content"도 아닌 경우 실행할 코드
			return "redirect:/message/wrongAccess";
		}
		PageVO pageVO =pageProcess.totBoardRecCnt(pag, pageSize, boardType,category, "","",part, searchString, "");//뒷부분 비어있는건 확장성을 위한 보조필드
		
		if(part.equals("") && searchString.equals("")) {
			vos = adminService.getAdminNoticeBoardList(pageVO.getStartIndexNo(), pageSize, category);
		}else {
			vos = adminService.getAdminNoticeBoardSearchList(pageVO.getStartIndexNo(), pageSize, part, searchString);
		}
		
		LocalDate today = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss[.S]");
		for(BoardVO vo : vos) {
			LocalDateTime time = LocalDateTime.parse(vo.getPostDate(), formatter);
			if(time.toLocalDate().equals(today)) {
				vo.setPostDate(vo.getPostDate().substring(11,19));
			}else {
				vo.setPostDate(vo.getPostDate().substring(0,10));
			}
			
		}
		
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		model.addAttribute("category", category);
		model.addAttribute("part", part);
		model.addAttribute("searchString", searchString);
		return "/admin/adminNoticeBoardList";
	}
	//어드민 관리자 보드 공지사항게시판 세부내용 보기
	@RequestMapping(value = "/adminNoticeBoardContent", method = RequestMethod.GET)
	public String adminNoticeBoardContentGet(Model model, int idx) {
		BoardVO vo = adminService.getAdminNoticeBoardContentByIdx(idx);
		if(vo==null) {
			return "redirect:/message/wrongAccess";
		}
		
		adminService.setAdminNoticeBoardViewCountIncreaseByIdx(idx);
		
		LocalDate today = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss[.S]");
		LocalDateTime time = LocalDateTime.parse(vo.getPostDate(), formatter);
		if(time.toLocalDate().equals(today)) {
			vo.setPostDate(vo.getPostDate().substring(11,19));
		}else {
			vo.setPostDate(vo.getPostDate().substring(0,vo.getPostDate().length()-2));
		}
		List<BoardFilesVO> fVos = adminService.getAdminNoticeBoardFilesByIdx(idx);
		model.addAttribute("vo", vo);
		model.addAttribute("fVos", fVos);
		return "admin/adminNoticeBoardContent";
	}
	//어드민 관리자 공지사항 게시판 글쓰기
	@RequestMapping(value = "/adminNoticeBoardInput", method = RequestMethod.GET)
	public String adminNoticeBoardInputGet() {
		return "admin/adminNoticeBoardInput";
	}
	
	//어드민 관리자 공지사항 게시판 작성글 DB 넣기
	@RequestMapping(value = "/adminNoticeBoardInput", method = RequestMethod.POST)
	public String adminNoticeBoardInputPost(BoardVO vo,@RequestParam("files[]") MultipartFile[] files) throws IOException {
		//에디터 사진 옮기기
		vo.setTitle(vo.getTitle()
				.replace("&", "&amp;")
				.replace("<", "&lt;")
				.replace(">", "&gt;")
				.replace("\"", "&quot;")
				.replace("'", "&#39;"));
		
		
		int res = adminService.setAdminNoticeBoardInputOk(vo, files);
		if(res !=0) {
			return "redirect:/message/adminNoticBoardInputOk";
		}else {
			return "redirect:/message/adminNoticBoardInputNo";
		}
	}
	//어드민 관리자 공지사항 게시판 글 삭제 -idx
	@RequestMapping(value = "/adminNoticeContentDelete", method = RequestMethod.GET)
	public String adminNoticeContentDeleteGet(int idx, String fileEx) {
		int res = 0;
		int res2 = 0;
		if(fileEx.equalsIgnoreCase("ok")) {
			res = adminService.setAdminNoticeBoardFilesDeleteByIdx(idx);
			if(res != 0) {
				res2 = adminService.setAdminNoticeBoardContentDeleteByIdx(idx);
				if(res2 != 0) {
					return "redirect:/message/adminNoticBoardContentDeleteOk";
				}else {
					return "redirect:/message/adminNoticBoardContentDeleteNo";
				}
			}else {
				return "redirect:/message/adminNoticBoardFileDeleteNo";
			}
		}else {
			res2 = adminService.setAdminNoticeBoardContentDeleteByIdx(idx);
			if(res2 != 0) {
				return "redirect:/message/adminNoticBoardContentDeleteOk";
			}else {
				return "redirect:/message/adminNoticBoardContentDeleteNo";
			}
		}
	}
	
	//글수정 불러오기
	@RequestMapping(value = "/adminNoticeBoardContentUpdate", method = RequestMethod.GET)
	public String adminNoticeBoardContentUpdateGet(Model model, int idx) {
		BoardVO vo = adminService.getAdminNoticeBoardContentByIdx(idx);
		List<BoardFilesVO> vos = adminService.getAdminNoticeBoardFilesByIdx(idx);
		
		model.addAttribute("vo", vo);
		model.addAttribute("vos", vos);
		
		return "admin/adminNoticeBoardContentUpdate";
	}
	//글수정 처리하기
	@RequestMapping(value = "/adminNoticeBoardContentUpdate", method = RequestMethod.POST)
	public String adminNoticeBoardContentUpdatePost(Model model, BoardVO vo, 
			@RequestParam(name="deleteCheck[]", required = false) ArrayList<String> deleteCheck,
			@RequestParam(name="files[]", required = false) MultipartFile[] files, int eIdx) {
		ArrayList<String> deleteCheckOriginal = new ArrayList<String>();
		ArrayList<String> deleteCheckServer = new ArrayList<String>();
		
		if(!CollectionUtils.isEmpty(deleteCheck)) {
			for(String ans : deleteCheck) {
				String[] ansSp = ans.split("/");
				deleteCheckServer.add(ansSp[0]);
				deleteCheckOriginal.add(ansSp[1]);
			}
		}
		vo.setTitle(vo.getTitle()
				.replace("&", "&amp;")
				.replace("<", "&lt;")
				.replace(">", "&gt;")
				.replace("\"", "&quot;")
				.replace("'", "&#39;"));
		
		int res = adminService.setAdminNoticeBoardContentUpdateByIdx(vo, deleteCheckServer,deleteCheckOriginal, files, eIdx);
		if(res !=0) {
			return "redirect:/message/adminNoticeBoardContentUpdateOk?idx="+eIdx;//No 도 있음
		}else {
			return "redirect:/message/adminNoticeBoardContentUpdateNo?idx="+eIdx;//No 도 있음
		}
	}
	
	//관리자 식물 데이터 리스트 페이지
	@RequestMapping(value = "/adminPlantDataList", method = RequestMethod.GET)
	public String adminPlantDataListGet(Model model,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "15", required = false) int pageSize,
			@RequestParam(name="boardType", defaultValue = "plantData", required = false) String boardType, //notice
			@RequestParam(name="category", defaultValue = "all", required = false) String category,
			@RequestParam(name="option", defaultValue = "all", required = false) String option,
			@RequestParam(name="subOption", defaultValue = "", required = false) String subOption,
			@RequestParam(name="part", defaultValue = "", required = false) String part, //검색용 분류
			@RequestParam(name="searchString", defaultValue = "", required = false) String searchString, //검색용단어
			@RequestParam(name="viewCheckOption", defaultValue = "", required = false) String viewCheckOption//분류별 보기 2번째 체크 단어
			) {
		String section = "식물데이터리스트";//product
		
		category = "product";
		boardType = "plantData";
		
		PageVO pageVO =pageProcess.totBoardRecCnt(pag, pageSize, boardType,category, option,subOption,part, searchString,viewCheckOption);//뒷부분 비어있는건 확장성을 위한 보조필드
		
		List<PlantDataVO> vos = adminService.getAdminPlantDataList(option,subOption,part, searchString,pageVO.getStartIndexNo(), pageSize);
		
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		model.addAttribute("section",section);
		model.addAttribute("category","product");
		return "admin/adminPlantDataList";
	}
	
	//관리자 식물 데이터 정보 상세 및 수정 페이지
	@RequestMapping(value = "/adminPlantDataDetailInfo", method = RequestMethod.GET)
	public String adminPlantDataDetailInfoGet(Model model, int idx) {
		String section = "식물데이터삽입";
		String category = "product";
		PlantDataVO vo = adminService.getAdminPlantDataByIdx(idx);
		model.addAttribute("vo",vo);
		model.addAttribute("section",section);
		model.addAttribute("category",category);
		return "admin/adminPlantDataDetailInfo";
	}
	
	//관리자 식물 데이터 수정 처리
	@RequestMapping(value = "/adminPlantDataUpdate", method = RequestMethod.POST)
	public String adminPlantDataUpdatePost(PlantDataVO vo, int idx2) {
		
		int res = adminService.setAdminPlantDataUpdateByIdx(vo, idx2);
		
		if(res != 0) {
			return "redirect:/message/adminPlantDataUpdateOk?idx="+idx2;
		}else {
			return "redirect:/message/adminPlantDataUpdateNo?idx="+idx2;
		}
	}
	
	//관리자 식물 데이터 삽입 페이지
	@RequestMapping(value = "/adminPlantDataInsert", method = RequestMethod.GET)
	public String adminPlantDataInsertGet(Model model) {
		String section = "식물데이터삽입";
		String category = "product";
		model.addAttribute("section",section);
		model.addAttribute("category",category);
		return "admin/adminPlantDataInsert";
	}
	//관리자 식물명 중복체크 ajax
	@ResponseBody
	@RequestMapping(value = "/adminPlantNameDuplicateCheck", method = RequestMethod.POST)
	public String adminPlantNameDuplicateCheckPost(String plantName) {
		int res = 0;
		PlantDataVO vo = adminService.getAdminPlantNameDuplicateCheckGet(plantName);
		if(vo != null) {
			res=1;
		}
		return res+"";
	}
	
	//관리자 식물공통데이터 목록 가져오기 ajax
	@ResponseBody
	@RequestMapping(value = "/getAdminPlantDataListByName", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String getAdminPlantDataListByNamePost(String searchWord, String dataType) {
		int res = 0;
		List<PlantDataVO> vos = null;
		if(dataType == null||dataType.isEmpty()) {
			vos = adminService.getAdminPlantDataListByName(searchWord, "");
		}
		else if(dataType.equals("품종")) {
			vos = adminService.getAdminPlantDataListByName(searchWord,dataType);
		}
		if(vos != null) {
			Gson gson = new Gson();
			String data = gson.toJson(vos);
			return data;
		}
		return String.valueOf(res);
	}
	
	//관리자 식물 데이터 삽입 처리
	@RequestMapping(value = "/adminPlantDataInsert", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String adminPlantDataInsertPost(Model model, PlantDataVO vo) {
		int res = 0;
		res = adminService.setAdminPlantDataInput(vo);
		if(res != 0) {
			return "redirect:/message/adminPlantDataInsertOk";
		}else {
			return "redirect:/message/adminPlantDataInsertNo";
		}
	}
	
	//관리자 식물 데이터 삭제 처리
	@RequestMapping(value = "/adminPlantDataDelete", method = RequestMethod.GET,  produces="application/text; charset=utf8")
	public String adminPlantDataDeleteGet(int idx) {
		int res = 0;
		res = adminService.setAdminPlantDataDelete(idx);
		if(res != 0) {
			return "redirect:/message/adminPlantDataDeleteOk";
		}else {
			return "redirect:/message/adminPlantDataDeleteNo?idx="+idx;
		}
	}
	
	//식물 데이터 옵션 리스트 가져오기
	@ResponseBody
	@RequestMapping(value = "/adminPlantOptionDataList", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String adminPlantOptionDataList(String optionData) {
		if(!optionData.equalsIgnoreCase("dataType")&&!optionData.equalsIgnoreCase("used")&&!optionData.equalsIgnoreCase("usablePart")&&!optionData.equalsIgnoreCase("lightLevel")&&!optionData.equalsIgnoreCase("status")) {
			return "redirect://message/wrongAccess";
		}
		
		List<String> optionDataList = adminService.getAdminPlantOptionDataList(optionData);
		
		Gson gson = new Gson();
		
		String res =  gson.toJson(optionDataList);
		
		return res;
	}
	
//어드민 관리자 식물데이터 전체 리스트 파이차트용 
	@ResponseBody
	@RequestMapping(value = "/adminPlantDataChartCountList", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String adminPlantDataChartCountListPost(String chartSelectValue, String chartType, String listType) {
		//chartSelectValue = 선택타입 차트타입=파이 리스트타입=all
		HashMap<String, Integer> dataMap = new HashMap<String, Integer>();
		List<String> LabelList = new ArrayList<String>();
    HashMap<String, String> colorMap = new HashMap<String, String>();
    List<String> optionList = new ArrayList<String>();
    
		if(chartType.equalsIgnoreCase("pie")) {
			switch (chartSelectValue) {
				case "dataType":
						optionList = adminService.getAdminPlantDataOptionSearchOptionList(chartSelectValue, "all");
						for (String option : optionList) {
							LabelList.add(option);
							dataMap.put(option, adminService.getAdminPlantDataCountListChart(chartSelectValue,option ,listType,chartType));
							
							if(option.equals("품종")) colorMap.put(option, "rgb(114, 191, 120)");
							else if(option.equals("기본")) colorMap.put(option, "rgb(211, 238, 152)");
							
						}
					break;
				case "used":
					optionList = adminService.getAdminPlantDataOptionSearchOptionList(chartSelectValue, "all");
					for(String option : optionList) {
						LabelList.add(option);
						dataMap.put(option, adminService.getAdminPlantDataCountListChart(chartSelectValue, option ,listType,chartType));
						if(option.equals("식용")) colorMap.put(option, "rgb(135, 169, 34)");
						else if(option.equals("약용")) colorMap.put(option, "rgb(17, 66, 50)");
						else if(option.equals("관상용")) colorMap.put(option, "rgb(247, 246, 187)"); //더 밝은 은색
					}
					break;
				case "usablePart":
					optionList = adminService.getAdminPlantDataOptionSearchOptionList(chartSelectValue, "all");
					for(String option : optionList) {
						LabelList.add(option);
						dataMap.put(option, adminService.getAdminPlantDataCountListChart(chartSelectValue, option ,listType,chartType));
						if(option.equals("관엽류")) colorMap.put(option, "rgb(54, 94, 50)");
						else if(option.equals("다육류")) colorMap.put(option, "rgb(93, 185, 150)");
						else if(option.equals("관화식물")) colorMap.put(option, "rgb(235, 90, 60)");
						else if(option.equals("방향류")) colorMap.put(option, "rgb(231, 211, 127)");
						else if(option.equals("관과류")) colorMap.put(option, "rgb(253, 155, 99)");
						else if(option.equals("엽채류")) colorMap.put(option, "rgb(52, 121, 40)");
						else if(option.equals("과실류")) colorMap.put(option, "rgb(252, 205, 42)");
						else if(option.equals("곡류")) colorMap.put(option, "rgb(255, 251, 230)");
						else if(option.equals("허브류")) colorMap.put(option, "rgb(129, 162, 99)");
						else if(option.equals("과채류")) colorMap.put(option, "rgb(95, 15, 64)");
						else if(option.equals("뿌리류")) colorMap.put(option, "rgb(104, 87, 82)");
						else if(option.equals("열매류")) colorMap.put(option, "rgb(255, 116, 139)");
						else if(option.equals("씨앗류")) colorMap.put(option, "rgb(84, 58, 20)");
						else if(option.equals("약엽류")) colorMap.put(option, "rgb(18, 53, 36)");
					}
					break;
				case "lightLevel":
					optionList = adminService.getAdminPlantDataOptionSearchOptionList(chartSelectValue, "all");
					for(String option : optionList) {
						LabelList.add(option);
						dataMap.put(option, adminService.getAdminPlantDataCountListChart(chartSelectValue, option ,listType,chartType));
						if(option.equals("직사광선")) colorMap.put(option, "rgb(255, 232, 147)");
						else if(option.equals("양지")) colorMap.put(option, "rgb(252, 255, 193)");
						else if(option.equals("반양지")) colorMap.put(option, "rgb(245, 237, 237)");
						else if(option.equals("반음지")) colorMap.put(option, "rgb(127, 161, 195)");
					}
					break;
				case "status":
					optionList = adminService.getAdminPlantDataOptionSearchOptionList(chartSelectValue, "all");
					for(String option : optionList) {
						LabelList.add(option);
						
						dataMap.put(option, adminService.getAdminPlantDataCountListChart(chartSelectValue, option ,listType,chartType));
						
						if(option.equals("잎")) colorMap.put(option, "rgb(54, 94, 50)");
						else if(option.equals("씨앗")) colorMap.put(option, "rgb(84, 58, 20)");
						else if(option.equals("열매")) colorMap.put(option, "rgb(252, 205, 42)");
						else if(option.equals("구근")) colorMap.put(option, "rgb(203, 163, 92)");
						else if(option.equals("모종")) colorMap.put(option, "rgb(248, 225, 183)");
						else if(option.equals("묘목")) colorMap.put(option, "rgb(117, 78, 26)");
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
	
	//식물 상태 변경-idx
	@ResponseBody
	@RequestMapping(value = "/adminPlantStatusChangeByIdx", method = RequestMethod.POST)
	public String adminPlantStatusChangeByIdxPost(int idx, String status) {
		int res = adminService.setAdminPlantStatusChangeByIdx(idx, status);
		return res+"";
	}
	
	//식물 광량 변경-idx
	@ResponseBody
	@RequestMapping(value = "/adminPlantLightLevelChangeByIdx", method = RequestMethod.POST)
	public String adminPlantLightLevelChangeByIdxPost(int idx, String lightLevel) {
		int res = adminService.setAdminPlantLightLevelChangeByIdx(idx, lightLevel);
		return res+"";
	}
	
	//식물 정보가져오기 -idx
	@ResponseBody
	@RequestMapping(value = "/adminPlantDataByIdx", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String adminPlantDataByIdxPost(int idx, String lightLevel) {
		PlantDataVO	vo = adminService.getAdminPlantDataByIdx(idx);
		Gson gson = new Gson();
		String data = gson.toJson(vo);
		return data;
	}
	
	//관리자 상품 데이터 리스트 페이지
	@RequestMapping(value = "/adminProductDataList", method = RequestMethod.GET)
	public String adminProductListGet(Model model,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "15", required = false) int pageSize,
			@RequestParam(name="boardType", defaultValue = "plantData", required = false) String boardType, //notice
			@RequestParam(name="category", defaultValue = "all", required = false) String category,
			@RequestParam(name="option", defaultValue = "all", required = false) String option,
			@RequestParam(name="subOption", defaultValue = "", required = false) String subOption,
			@RequestParam(name="part", defaultValue = "", required = false) String part, //검색용 분류
			@RequestParam(name="searchString", defaultValue = "", required = false) String searchString, //검색용단어
			@RequestParam(name="viewCheckOption", defaultValue = "", required = false) String viewCheckOption//분류별 보기 2번째 체크 단어
			) {
		String section = "상품데이터리스트";//product
		
		category = "product";
		boardType = "productData";
		
		PageVO pageVO =pageProcess.totBoardRecCnt(pag, pageSize, boardType,category, option,subOption,part, searchString,viewCheckOption);//뒷부분 비어있는건 확장성을 위한 보조필드
		
		List<ProductDataVO> vos = adminService.getAdminProductDataList(option,subOption,part, searchString,pageVO.getStartIndexNo(), pageSize);
		
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		model.addAttribute("section",section);
		model.addAttribute("category","product");
		return "admin/adminProductDataList";
	}
	
	//관리자 상품 데이터 삽입 페이지
	@RequestMapping(value = "/adminProductDataInsert", method = RequestMethod.GET)
	public String adminProductDataInsertGet(Model model) {
		String section = "상품데이터삽입";
		String category = "product";
		model.addAttribute("section",section);
		model.addAttribute("category",category);
		return "admin/adminProductDataInsert";
	}
	
	//관리자 상품 데이터 삽입 처리 ajax
	@RequestMapping(value = "/adminProductDataInsert", method = RequestMethod.POST)
	public String adminProductDataInsertPost(ProductDataVO vo, @RequestParam("mainImage") MultipartFile mainImage,@RequestParam("detailedImage") MultipartFile detailedImage,String productPlantName ,String mainImageCheck,String detailImageCheck,int plantIdx) throws IOException {
		int res = 0;
		vo.setProductDescription(vo.getProductDescription()
				.replace("&", "&amp;")
				.replace("<", "&lt;")
				.replace(">", "&gt;")
				.replace("\"", "&quot;")
				.replace("'", "&#39;"));
		if(plantIdx !=0) {
			vo.setProductPlantIdx(plantIdx);
			res = adminService.setAdminProductDataInsert(vo);
		}
		else {
			//기타로 넘어올때의 추가 처리 필요
			if(!productPlantName.equals("기타")) {
				PlantDataVO plantVo = adminService.getAdminPlantDataByName(productPlantName);
				vo.setProductPlantIdx(plantVo.getIdx());
				res = adminService.setAdminProductDataInsert(vo);
			}else {
				System.out.println("기타일 경우 1처리 1은 데이터없음");
				vo.setProductPlantIdx(1);
				res = adminService.setAdminProductDataInsert(vo);
			}
		}
		int check1 = 0;
		int check2 = 0;
		ProductDataVO dataVO = adminService.getAdminProductNameDuplicateCheck(vo.getProductName());
		String tempCate = "productPlant";
		String sFileNameMain = "";
		String sFileNameDetail = "";
		
		if(res != 0) {
			if(mainImageCheck.equals("파일있음")) {
				String path = "/resources/data/product/";
				DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss"); // 날짜, 시분초 포함
				LocalDateTime now = LocalDateTime.now(); // LocalDateTime 사용
				String day = now.format(DATE_FORMATTER);
				sFileNameMain = day+"_"+mainImage.getOriginalFilename();
				commonClass.writeFile(mainImage, sFileNameMain, path, "productData"); //멀티파트 서버네임 경로 프로세스타입
				check1 = 1;
			}
			if(detailImageCheck.equals("파일있음")) {
				String path = "/resources/data/product/";
				DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss"); // 날짜, 시분초 포함
				LocalDateTime now = LocalDateTime.now(); // LocalDateTime 사용
				String day = now.format(DATE_FORMATTER);
				sFileNameDetail = day+"_"+detailedImage.getOriginalFilename();
				commonClass.writeFile(detailedImage, sFileNameDetail, path, "productData"); //멀티파트 서버네임 경로 프로세스타입
				check2 = 1;
			}
			ProductImageVO imageVO = new ProductImageVO();
			if(check1 !=0 && check2 !=0) {
				imageVO.setCategory(tempCate);
				imageVO.setProductIdx(dataVO.getIdx());
				if(check1 == 1) {
					imageVO.setMainImage(sFileNameMain);
				}
				if(check2 == 1) {
					imageVO.setDetailedImage(sFileNameDetail);
				}
				int res2 = adminService.setAdminProductImageInsert(imageVO);
				if(res2 == 0) {
					return "redirect:/message/adminProductDataInsertNo";
				}
			}
			
			return "redirect:/message/adminProductDataInsertOk";
		}else {
			return "redirect:/message/adminProductDataInsertNo";
		}
	}
	
	//관리자 상품명 중복체크 ajax
	@ResponseBody
	@RequestMapping(value = "/adminProductNameDuplicateCheck", method = RequestMethod.POST)
	public String adminProductNameDuplicateCheckPost(String productName) {
		int res = 0;
		ProductDataVO vo = adminService.getAdminProductNameDuplicateCheck(productName);
		if(vo != null) {
			res=1;
		}
		return res+"";
	}
	
	//관리자 상품 정보 목록 가져오기  ajax
	@ResponseBody
	@RequestMapping(value = "/adminProductDataListByName", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String adminProductDataListByNamePost(String searchWord) {
		int res = 0;
		List<ProductDataVO> vos = adminService.getProductDataListByName(searchWord);
		if(vos != null) {
			Gson gson = new Gson();
			String data = gson.toJson(vos);
			return data;
		}
		return res+"";
	}
	
	//판매상태변경 ajax
	@ResponseBody
	@RequestMapping(value = "/adminProductStatusChangeByIdx", method = RequestMethod.POST)
	public String adminProductStatusChangeByIdxPost(String productStatus, int idx) {
		int res = 0;
		res = adminService.setAdminProductStatusChangeByIdx(idx,productStatus);
		
		return res + "";
	}
	
	//상품 데이터 옵션 리스트 가져오기
	@ResponseBody
	@RequestMapping(value = "/adminProductOptionDataList", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String adminProductOptionDataListPost(String optionData) {
		if(!optionData.equalsIgnoreCase("productCategory")&&!optionData.equalsIgnoreCase("productStatus")) {
			return "redirect://message/wrongAccess";
		}
		
		List<String> optionDataList = adminService.getAdminProductOptionDataList(optionData);
		
		Gson gson = new Gson();
		
		String res =  gson.toJson(optionDataList);
		
		return res;
	}
	
//어드민 관리자 상품 데이터 전체 리스트 파이차트용 
	@ResponseBody
	@RequestMapping(value = "/adminProductDataChartCountList", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String adminProductDataChartCountListPost(String chartSelectValue, String chartType, String listType) {
		//chartSelectValue = 선택타입 차트타입=파이 리스트타입=all
		HashMap<String, Integer> dataMap = new HashMap<String, Integer>();
		List<String> LabelList = new ArrayList<String>();
    HashMap<String, String> colorMap = new HashMap<String, String>();
    List<String> optionList = new ArrayList<String>();
    
		if(chartType.equalsIgnoreCase("pie")) {
			switch (chartSelectValue) {
				case "productCategory":
						optionList = adminService.getAdminProductDataOptionSearchOptionList(chartSelectValue, "all");
						for (String option : optionList) {
							LabelList.add(option);
							dataMap.put(option, adminService.getAdminProductDataCountListChart(chartSelectValue,option ,listType,chartType));
							
							if(option.equals("식물")) colorMap.put(option, "rgb(17, 139, 80)");
							else if(option.equals("부자재")) colorMap.put(option, "rgb(251, 246, 233)");
							else if(option.equals("기타")) colorMap.put(option, "rgb(114, 125, 115)");
							
						}
					break;
				case "productStatus":
					optionList = adminService.getAdminProductDataOptionSearchOptionList(chartSelectValue, "all");
					for(String option : optionList) {
						LabelList.add(option);
						dataMap.put(option, adminService.getAdminProductDataCountListChart(chartSelectValue, option ,listType,chartType));
						if(option.equals("판매중")) colorMap.put(option, "rgb(92, 179, 56)");
						else if(option.equals("임시등록")) colorMap.put(option, "rgb(236, 232, 82)");
						else if(option.equals("판매중지")) colorMap.put(option, "rgb(251, 65, 65)"); 
						else if(option.equals("재고없음")) colorMap.put(option, "rgb(255, 193, 69)"); 
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
	
	//관리자 상품 데이터 정보 상세 및 수정 페이지
	@RequestMapping(value = "/adminProductDataDetailInfo", method = RequestMethod.GET)
	public String adminProductDataDetailInfoGet(Model model, int idx) {
		String section = "상품데이터수정";
		String category = "product";
		ProductDataVO vo = adminService.getAdminProductDataByIdx(idx);
		ProductImageVO imgVO = adminService.getAdminProductImageByIdx(idx);
		PlantDataVO plantVO = adminService.getAdminPlantDataByIdx(vo.getProductPlantIdx());
		model.addAttribute("vo",vo);
		model.addAttribute("imgVO",imgVO);
		model.addAttribute("plantVO",plantVO);
		model.addAttribute("section",section);
		model.addAttribute("category",category);
		return "admin/adminProductDataDetailInfo";
	}
	
	//관리자 상품 데이터 수정 처리
	@RequestMapping(value = "/adminProductDataUpdate", method = RequestMethod.POST)
	public String adminProductDataUpdatePost(ProductDataVO vo, @RequestParam("mainImage") MultipartFile mainImage,@RequestParam("detailedImage") MultipartFile detailedImage,String productPlantName ,String mainImageCheck,String detailImageCheck,int plantIdx, int currentIdx) throws IOException {
		int res = 0;
		vo.setProductDescription(vo.getProductDescription()
				.replace("&", "&amp;")
				.replace("<", "&lt;")
				.replace(">", "&gt;")
				.replace("\"", "&quot;")
				.replace("'", "&#39;"));
		if(plantIdx !=0) {
			vo.setProductPlantIdx(plantIdx);
			res = adminService.setAdminProductDataUpdate(vo, currentIdx);
		}
		else {
			//기타로 넘어올때의 추가 처리 필요
			if(!productPlantName.equals("기타")) {
				PlantDataVO plantVo = adminService.getAdminPlantDataByName(productPlantName);
				vo.setProductPlantIdx(plantVo.getIdx());
				res = adminService.setAdminProductDataUpdate(vo, currentIdx);
			}else {
				System.out.println("기타일 경우 1처리 1은 데이터없음");
				vo.setProductPlantIdx(1);
				res = adminService.setAdminProductDataUpdate(vo,currentIdx);
			}
		}
		int check1 = 0;
		int check2 = 0;
		ProductDataVO dataVO = adminService.getAdminProductNameDuplicateCheck(vo.getProductName());
		String tempCate = "productPlant";
		String sFileNameMain = "";
		String sFileNameDetail = "";
		
		if(res != 0) {
			//기존이미지사용 - 파일있음
			if(mainImageCheck.equals("파일있음")) {
				String path = "/resources/data/product/";
				DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss"); // 날짜, 시분초 포함
				LocalDateTime now = LocalDateTime.now(); // LocalDateTime 사용
				String day = now.format(DATE_FORMATTER);
				sFileNameMain = day+"_"+mainImage.getOriginalFilename();
				commonClass.writeFile(mainImage, sFileNameMain, path, "productData"); //멀티파트 서버네임 경로 프로세스타입
				check1 = 1;
			}
			if(detailImageCheck.equals("파일있음")) {
				String path = "/resources/data/product/";
				DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss"); // 날짜, 시분초 포함
				LocalDateTime now = LocalDateTime.now(); // LocalDateTime 사용
				String day = now.format(DATE_FORMATTER);
				sFileNameDetail = day+"_"+detailedImage.getOriginalFilename();
				commonClass.writeFile(detailedImage, sFileNameDetail, path, "productData"); //멀티파트 서버네임 경로 프로세스타입
				check2 = 1;
			}
			ProductImageVO imageVO = new ProductImageVO();
			imageVO.setCategory(tempCate);
			imageVO.setProductIdx(dataVO.getIdx());
			if(check1 !=0 || check2 !=0) {
				if(check1 == 1) {
					imageVO.setMainImage(sFileNameMain);
				}
				if(check2 == 1) {
					imageVO.setDetailedImage(sFileNameDetail);
				}
				int res2 = adminService.setAdminProductImageUpdate(imageVO, currentIdx);
				if(res2 == 0) {
					return "redirect:/message/adminProductDataImgUpdateNo";
				}
			}
			return "redirect:/message/adminProductDataUpdateOk";
		}else {
			return "redirect:/message/adminProductDataUpdateNo";
		}
	}
	
	//상품데이터 삭제
	@RequestMapping(value = "/adminProductDataDelete", method = RequestMethod.GET)
	public String adminProductDataDeleteGet(int idx) {
		int res = 0;
		int res2 = 0;
		
		res = adminService.setAdminProductDataDeleteByIdx(idx);
		if(res !=0) {
			System.out.println("res 처음 부분 : "+res);
			res = adminService.setAdminProductImagesDeleteByIdx(idx);
			System.out.println("res 다시 부분 : "+res);
			if(res !=0) {
				System.out.println("res2두번쨰 : "+res);
				return "redirect:/message/adminProductDataDeleteOk";
			}else if(res== 0) {
				System.out.println("res23번째 : "+res);
				return "redirect:/message/adminProductDataImageDeleteNo";
			}
		}
		System.out.println("res마지막 : "+res);
		System.out.println("res2마지막 : "+res2);
		return "redirect:/message/adminProductDataDeleteNo";
	}
	
	//관리자 최근 주문 목록
	@RequestMapping(value = "/adminOrderList", method = RequestMethod.GET)
	public String adminOrderListGet(Model model,
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
		
		PageVO pageVO =pageProcess.totBoardRecCnt(pag, pageSize, boardType,category, option,subOption,part, searchString,viewCheckOption);//뒷부분 비어있는건 확장성을 위한 보조필드
		
		List<OrderItemsVO> vos = adminService.getAdminOrderList(option,subOption,part, searchString,pageVO.getStartIndexNo(), pageSize);
		
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("section",section);
		model.addAttribute("category","orders");
		
		model.addAttribute("vos", vos);
		return "admin/adminOrderList";
	}
	
	//주문 데이터 옵션 리스트 가져오기
	@ResponseBody
	@RequestMapping(value = "/adminOrderOptionDataList", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String adminOrderOptionDataListPost(String optionData) {
		if(!optionData.equalsIgnoreCase("productName")&&!optionData.equalsIgnoreCase("customerMid")) {
			return "redirect://message/wrongAccess";
		}
		
		List<String> optionDataList = adminService.getAdminOrderOptionDataList(optionData);
		
		Gson gson = new Gson();
		
		String res =  gson.toJson(optionDataList);
		
		return res;
	}
	
//어드민 관리자 주문 데이터 전체 리스트 파이차트용 
	@ResponseBody
	@RequestMapping(value = "/adminOrderDataChartCountList", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String adminOrderDataChartCountListPost(String chartSelectValue, String chartType, String listType) {
		//chartSelectValue = 선택타입 차트타입=파이 리스트타입=all
		HashMap<String, Integer> dataMap = new HashMap<String, Integer>();
		List<String> LabelList = new ArrayList<String>();
    HashMap<String, String> colorMap = new HashMap<String, String>();
    List<String> optionList = new ArrayList<String>();
    //_4type=저온다습 등
    
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
	
	//사진전송 
	@RequestMapping(value = "/adminImageUpload", method = RequestMethod.POST)
	public void imageUpload(MultipartFile upload, HttpServletRequest request, HttpServletResponse response) throws IOException {
	
		//한글 인코딩
		//서버로 간게 아니라 브라우저에 떠있는거라 필터를 안거침 그래서 한글처리가 필요
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/ckeditor/");//매핑 경로 아니고 실제 경로 리소시즈 부터 직접적어야함
		//원본이름
		String oFileName = upload.getOriginalFilename();
		//파일명 중복방지를 위한 이름 설정 여긴 date사용 (JSP-칼렌더,UUID 방법)
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss"); //날짜만 하면 겹칠수 있어서 시간도 추가
		oFileName = sdf.format(date)+"_"+oFileName;
		
		//파일 서버로 업로드 처리
		//알아서 다해주니까 에외처리는 던지기
		byte[] bytes = upload.getBytes(); //바이너리를 바이트로 바꿔줌 서버-서버는 2048,4096 중에 사용 인풋에서-아웃풋으로도 마찬가지
		//저장되는 위치의 파일명과 위치 껍데기를 만들고 채우는것 
		FileOutputStream fos = new FileOutputStream(new File(realPath+oFileName));//우리가 만든 껍데기 파일 넣기
		fos.write(bytes);
		//이러면 ckeditor에 저장됨
		//여기까지 파일 업로드
		
		//브라우저에 서버에 전송된 그림을 표시시켜주기
		PrintWriter out = response.getWriter();
		String fileUrl = request.getContextPath()+"/data/ckeditor/"+oFileName; //맨앞 /=도메인
		
		String jsonResponse = commonClass.createJsonResponse(oFileName, 1, fileUrl);
		
		out.println(jsonResponse); //JSON 포맷
		//out.println("{\"originalFilename\":\""+oFileName+"\",\"uploaded\":1,\"url\":\""+fileUrl+"\"}"); //JSON 포맷 {"":"",}같은식이라 \"를 써야한다
		
		out.flush();
		fos.close();
		
	}
	
//data 폴더 아래쪽의 '폴더명/파일명'들을 다운받고자 할때 수행하는 메소드
	@RequestMapping(value = "/fileDownAction", method = RequestMethod.GET)
	//헤드에 담아 넣어서 보내는거라 response도 있어야 함 jsp랑 같다 
	public void fileDownActionGet(HttpServletRequest request,HttpServletResponse response,String path, String file) throws IOException {
		if(path.equals("pds")) path += "/temp/";
		
		String realPathFile = request.getSession().getServletContext().getRealPath("/resources/data/"+path)+file;//확장성을 위해 path 사용
		
		File downFile = new File(realPathFile);//위에서 경로랑 파일명 합쳐둠
		
		String downFileName = new String(file.getBytes("utf-8"), "8859_1");//윈도우 기본 인코딩을 변경-예외처리
		//헤더에 넣기
		response.setHeader("Content-Dispositon", "attachment;filename="+downFileName);//(예약어),첨부하겠다(예약어) 전부 대소문자 구분한다
		
		//서버-클라이언트(서블릿아웃풋)
		FileInputStream fis = new FileInputStream(downFile); //서버쪽
		ServletOutputStream sos = response.getOutputStream();
		
		byte[] bytes = new byte[2048];
		int data = 0;
		while ((data=fis.read(bytes,0,bytes.length))!= -1) {
			sos.write(bytes, 0, data);
		}
		sos.flush();
		sos.close();
		fis.close();
		
		//다운로드 완료후에 서버에 저장된 zip파일을 삭제처리한다
		downFile.delete();
	}
	
	
}
