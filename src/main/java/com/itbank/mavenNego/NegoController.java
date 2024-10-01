package com.itbank.mavenNego;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itbank.mavenNego.dto.CateDTO;
import com.itbank.mavenNego.dto.MemberDTO;
import com.itbank.mavenNego.dto.ProductDTO;
import com.itbank.mavenNego.service.MemberMapper;
import com.itbank.mavenNego.service.NegoMapper;
import com.itbank.mavenNego.service.ProductMapper;



@Controller
public class NegoController {

	@Autowired
	NegoMapper negoMapper;
	
	@Autowired
	ProductMapper productMapper;
	
	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	ServletContext servletcontext;
	
	@RequestMapping(value = {"/","/main.do"}, method = RequestMethod.GET)
	public String main(HttpServletRequest req) {
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
		
        
		List<ProductDTO> rlist = productMapper.randomProd();
		req.setAttribute("randomProd", rlist);
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
		
		List<ProductDTO> dlist = productMapper.dateProd();
		req.setAttribute("dateProd", dlist);
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
		
		List<ProductDTO> clist = productMapper.readcountProd();
		req.setAttribute("readCountProd", clist);
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
		
		return "nego/main";
	}
	
	@RequestMapping("/Header.do")
	public String header(HttpServletRequest req) {
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
		return "nego/Header";
	}
	
	@RequestMapping("/mypage.do")
	public String mypage(HttpServletRequest req,
			@RequestParam("member_id") String member_id,
    		@RequestParam(value="sort", required=false) String sort) {
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
		
        Map<String, Object> params = new HashMap<>();
        params.put("member_id", member_id);
        params.put("sort", sort);
		
        MemberDTO mdto = memberMapper.getMember(member_id);
        req.setAttribute("member", mdto);
        
		List<ProductDTO> list = productMapper.idProd(params);
		req.setAttribute("idProd", list);
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
		
		List<ProductDTO> slist = productMapper.idProd_sell(member_id);
		req.setAttribute("idProd_sell", slist);
		
		
		List<ProductDTO> clist = productMapper.idProd_complete(member_id);
		req.setAttribute("idProd_complete", clist);
		

		return "nego/mypage/Mypage";
	}
	
	@GetMapping("/myPageInfo.do")
    public ResponseEntity<Map<String, Object>> myPageInfo(
    		@RequestParam("member_id") String member_id,
    		@RequestParam("sort") String sort) {

        Map<String, Object> response = new HashMap<>();

        // 검색 조건 설정
        Map<String, Object> params = new HashMap<>();
        params.put("member_id", member_id);
        params.put("sort", sort);


        System.out.println(params);
        
       
        List<ProductDTO> productList = productMapper.idProd(params);
        
        System.out.println(productList);


        // 결과 설정
        response.put("idProd", productList);

        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
	
	@RequestMapping("/delivery.do")
	public String delivery(HttpServletRequest req) {
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
		return "nego/mypage/DeliveryLog";
	}

	
	@RequestMapping("/userout.do")
	public String userout(HttpServletRequest req) {
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
		return "nego/mypage/userout";
	}
	
	@RequestMapping("/getCategories.do")
    @ResponseBody
    public List<CateDTO> getCategories() {
        return negoMapper.mainList();
    }
	
	@RequestMapping("/getSubCategories.do")
    @ResponseBody
    public List<CateDTO> getSubCategories(@RequestParam("parentId") int parentId) {
        return negoMapper.subList(parentId);
    }

    @RequestMapping("/getItems.do")
    @ResponseBody
    public List<CateDTO> getItems(@RequestParam("subId") int subId) {
        return negoMapper.itemList(subId);
    }
    
	@RequestMapping("/attendance.do")
	public String attendance(HttpServletRequest req) {
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
		return "nego/header/attendance";
	}
		
	@RequestMapping(value = {"/admin.do"}, method = RequestMethod.GET)
	public String admin(HttpServletRequest req) {
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
		
		return "nego/admin/admin";
	}
	
	//카테고리 등록페이
		@RequestMapping("/cate.do")
		public String cate(HttpServletRequest req) {
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
			
			return "nego/admin/manageCategories";
		}

	//최상위 카테고리 등록
		@RequestMapping(value = "/insertCate.do", method = RequestMethod.POST)
		  @ResponseBody
			public String insertCate(HttpServletRequest req,CateDTO dto) {
				int res = negoMapper.insertCate(dto);
				  if (res > 0) {
			            return "success"; // 성공적으로 등록되었음을 클라이언트에게 알림
			        } else {
			            return "failure"; // 등록 실패를 클라이언트에게 알림
			        }
			}
		
		
		@RequestMapping(value = "/insertSubCate.do", method = RequestMethod.POST)
	    @ResponseBody
	    public String insertSubCate(
	    	    HttpServletRequest req,
	    	    @RequestParam String name,
	    	    @RequestParam(required = true) int parentId,
	    	    @RequestParam(required = true) int level) {
	    int res = negoMapper.insertSubCate(name, parentId, level);
	        if (res > 0) {
	            return "success"; // 성공적으로 등록되었음을 클라이언트에게 알림
	        } else {
	            return "failure"; // 등록 실패를 클라이언트에게 알림
	        }
	    }
		
		@RequestMapping(value="/deleteCate.do", method = RequestMethod.POST)
		@ResponseBody
		public String deleteCate(@RequestParam int id) {
			int res = negoMapper.deleteCate(id);
			  if (res > 0) {
		            return "success"; // 성공적으로 등록되었음을 클라이언트에게 알림
		        } else {
		            return "failure"; // 등록 실패를 클라이언트에게 알림
		        }
		}
		
		@RequestMapping(value = "/editCate.do", method = RequestMethod.POST)
		@ResponseBody
		public String updateCate(@RequestParam String name,@RequestParam int id) {
			int res = negoMapper.updateCate(name,id);
			  if (res > 0) {
		            return "success"; // 성공적으로 등록되었음을 클라이언트에게 알림
		        } else {
		            return "failure"; // 등록 실패를 클라이언트에게 알림
		        }
		}
}
