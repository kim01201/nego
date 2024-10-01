package com.itbank.mavenNego.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.mavenNego.dto.AddressDTO;

@Service
public class AddressMapper {
	
	@Autowired
	private SqlSession sqlSession;
	
	public List<AddressDTO> addList(String member_id){
		return sqlSession.selectList("addList",member_id);
	}
	
	public int insertAdd(AddressDTO dto) {
		return sqlSession.insert("insertAdd",dto);
	}
	
	public int deleteAdd(int id) {
		return sqlSession.delete("deleteAdd",id);
	}
	public int addCount(String member_id) {
		return sqlSession.selectOne("addCount",member_id);
	}
	
	public int deleteMember_add(String id) {
		return sqlSession.delete("deleteMember_add",id);
	}
}
