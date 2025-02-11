package com.spring.javaGroupS2.pagenation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.spring.javaGroupS2.service.AdminService;
import com.spring.javaGroupS2.service.PageService;
import com.spring.javaGroupS2.service.ProductService;

@Component
//서비스?
public class PageProcess {
	
	@Autowired
	PageService pageService;
	
	@Autowired
	AdminService adminService;

	@Autowired
	ProductService productService;
	
	public PageVO getAllPagenation(int pag, int pageSize, String table) {
		
		PageVO vo = new PageVO();//이안에 매개변수들도 많을예정
		//내용 채우기 메소드 같은거 
		int totRecCnt =  1;//pageService.getTotRecCnt(table); //$처리
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStartNo = totRecCnt - startIndexNo;
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage - 1) / blockSize;
		
		vo.setTable(table);
		vo.setPag(pag);
		vo.setPageSize(pageSize);
		vo.setTotRecCnt(totRecCnt);
		vo.setTotPage(totPage);
		vo.setStartIndexNo(startIndexNo);
		vo.setCurScrStartNo(curScrStartNo);
		vo.setBlockSize(blockSize);
		vo.setCurBlock(curBlock);
		vo.setLastBlock(lastBlock);
		
		return vo;
	}

	//선생님것 section 테이블
	public PageVO totRecCnt(int pag, int pageSize, String section, String option,String viewCheckOption,String viewCheckOption_2,String part, String searchString) {
		PageVO pageVO = new PageVO();
		
		int totRecCnt = 0;
		String search = "";
		
		if(section.equals("adminMember")) {
		 if(part.equals("")&&searchString.equals("")) {
			 totRecCnt = adminService.getAdminMemberCount(option, viewCheckOption,viewCheckOption_2);
		 }
		 else {
			 totRecCnt = adminService.getAdminMemberSearchCount(option, viewCheckOption,viewCheckOption_2,part,searchString);
		 }
		}
		else if(section.equals("member")) {
			
		}
		else if(section.equals("admin_board")) {
		}
	
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStartNo = totRecCnt - startIndexNo;
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage - 1) / blockSize;
		
		pageVO.setPag(pag);
		pageVO.setPageSize(pageSize);
		pageVO.setTotRecCnt(totRecCnt);
		pageVO.setTotPage(totPage);
		pageVO.setStartIndexNo(startIndexNo);
		pageVO.setCurScrStartNo(curScrStartNo);
		pageVO.setBlockSize(blockSize);
		pageVO.setCurBlock(curBlock);
		pageVO.setLastBlock(lastBlock);
		
		pageVO.setSearch(search);
		pageVO.setSearchString(searchString);
		
		pageVO.setPart(part);
		
		//검색기에서 search와 searchString을 처리 할때 사용
		String searchTitle = "";
		if(!searchString.equals("")) {
			switch (part) {
				case "title": searchTitle ="제목"; break;
				case "nickName": searchTitle ="글쓴이"; break;
				case "content": searchTitle ="글내용"; break;
			}
			pageVO.setSearchTitle(searchTitle);
		}
		
		return pageVO;
	}
	
	//보드용
	public PageVO totBoardRecCnt(int pag, int pageSize, String boardType, String category, String option,String subOption,String part, String searchString, String viewCheckOption) {
		PageVO pageVO = new PageVO();
		
		int totRecCnt = 0;
		String search = "";
		
		if(boardType.equals("notice")) {
				totRecCnt = adminService.getAdminNoticeBoardListCount(category,part ,searchString);
		}
		else if(boardType.equals("plantData")) {
			if(viewCheckOption.equals("")) {
				totRecCnt = adminService.getAdminPlantDataListCount(option,subOption,part ,searchString);
			}
			else if(!viewCheckOption.equals("")) {
				totRecCnt = adminService.getAdminPlantDataListCount(option,subOption,part ,searchString);
			}
		}
		else if(boardType.equals("productData")) {
			if(viewCheckOption.equals("")) {
				totRecCnt = adminService.getAdminProductDataListCount(option,subOption,part ,searchString);
			}
			else if(!viewCheckOption.equals("")) {
				totRecCnt = adminService.getAdminProductDataListCount(option,subOption,part ,searchString);
			}
		}
		else if(boardType.equals("productPlant")) {
			totRecCnt = productService.getProductPlantDataListCount(option,subOption,part,searchString,viewCheckOption);
		}
		else if(boardType.equals("ordersDataAdmin")) {
			if(viewCheckOption.equals("")) {
				totRecCnt = adminService.getAdminOrderListCount(option,subOption,part ,searchString);
			}
			else if(!viewCheckOption.equals("")) {
				totRecCnt = adminService.getAdminOrderListCount(option,subOption,part ,searchString);
			}
		}
		else if(boardType.equals("ordersDataMember")) {
		}
		
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStartNo = totRecCnt - startIndexNo;
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage - 1) / blockSize;
		
		pageVO.setPag(pag);
		pageVO.setPageSize(pageSize);
		pageVO.setTotRecCnt(totRecCnt);
		pageVO.setTotPage(totPage);
		pageVO.setStartIndexNo(startIndexNo);
		pageVO.setCurScrStartNo(curScrStartNo);
		pageVO.setBlockSize(blockSize);
		pageVO.setCurBlock(curBlock);
		pageVO.setLastBlock(lastBlock);
		
		pageVO.setSearch(search);
		pageVO.setSearchString(searchString);
		
		pageVO.setPart(part);
		
		
		return pageVO;
	}
}
