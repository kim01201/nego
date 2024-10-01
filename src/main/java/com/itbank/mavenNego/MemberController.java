package com.itbank.mavenNego;


import java.io.IOException;
import java.sql.Date;
import java.util.*;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import javax.servlet.http.Cookie;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.github.scribejava.core.model.OAuth2AccessToken;
import com.itbank.mavenNego.dto.AttendanceDTO;
import com.itbank.mavenNego.dto.MemberDTO;
import com.itbank.mavenNego.service.AddressMapper;
import com.itbank.mavenNego.service.BuyCompletedMapper;
import com.itbank.mavenNego.service.FraudMapper;
import com.itbank.mavenNego.service.MboardMapper;
import com.itbank.mavenNego.service.MemberMapper;
import com.itbank.mavenNego.service.ProductMapper;
import com.itbank.mavenNego.service.ReviewsMapper;
import com.itbank.mavenNego.service.SalesCompletedMapper;
import com.itbank.mavenNego.service.StorageMapper;
import com.itbank.mavenNego.service.WishListMapper; 


@Controller
public class MemberController {
	@Autowired
	MemberMapper memberMapper;

	@Autowired
	ProductMapper productMapper;

	@Autowired
	WishListMapper wishListMapper;

	@Autowired
	FraudMapper fraudMapper;

	@Autowired
	BuyCompletedMapper buyCompletedMapper;

	@Autowired
	SalesCompletedMapper salesCompletedMapper;

	@Autowired
	StorageMapper storageMapper;

	@Autowired
	ReviewsMapper reviewsMapper;

	@Autowired
	MboardMapper mboardMapper;
	
	@Autowired
	AddressMapper addressMapper;
	
	@Autowired
	JavaMailSender mailSender;
	
	private NaverLoginBO naverLoginBO;
	private String apiResult = null;		
	@Autowired	
	private void setNaverLoginBO(NaverLoginBO naverLoginBO) {
		this.naverLoginBO = naverLoginBO;	
		} 	

	
	@RequestMapping(value ="/Login.do", method = { RequestMethod.GET, RequestMethod.POST })
    public String Login(Model model, HttpSession session) {
		/* 네이버아이디로 인증 URL을 생성하기 위하여 naverLoginBO클래스의 getAuthorizationUrl메소드 호출 */		
		String naverAuthUrl = naverLoginBO.getAuthorizationUrl(session);
		//https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=sE***************&		
		//redirect_uri=http%3A%2F%2F211.63.89.90%3A8090%2Flogin_project%2Fcallback&state=e68c269c-5ba9-4c31-85da-54c16c658125		
		//System.out.println("네이버:" + naverAuthUrl);				
		//System.out.println("로그인 화면 세션 : "+session);
		//네이버 	
		model.addAttribute("url", naverAuthUrl); 
		
        return "nego/member/Login";
    }
	
