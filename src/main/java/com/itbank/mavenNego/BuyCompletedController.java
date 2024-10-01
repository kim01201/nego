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
import com.itbank.mavenNego.dto.StorageDTO;
import com.itbank.mavenNego.service.BuyCompletedMapper;
import com.itbank.mavenNego.service.StorageMapper;


@Controller
public class BuyCompletedController {
	@Autowired
	BuyCompletedMapper completeMapper;
	
	@Autowired
	StorageMapper storageMapper;
	
	@Autowired
	ServletContext servletcontext;
	
	
	//판매내역에서 상품명 검색하기
	@RequestMapping(value="/searchBuyCompleted.prod", method=RequestMethod.POST)
	public String searchBuyCompleted(HttpServletRequest req, String search) {
		List<BuyCompletedDTO> list = completeMapper.searchBuyCompleted(search);
		req.setAttribute("buyCompleted", list);
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
		return "nego/mypage/buyCompleted";
	}
	
	// buyer_id 받아서 list 불러오기
    @RequestMapping(value="/buyCompleted.prod", method=RequestMethod.GET)
    public String buyCompleted(HttpServletRequest req, String buyer_id) {
        
        // 구매 완료된 리스트 불러오기
        List<BuyCompletedDTO> completedList = completeMapper.buyCompleted(buyer_id);
        req.setAttribute("buyCompleted", completedList);
        req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
        
        return "nego/mypage/buyCompleted";
    }
	
	
  //판매자가 판매 물품 삭제하기
    @RequestMapping("/deleteBuyComplete.prod")
    public String deleteBuyComplete(@RequestParam("pnum")int pnum) {
    	BuyCompletedDTO dto = completeMapper.getBuyCompleted(pnum);
    	String buyer_id = dto.getBuyer_id();
       int res = completeMapper.deleteBuyComplete(pnum);
       return "redirect:buyCompleted.prod?buyer_id="+buyer_id;
    }

}