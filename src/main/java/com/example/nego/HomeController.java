package com.example.nego;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class HomeController {

	@Autowired
	JavaMailSender mailSender;
	
	@GetMapping(value = {"/", "/main.do"})
	public String main(HttpServletRequest req) {
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