	//네이버 로그인 성공시 callback호출 메소드	
		@RequestMapping(value = "/callback.do", method = { RequestMethod.GET, RequestMethod.POST })
		public String callback(HttpServletRequest req,Model model, @RequestParam String code, @RequestParam String state, HttpSession session) throws IOException, ParseException {
			OAuth2AccessToken oauthToken;
			oauthToken = naverLoginBO.getAccessToken(session, code, state);
			//System.out.println("세션 : " +session);
			//System.out.println("코드 :"+code);
			//System.out.println("state :"+state);
			//1. 로그인 사용자 정보를 읽어온다.		
			
			  //System.out.println("토큰확인 : "+oauthToken);
			apiResult = naverLoginBO.getUserProfile(oauthToken);
		
			//String형식의 json데이터				
			/** apiResult json 구조		
			 * {"resultcode":"00",		
			 *  "message":"success",		 
			 *  "response":{"id":"33666449","nickname":"shinn****","age":"20-29","gender":"M","email":"sh@naver.com","name":"\uc2e0\ubc94\ud638"}}	
			 *  	**/				
			
			//2. String형식인 apiResult를 json형태로 바꿈
			JSONParser parser = new JSONParser();		
			Object obj = parser.parse(apiResult);		
			JSONObject jsonObj = (JSONObject) obj;				
			System.out.println("결과1 : "+apiResult);
			
			//3. 데이터 파싱 		
			//Top레벨 단계 _response 파싱		
			JSONObject response_obj = (JSONObject)jsonObj.get("response");
			//response의 nickname값 파싱		
			String id = (String)response_obj.get("id");
			String name = (String)response_obj.get("name");
			String mobile = (String)response_obj.get("mobile");
			
		
			System.out.println("전체 id : " + id);
			System.out.println("이름  : " + name);
			System.out.println("번호  : " + mobile);

			// id의 앞 8자리 추출
			String idPrefix = id.substring(0, 8);
			System.out.println("앞 8자리 id : " + idPrefix);
			
			String hp1= mobile.substring(0,3);
			String hp2= mobile.substring(4,8);
			String hp3= mobile.substring(9,13);
			
			System.out.println("번호1 : "+hp1);
			System.out.println("번호2 : "+hp2);
			System.out.println("번호3 : "+hp3);
			

			// MemberDTO 객체 생성 및 id 설정
			MemberDTO dto = new MemberDTO();
			HttpSession session1 = req.getSession();
			dto.setId(idPrefix); // 앞 8자리 id 설정
			dto.setName(name);
			dto.setHp1(hp1);
			dto.setHp2(hp2);
			dto.setHp3(hp3);
			
			MemberDTO find = memberMapper.getMember(idPrefix);
			if(find == null) {
			 int res = memberMapper.insertMember(dto);
			}
			//4.파싱 닉네임 세션으로 저장		
			session1.setAttribute("mbId",dto); //세션 생성				
	        session1.setAttribute("loginMethod", "naver");
	        session1.setAttribute("oauthToken", oauthToken);
			model.addAttribute("result", apiResult);	     		
			return "redirect:main.do";
			}		
		
	
	
	@RequestMapping(value = "/insert_smember.do", method = RequestMethod.POST)
    public String insertSmember(@ModelAttribute MemberDTO dto) {
        int res = memberMapper.insertMember(dto);
        return "nego/member/redirect:list_smember.do";
    }
	
	@RequestMapping(value = "/NeGOMember_Login.do", method = RequestMethod.GET)
    public String neGOMemberLogin() {
        return "nego/member/NeGOMember_Login"; // NeGOMemberLogin.jsp 파일 이름 반환
    }
            
    
    @RequestMapping(value = "/FindId.do", method = RequestMethod.GET)
    public String FindId() {
        return "nego/member/FindId";
    }
    
    @ResponseBody
    @RequestMapping("/idCheck.do")
    public String checkId(@RequestParam("id") String id) {
        int res = memberMapper.checkId(id);
        if (res == 0) {
            return "OK";
        } else {
            return "NO";
        }
    }
    
    @RequestMapping(value = "/findIdResult.do", method = RequestMethod.POST)
    public ModelAndView findIdResult(@RequestParam("name") String name, @RequestParam("email") String email) {
        ModelAndView mav = new ModelAndView("nego/member/findIdResult");
        String foundUsername = memberMapper.findIdByNameAndEmail(name, email);
        mav.addObject("foundUsername", foundUsername);
        return mav;
    }
    
    @RequestMapping(value = "/FindPasswd.do", method = RequestMethod.GET)
    public String FindPasswd() {
        return "nego/member/FindPasswd";
    }    
    
    @RequestMapping(value = "/findPasswordResult.do", method = RequestMethod.POST)
    public ModelAndView findPasswordResult(@RequestParam("id") String id, @RequestParam("email") String email) {
        ModelAndView mav = new ModelAndView("nego/member/findPasswordResult");
        String foundPasswd = memberMapper.findPasswdByEmail(id, email);
        mav.addObject("foundPasswd", foundPasswd);  // foundPasswd 값을 JSP에 전달
        return mav;
    }
    
    @RequestMapping(value = "/NeGOmember_Input.do", method = RequestMethod.GET)
    public String NeGOmember_Inputs() {
        return "nego/member/NeGOmember_Input";    // 기존 GET 요청 처리
    }   

