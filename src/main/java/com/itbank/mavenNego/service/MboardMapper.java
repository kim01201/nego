package com.itbank.mavenNego.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.mavenNego.dto.GboardDTO;
import com.itbank.mavenNego.dto.MboardDTO;

@Service
public class MboardMapper {
 @Autowired
 private SqlSession sqlSession;
 	
 public List<MboardDTO> boardList(){
	 return sqlSession.selectList("boardList");
 }
 public int getCount() {
     return sqlSession.selectOne("getCount");
 }
 
 public int insertBoard(MboardDTO dto) {
	 return sqlSession.insert("insertBoard",dto);
 }
 
 public MboardDTO getBoard(int num) {
	 return sqlSession.selectOne("getBoard",num);
 }
 
 public int plusReadcount(int num) {
		return sqlSession.update("plusReadcount", num);
	}
 
 public int updateBoard(MboardDTO dto) {
		return sqlSession.update("updateBoard", dto);
	}
 
 public int deleteBoard(int num) {
	 return sqlSession.delete("deleteBoard",num);
 }
 
 public void updateNewSetp(int num) {
	 sqlSession.update("updateNewStep", num);
 }
 
 public void updateReStep(int num) {
     sqlSession.update("updateReStep", num);
 }
 
 public List<MboardDTO> searchMboardList(String search) {
		return sqlSession.selectList("searchMboardList",search);
	}
 
 public int reMboard_id(String id) {
	 return sqlSession.update("reMboard_id",id);
 }
}
