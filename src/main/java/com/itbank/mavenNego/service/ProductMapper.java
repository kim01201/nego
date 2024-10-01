package com.itbank.mavenNego.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.File;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.mavenNego.dto.ProductDTO;

@Service
public class ProductMapper {
	@Autowired
	private SqlSession sqlSession;
	
	//전체 상품
	public List<ProductDTO> allProd() {
		return sqlSession.selectList("allProd");
	}
	//검색창에 검색
	public List<ProductDTO> searchProd(String search) {
		 if (search == null || search.trim().isEmpty()) {
		        search = null;  // null로 설정하여 모든 항목을 검색
		 }
		return sqlSession.selectList("searchProd",search);
	}
	
	//카테고리 선택 검색
	public List<ProductDTO> cateSearchProd(Map<String, Object> params) {
		return sqlSession.selectList("cateSearchProd",params);
	}
	
	public Map<String, Object> searchPriceStats(Map<String, Object> params) {
		return sqlSession.selectOne("searchPriceStats",params);
	}

	
	//상품 카테고리 설정, 가격대 설정, 판매상태 설정 전부 선택 후 검색
	public List<ProductDTO> allSearchProd(ProductDTO dto) {
		return sqlSession.selectList("allSearchProd");
	}
	//상품 상세보기(상품 클릭시), 수정하기(pnum으로 dto 가져오기)
	public ProductDTO getProd(int pnum) {
		return sqlSession.selectOne("getProd", pnum);
	}

	
	//멤버아이디로 상품가져오기
	public List<ProductDTO> idProd(Map<String, Object> params){
		return sqlSession.selectList("idProd",params);
	}
	
	public List<ProductDTO> idProd_sell(String member_id){
		return sqlSession.selectList("idProd_sell",member_id);
	}
	
	public List<ProductDTO> idProd_complete(String member_id){
		return sqlSession.selectList("idProd_complete",member_id);
	}
	
	//랜덤 추천
	public List<ProductDTO> randomProd() {
		return sqlSession.selectList("randomProd");
	}
	//조회수 기반 
	public List<ProductDTO> readcountProd() {
		return sqlSession.selectList("readCountProd");
	}
	
	//최신순
	public List<ProductDTO> dateProd() {
		return sqlSession.selectList("dateProd");
	}
	
	//조회수 증가
	public int plusPreadcount(int pnum) {
		return sqlSession.update("plusPreadcount", pnum);
	}
	
	//찜 증가
	public int plusPlike(int pnum) {
		return sqlSession.update("plusPlike", pnum);
	}
	
	//상품등록(판매하기)
	public int insertProd(ProductDTO dto) {
		return sqlSession.insert("insertProd", dto);
	}
	
	public int getLastInsertId() {
		return sqlSession.selectOne("getLastInsertId");
	}
	//상품등록 수정하기
	public int editProd(ProductDTO dto) {
		return sqlSession.update("editProd", dto);
	}
	
	//상품삭제하기
	public int deleteProd(int pnum) {
		return sqlSession.delete("deleteProd", pnum);
	}
	
	//시세 조회
		public List<Double> marketPrice(String product) {
			return sqlSession.selectList("marketPrice", product);
		}
		public List<Double> marketPriceByCategory(String category) {
			return sqlSession.selectList("marketPriceByCategory", category);
		}
		
		//pstatus를 '판매완료'로 업데이트
		public int updatePstatus(int pnum) {
			return sqlSession.update("updatePstatus",pnum);
		}
		
		   //상품명 검색시 평균값
        public int avg1Price(String search) {
           Integer avg1Price = sqlSession.selectOne("avg1Price", search);
            return avg1Price != null ? avg1Price : 0;
        }
        
        //상품명 검색시 최소값
        public int min1Price(String search) {
           Integer min1Price = sqlSession.selectOne("min1Price", search);
            return min1Price != null ? min1Price : 0;
        }
        //상품명 검색시 최대값
        public int max1Price(String search) {
           Integer max1Price = sqlSession.selectOne("max1Price", search);
            return max1Price != null ? max1Price : 0;
        }
			
			//카테고리 평균값
			public double avgPrice2(String pcategory) {
				return sqlSession.selectOne("avgPrice2", pcategory);
			}
			
			//카테고리 최소값
			public int minPrice2(String pcategory) {
				return sqlSession.selectOne("minPrice2", pcategory);
			}
			
			//카테고리 최대값
			public int maxPrice2(String pcategory) {
				return sqlSession.selectOne("maxPrice2", pcategory);
			}
			
			//pstatus를 '거래중'으로 업데이트
			public int update1Pstatus() {
				return sqlSession.update("update1Pstatus");
			}
			
			//pstatus를 '판매중'으로 업데이트
			public int rePstatus(int pnum) {
				return sqlSession.update("rePstatus", pnum);
			}

			
			
			//회원삭제시 찜한 상품삭제를 위한 값 가져오기
			public List<Integer> getProdPnum(String id){
				return sqlSession.selectList("getProdPnum",id);
			}
			
			//회원삭제시 상품 삭제
			public int deleteMember_pro(String id) {
				return sqlSession.delete("deleteMember_pro",id);
			}

			public List<ProductDTO> idProd_reserve(String member_id) {
				return sqlSession.selectList("idProd_reserve",member_id);
			}

			 public ProductDTO getProdByRoomId(String roomId) {
			        return sqlSession.selectOne("getProdByRoomId", roomId);
			    }

}
