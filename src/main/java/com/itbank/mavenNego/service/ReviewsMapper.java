package com.itbank.mavenNego.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.mavenNego.dto.ReviewsDTO;

@Service
public class ReviewsMapper {

	@Autowired
	private SqlSession sqlSession;
	
	
	// 후기 작성
	public int insertReviews(ReviewsDTO dto) {
		return sqlSession.insert("insertReviews", dto);
	}

	//후기 작성시에 필요한 값 판매 테이블에서 가져오기
	public int getReviews(int product_id) {
		return sqlSession.selectOne("getReviews",product_id);
	}
	
	// 같은 상품에 후기 중복 체크
	public ReviewsDTO findReviews(int product_id, String sender_id) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("product_id", product_id);
		params.put("sender_id", sender_id);
		return sqlSession.selectOne("findReviews", params);
	}

	// 판매자 후기 갯수
	public int reviewsCount(String receiver_id) {
		return sqlSession.selectOne("reviewsCount", receiver_id);
	}

	// 내가 작성한 후기 보기
	public List<ReviewsDTO> myReviews(String sender_id){
		return sqlSession.selectList("myReviews",sender_id);
	}

	// 판매자에 대한 후기 보기
	public List<ReviewsDTO> sellReviews(String receiver_id){
		return sqlSession.selectList("sellReviews",receiver_id);
	}
	
	//후기 수정
	public int editReviews(ReviewsDTO dto) {
		return sqlSession.update("editReviews",dto);
	}
	
	//후기 삭제
	public int deleteReviews(int product_id,String sender_id) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("product_id", product_id);
		params.put("sender_id", sender_id);
		return sqlSession.delete("deleteReviews",params);
	}
	
	//회원 탈퇴시 작성자 아이디 변경
		public int reReviews_id(String id) {
			return sqlSession.update("reReviews_id",id);
		}
}
