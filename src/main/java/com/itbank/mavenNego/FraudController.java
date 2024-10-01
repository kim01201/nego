package com.itbank.mavenNego;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.itbank.mavenNego.dto.FraudDTO;
import com.itbank.mavenNego.dto.MemberDTO;
import com.itbank.mavenNego.service.FraudMapper;
import com.itbank.mavenNego.service.MemberMapper;

@Controller
public class FraudController {
	@Autowired
	FraudMapper fraudMapper;
	
	@Autowired
	MemberMapper memberMapper;

	//블랙리스트 페이지
	@RequestMapping("/fraud.do")
	public String fraudList(HttpServletRequest req) {
		List <FraudDTO> list = fraudMapper.fraudList();
		req.setAttribute("fraudList", list);
		return "nego/admin/manageFraud";
	}
	
	
	@RequestMapping(value="/fraud.fraud", method=RequestMethod.GET)
	public String fraud() {
		return "nego/header/fraud/fraud";
	}
	
	//사기조회
	@RequestMapping(value="/fraud.fraud", method=RequestMethod.POST)
	public String searchFraud(HttpServletRequest req, @RequestParam("fraudAccount") String fraudAccount) {
	    String sanitizedFraudAccount = fraudAccount.replace("-",""); // '-' 문자 제거
	    
	 
	    MemberDTO mdto = memberMapper.fraudMember(sanitizedFraudAccount);		
		if (mdto == null) {
	        // 회원 정보가 없는 경우 처리
	        req.setAttribute("errorMessage", "존재하지 않는 회원입니다.");
	        return "nego/header/fraud/fraud";
	    }		
		String member_id = mdto.getId();
		

	    FraudDTO dto = fraudMapper.searchFraud(member_id);
	    req.setAttribute("searchFraud", dto);
	    req.setAttribute("fraudAccount", fraudAccount);
	    return "nego/header/fraud/fraud";
	}
	
	@RequestMapping(value="/updateFraud.fraud", method=RequestMethod.GET)
	public String updateFraud(HttpServletRequest req, @RequestParam("fraudAccount") String fraudAccount) {
		req.setAttribute("fraudAccount", fraudAccount);
		return "nego/header/fraud/updateFraud";
	}
	
	@RequestMapping(value="/updateFraud.fraud", method=RequestMethod.POST)
	   public String updateProFraud(FraudDTO dto) {
	      String fraudAccount = dto.getFraudAccount().replace("-", ""); // '-' 문자 제거
	      
	      MemberDTO mdto = memberMapper.fraudMember(fraudAccount);      
	      String member_id = mdto.getId();
	      dto.setMember_id(member_id);
	      
	      int res = fraudMapper.updateFraud(dto);
	      int fres = memberMapper.fraud_score(member_id);
	      return "redirect:fraud.fraud";
	   }
	
	//사기등록 페이지 이동
	@RequestMapping(value="/insertFraud.fraud", method=RequestMethod.GET)
	public String insertFraud() {
		return "nego/header/fraud/insertFraud";
	}
	
	//사기 신고 등록
	@RequestMapping(value="/insertFraud.fraud", method=RequestMethod.POST)
	public String insertProFraud(HttpServletRequest req, FraudDTO dto) {
		//신고당한적이 있다면 값을 추가
		String fraudAccount = dto.getFraudAccount().replace("-", ""); // '-' 문자 제거
		
		MemberDTO mdto = memberMapper.fraudMember(fraudAccount);		
		String member_id = mdto.getId();
		dto.setMember_id(member_id);
	
	    if (fraudMapper.searchFraud(member_id) != null) {
	        int res = fraudMapper.updateFraud(dto);    
	        int fres = memberMapper.fraud_score(member_id);
	    } else {
	        int res = fraudMapper.insertFraud(dto);
	        int fres = memberMapper.fraud_score(member_id);
	    }

	    return "redirect:fraud.fraud";
	}
}
