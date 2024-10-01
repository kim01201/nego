	package com.itbank.mavenNego.service;
	
	import java.util.HashMap;
	import java.util.List;
	import java.util.Map;
	
	import org.apache.ibatis.session.SqlSession;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;

import com.itbank.mavenNego.dto.ProductDTO;
import com.itbank.mavenNego.dto.WishListDTO;
	
	@Service
	public class WishListMapper {
		@Autowired
		private SqlSession sqlSession;
		
		public List<WishListDTO> wishList(){
			return sqlSession.selectList("wishList");
		}
		
		public int insertWish(WishListDTO dto) {
			return sqlSession.update("insertWish",dto);
		}

		
		public List<WishListDTO> find_myWish(WishListDTO dto) {
		    Map<String, Object> params = new HashMap<String,Object>();
		    params.put("product_name", dto.getProduct_name());
		    params.put("member_id", dto.getMember_id());
		    return sqlSession.selectList("find_myWish", params);
		}

	
		public WishListDTO findWish(int product_id, String member_id) {
			 Map<String, Object> params = new HashMap<String,Object>();
			    params.put("product_id", product_id);
			    params.put("member_id", member_id);
			  return sqlSession.selectOne("findWish", params);
		}
	
		public int deleteWish(int product_id, String member_id) {
			 Map<String, Object> params = new HashMap<String,Object>();
			    params.put("product_id", product_id);
			    params.put("member_id", member_id);
			    return sqlSession.delete("deleteWish", params);
		}
		
		public int wishCount(int product_id) {
	        return sqlSession.selectOne("wishCount", product_id);
	    }
		
		public List<WishListDTO> myWish(String member_id){
			return sqlSession.selectList("myWish",member_id);
		}
		
		public int prod_delete(int product_id) {
			return sqlSession.delete("prod_delete",product_id);
		}
		
		public  List<WishListDTO> getWish(int pnum) {
		return sqlSession.selectList("getWish",pnum);
		}
	

		public int updateWish(WishListDTO wishDTO) {
			return sqlSession.update("updateWish",wishDTO);
		}

		public int delete_member(int pnum) {
			return sqlSession.delete("delete_member",pnum);
		}

		//회원 삭제시 찜 삭제
		public  int deleteMember_wish(String id) {
			return sqlSession.delete("deleteMember_wish",id);
		}

		
	}
