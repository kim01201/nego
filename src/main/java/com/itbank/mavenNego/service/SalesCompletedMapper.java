package com.itbank.mavenNego.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.mavenNego.dto.BuyCompletedDTO;
import com.itbank.mavenNego.dto.SalesCompletedDTO;
import com.itbank.mavenNego.dto.StorageDTO;

@Service
public class SalesCompletedMapper {
	@Autowired
	private SqlSession sqlSession;

	// 판매완료 버튼 클릭시
	public int saleComplete(StorageDTO dto) {
		return sqlSession.insert("saleComplete", dto);
	}

	// 상품명 검색
	public List<SalesCompletedDTO> searchCompleted(String search) {
		return sqlSession.selectList("searchCompleted", search);
	}

	// 판매자의 판매완료 물품 리스트
	public List<SalesCompletedDTO> sellerCompleted(String seller_id) {
		return sqlSession.selectList("sellerCompleted", seller_id);
	}

	// 판매 테이블값 가져오기
	public SalesCompletedDTO getSellCompleted(int pnum) {
		return sqlSession.selectOne("getSellCompleted", pnum);
	}

	// 삭제하기
	public int deleteComplete(int pnum) {
		return sqlSession.delete("deleteComplete", pnum);
	}

	// 판매자 안전거래 횟수
	public int sellerCount(String seller_id) {
		return sqlSession.selectOne("sellerCount", seller_id);
	}
	
	//회원 삭제시 신고 값 삭제
	public int deleteMember_seller(String id) {
		return sqlSession.delete("deleteMember_seller",id);
	}
}
