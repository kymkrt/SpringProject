package com.spring.javaGroupS2.service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaGroupS2.common.CommonClass;
import com.spring.javaGroupS2.dao.AdminDAO;
import com.spring.javaGroupS2.vo.BoardFilesVO;
import com.spring.javaGroupS2.vo.BoardVO;
import com.spring.javaGroupS2.vo.DeleteMemberVO;
import com.spring.javaGroupS2.vo.MemberVO;
import com.spring.javaGroupS2.vo.OrderItemsVO;
import com.spring.javaGroupS2.vo.PlantDataVO;
import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	AdminDAO adminDAO;
	
	@Autowired
	CommonClass commonClass;

	//관리자 탈퇴회원 수 가져오기 - 시간별
	@Override
	public int getAdminDeleteMemberCount(String date) {
		return adminDAO.getAdminDeleteMemberCount(date);
	}

	//관리자 멤버트렌드 전부 가져오기
	@Override
	public int getAdminMemberTrendCount(String date) {
		return adminDAO.getAdminMemberTrendCount(date);
	}

	//관리자 회원 통계 가져오기(년 월 일)
	@Override
	public int getAdminMemberCountStats(String day, String condition, String timeCheck,String typeFlag) {
		return adminDAO.getAdminMemberCountStats(day, condition, timeCheck,typeFlag);
	}
	
//관리자 회원 통계 가져오기(주간)
	@Override
	public int getAdminMemberCountStatsWeek(String firstDate, String lastDate, String condition, String timeCheck,String typeFlag) {
		return adminDAO.getAdminMemberCountStatsWeek(firstDate, lastDate, condition, timeCheck,typeFlag);
	}
	
//어드민 전체 멤버리스트(vo로 탈퇴회원 포함) 
	@Override
	public List<MemberVO> getAdminAllMembers(String viewCheckOption,String viewCheckOption_2,String part,String searchString,int startIndexNo, int pageSize) {
		return adminDAO.getAdminAllMembers(viewCheckOption,viewCheckOption_2,part,searchString,startIndexNo, pageSize);
	}

