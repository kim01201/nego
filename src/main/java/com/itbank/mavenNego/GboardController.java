package com.itbank.mavenNego;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.itbank.mavenNego.dto.CateDTO;
import com.itbank.mavenNego.dto.GboardDTO;

import com.itbank.mavenNego.service.GboardMapper;
import com.itbank.mavenNego.service.NegoMapper;

@Controller
public class GboardController {

	@Autowired
	GboardMapper gboardMapper;
	
	@Autowired
	NegoMapper negoMapper;
	
	@RequestMapping("/gboard.do")
    public String gboardList(HttpServletRequest req, @RequestParam(value = "search", required = false) String search) {
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

        int pageSize = 5; // 한 페이지당 보여줄 게시물 수
        String pageNumStr = req.getParameter("pageNum"); // 현재 페이지 번호를 파라미터로 받아옴
        int pageNum = (pageNumStr == null) ? 1 : Integer.parseInt(pageNumStr); // 현재 페이지 번호, 기본값은 1
 
        // 검색어가 있는 경우
        List<GboardDTO> list;
        int totalCount;

        if (search != null && !search.isEmpty()) {
            list = gboardMapper.searchGboardList(search);
            totalCount = list.size(); // 검색 결과의 전체 게시물 수
        } else {
            list = gboardMapper.gboardList();
            totalCount = list.size(); // 전체 게시물 수
        }

        // 현재 페이지에 해당하는 게시물만 자르기
        int start = (pageNum - 1) * pageSize;
        int end = Math.min(start + pageSize, totalCount);
        List<GboardDTO> paginatedList = list.subList(start, end);

        // 페이지 정보 계산
        int pageCount = (int) Math.ceil((double) totalCount / pageSize); // 전체 페이지 수
        int pageBlock = 5; // 페이지 블록 사이즈
        int startPage = (pageNum - 1) / pageBlock * pageBlock + 1; // 시작 페이지 번호
        int endPage = Math.min(startPage + pageBlock - 1, pageCount); // 끝 페이지 번호

        // 결과를 request에 저장
        req.setAttribute("count", totalCount);
        req.setAttribute("gboardList", paginatedList); // 현재 페이지에 해당하는 게시판 목록
        req.setAttribute("pageNum", pageNum); // 현재 페이지 번호
        req.setAttribute("pageCount", pageCount); // 전체 페이지 수
        req.setAttribute("startPage", startPage); // 시작 페이지 번호
        req.setAttribute("endPage", endPage); // 끝 페이지 번호
        req.setAttribute("search", search); // 검색어 저장

        return "nego/header/gboard/gboard"; // View로 전달할 JSP 페이지 이름
    }
	
	@RequestMapping(value="/write_gboard.do", method=RequestMethod.GET)
	public String writeFormGboard(HttpServletRequest req) {
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
		return "nego/header/gboard/writeForm";
	}
	
	@RequestMapping(value="/write_gboard.do", method=RequestMethod.POST)
	public String writeProGboard(HttpServletRequest req, GboardDTO dto) {
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
		
		int res = gboardMapper.insertGboard(dto);
		return "redirect:gboard.do";
	}
	
	@RequestMapping("/content_gboard.do")
	public String contentGboard(HttpServletRequest req, int num) {
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
		
		GboardDTO dto = gboardMapper.getGboard(num);
		req.setAttribute("getGboard", dto);
		return "nego/header/gboard/content";
	}
	
	
	@RequestMapping("/delete_gboard.do")
	public String deleteGboard(HttpServletRequest req, int num) {
		
		int res = gboardMapper.deleteGboard(num);
		return "redirect:gboard.do";
	}
	
	@RequestMapping(value="/update_gboard.do", method=RequestMethod.GET)
	public String updateFormGboard(HttpServletRequest req, int num) {
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
		
		GboardDTO dto = gboardMapper.getGboard(num);
		req.setAttribute("getGboard", dto);
		return "nego/header/gboard/updateForm";
	}
	
	@RequestMapping(value="/update_gboard.do", method=RequestMethod.POST)
	public String updateProGboard(@ModelAttribute GboardDTO dto, BindingResult result) {
		if (result.hasErrors()) {	//만약에 dto객체를 만드는 중 오류가 발생했다면.. 
			//여기는 오류를 내가 알아서 해결하는 코드
			dto.setNum(0);
		}
		int res = gboardMapper.updateGboard(dto);
		return "redirect:gboard.do";
	}
}