    @RequestMapping(value="/NeGOmember_Inputok.do", method=RequestMethod.POST)
    public String member_input(HttpServletRequest req, @ModelAttribute MemberDTO dto) {
        int res = memberMapper.insertMember(dto);

        if (res > 0) {
            req.setAttribute("msg", "회원가입 성공!!");
            req.setAttribute("url", "Login.do");
            return "nego/member/message";
        } else {
            req.setAttribute("msg", "회원가입 실패!! 회원가입페이지로 이동합니다.");
            req.setAttribute("url", "NeGOMember_Ssn.do");
            return "nego/member/message";   
        }
    }
    
    @RequestMapping("/login_ok.do")
    public String login_ok(HttpServletRequest req, HttpServletResponse resp, @RequestParam Map<String, String> params) {
        
    	int res = memberMapper.loginCheck(params.get("id"), params.get("passwd"));
    	 
    	switch (res) {
            case MemberMapper.OK:
                MemberDTO dto = memberMapper.getMember(params.get("id"));
                Cookie ck = new Cookie("saveId", params.get("id"));
                if (!params.containsKey("saveId")) {
                    ck.setMaxAge(0);
                } else {
                    ck.setMaxAge(24 * 60 * 60);
                }
                resp.addCookie(ck);
                HttpSession session = req.getSession();
                session.setAttribute("mbId", dto);
                session.setAttribute("loginMethod", "phone");
               // System.out.println("Logged in user: " + dto.getName()); // 콘솔에서 사용자 이름 확인
                //System.out.println("Session ID: " + session.getId()); // 세션 ID 확인
                req.setAttribute("msg", dto.getName() + "님이 로그인 하셨습니다.");
               // req.setAttribute("url", "NeGOMember_Login.do");
                req.setAttribute("url", "main.do");
                break;
            case MemberMapper.NOT_ID:
                req.setAttribute("msg", "없는 아이디 입니다. 다시 확인 후 로그인을 해 주세요");
                req.setAttribute("url", "Login.do");
                break;
            case MemberMapper.NOT_PW:
                req.setAttribute("msg", "비밀번호가 틀렸습니다. 다시 확인 후 로그인을 해 주세요");
                req.setAttribute("url", "Login.do");
                break;
        }
        return "forward:message.do";
    }
 
    @RequestMapping("/message.do")
    public String showMessage(HttpServletRequest req) {
        return "nego/member/message"; // Ensure there's a message.jsp in /WEB-INF/views/
    }
    
    @RequestMapping("/naverMsg.do")
    public String showMsg(HttpServletRequest req) {
    	return "nego/member/naverMsg"; 
    }

    @RequestMapping("/Logout.do")
    public ModelAndView logout(HttpServletRequest req) {
        HttpSession session = req.getSession();
        session.invalidate();
        ModelAndView mav = new ModelAndView("forward:message.do");
        mav.addObject("msg", "로그아웃 되었습니다. 메인 페이지로 이동합니다.");
       // mav.addObject("url", "Login.do");
        mav.addObject("url", "main.do");
        return mav;
    }


    @RequestMapping("/naver_logout.do")
    public ModelAndView naaver_logout(HttpServletRequest req) {
        // 네이버 로그아웃 URL을 호출하고, 로그아웃 후에 메인 페이지로 이동하도록 설정
        HttpSession session = req.getSession();
        session.invalidate();

        // 네이버 로그아웃 URL (사용자가 직접 로그아웃 페이지로 이동)
        String logoutUrl = "http://nid.naver.com/nidlogin.logout";

        ModelAndView mav = new ModelAndView("forward:naverMsg.do");
        mav.addObject("msg", "네이버에서 로그아웃되었습니다. 메인페이지로 이동합니다.");
        mav.addObject("url", logoutUrl); // 네이버 로그아웃 페이지로 이동

        return mav;
    }

    
   
    
    @RequestMapping("/mail.do")
    public String sendMail(HttpServletRequest request) throws Exception {
        // 6자리 랜덤 숫자 생성
        Random rand = new Random();
        int randomNum = rand.nextInt(900000) + 100000;  // 100000(최소값)부터 999999(최대값) 사이의 숫자

        MimeMessage msg = mailSender.createMimeMessage();
        msg.setSubject("NeGO 아이디 찾기 인증번호입니다.");
        msg.setText("귀하의 인증번호는 " + randomNum + " 입니다.");  // 랜덤 숫자를 이메일 본문에 포함
        msg.setRecipients(MimeMessage.RecipientType.TO, InternetAddress.parse(request.getParameter("email")));
        mailSender.send(msg);

        // Store verification code in session
        HttpSession session = request.getSession();
        session.setAttribute("verificationCode", randomNum);
        session.setAttribute("email", request.getParameter("email"));
        session.setAttribute("name", request.getParameter("name"));

        return "nego/member/FindId";
    }
    
