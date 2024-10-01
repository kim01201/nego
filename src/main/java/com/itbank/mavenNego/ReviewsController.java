package com.itbank.mavenNego;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.itbank.mavenNego.dto.BuyCompletedDTO;
import com.itbank.mavenNego.dto.CateDTO;
import com.itbank.mavenNego.dto.ProductDTO;
import com.itbank.mavenNego.dto.ReviewsDTO;
import com.itbank.mavenNego.service.BuyCompletedMapper;
import com.itbank.mavenNego.service.MemberMapper;
import com.itbank.mavenNego.service.NegoMapper;
import com.itbank.mavenNego.service.ProductMapper;
import com.itbank.mavenNego.service.ReviewsMapper;

@Controller
public class ReviewsController {
	@Autowired
	ReviewsMapper reviewsMapper;
	
	@Autowired
	BuyCompletedMapper buyCompletedMapper;
	
	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	ProductMapper productMapper;

	@Autowired
	NegoMapper negoMapper;
	
	@Autowired
	ServletContext servletcontext;
	
	// 후기 중복체크 및 페이지 이동
	@RequestMapping(value = "/insert_reviews.do", method = RequestMethod.GET)
	public String reviewsWriteForm(Model model, @RequestParam int product_id, @RequestParam String sender_id,
			HttpSession session) {
		// 후기 중복 체크-상품의 번호와 내 아이디가 있다면
		ReviewsDTO existingReview = reviewsMapper.findReviews(product_id, sender_id);
		if (existingReview != null) {
			model.addAttribute("msg", "이미 후기를 작성하였습니다.");
			model.addAttribute("url", "mypage.do?member_id=" + sender_id);
			return "nego/reviews/message";
		} else {
			BuyCompletedDTO dto = buyCompletedMapper.getBuyCompleted(product_id);
			ProductDTO pdto = productMapper.getProd(product_id);
	
			
		
			model.addAttribute("getProd",pdto);
			model.addAttribute("getBuyCompleted", dto);

		}
		return "nego/reviews/reviewsWrite";
	}

	// 후기 등록
		@RequestMapping(value = "/insert_reviews.do", method = RequestMethod.POST)
		public String reviewsWritePro(HttpServletRequest req, ReviewsDTO dto) {
			
			int res = reviewsMapper.insertReviews(dto);
			// 후기 등록시 신뢰점수 증가
			if (dto.getGoodPoints() != null) {
				// 판매자 신뢰지수 증가
				int re_res = memberMapper.greviews_score(dto.getReceiver_id());
			} else {//
					// 판매자 신뢰지수 감소
				int re_res = memberMapper.breviews_score(dto.getReceiver_id());
			}

			// 작성자 신뢰점수 증가
			int send_res = memberMapper.reviews_score(dto.getSender_id());
			return "redirect:mypage.do?member_id="+dto.getSender_id();
		}



	// 내가 쓴,내가 받은 후기 보기
		@RequestMapping(value = "/allReviews.do", method = RequestMethod.GET)
		public String allReviews(HttpServletRequest req, String sender_id, String receiver_id) {
			int pageSize = 5; // 한 페이지당 보여줄 게시물 수
			String pageNumStr = req.getParameter("pageNum"); // 현재 페이지 번호를 파라미터로 받아옴

			int pageNum = (pageNumStr == null) ? 1 : Integer.parseInt(pageNumStr); // 현재 페이지 번호, 기본값은 1

			List<ReviewsDTO> receiverlist = reviewsMapper.sellReviews(receiver_id);
			int reTotal = receiverlist.size();

			int start = (pageNum - 1) * pageSize;
			int end = Math.min(start + pageSize, reTotal);

			List<ReviewsDTO> sellpageList = receiverlist.subList(start, end);

		

			req.setAttribute("count", reTotal);
			req.setAttribute("sellReviews", sellpageList); // 현재 페이지에 해당하는 게시판 목록
			req.setAttribute("pageNum", pageNum); // 현재 페이지 번호
		
			
			String myPageNumStr = req.getParameter("myPageNum"); // 현재 페이지 번호를 파라미터로 받아옴

			int myPageNum = (myPageNumStr == null) ? 1 : Integer.parseInt(myPageNumStr); // 현재 페이지 번호, 기본값은 1

			List<ReviewsDTO> mylist = reviewsMapper.myReviews(sender_id);
			
			int myTotal =mylist.size();

			int myStart = (myPageNum - 1) * pageSize;
			int myEnd = Math.min(myStart + pageSize, myTotal);

			
			List<ReviewsDTO> myPageList = mylist.subList(myStart, myEnd);
			
			
			req.setAttribute("myCount", myTotal);
			req.setAttribute("myReviews", myPageList); // 현재 페이지에 해당하는 게시판 목록
			req.setAttribute("myPageNum", myPageNum); // 현재 페이지 번호
			//req.setAttribute("myReviews", mylist);
			req.setAttribute("sellPoint", receiverlist);
			return "nego/reviews/allReviews";
		}

	// 후기 수정 페이지 이동
	@RequestMapping(value = "/edit_Reviews.do", method = RequestMethod.GET)
	public String edit_ReviewsForm(HttpServletRequest req, @RequestParam int product_id, @RequestParam String sender_id,
			HttpSession session) {
		ReviewsDTO dto = reviewsMapper.findReviews(product_id, sender_id);
		req.setAttribute("findReviews", dto);

		return "nego/reviews/reviewsEdit";
	}
	
	//후기 수정
	@RequestMapping(value = "/edit_Reviews.do", method = RequestMethod.POST)
	public String edit_ReviewsPro(HttpServletRequest req,@ModelAttribute ReviewsDTO dto) {
		int res = reviewsMapper.editReviews(dto);		
		return "redirect:mypage.do?member_id="+dto.getSender_id();
	}

	//후기 삭제
	@RequestMapping("/delete_Reviews.do")
	public String deleteReviews(@RequestParam int product_id, @RequestParam String sender_id) {
		int res = reviewsMapper.deleteReviews(product_id,sender_id);
		return "nego/mypage/Mypage";
	}
	
}
