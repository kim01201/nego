package com.example.nego;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.nego.cate.service.CateService;
import com.example.nego.dto.CateDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class HomeController {

	@Autowired
	JavaMailSender mailSender;
	
	@Autowired
	CateService cateService;

	
	@GetMapping(value = {"/", "/main.do"})
	public String main(HttpServletRequest req) {
		List<CateDTO> mainList = cateService.mainList();
		req.setAttribute("mainList", mainList);
		
		for (CateDTO mainCategory : mainList) {
			List<CateDTO> subList = cateService.subList(mainCategory.getId());
			mainCategory.setSubList(subList);
			
			for (CateDTO subCategory : subList) {
				List<CateDTO> itemList = cateService.itemList(subCategory.getId());
				subCategory.setItemList(itemList);
			}  
		}
		return "main";
	}
	
	@Autowired
    private EmailService emailService;

    @GetMapping("/mail.do")
    public String sendEmail() {
        emailService.sendSimpleEmail("kkim01201@naver.com", "Test Subject", "Test Body");
        return "main";
    }
}