    @RequestMapping(value = "/checkAndFindId.do", method = RequestMethod.POST)
    public ModelAndView checkAndFindId(HttpServletRequest request) {
        ModelAndView mav = new ModelAndView("nego/member/checkAndFindIdResult");
        HttpSession session = request.getSession();

        int inputCode = Integer.parseInt(request.getParameter("verificationCode"));
        Integer sessionCode = (Integer) session.getAttribute("verificationCode");
        String name = (String) session.getAttribute("name");
        String email = (String) session.getAttribute("email");

        if (sessionCode != null && inputCode == sessionCode) {
            // Verification code is correct, proceed to find ID
            String foundUsername = memberMapper.findIdByNameAndEmail(name, email);
            if (foundUsername != null) {
                mav.addObject("message", "인증번호가 확인되었습니다. 입력하신 이름과 이메일로 등록된 아이디는 " + foundUsername + "입니다.");
            } else {
                mav.addObject("message", "인증번호는 확인되었으나, 입력하신 이름과 이메일로 등록된 아이디를 찾을 수 없습니다.");
            }
        } else {
            mav.addObject("message", "인증번호가 일치하지 않습니다. 다시 시도해주세요.");
        }

        return mav;
    }
    
    
    
    @RequestMapping(value = "/withdrawalAction.do", method = RequestMethod.POST)
    public String withdrawMember(HttpServletRequest req, @RequestParam("Id") String id, @RequestParam("passwd") String passwd) {
        int res = memberMapper.loginCheck(id, passwd);
        if (res == memberMapper.OK) {
            int result = memberMapper.deleteMember(id);
            if (result > 0) {
                req.setAttribute("msg", "회원 탈퇴가 완료되었습니다.");
                req.setAttribute("url", "main.do");
            } else {
                req.setAttribute("msg", "회원 탈퇴에 실패했습니다. 다시 시도해 주세요.");
                req.setAttribute("url", "userout.do");
            }
        } else {
            req.setAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
            req.setAttribute("url", "userout.do");
        }
        
        List<Integer> prodList = productMapper.getProdPnum(id);
 		for (Integer pnum : prodList) {
 			wishListMapper.delete_member(pnum);
 		}
 		int wish_res = wishListMapper.deleteMember_wish(id);
 		int pro_res = productMapper.deleteMember_pro(id);
 		int fraud_res = fraudMapper.deleteMember_fraud(id);
 		int buyer_res = buyCompletedMapper.deleteMember_buyer(id);
 		int seller_res = salesCompletedMapper.deleteMember_seller(id);
 		int mboard_res = mboardMapper.reMboard_id(id);
 		int reviews_res = reviewsMapper.reReviews_id(id);
 		int address_res = addressMapper.deleteMember_add(id);
 		int attend_res = memberMapper.delete_attend(id);

 		// 스토리지에 저장된 아이디의 상품 번호(거래 취소로 보고 다시 판매중으로 변경하기 위한 작업)
 		List<Integer> pnumList = storageMapper.getPnum(id);

 		// 찾은 상품번호 다시 판매중으로 바꾸기
 		for (Integer pnum : pnumList) {
 			productMapper.rePstatus(pnum);
 		}

 		// 스토리지에 있는 값 삭제
 		int storage_res = storageMapper.deleteStorageMember(id);
        
        
        
        
        
        return "nego/member/message";
    }    

