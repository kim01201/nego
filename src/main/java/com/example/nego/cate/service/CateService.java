package com.example.nego.cate.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.nego.dto.CateDTO;

@Service
public class CateService {

	@Autowired
	private SqlSession sqlSession;
	

	public List <CateDTO> mainList(){
		
		return sqlSession.selectList("mainList");
	}
	
	public  List <CateDTO> subList(int id){
		return sqlSession.selectList("subList",id);
			
	}
	
	public  List <CateDTO> itemList(int id){
		return sqlSession.selectList("itemList",id);
		
	}

	
}
