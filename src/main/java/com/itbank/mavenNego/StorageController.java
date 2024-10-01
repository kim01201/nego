package com.itbank.mavenNego;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itbank.mavenNego.dto.CateDTO;
import com.itbank.mavenNego.dto.ProductDTO;
import com.itbank.mavenNego.dto.StorageDTO;
import com.itbank.mavenNego.service.BuyCompletedMapper;
import com.itbank.mavenNego.service.MemberMapper;
import com.itbank.mavenNego.service.NegoMapper;
import com.itbank.mavenNego.service.ProductMapper;
import com.itbank.mavenNego.service.SalesCompletedMapper;
import com.itbank.mavenNego.service.StorageMapper;

@Controller
public class StorageController {
	@Autowired
	StorageMapper storageMapper;
	
	@Autowired
	BuyCompletedMapper bmapper;
	
	@Autowired
	SalesCompletedMapper smapper;
	
	@Autowired
	ProductMapper pMapper;
	
	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	NegoMapper negoMapper;
	
	@Autowired
	ServletContext servletcontext;
	
	//구매하기 버튼을 눌렀을 때
	@RequestMapping("/ifClickBuy.prod")
	public String ifClickBuy(HttpServletRequest req,@RequestParam("buyer_id")String buyer_id, @RequestParam("pnum")int pnum) {
		Map<String, Object> params = new HashMap<>();
        params.put("member_id", buyer_id);
		
		List<CateDTO> mainList = negoMapper.mainListAll();
		
	    int res = storageMapper.ifClickBuy(buyer_id, pnum);
	    
	    List<ProductDTO> list = pMapper.idProd(params);
		req.setAttribute("idProd", list);
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
		
		List<ProductDTO> slist = pMapper.idProd_sell(buyer_id);
		req.setAttribute("idProd_sell", slist);
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
		
		List<ProductDTO> clist = pMapper.idProd_complete(buyer_id);
		req.setAttribute("idProd_complete", clist);
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
	    
	  //Product의 pstatus를 '거래중'로 변경하기
	    int res1 = pMapper.update1Pstatus();
		return "nego/mypage/Mypage";
	}

	//구매자의 구매 대기 리스트
	@RequestMapping("/sendBuyer.prod")
	public String sendBuyer(HttpServletRequest req, @RequestParam("buyer_id")String buyer_id) {
		List<StorageDTO> list = storageMapper.sendBuyer(buyer_id);
	    req.setAttribute("sendBuyer", list);
	    req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
	    return "nego/mypage/wantBuyList";
	}

	//판매자의 구매 승인 리스트
	@RequestMapping(value = "/sendSeller.prod", method = RequestMethod.GET)
	public String sendSeller(HttpServletRequest req, @RequestParam("seller_id") String seller_id) {
	    List<StorageDTO> list = storageMapper.sendSeller(seller_id);
	    req.setAttribute("sendSeller", list);
	    req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
	    return "nego/mypage/waitList";  // JSP 파일 경로
	}
	
	//승인 거절
	@RequestMapping(value = "/deny.prod", method = RequestMethod.POST)
    @ResponseBody
    public String deny(@RequestParam("buyer_id") String buyer_id, @RequestParam("pnum") int pnum) {
        int res1 = pMapper.rePstatus(pnum);
        int res = storageMapper.deny(buyer_id, pnum);
        return "OK";
    }
	
	//안 살래요
	@RequestMapping("/cancel.prod")
	public String cancel(@RequestParam("buyer_id")String buyer_id, @RequestParam("pnum")int pnum) {
		int res1 = pMapper.rePstatus(pnum);
		int res = storageMapper.deny(buyer_id, pnum);
		
		return "redirect:mypage.do?member_id="+buyer_id;
	}
	
	@RequestMapping(value = "/ifClickSell.prod", method = RequestMethod.POST)
    @ResponseBody
    public String ifClickSell(@RequestParam("seller_id") String seller_id, 
                              @RequestParam("buyer_id") String buyer_id, 
                              @RequestParam("pnum") String pnumStr) {
        int pnum = Integer.parseInt(pnumStr);
        StorageDTO dto = storageMapper.getStorage(pnum);
        int res_buy = bmapper.buyComplete(dto);
        int res_sale = smapper.saleComplete(dto);
        int res_sto = storageMapper.deleteStorage(pnum);
        int res_pro = pMapper.updatePstatus(pnum);
        int sell_res = memberMapper.sell_score(seller_id);
        return "OK";
    }
	
	
	
}
