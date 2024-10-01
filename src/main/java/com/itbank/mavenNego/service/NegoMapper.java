package com.itbank.mavenNego.service;

import java.io.IOException;
import java.io.Reader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.mavenNego.dto.CateDTO;




@Service
public class NegoMapper {
	
	@Autowired
	private SqlSession sqlSession;
	
	public List <CateDTO> mainListAll(){
		
		return sqlSession.selectList("mainListAll");
		
	}
	
	public List <CateDTO> mainList(){
		
		return sqlSession.selectList("mainList");
		
	}
	
	public  List <CateDTO> subList(int id){
		return sqlSession.selectList("subList",id);
			
	}
	
	public  List <CateDTO> itemList(int id){
		return sqlSession.selectList("itemList",id);
		
	}
	
	public  CateDTO cateById(int id) {
		return  sqlSession.selectOne("cateById", id);
         
    }
	
	public String categoryName(int categoryId) {
        return sqlSession.selectOne("categoryName", categoryId);
    }
	
	public String parentCategoryName(int id) {
		return sqlSession.selectOne("parentCategoryName", id);
	    
	}
	
	public String grandParentCategoryName(int id) {
		return  sqlSession.selectOne("grandParentCategoryName", id);
           
    }
	
	public int insertCate(CateDTO dto) {
		return sqlSession.insert("insertCate",dto);
	}
	
	public int insertSubCate(String name, int parentId, int level) {
		Map<String, Object> params = new HashMap<String,Object>();
        params.put("name", name);
        params.put("parentId", parentId);
        params.put("level", level);
		return sqlSession.insert("insertSubCate",params);
    }
	
	public int updateCate(String name,int id) {
		Map<String, Object> params = new HashMap<String,Object>();
        params.put("name", name);
        params.put("id", id);
		return sqlSession.update("updateCate",params);
	}
	
	public int deleteCate(int id) {
		return sqlSession.delete("deleteCate",id);
	}
	
	
}
