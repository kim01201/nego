package com.itbank.mavenNego;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itbank.mavenNego.dto.AddressDTO;
import com.itbank.mavenNego.service.AddressMapper;

@Controller
public class AddressController {

	@Autowired
	AddressMapper addressMapper;
	
	@RequestMapping("/Address.do")
	public String addList(HttpServletRequest req,@RequestParam("member_id")String member_id) {
		List<AddressDTO> list =addressMapper.addList(member_id);
		req.setAttribute("addList", list);
		return "nego/mypage/AddressManagement";
	}

	@RequestMapping (value ="/insert_add.do" ,method = RequestMethod.POST)
	  @ResponseBody
	public String insertAdd(AddressDTO dto) {
		int count = addressMapper.addCount(dto.getMember_id());
		if(count >= 5) {
			return "full"; 
		}
		
		int res = addressMapper.insertAdd(dto);
		  if (res > 0) {
	            return "success"; // 성공적으로 등록되었음을 클라이언트에게 알림
	        } else {
	            return "failure"; // 등록 실패를 클라이언트에게 알림
	        }
	}
	

	
	@RequestMapping("/delete_add.do")
	public String deleteAdd(int id,String member_id) {
		int res = addressMapper.deleteAdd(id);
		return "redirect:mypage.do?member_id="+member_id;
		}

	}


