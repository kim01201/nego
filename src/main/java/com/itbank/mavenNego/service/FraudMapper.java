package com.itbank.mavenNego.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.mavenNego.dto.FraudDTO;

@Service
public class FraudMapper {
	@Autowired
	private SqlSession sqlSession;
	
	//첫번째 신고
	public int insertFraud(FraudDTO dto) {
		return sqlSession.insert("insertFraud", dto);
	}
	
	//누적 신고
	public int updateFraud(FraudDTO dto) {
		return sqlSession.update("updateFraud", dto);
	}
	
	//사기 조회하기
	public FraudDTO searchFraud(String fraudAccount) {
		return sqlSession.selectOne("searchFraud", fraudAccount);
	}
	
	public List<FraudDTO> fraudList() {
		return sqlSession.selectList("fraudList");
	}
	
	//회원 삭제시 신고 값 삭제
	public int deleteMember_fraud(String id) {
		return sqlSession.delete("deleteMember_fraud",id);
	}
}
