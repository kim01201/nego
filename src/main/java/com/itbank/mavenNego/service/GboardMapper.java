package com.itbank.mavenNego.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.mavenNego.dto.GboardDTO;

@Service
public class GboardMapper {
	@Autowired
	private SqlSession sqlSession;
	
	public List <GboardDTO> gboardList(){
		return sqlSession.selectList("gboardList");
	}
	
	public int insertGboard(GboardDTO dto) {
		return sqlSession.insert("insertGboard", dto);
	}

	public GboardDTO getGboard(int num){
	return sqlSession.selectOne("getGboard", num);
	}

	public int deleteGboard(int num) {
	return sqlSession.delete("deleteGboard", num);
	}

	public int updateGboard(GboardDTO dto) {
	return sqlSession.update("updateGboard", dto);
	}

	public List<GboardDTO> searchGboardList(String search) {
		return sqlSession.selectList("searchGboardList",search);
	}
	
}
