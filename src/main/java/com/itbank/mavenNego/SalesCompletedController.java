package com.itbank.mavenNego;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.itbank.mavenNego.dto.BuyCompletedDTO;
import com.itbank.mavenNego.dto.SalesCompletedDTO;
import com.itbank.mavenNego.dto.StorageDTO;
import com.itbank.mavenNego.service.SalesCompletedMapper;
import com.itbank.mavenNego.service.StorageMapper;


@Controller
public class SalesCompletedController {
	@Autowired
	SalesCompletedMapper completeMapper;
	
	@Autowired
	StorageMapper storageMapper;
	
	@Autowired
	ServletContext servletcontext;
	
	
	//판매내역에서 상품명 검색하기
	@RequestMapping(value="/searchCompleted.prod", method=RequestMethod.POST)
	public String searchCompleted(HttpServletRequest req, String search) {
		List<SalesCompletedDTO> list = completeMapper.searchCompleted(search);
		req.setAttribute("sellerCompleted", list);
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
		return "nego/mypage/sellCompleted";
	}
	
	//seller_id 받아서 list 불러오기
	@RequestMapping(value="/sellerCompleted.prod", method=RequestMethod.GET)
    public String sellerCompleted(HttpServletRequest req, String seller_id) {

        // 판매 완료된 리스트 불러오기
        List<SalesCompletedDTO> completedList = completeMapper.sellerCompleted(seller_id);
        req.setAttribute("sellerCompleted", completedList);
        System.out.println("셀러값 : "+completedList);
        req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
        
        return "nego/mypage/sellCompleted";
    }
	
	
	//판매자가 판매 물품 삭제하기
	   @RequestMapping("/deleteComplete.prod")
	   public String deleteComplete(@RequestParam("pnum")int pnum) {
		   SalesCompletedDTO dto = completeMapper.getSellCompleted(pnum);
		   String seller_id = dto.getSeller_id();
	      int res = completeMapper.deleteComplete(pnum);
	      return "redirect:sellerCompleted.prod?seller_id="+seller_id;
	   }

}