  //회원 찾기 기능
  	 @RequestMapping(value = "/search_user.do", method = RequestMethod.GET)
  	    public String search_user(Model model, @RequestParam(value = "name", required = false) String name, @RequestParam(value = "id", required = false) String id) {
  	       // System.out.println("Received search parameters - Name: " + name + ", ID: " + id);

  	        Map<String, String> params = new HashMap<String,String>();
  	        params.put("name", name);
  	        params.put("id", id);
  	        List<MemberDTO> listMember = memberMapper.findMember(params);
  	        
  	       // System.out.println("Search results: " + listMember); // Add this line to debug the results

  	        model.addAttribute("listMember", listMember);
  	        return "nego/admin/manageMembers";
  	    }
  	 
 	// 회원삭제
 	@RequestMapping(value = "/member_delete.do", method = RequestMethod.GET)
 	public String deleteMember(@RequestParam("no") String id, HttpServletRequest req) {
 		int result = memberMapper.deleteMember(id);

 		List<Integer> prodList = productMapper.getProdPnum(id);
 		for (Integer pnum : prodList) {
 			wishListMapper.delete_member(pnum);
 		}
 		int wish_res = wishListMapper.deleteMember_wish(id);
 		int pro_res = productMapper.deleteMember_pro(id);
 		int fraud_res = fraudMapper.deleteMember_fraud(id);
 		int buyer_res = buyCompletedMapper.deleteMember_buyer(id);
 		int seller_res = salesCompletedMapper.deleteMember_seller(id);
 		int mboard_res = mboardMapper.reMboard_id(id);
 		int reviews_res = reviewsMapper.reReviews_id(id);
 		int address_res = addressMapper.deleteMember_add(id);
 		int attend_res = memberMapper.delete_attend(id);

 		// 스토리지에 저장된 아이디의 상품 번호(거래 취소로 보고 다시 판매중으로 변경하기 위한 작업)
 		List<Integer> pnumList = storageMapper.getPnum(id);

 		// 찾은 상품번호 다시 판매중으로 바꾸기
 		for (Integer pnum : pnumList) {
 			productMapper.rePstatus(pnum);
 		}

 		// 스토리지에 있는 값 삭제
 		int storage_res = storageMapper.deleteStorageMember(id);

 		if (result > 0) {
 			req.setAttribute("msg", "회원 삭제 성공!");
 			req.setAttribute("url", "admin.do");
 		} else {
 			req.setAttribute("msg", "회원 삭제 실패!");
 			req.setAttribute("url", "admin.do");
 		}
 		return "nego/admin/message";
 	}
 	
 	//회원수정 페이지 이동
 	 @RequestMapping(value = "/member_update.do", method = RequestMethod.GET)
 	    public String showUpdateForm(@RequestParam("no") String id, Model model) {
 	        MemberDTO dto = memberMapper.getMember(id);
 	        model.addAttribute("member", dto);
 	        return "nego/admin/manageMemberUpdate";
 	    }
 	 
 	 //회원수정
 	 @RequestMapping(value = "/member_update.do", method = RequestMethod.POST)
 	    public String updateMember(@ModelAttribute MemberDTO dto, HttpServletRequest req) {
 	        int result = memberMapper.updateMember(dto);
 	        if (result > 0) {
 	            req.setAttribute("msg", "회원 수정 성공!");
 	            req.setAttribute("url", "admin.do");
 	        } else {
 	            req.setAttribute("msg", "회원 수정 실패!");
 	            req.setAttribute("url", "admin.do");
 	        }
 	        return "nego/admin/message";
 	    }
 	 
  	//회원수정 페이지 이동
 	 @RequestMapping(value = "/member_update_user.do", method = RequestMethod.GET)
 	    public String showUpdateForm2(@RequestParam("no") String id, Model model) {
 	        MemberDTO dto = memberMapper.getMember(id);
 	        model.addAttribute("member", dto);
 	        return "nego/mypage/userUpdate";
 	    }
 	 
 	 //회원수정
 	 @RequestMapping(value = "/member_update_user.do", method = RequestMethod.POST)
 	    public String updateMember2(@ModelAttribute MemberDTO dto, HttpServletRequest req,@RequestParam("member_id") String member_id) {
 	        int result = memberMapper.updateMember(dto);
 	        if (result > 0) {
 	            req.setAttribute("msg", "회원 수정 성공!");
 	            req.setAttribute("url", "mypage.do?member_id="+member_id);
 	        } else {
 	            req.setAttribute("msg", "회원 수정 실패!");
 	            req.setAttribute("url", "mypage.do?member_id="+member_id);
 	        }
 	        return "nego/admin/message";
 	    }
 	 
