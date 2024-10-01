package com.itbank.mavenNego;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.itbank.mavenNego.dto.CateDTO;
import com.itbank.mavenNego.dto.MboardDTO;
import com.itbank.mavenNego.service.MboardMapper;
import com.itbank.mavenNego.service.NegoMapper;

@Controller
public class MboardController {

	@Autowired
	MboardMapper mboardMapper;
	
	@Autowired
	NegoMapper negoMapper;
	
	@RequestMapping("/mboard.do")
	public String mboardList(HttpServletRequest req, @RequestParam(value = "search", required = false) String search) {
		
		List<CateDTO> mainList = negoMapper.mainList();
		req.setAttribute("mainList", mainList);
		
		for (CateDTO mainCategory : mainList) {
			List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
			mainCategory.setSubList(subList);
			
			for (CateDTO subCategory : subList) {
				List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
				subCategory.setItemList(itemList);
			}
		}
		
		/*
		  List<MboardDTO> list = mboardMapper.boardList();
		 req.setAttribute("mboardList",list); return "mboard/main";
		 */
		int pageSize = 5; // 한 페이지당 보여줄 게시물 수
	    String pageNumStr = req.getParameter("pageNum"); // 현재 페이지 번호를 파라미터로 받아옴

	    int pageNum = (pageNumStr == null) ? 1 : Integer.parseInt(pageNumStr); // 현재 페이지 번호, 기본값은 1

	    // 게시판 목록 가져오기
	    List<MboardDTO> list = mboardMapper.boardList();
	    int totalCount;

        if (search != null && !search.isEmpty()) {
            list = mboardMapper.searchMboardList(search);
            totalCount = list.size(); // 검색 결과의 전체 게시물 수
        } else {
            list = mboardMapper.boardList();
            totalCount = list.size(); // 전체 게시물 수
        }
	    // 현재 페이지에 해당하는 게시물만 자르기
	    int start = (pageNum - 1) * pageSize;
	    int end = Math.min(start + pageSize, totalCount);
	    List<MboardDTO> paginatedList = list.subList(start, end);

	    // 페이지 정보 계산
	    int pageCount = (int) Math.ceil((double) totalCount / pageSize); // 전체 페이지 수
	    int pageBlock = 5; // 페이지 블록 사이즈
	    int startPage = (pageNum - 1) / pageBlock * pageBlock + 1; // 시작 페이지 번호
	    int endPage = Math.min(startPage + pageBlock - 1, pageCount); // 끝 페이지 번호

	    // 결과를 request에 저장
	    req.setAttribute("count", totalCount);
	    req.setAttribute("mboardList", paginatedList); // 현재 페이지에 해당하는 게시판 목록
	    req.setAttribute("pageNum", pageNum); // 현재 페이지 번호
	    req.setAttribute("pageCount", pageCount); // 전체 페이지 수
	    req.setAttribute("startPage", startPage); // 시작 페이지 번호
	    req.setAttribute("endPage", endPage); // 끝 페이지 번호
	    req.setAttribute("search", search);
	    
	    return "nego/header/mboard/mboard"; // View로 전달할 JSP 페이지 이름
	}
	
	@RequestMapping(value="/write_board.do", method=RequestMethod.GET)
	public String writeFormBoard(HttpServletRequest req, @RequestParam(value = "num", required = false, defaultValue = "0") Integer num) {
		List<CateDTO> mainList = negoMapper.mainList();
		req.setAttribute("mainList", mainList);
		
		for (CateDTO mainCategory : mainList) {
			List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
			mainCategory.setSubList(subList);
			
			for (CateDTO subCategory : subList) {
				List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
				subCategory.setItemList(itemList);
			}
		}
		
		 MboardDTO dto = new MboardDTO();
		if(num !=0) {
		 dto = mboardMapper.getBoard(num);
		}else {
			dto.setNum(0);
	        dto.setRe_step(0);
	        dto.setRe_level(0);
		}
		req.setAttribute("getBoard",dto);
		return "nego/header/mboard/writeForm";
	}
	
	@RequestMapping(value="/write_board.do", method=RequestMethod.POST)
	public String writeProBoard(HttpServletRequest req, MboardDTO dto) {
		List<CateDTO> mainList = negoMapper.mainList();
		req.setAttribute("mainList", mainList);
		
		for (CateDTO mainCategory : mainList) {
			List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
			mainCategory.setSubList(subList);
			
			for (CateDTO subCategory : subList) {
				List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
				subCategory.setItemList(itemList);
			}
		}
		
		 if (dto.getNum() == 0) {    // 새 글인 경우
			 mboardMapper.updateNewSetp(dto.getNum());
		        dto.setRe_step(0);
		        dto.setRe_level(0);
		    } else {                    // 답글인 경우
		    	mboardMapper.updateReStep(dto.getRe_step());
		        dto.setRe_step(dto.getRe_step() + 1);
		        dto.setRe_level(dto.getRe_level() + 1);
		    }
		    int res = mboardMapper.insertBoard(dto);
		    return "redirect:mboard.do";
	}
	
	@RequestMapping("/content_board.do")
	public String contentBoard(HttpServletRequest req, int num) {
		List<CateDTO> mainList = negoMapper.mainList();
		req.setAttribute("mainList", mainList);
		
		for (CateDTO mainCategory : mainList) {
			List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
			mainCategory.setSubList(subList);
			
			for (CateDTO subCategory : subList) {
				List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
				subCategory.setItemList(itemList);
			}
		}
		
		int res = mboardMapper.plusReadcount(num);
		MboardDTO dto = mboardMapper.getBoard(num);
		req.setAttribute("getBoard",dto);
		return "nego/header/mboard/content";
		
	}
	
	@RequestMapping(value="/update_board.do", method=RequestMethod.GET)
	public String updateFormBoard(HttpServletRequest req, int num) {
		List<CateDTO> mainList = negoMapper.mainList();
		req.setAttribute("mainList", mainList);
		
		for (CateDTO mainCategory : mainList) {
			List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
			mainCategory.setSubList(subList);
			
			for (CateDTO subCategory : subList) {
				List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
				subCategory.setItemList(itemList);
			}
		}
		
		MboardDTO dto = mboardMapper.getBoard(num);
		req.setAttribute("getBoard", dto);
		return "nego/header/mboard/updateForm";
	}
	
	@RequestMapping(value="/update_board.do", method=RequestMethod.POST)
	public String updateProBoard(@ModelAttribute MboardDTO dto, BindingResult result) {
		
		if (result.hasErrors()) {	//만약에 dto객체를 만드는 중 오류가 발생했다면.. 
			//여기는 오류를 내가 알아서 해결하는 코드
			dto.setNum(0);
		}
		int res = mboardMapper.updateBoard(dto);
		return "redirect:mboard.do";
	}
	
	@RequestMapping("/delete_board.do")
	public String deleteBoard(HttpServletRequest req, int num) {
		int res = mboardMapper.deleteBoard(num);
		return "redirect:mboard.do";
	}
	
	
}
