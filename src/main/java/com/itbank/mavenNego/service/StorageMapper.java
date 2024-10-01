package com.itbank.mavenNego.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.mavenNego.dto.StorageDTO;

@Service
public class StorageMapper {
	@Autowired
	private SqlSession sqlSession;
	
	//구매 버튼 클릭시
	public int ifClickBuy(String buyer_id, int pnum) {
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("buyer_id", buyer_id);
	    map.put("pnum", pnum);
	    return sqlSession.insert("ifClickBuy", map);
	}
	//구매자의 구매 승인 리스트
	public List<StorageDTO> sendBuyer(String buyer_id) {
		return sqlSession.selectList("sendBuyer", buyer_id);
	}
	
	//판매자의의 판매 승인 리스트
	public List<StorageDTO> sendSeller(String seller_id) {
		return sqlSession.selectList("sendSeller", seller_id);
	}
	
	
	//승인 거절하기
	public int deny(String buyer_id, int pnum) {
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("buyer_id", buyer_id);
	    map.put("pnum", pnum);
		return sqlSession.delete("deny", map);
	}
	
	
	//판매버튼 클릭시 정보 가져오기
	public StorageDTO getStorage(int pnum) {
		return sqlSession.selectOne("getStorage",pnum);
	}
	
	//판매버튼 클릭시 해당하는 스토리지 삭제
	public int deleteStorage(int pnum) {
		return sqlSession.delete("deleteStorage",pnum);
	}
	

	//판매내역에 보낼 값
	public List<StorageDTO> sendSellList(String seller_id, int pnum) {
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("seller_id", seller_id);
	    map.put("pnum", pnum);
		return sqlSession.selectList("sendSellList", map);
	}
	
	//구매내역에 보낼 값
	public List<StorageDTO> sendBuyList(String buyer_id, int pnum) {
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("buyer_id", buyer_id);
	    map.put("pnum", pnum);
		return sqlSession.selectList("sendBuyList", map);
	}
	
	//회원 삭제시 삭제할 상품 번호 가져오기
		public List<Integer> getPnum(String id){
			return sqlSession.selectList("getPnum",id);
		}
		
		//회원 삭제시 값 삭제
		public int deleteStorageMember(String id) {
			return sqlSession.delete("deleteStorageMember",id);
		}

}
