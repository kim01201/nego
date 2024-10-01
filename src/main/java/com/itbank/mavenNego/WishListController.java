package com.itbank.mavenNego;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.itbank.mavenNego.dto.CateDTO;
import com.itbank.mavenNego.dto.MboardDTO;
import com.itbank.mavenNego.dto.WishListDTO;
import com.itbank.mavenNego.service.NegoMapper;
import com.itbank.mavenNego.service.ProductMapper;
import com.itbank.mavenNego.service.WishListMapper;

@Controller
public class WishListController {
	@Autowired
	WishListMapper wishListMapper;
	@Autowired
	ProductMapper productMapper;
	
	@Autowired
	ServletContext servletcontext;
	
	@Autowired
	NegoMapper negoMapper;

	@RequestMapping("/wish_insert.do")
	public String insertWish(HttpServletRequest req, WishListDTO dto,@RequestParam("member_id")String member_id) {
		List<CateDTO> mainList = negoMapper.mainList();
		req.setAttribute("mainList", mainList);
		
	    // 이미 찜 목록에 있는지 검사
	    WishListDTO existingWish = wishListMapper.findWish(dto.getProduct_id(), dto.getMember_id());
	    
	    if (existingWish != null) {
	        // 이미 찜 목록에 있는 경우 기존 데이터 삭제
	        int deleteRes = wishListMapper.deleteWish(dto.getProduct_id(), dto.getMember_id());
	        if (deleteRes > 0) {
	            // 삭제 성공
	        } else {
	            // 삭제 실패
	        }
	    }else {
	    // 새로운 찜 추가
	    int insertRes = wishListMapper.insertWish(dto);
	    } 
	    
	    // 찜 목록 조회
		List<WishListDTO> list = wishListMapper.myWish(member_id);
		req.setAttribute("myWish", list);
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
	   // return "nego/header/wishList/wishList";
	    return "redirect:spec_prod.prod?pnum="+dto.getProduct_id(); // 상품 상세페이지
	}
	
	/*
	//상품갯수
	@RequestMapping("/wishCount.do")
	public String wishCount(HttpServletRequest req,int product_id) {
		int count = wishListMapper.wishCount(product_id);
		req.setAttribute("wishCount", count);
		return "wishList/wishCount";
	}
	*/
	
	//내가 찜한 상품
	@RequestMapping("/myWish.do")
	public String myWish(HttpServletRequest req,@RequestParam("member_id")String member_id) {
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
		
		List<WishListDTO> list = wishListMapper.myWish(member_id);
		req.setAttribute("myWish", list);
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/")); 
		return "nego/header/wishList/wishList";
	}
	
	@RequestMapping("/find_myWish.do")
	public String find_myWish(@RequestParam("product_name") String product_name, 
	                          @RequestParam("member_id") String member_id,
	                          Model model) {
		List<CateDTO> mainList = negoMapper.mainList();
		model.addAttribute("mainList", mainList);
		
		for (CateDTO mainCategory : mainList) {
			List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
			mainCategory.setSubList(subList);
			
			for (CateDTO subCategory : subList) {
				List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
				subCategory.setItemList(itemList);
			}
		}
		
	    WishListDTO wishDTO = new WishListDTO();
	    wishDTO.setProduct_name(product_name);
	    wishDTO.setMember_id(member_id);

	    List<WishListDTO> list = wishListMapper.find_myWish(wishDTO);
	    model.addAttribute("find_myWish", list);
	    model.addAttribute("path", servletcontext.getRealPath("/resources/images/")); 
	    return "nego/header/wishList/wishList";
	}
	
}