 	@RequestMapping(value = "/user.do", method = RequestMethod.GET)
	public String showUserList(Model model,
			@RequestParam(value = "showList", required = false, defaultValue = "true") String showList) {
		if ("true".equals(showList)) {
			List<MemberDTO> listMember = memberMapper.getAllMembers();
			model.addAttribute("listMember", listMember);
		}
		return "nego/admin/manageMembers"; 
	}
 	
	//출석체크
	@RequestMapping(value = "/checkAttendance.do", method = RequestMethod.POST)
	 @ResponseBody
	public String checkAttendance(HttpServletRequest req) {
	        String member_id = req.getParameter("member_id");
	        if (member_id == null) {
	            return "redirect:Login.do";
	        }
	        
	        //시간은 전부 0으로 초기화
	        Calendar calendar = Calendar.getInstance();
	        calendar.set(Calendar.HOUR_OF_DAY, 0);
	        calendar.set(Calendar.MINUTE, 0);
	        calendar.set(Calendar.SECOND, 0);
	        calendar.set(Calendar.MILLISECOND, 0);
	        java.util.Date today = calendar.getTime();
	        
	          
	       AttendanceDTO find_attend = memberMapper.find_attend(member_id);
	       
	       
	       if (find_attend != null) {
	            // AttendanceDTO의 날짜를 Calendar 객체로 변환하여 비교
	            Calendar attendCalendar = Calendar.getInstance();
	            attendCalendar.setTime(find_attend.getAttendance_date());
	            attendCalendar.set(Calendar.HOUR_OF_DAY, 0);
	            attendCalendar.set(Calendar.MINUTE, 0);
	            attendCalendar.set(Calendar.SECOND, 0);
	            attendCalendar.set(Calendar.MILLISECOND, 0);
	            java.util.Date attendDate = attendCalendar.getTime();

	            if (today.equals(attendDate)) {
	                return "notToday";
	            } else {
	                find_attend.setAttendance_date(new Date(calendar.getTimeInMillis()));
	                int res = memberMapper.updateAttendance(find_attend);
	                int tres = memberMapper.attend_score(member_id);
	                return "success";
	            }
	        }else {
	        AttendanceDTO attendance = new AttendanceDTO();
	        attendance.setMember_id(member_id);
	        attendance.setCount(1); 
	        attendance.setAttendance_date(new Date(calendar.getTimeInMillis()));

	        int result = memberMapper.insertAttendance(attendance);
	        int tres = memberMapper.attend_score(member_id);

	        return "success";
	       }
	    }
	
	@RequestMapping(value="/user/kakao/callback", method=RequestMethod.GET)
	public String kakaoLogin(@RequestParam(value = "code", required = false) String code, HttpServletRequest req) throws Exception {
		//System.out.println("#########" + code);
        
		req.setAttribute("code", code);
		// 위에서 만든 코드 아래에 코드 추가
		String access_Token = memberMapper.getAccessToken(code);
		req.setAttribute("accessToken", access_Token);
		HashMap<String, Object> userInfo = memberMapper.getUserInfo(access_Token);
		System.out.println("###access_Token#### : " + access_Token);
		System.out.println("###nickname#### : " + userInfo.get("nickname"));
		System.out.println("###id#### : " + userInfo.get("id"));
        System.out.println("prd"+userInfo.get("properties"));
        
    	String id = (String) userInfo.get("id");
	

        MemberDTO dto = new MemberDTO();
		dto.setId(id); // 앞 8자리 id 설정
        dto.setName((String) userInfo.get("nickname"));
        
        
        MemberDTO find = memberMapper.getMember(id);
		if(find == null) {
		 int res = memberMapper.insertMember(dto);
		}

        
        HttpSession session = req.getSession();
        session.setAttribute("mbId", dto);
        session.setAttribute("loginMethod", "kakao");
		return "redirect:/";
		
    }
}