//어드민 전체 신규 멤버리스트(vo로 탈퇴회원 포함) 
	@Override
	public List<MemberVO> getAdminNewMembers(String viewCheckOption, String viewCheckOption_2, String part, String searchString, int startIndexNo, int pageSize) {
		return adminDAO.getAdminNewMembers(viewCheckOption, viewCheckOption_2, part, searchString, startIndexNo, pageSize);
	}

	//어드민 전체 탈퇴 멤버리스트
	@Override
	public List<MemberVO> getAdminWithdrawMembers(String viewCheckOption, String viewCheckOption_2, String part, String searchString, int startIndexNo, int pageSize) {
		return adminDAO.getAdminWithdrawMembers(viewCheckOption, viewCheckOption_2, part, searchString, startIndexNo, pageSize);
	}
	
	//어드민 전체 멤버 카운트
	@Override
	public int getAdminMemberCount(String option,String viewCheckOption, String viewCheckOption_2) {
		return adminDAO.getAdminMemberCount(option,viewCheckOption, viewCheckOption_2);
	}

	//어드민 멤버 레벨 변경-idx
	@Override
	public int setAdminMemberLevelChangeByIdx(int idx, int level) {
		return adminDAO.setAdminMemberLevelChangeByIdx(idx, level);
	}

	//어드민 멤버 로그인 타입 회원타입 변경-idx
	@Override
	public int setAdminMemberLoginTypeChangeByIdx(int idx, String loginType) {
		return adminDAO.setAdminMemberLoginTypeChangeByIdx(idx, loginType);
	}
	
	//어드민 멤버 옵션 검색 리스트
	@Override
	public List<String> allMemberOptionSearchOptionList(String option,String type) {
		return adminDAO.allMemberOptionSearchOptionList(option, type);
	}

	//어드민 멤버 검색 카운트
	@Override
	public int getAdminMemberSearchCount(String option, String viewCheckOption, String viewCheckOption_2, String part,
			String searchString) {
		return adminDAO.getAdminMemberSearchCount(option, viewCheckOption, viewCheckOption_2, part,
				searchString);
	}
	//어드민 탈퇴 멤버 복구 시키기-idx
	@Override
	public int setAdminMemberActivateByIdx(int idx) {
		return adminDAO.setAdminMemberActivateByIdx(idx);
	}
	//어드민 멤버 탈퇴시키기 -idx
	@Override
	public int setAdminMemberDeleteByIdx(int idx) {
		return adminDAO.setAdminMemberDeleteByIdx(idx);
	}
	//어드민 탈퇴멤버 복구 delete테이블
	@Override
	public int setAdminMemberDeleteTableRestore(String mid) {
		return adminDAO.setAdminMemberDeleteTableRestore(mid);
	}

	//어드민 멤버 탈퇴시키기 -mid
	@Override
	public int setAdminMemberDeleteByMid(String mid) {
		return adminDAO.setAdminMemberDeleteByMid(mid);
	}

	//어드민 멤버 delete 테이블 데이터 삽입
	@Override
	public int setAdminMemberDeleteTableInsert(String mid, String deleteType, String deleteComment) {
		return adminDAO.setAdminMemberDeleteTableInsert(mid, deleteType, deleteComment);
	}

		//어드민 멤버 delete 테이블 정보 한건 가져오기
	@Override
	public DeleteMemberVO getAdminMemberDeleteTableByMid(String mid) {
		return adminDAO.getAdminMemberDeleteTableByMid(mid);
	}

	//어드민 멤버 delete 테이블 정보 수정하기
	@Override
	public int setadminMemberDeleteTableUpdateByMid(String deleteMid, String deleteType, String deleteReason,
			String deleteComment) {
		return adminDAO.setadminMemberDeleteTableUpdateByMid(deleteMid, deleteType, deleteReason,
				deleteComment);
	}

	//어드민 멤버 정보 수정용 정보 가져오기 - idx
	@Override
	public MemberVO getAdminMemberInfoByIdx(int idx) {
		return adminDAO.getAdminMemberInfoByIdx(idx);
	}

	//어드민 멤버 정보 가져오기-mid
	@Override
	public MemberVO getAdminMemberInfoByMid(String mid) {
		return adminDAO.getAdminMemberInfoByMid(mid);
	}

	//어드민 회원 멤버 정보 수정
	@Override
	public int setAdminMemberInfoUpdate(MemberVO vo, String midCheck, String pwdCheck, String userDelCheck,int idx2) {
		return adminDAO.setAdminMemberInfoUpdate(vo, midCheck, pwdCheck,userDelCheck, idx2);
	}

	//어드민 관리자 멤버 리스트 차트용 카운트 가져오기 
	@Override
	public Integer getAdminMemberCountListChart(String chartSelectValue, String option,String listType ,String chartType) {
		return adminDAO.getAdminMemberCountListChart(chartSelectValue, option,listType ,chartType);
	}

	//어드민 관리자 공지사항 게시판 카운트 가져오기 notice
	@Override
	public int getAdminNoticeBoardListCount(String category, String part, String searchString) {
		return adminDAO.getAdminNoticeBoardListCount(category, part, searchString);
	}

	//어드민 관리자 공지사항 게시판 리스트
	@Override
	public List<BoardVO> getAdminNoticeBoardList(int startIndexNo, int pageSize, String category) {
		return adminDAO.getAdminNoticeBoardList(startIndexNo, pageSize, category);
	}

	//어드민 관리자 검색 공지사항 게시판 리스트
	@Override
	public List<BoardVO> getAdminNoticeBoardSearchList(int startIndexNo, int pageSize, String part, String searchString) {
		return adminDAO.getAdminNoticeBoardSearchList(startIndexNo, pageSize, part, searchString);
	}

	@Override
	public BoardVO getAdminNoticeBoardContentByIdx(int idx) {
		return adminDAO.getAdminNoticeBoardContentByIdx(idx);
	}

	//어드민 관리자 공지사항 게시판 글쓰기
	@Transactional(rollbackFor = Exception.class)
	@Override
	public int setAdminNoticeBoardInputOk(BoardVO vo, MultipartFile[] files) throws IOException {
	    int res = 0;
	    int res2 = 0;
	    List<String> oriFileList = new ArrayList<>();
	    List<String> serFileList = new ArrayList<>();
	    List<Integer> fileSizeList = new ArrayList<>();
	    String path = "/resources/data/board/noticeBoard/";

	    if (files != null && files.length > 0) {
	        for (MultipartFile file : files) {
	            if (!file.isEmpty()) {
	                try {
	                    String oFileName = file.getOriginalFilename();
	                    oriFileList.add(oFileName);

	                    SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
	                    oFileName = sdf.format(new Date()) + "_" + oFileName;
	                    serFileList.add(oFileName);
	                    fileSizeList.add((int) file.getSize());

	                    commonClass.writeFile(file, oFileName, path, null);
	                } catch (IOException e) {
	                    throw new RuntimeException("파일 저장 실패: " + e.getMessage()); // 🚨 예외 발생 시 트랜잭션 롤백
	                }
	            }
	        }
	    }

	    StringBuilder fileListBuilder = new StringBuilder();
	    for (int i = 0; i < oriFileList.size(); i++) {
	        fileListBuilder.append(oriFileList.get(i));
	        if (i != oriFileList.size() - 1) {
	            fileListBuilder.append("/");
	        }
	    }

	    vo.setFile(fileListBuilder.toString().isEmpty() ? null : fileListBuilder.toString());

	    res = adminDAO.setAdminNoticeBoardInputOk(vo);
	    if (res != 0 && !fileListBuilder.toString().isEmpty()) {
	        BoardVO vo2 = adminDAO.getAdminNoticeBoardContentByIdx(vo.getIdx());
	        BoardFilesVO fVo = new BoardFilesVO();
	        
	        for (int i = 0; i < oriFileList.size(); i++) {
	            fVo.setPostIdx(vo2.getIdx());
	            fVo.setPostMid(vo2.getMid());
	            fVo.setPostNickName(vo2.getNickName()); 
	            fVo.setOriginalName(oriFileList.get(i));
	            fVo.setServerName(serFileList.get(i));
	            fVo.setFileSize(fileSizeList.get(i));
	            fVo.setDownloadIp(vo2.getHostIp());
	            //다운, 데이트, 디폴트
	            res2 = adminDAO.setAdminNoticeBoardFilesInput(fVo);
	            if (res2 == 0) {
	                throw new RuntimeException("파일 정보 저장 실패! 트랜잭션 롤백");
	            }else {
	            	return res2; 
	            }
	        }
	    }
	   return res;
	}
	//공지사항 게시판 파일 목록 가져오기
	@Override
	public List<BoardFilesVO> getAdminNoticeBoardFilesByIdx(int idx) {
		return adminDAO.getAdminNoticeBoardFilesByIdx(idx);
	}
	//공지사항 게시판 파일 지우기
	@Override
	public int setAdminNoticeBoardFilesDeleteByIdx(int idx) {
		return adminDAO.setAdminNoticeBoardFilesDeleteByIdx(idx);
	}
	//공지사항 게시판 글 지우기
	@Override
	public int setAdminNoticeBoardContentDeleteByIdx(int idx) {
		return adminDAO.setAdminNoticeBoardContentDeleteByIdx(idx);
	}
	//공지사항게시판 조회수 증가
	@Override
	public void setAdminNoticeBoardViewCountIncreaseByIdx(int idx) {
		adminDAO.setAdminNoticeBoardViewCountIncreaseByIdx(idx);
	}
	//공지사항 글 수정처리 -idx 
	@Override
	public int setAdminNoticeBoardContentUpdateByIdx(BoardVO vo, ArrayList<String> deleteCheckServer,ArrayList<String> deleteCheckOriginal ,MultipartFile[] files,
			int eIdx) {
		//글 테이블, 파일 테이블 수정
		
		 	int res = 0;
	    int res2 = 0;
	    List<String> oriFileList = new ArrayList<>();
	    List<String> serFileList = new ArrayList<>();
	    List<Integer> fileSizeList = new ArrayList<>();
	    String path = "/resources/data/board/noticeBoard/";
	    
	    //파일처리
	    if (files != null && files.length > 0) {
	        for (MultipartFile file : files) {
	            if (!file.isEmpty()) {
	                try {
	                    String oFileName = file.getOriginalFilename();
	                    oriFileList.add(oFileName);

	                    SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
	                    oFileName = sdf.format(new Date()) + "_" + oFileName;
	                    serFileList.add(oFileName);
	                    fileSizeList.add((int) file.getSize());

	                    commonClass.writeFile(file, oFileName, path, null);
	                } catch (IOException e) {
	                    throw new RuntimeException("파일 저장 실패: " + e.getMessage()); 
	                }
	            }
	        }
	    }
	    
	    //보드테이블에 사진 처리하기 
	    StringBuilder fileListBuilder = new StringBuilder();
	    BoardVO tempVo = adminDAO.getAdminNoticeBoardContentByIdx(eIdx);
	    
	    
	    //넘어온 삭제 사진들을 지워야 한다 
	    if (tempVo != null && tempVo.getFile() != null && !tempVo.getFile().isEmpty()) {
	      String existingFile = tempVo.getFile();
	      String[] existingFileArr = existingFile.split("/");
	      List<String> existingFileArrList = new ArrayList<>(Arrays.asList(existingFileArr));
	      if(!CollectionUtils.isEmpty(deleteCheckOriginal)) {
	      	existingFileArrList.removeAll(deleteCheckOriginal);
	      }

        existingFile = existingFileArrList.stream().collect(Collectors.joining("/"));
	      
	      if (!existingFile.endsWith("/") && !existingFile.equals("")) { // 중복 방지
	          fileListBuilder.append(existingFile);
	          fileListBuilder.append("/");
	      } else {
	          fileListBuilder.append(existingFile);
	      }
	    }
	    
	    if (oriFileList != null && !oriFileList.isEmpty()) { // null 및 empty 체크 추가
	      for (int i = 0; i < oriFileList.size(); i++) {
          fileListBuilder.append(oriFileList.get(i));
          if (i != oriFileList.size() - 1) {
              fileListBuilder.append("/");
          }
	      }
	    }
	    String fileList = fileListBuilder.toString();
	    if (fileList.endsWith("/")) {
	      fileList = fileList.substring(0, fileList.length() - 1);
	    }
	    
	    vo.setFile(fileList.isEmpty() ? null : fileList);
	    
	    res = adminDAO.setAdminNoticeBoardContentUpdateOk(vo, eIdx);
	    //&& !fileList.isEmpty()
	    if (res != 0) {
	        BoardVO vo2 = adminDAO.getAdminNoticeBoardContentByIdx(eIdx);
	        BoardFilesVO fVo = new BoardFilesVO();
	        
	        for (int i = 0; i < oriFileList.size();i++) {
	            fVo.setPostIdx(eIdx);
	            fVo.setPostMid(vo2.getMid());
	            fVo.setPostNickName(vo2.getNickName()); 
	            fVo.setOriginalName(oriFileList.get(i));
	            fVo.setServerName(serFileList.get(i));
	            fVo.setFileSize(fileSizeList.get(i));
	            fVo.setDownloadIp(vo2.getHostIp());
	            //다운, 데이트, 디폴트
	            res2 = adminDAO.setAdminNoticeBoardFilesInput(fVo);
	            if (res2 == 0) {
	                throw new RuntimeException("파일 정보 저장 실패! 트랜잭션 롤백"); 
	            }
	        }
	        //null과 ""을 동시에 체크. 그냥 isEmpty면 ""만 체크 []가 있으면 true
	        if(res2 != 0 && !CollectionUtils.isEmpty(deleteCheckServer)) {
	        	for(String fName :deleteCheckServer) {
	        		res = adminDAO.setAdminNoticeBoardFilesDeleteByServerName(fName);
	        		if(res ==0) {
	        			throw new RuntimeException("파일 정보 저장 실패! 트랜잭션 롤백"); 
	        		}
	        	}
	        }
			return res;
	   }
		return res;
	}
	//관리자페이지 식물데이터 넣기
	@Override
	public int setAdminPlantDataInput(PlantDataVO vo) {
		return adminDAO.setAdminPlantDataInput(vo);
	}
	//관리자 식물데이터 리스트 가져오기
	@Override
	public List<PlantDataVO> getAdminPlantDataList(String option, String subOption, String part, String searchString, int startIndexNo, int pageSize) {
		return adminDAO.getAdminPlantDataList(option, subOption, part, searchString, startIndexNo, pageSize);
	}
	//식물데이터 리스트 전체숫자 가져오기
	@Override
	public int getAdminPlantDataListCount(String option, String subOption, String part, String searchString) {
		return adminDAO.getAdminPlantDataListCount(option, subOption, part, searchString);
	}
	//식물데이터 한건 가져오기-idx
	@Override
	public PlantDataVO getAdminPlantDataByIdx(int idx) {
		return adminDAO.getAdminPlantDataByIdx(idx);
	}
	//식물 상태 변경 -idx
	@Override
	public int setAdminPlantStatusChangeByIdx(int idx, String status) {
		return adminDAO.setAdminPlantStatusChangeByIdx(idx, status);
	}
	//식물 광량 변경
	@Override
	public int setAdminPlantLightLevelChangeByIdx(int idx, String lightLevel) {
		return adminDAO.setAdminPlantLightLevelChangeByIdx(idx, lightLevel);
	}

	@Override
	public PlantDataVO getAdminPlantNameDuplicateCheckGet(String plantName) {
		return adminDAO.getAdminPlantNameDuplicateCheckGet(plantName);
	}
	//분류별 검색용 옵션 리스트가져오기
	@Override
	public List<String> getAdminPlantOptionDataList(String optionData) {
		return adminDAO.getAdminPlantOptionDataList(optionData);
	}
	//차트용 식물 데이터 옵션 목록 가져오기
	@Override
	public List<String> getAdminPlantDataOptionSearchOptionList(String option, String type) {
		return adminDAO.getAdminPlantDataOptionSearchOptionList(option, type);
	}
	//어드민 관리자 식물 데이터 차트용 카운트 가져오기 
	@Override
	public Integer getAdminPlantDataCountListChart(String chartSelectValue, String option, String listType,
			String chartType) {
		return adminDAO.getAdminPlantDataCountListChart(chartSelectValue, option, listType,
				chartType);
	}
	//식물 데이터 업데이트
	@Override
	public int setAdminPlantDataUpdateByIdx(PlantDataVO vo, int idx2) {
		return adminDAO.setAdminPlantDataUpdateByIdx(vo, idx2);
	}
	//달력용 데이터 가져오기
	@Override
	public int getAdminMainCalendarInfoCnt(String option, String day) {
		return adminDAO.getAdminMainCalendarInfoCnt(option, day);
	}
	//달력용 상품 데이터 가져오기
	@Override
	public int getAdminMainCalendarInfoOrderCnt(String option, String day) {
		return adminDAO.getAdminMainCalendarInfoOrderCnt(option, day);
	}

	//식물 데이터 삭제하기
	@Override
	public int setAdminPlantDataDelete(int idx) {
		return adminDAO.setAdminPlantDataDelete(idx);
	}
	//상품데이터 중복확인 ajax
	@Override
	public ProductDataVO getAdminProductNameDuplicateCheck(String productName) {
		return adminDAO.getAdminProductNameDuplicateCheck(productName);
	}

	//상품 데이터 목록 검색-이름 ajax
	@Override
	public List<ProductDataVO> getProductDataListByName(String searchWord) {
		return adminDAO.getProductDataListByName(searchWord);
	}

	//공통 식물 데이터 목록  검색-이름 ajax
	@Override
	public List<PlantDataVO> getAdminPlantDataListByName(String searchWord, String dataType) {
		return adminDAO.getAdminPlantDataListByName(searchWord, dataType);
	}
	//상품데이터 정보 저장처리
	@Override
	public int setAdminProductDataInsert(ProductDataVO vo) {
		return adminDAO.setAdminProductDataInsert(vo);
	}
	//상품데이터 가져오기- 이름-상품명
	@Override
	public PlantDataVO getAdminPlantDataByName(String productPlantName) {
		return adminDAO.getAdminPlantDataByName(productPlantName);
	}
	//상품 데이터 카운트
	@Override
	public int getAdminProductDataListCount(String option, String subOption, String part, String searchString) {
		return adminDAO.getAdminProductDataListCount(option, subOption, part, searchString);
	}
	//상품게시판 데이터 목록
	@Override
	public List<ProductDataVO> getAdminProductDataList(String option, String subOption, String part, String searchString,
			int startIndexNo, int pageSize) {
		return adminDAO.getAdminProductDataList(option, subOption, part, searchString,
				startIndexNo, pageSize);
	}
	//상품 판매상태 변경 -idx ajax
	@Override
	public int setAdminProductStatusChangeByIdx(int idx, String productStatus) {
		return adminDAO.setAdminProductStatusChangeByIdx(idx, productStatus);
	}
	//상품 옵션 데이터 리스트
	@Override
	public List<String> getAdminProductOptionDataList(String optionData) {
		return adminDAO.getAdminProductOptionDataList(optionData);
	}
	//상품 이미지 데이터 삽입
	@Override
	public int setAdminProductImageInsert(ProductImageVO imageVO) {
		return adminDAO.setAdminProductImageInsert(imageVO);
	}
	//차트용 상품 데이터 옵션 목록 가져오기
	@Override
	public List<String> getAdminProductDataOptionSearchOptionList(String option, String type) {
		return adminDAO.getAdminProductDataOptionSearchOptionList(option, type);
	}
	//어드민 관리자 상품 데이터 차트용 카운트 가져오기 
	@Override
	public Integer getAdminProductDataCountListChart(String chartSelectValue, String option, String listType,
			String chartType) {
		return adminDAO.getAdminProductDataCountListChart(chartSelectValue, option, listType,
				chartType);
	}
	//상품데이터 정보 한건 가져오기
	@Override
	public ProductDataVO getAdminProductDataByIdx(int idx) {
		return adminDAO.getAdminProductDataByIdx(idx);
	}
	//상품 데이터 사진 가져오기
	@Override
	public ProductImageVO getAdminProductImageByIdx(int idx) {
		return adminDAO.getAdminProductImageByIdx(idx);
	}
	
	//상품 데이터 정보 수정처리
	@Override
	public int setAdminProductDataUpdate(ProductDataVO vo, int currentIdx) {
		return adminDAO.setAdminProductDataUpdate(vo, currentIdx);
	}
	//상품 데이터 이미지 수정처리
	@Override
	public int setAdminProductImageUpdate(ProductImageVO imageVO, int currentIdx) {
		return adminDAO.setAdminProductImageUpdate(imageVO, currentIdx);
	}
	//상품데이터 삭제처리
	@Override
	public int setAdminProductDataDeleteByIdx(int idx) {
		return adminDAO.setAdminProductDataDeleteByIdx(idx);
	}
	//상품데이터 이미지 삭제처리
	@Override
	public int setAdminProductImagesDeleteByIdx(int idx) {
		return adminDAO.setAdminProductImagesDeleteByIdx(idx);
	}
	
	//주문 목록 카운트 가져오기
	@Override
	public int getAdminOrderListCount(String option, String subOption, String part, String searchString) {
		return adminDAO.getAdminOrderListCount(option, subOption, part, searchString);
	}
	//상품 리스트 가져오기
	@Override
	public List<OrderItemsVO> getAdminOrderList(String option, String subOption, String part, String searchString,
			int startIndexNo, int pageSize) {
		return adminDAO.getAdminOrderList(option, subOption, part, searchString,
				startIndexNo, pageSize);
	}
	//옵션데이터 리스트 가져오기
	@Override
	public List<String> getAdminOrderOptionDataList(String optionData) {
		return adminDAO.getAdminOrderOptionDataList(optionData);
	}
	//차트용 주문 데이터 옵션 목록 가져오기
	@Override
	public List<String> getAdminOrderDataOptionSearchOptionList(String option, String type) {
		return adminDAO.getAdminOrderDataOptionSearchOptionList(option, type);
	}
	//어드민 관리자 주문 데이터 차트용 카운트 가져오기 
	@Override
	public Integer getAdminOrderDataCountListChart(String chartSelectValue, String option, String listType,
			String chartType) {
		return adminDAO.getAdminOrderDataCountListChart(chartSelectValue, option, listType,
				chartType);
	}
}