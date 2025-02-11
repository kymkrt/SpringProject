package com.spring.javaGroupS2.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javaGroupS2.vo.BoardFilesVO;
import com.spring.javaGroupS2.vo.BoardVO;
import com.spring.javaGroupS2.vo.DeleteMemberVO;
import com.spring.javaGroupS2.vo.MemberVO;
import com.spring.javaGroupS2.vo.OrderItemsVO;
import com.spring.javaGroupS2.vo.PlantDataVO;
import com.spring.javaGroupS2.vo.ProductDataVO;
import com.spring.javaGroupS2.vo.ProductImageVO;

public interface AdminDAO {

	int getAdminDeleteMemberCount(@Param("date") String date);

	int getAdminMemberTrendCount(@Param("date") String date);

	int getAdminMemberCountStats(@Param("day") String day, @Param("condition") String condition,@Param("timeCheck") String timeCheck,@Param("typeFlag") String typeFlag);
	
	int getAdminMemberCountStatsWeek(@Param("firstDate") String firstDate,@Param("lastDate") String lastDate,@Param("condition") String condition,@Param("timeCheck") String timeCheck,@Param("typeFlag") String typeFlag);

	List<MemberVO> getAdminAllMembers(@Param("viewCheckOption") String viewCheckOption, @Param("viewCheckOption_2") String viewCheckOption_2,@Param("part") String part,@Param("searchString") String searchString, @Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize);

	List<MemberVO> getAdminNewMembers(@Param("viewCheckOption") String viewCheckOption, @Param("viewCheckOption_2") String viewCheckOption_2,@Param("part") String part,@Param("searchString") String searchString, @Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize);

	List<MemberVO> getAdminWithdrawMembers(@Param("viewCheckOption") String viewCheckOption, @Param("viewCheckOption_2") String viewCheckOption_2,@Param("part") String part,@Param("searchString") String searchString, @Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize);

	int getAdminMemberCount(@Param("option") String option,@Param("viewCheckOption") String viewCheckOption,@Param("viewCheckOption_2") String viewCheckOption_2);

	int setAdminMemberLevelChangeByIdx(@Param("idx") int idx, @Param("level") int level);

	int setAdminMemberLoginTypeChangeByIdx(@Param("idx") int idx,@Param("loginType") String loginType);

	List<String> allMemberOptionSearchOptionList(@Param("option") String option,@Param("type") String type);

	int getAdminMemberSearchCount(@Param("option") String option,@Param("viewCheckOption") String viewCheckOption,@Param("viewCheckOption_2") String viewCheckOption_2,@Param("part") String part,@Param("searchString") String searchString);

	int setAdminMemberActivateByIdx(@Param("idx") int idx);

	int setAdminMemberDeleteByIdx(@Param("idx") int idx);

	int setAdminMemberDeleteTableRestore(@Param("mid") String mid);

	int setAdminMemberDeleteByMid(@Param("mid") String mid);

	int setAdminMemberDeleteTableInsert(@Param("mid") String mid,@Param("deleteType") String deleteType,@Param("deleteComment") String deleteComment);

	DeleteMemberVO getAdminMemberDeleteTableByMid(@Param("mid") String mid);

	int setadminMemberDeleteTableUpdateByMid(@Param("deleteMid") String deleteMid,@Param("deleteType") String deleteType,@Param("deleteReason") String deleteReason,@Param("deleteComment")
			String deleteComment);

	MemberVO getAdminMemberInfoByIdx(@Param("idx") int idx);

	MemberVO getAdminMemberInfoByMid(@Param("mid") String mid);

	int setAdminMemberInfoUpdate(@Param("vo")MemberVO vo,@Param("midCheck") String midCheck,@Param("pwdCheck") String pwdCheck,@Param("userDelCheck") String userDelCheck,@Param("idx2") int idx2);

	Integer getAdminMemberCountListChart(@Param("chartSelectValue") String chartSelectValue,@Param("option") String option,@Param("listType") String listType,@Param("chartType") String chartType);

	int getAdminNoticeBoardListCount(@Param("category") String category,@Param("part") String part,@Param("searchString") String searchString);

	List<BoardVO> getAdminNoticeBoardList(@Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize,@Param("category") String category);

	List<BoardVO> getAdminNoticeBoardSearchList(@Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize,@Param("part") String part,@Param("searchString") String searchString);

	BoardVO getAdminNoticeBoardContentByIdx(@Param("idx") int idx);

	int setAdminNoticeBoardInputOk(@Param("vo") BoardVO vo);

	int setAdminNoticeBoardFilesInput(@Param("fVo") BoardFilesVO fVo);

	List<BoardFilesVO> getAdminNoticeBoardFilesByIdx(@Param("idx") int idx);

	int setAdminNoticeBoardFilesDeleteByIdx(@Param("idx") int idx);

