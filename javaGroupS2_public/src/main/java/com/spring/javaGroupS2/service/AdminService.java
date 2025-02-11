package com.spring.javaGroupS2.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaGroupS2.vo.BoardFilesVO;
import com.spring.javaGroupS2.vo.BoardVO;
import com.spring.javaGroupS2.vo.DeleteMemberVO;
import com.spring.javaGroupS2.vo.MemberVO;
import com.spring.javaGroupS2.vo.OrderItemsVO;
import com.spring.javaGroupS2.vo.PlantDataVO;
import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;

public interface AdminService {

	int getAdminDeleteMemberCount(String date);

	int getAdminMemberTrendCount(String date);

	int getAdminMemberCountStats(String day, String condition, String timeCheck,String typeFlag);

	int getAdminMemberCountStatsWeek(String firstDate, String lastDate, String condition, String timeCheck,String typeFlag);

	List<MemberVO> getAdminAllMembers(String viewCheckOption,String viewCheckOption_2,String part,String searchString,int startIndexNo, int pageSize);

	List<MemberVO> getAdminNewMembers(String viewCheckOption, String viewCheckOption_2, String part, String searchString, int startIndexNo, int pageSize);

	List<MemberVO> getAdminWithdrawMembers(String viewCheckOption, String viewCheckOption_2, String part, String searchString, int startIndexNo, int pageSize);

	int getAdminMemberCount(String option, String viewCheckOption, String viewCheckOption_2);

	int setAdminMemberLevelChangeByIdx(int idx, int level);

	int setAdminMemberLoginTypeChangeByIdx(int idx, String loginType);

	List<String> allMemberOptionSearchOptionList(String option,String type);

	int getAdminMemberSearchCount(String option, String viewCheckOption, String viewCheckOption_2, String part, String searchString);

	int setAdminMemberActivateByIdx(int idx);

	int setAdminMemberDeleteByIdx(int idx);

	int setAdminMemberDeleteTableRestore(String mid);

	int setAdminMemberDeleteByMid(String mid);

	int setAdminMemberDeleteTableInsert(String mid, String deleteType, String deleteComment);

	DeleteMemberVO getAdminMemberDeleteTableByMid(String mid);

	int setadminMemberDeleteTableUpdateByMid(String deleteMid, String deleteType, String deleteReason,
			String deleteComment);

	MemberVO getAdminMemberInfoByIdx(int idx);

	MemberVO getAdminMemberInfoByMid(String mid);

	int setAdminMemberInfoUpdate(MemberVO vo, String midCheck, String pwdCheck, String userDelCheck,int idx2);

	Integer getAdminMemberCountListChart(String chartSelectValue, String option, String listType, String chartType);

	int getAdminNoticeBoardListCount(String category, String part, String searchString);

	List<BoardVO> getAdminNoticeBoardList(int startIndexNo, int pageSize, String category);

	List<BoardVO> getAdminNoticeBoardSearchList(int startIndexNo, int pageSize, String part, String searchString);

	BoardVO getAdminNoticeBoardContentByIdx(int idx);

	int setAdminNoticeBoardInputOk(BoardVO vo, MultipartFile[] files) throws IOException;

	List<BoardFilesVO> getAdminNoticeBoardFilesByIdx(int idx);

	int setAdminNoticeBoardFilesDeleteByIdx(int idx);

	int setAdminNoticeBoardContentDeleteByIdx(int idx);

	void setAdminNoticeBoardViewCountIncreaseByIdx(int idx);

	int setAdminNoticeBoardContentUpdateByIdx(BoardVO vo, ArrayList<String> deleteCheckServer, ArrayList<String> deleteCheckOriginal, MultipartFile[] files, int eIdx);

	int setAdminPlantDataInput(PlantDataVO vo);

	List<PlantDataVO> getAdminPlantDataList(String option, String subOption, String part, String searchString, int startIndexNo, int pageSize);

	int getAdminPlantDataListCount(String option, String subOption, String part, String searchString);

	PlantDataVO getAdminPlantDataByIdx(int idx);

	int setAdminPlantStatusChangeByIdx(int idx, String status);

	int setAdminPlantLightLevelChangeByIdx(int idx, String lightLevel);

	PlantDataVO getAdminPlantNameDuplicateCheckGet(String plantName);

	List<String> getAdminPlantOptionDataList(String optionData);

	List<String> getAdminPlantDataOptionSearchOptionList(String option, String type);

	Integer getAdminPlantDataCountListChart(String chartSelectValue, String option, String listType, String chartType);

	int setAdminPlantDataUpdateByIdx(PlantDataVO vo, int idx2);

	int getAdminMainCalendarInfoCnt(String option, String day);

	int getAdminMainCalendarInfoOrderCnt(String option, String day);

	int setAdminPlantDataDelete(int idx);

	ProductDataVO getAdminProductNameDuplicateCheck(String productName);

	List<ProductDataVO> getProductDataListByName(String searchWord);

	List<PlantDataVO> getAdminPlantDataListByName(String searchWord, String dataType);

	int setAdminProductDataInsert(ProductDataVO vo);

	PlantDataVO getAdminPlantDataByName(String productPlantName);

	int getAdminProductDataListCount(String option, String subOption, String part, String searchString);

	List<ProductDataVO> getAdminProductDataList(String option, String subOption, String part, String searchString,
			int startIndexNo, int pageSize);

	int setAdminProductStatusChangeByIdx(int idx, String productStatus);

	List<String> getAdminProductOptionDataList(String optionData);

	int setAdminProductImageInsert(ProductImageVO imageVO);
	
	List<String> getAdminProductDataOptionSearchOptionList(String option, String type);
	
	Integer getAdminProductDataCountListChart(String chartSelectValue, String option, String listType, String chartType);

	ProductDataVO getAdminProductDataByIdx(int idx);

	ProductImageVO getAdminProductImageByIdx(int idx);

	int setAdminProductDataUpdate(ProductDataVO vo, int currentIdx);

	int setAdminProductImageUpdate(ProductImageVO imageVO, int currentIdx);

	int setAdminProductDataDeleteByIdx(int idx);

	int setAdminProductImagesDeleteByIdx(int idx);

	int getAdminOrderListCount(String option, String subOption, String part, String searchString);

	List<OrderItemsVO> getAdminOrderList(String option, String subOption, String part, String searchString,
			int startIndexNo, int pageSize);

	List<String> getAdminOrderOptionDataList(String optionData);

	List<String> getAdminOrderDataOptionSearchOptionList(String option, String type);
	
	Integer getAdminOrderDataCountListChart(String chartSelectValue, String option, String listType, String chartType);

}
