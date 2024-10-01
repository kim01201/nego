package com.itbank.mavenNego.service;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.mavenNego.dto.BuyCompletedDTO;
import com.itbank.mavenNego.dto.StorageDTO;

@Service
public class BuyCompletedMapper {
	@Autowired
	private SqlSession sqlSession;
	
	//판매완료 버튼 클릭시
	public int buyComplete(StorageDTO dto) {
		return sqlSession.insert("buyComplete", dto);
	}
	
	//상품명 검색
	public List<BuyCompletedDTO> searchBuyCompleted(String search) {
		return sqlSession.selectList("searchBuyCompleted", search);
	}
	
	//구매자의 구매완료 물품 리스트
	public List<BuyCompletedDTO> buyCompleted(String buyer_id) {
		return sqlSession.selectList("buyCompleted", buyer_id);
	}
	
	//삭제하기
	public int deleteBuyComplete(int pnum) {
		return sqlSession.delete("deleteBuyComplete", pnum);
	}
	
	
	//구매 테이블값 가져오기
	public BuyCompletedDTO getBuyCompleted(int pnum) {
		return sqlSession.selectOne("getBuyCompleted",pnum);
	}
	
	//회원 삭제시 구매정보 삭제
	public int deleteMember_buyer(String id) {
		return sqlSession.delete("deleteMember_buyer",id);
	}
	
	
	
}