	int setAdminNoticeBoardContentDeleteByIdx(@Param("idx") int idx);

	void setAdminNoticeBoardViewCountIncreaseByIdx(@Param("idx") int idx);

	int setAdminNoticeBoardFilesDeleteByServerName(@Param("fName") String fName);

	int setAdminNoticeBoardContentUpdateOk(@Param("vo") BoardVO vo,@Param("eIdx") int eIdx);

	int setAdminPlantDataInput(@Param("vo") PlantDataVO vo);

	List<PlantDataVO> getAdminPlantDataList(@Param("option") String option, @Param("subOption") String subOption,@Param("part") String part,@Param("searchString") String searchString,@Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize);

	int getAdminPlantDataListCount(@Param("option") String option,@Param("subOption") String subOption,@Param("part") String part,@Param("searchString") String searchString);

	PlantDataVO getAdminPlantDataByIdx(@Param("idx") int idx);

	int setAdminPlantStatusChangeByIdx(@Param("idx") int idx,@Param("status") String status);

	int setAdminPlantLightLevelChangeByIdx(@Param("idx") int idx,@Param("lightLevel") String lightLevel);

	PlantDataVO getAdminPlantNameDuplicateCheckGet(@Param("plantName") String plantName);

	List<String> getAdminPlantOptionDataList(@Param("optionData") String optionData);

	List<String> getAdminPlantDataOptionSearchOptionList(@Param("option") String option,@Param("type") String type);

	Integer getAdminPlantDataCountListChart(@Param("chartSelectValue") String chartSelectValue,@Param("option") String option,@Param("listType") String listType,@Param("chartType") String chartType);

	int setAdminPlantDataUpdateByIdx(@Param("vo") PlantDataVO vo,@Param("idx2") int idx2);

	int getAdminMainCalendarInfoCnt(@Param("option") String option,@Param("day") String day);
	
	int getAdminMainCalendarInfoOrderCnt(@Param("option") String option,@Param("day") String day);

	int setAdminPlantDataDelete(@Param("idx") int idx);

	ProductDataVO getAdminProductNameDuplicateCheck(@Param("productName") String productName);

	List<ProductDataVO> getProductDataListByName(@Param("searchWord") String searchWord);

	List<PlantDataVO> getAdminPlantDataListByName(@Param("searchWord") String searchWord,@Param("dataType") String dataType);

	int setAdminProductDataInsert(@Param("vo") ProductDataVO vo);

	PlantDataVO getAdminPlantDataByName(@Param("productPlantName") String productPlantName);

	int getAdminProductDataListCount(@Param("option") String option,@Param("subOption") String subOption,@Param("part") String part,@Param("searchString") String searchString);

	List<ProductDataVO> getAdminProductDataList(@Param("option") String option, @Param("subOption") String subOption,@Param("part") String part,@Param("searchString") String searchString,@Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize);

	int setAdminProductStatusChangeByIdx(@Param("idx") int idx,@Param("productStatus") String productStatus);

	List<String> getAdminProductOptionDataList(@Param("optionData") String optionData);

	int setAdminProductImageInsert(@Param("imageVO") ProductImageVO imageVO);
	
	List<String> getAdminProductDataOptionSearchOptionList(@Param("option") String option,@Param("type") String type);

	Integer getAdminProductDataCountListChart(@Param("chartSelectValue") String chartSelectValue,@Param("option") String option,@Param("listType") String listType,@Param("chartType") String chartType);

	ProductDataVO getAdminProductDataByIdx(@Param("idx") int idx);

	ProductImageVO getAdminProductImageByIdx(@Param("idx") int idx);

	int setAdminProductDataUpdate(@Param("vo") ProductDataVO vo,@Param("currentIdx") int currentIdx);

	int setAdminProductImageUpdate(@Param("imageVO") ProductImageVO imageVO, @Param("currentIdx") int currentIdx);

	int setAdminProductDataDeleteByIdx(@Param("idx") int idx);

	int setAdminProductImagesDeleteByIdx(@Param("idx") int idx);

	int getAdminOrderListCount(@Param("option") String option,@Param("subOption") String subOption,@Param("part") String part,@Param("searchString") String searchString);

	List<OrderItemsVO> getAdminOrderList(@Param("option") String option,@Param("subOption") String subOption,@Param("part") String part,@Param("searchString") String searchString,
			@Param("startIndexNo") int startIndexNo,@Param("pageSize") int pageSize);

	List<String> getAdminOrderOptionDataList(@Param("optionData") String optionData);
	
	List<String> getAdminOrderDataOptionSearchOptionList(@Param("option") String option,@Param("type") String type);

	Integer getAdminOrderDataCountListChart(@Param("chartSelectValue") String chartSelectValue,@Param("option") String option,@Param("listType") String listType,@Param("chartType") String chartType);
}
