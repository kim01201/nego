package com.itbank.mavenNego.service;


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.itbank.mavenNego.dto.AttendanceDTO;
import com.itbank.mavenNego.dto.MemberDTO;

@Service

public class MemberMapper {
	@Autowired
	private SqlSession sqlSession;
	
	
	 
	// Define constants
    public static final int OK = 1;
    public static final int NOT_PW = 2;
    public static final int NOT_ID = 3;
    
    public int insertMember(MemberDTO dto) {
        return sqlSession.insert("insertMember", dto);    
    }
    
	    public int loginCheck(String id, String passwd) {
	       
	    	Map<String, String> params = new HashMap<String,String>();
	        params.put("id", id);
	        params.put("passwd", passwd);
	
	        Integer count = sqlSession.selectOne("loginCheck", params);
	        if (count != null && count > 0) {
	            return OK;
	        } else {
	            Integer idExists = sqlSession.selectOne("idCheck", id);
	            if (idExists != null && idExists > 0) {
	                return NOT_PW;
	            } else {
	                return NOT_ID;
	            }
	        }
	    }

    public MemberDTO getMember(String id) {
        return sqlSession.selectOne("getMember", id);
        
    }
    
    public String findIdByNameAndEmail(String name, String email) {
        Map<String, String> params = new HashMap<String,String>();
        params.put("name", name);
        params.put("email", email);
        return sqlSession.selectOne("findIdByNameAndEmail", params);
    }
    
    public String findPasswdByEmail(String id, String email) {
  		Map<String, String> params = new HashMap<String,String>();
          params.put("id", id);
          params.put("email", email);
          return sqlSession.selectOne("com.itbank.mavenNego.dto.negoMapper.findPasswdByEmail", params);
    }
    
    public List<MemberDTO> getAllMembers() {
        return sqlSession.selectList("getAllMembers");
    }
	
	
	public List<MemberDTO> findMember(Map<String, String> params) {
        return sqlSession.selectList("findmember", params);
}
	
	public String findIdByEmail(String id, String email) {
		Map<String, String> params = new HashMap<String,String>();
        params.put("id", id);
        params.put("email", email);
		 return sqlSession.selectOne("com.itbank.mavenMapper.dto.MemberMapper.findIdByEmail", params);
	}

	public int checkId(String id) {
		return sqlSession.selectOne("checkId", id);
	}
	
    public int insertAttendance(AttendanceDTO dto) {
        try {
            System.out.println("Attempting to insert attendance: " + dto);
            int result = sqlSession.update("insertAttendance", dto);
            System.out.println("Inserted attendance: " + dto + ", result: " + result);
            return result;
        } catch (Exception e) {
            System.err.println("Error inserting attendance: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    
    public List<AttendanceDTO> getAttendanceByMemberId(String memberId) {
        return sqlSession.selectList("getAttendanceByMemberId", memberId);
    }

	public int deleteMember(String id) {
		 return sqlSession.delete("deleteMember", id);
	}
	
	//리뷰 작성시 신뢰지수
	public int reviews_score(String receiver_id) {
		return sqlSession.update("reviews_score",receiver_id);
	}
	
	// 리뷰 작성시 판매자 신뢰지수 증가
		public int greviews_score(String receiver_id) {
			return sqlSession.update("greviews_score", receiver_id);
		}
		
		// 리뷰 작성시 판매자 신뢰지수 감소
		public int breviews_score(String receiver_id) {
			return sqlSession.update("breviews_score", receiver_id);
		}
	
	//신고 당하면 신뢰점수 하락
	public int fraud_score(String fraudAccount) {
		return sqlSession.update("fraud_score",fraudAccount);
	}
	
	public int updateMember(MemberDTO dto) {
        return sqlSession.update("updateMember", dto);
    }
	
	//판매승인시 판매자 신뢰점수 증가
		public int sell_score(String seller_id) {
			return sqlSession.update("sell_score",seller_id);
		}
		
	//신고당한 사람 아이디 찾기
	public MemberDTO fraudMember(String fraudAccount) {
		return sqlSession.selectOne("fraudMember", fraudAccount);
	}
	
	public AttendanceDTO find_attend(String id) {
		return sqlSession.selectOne("find_attend",id);
	}
	
	public int updateAttendance(AttendanceDTO dto) {
		return sqlSession.update("updateAttendance",dto);
	}
	
	public int delete_attend(String id) {
		return sqlSession.delete("delete_attend",id);
	}
	
	//카카오톡 로그인
		public String getAccessToken (String authorize_code) {
			String access_Token = "";
			String refresh_Token = "";
			String reqURL = "https://kauth.kakao.com/oauth/token";

			try {
				URL url = new URL(reqURL);
	            
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				// POST 요청을 위해 기본값이 false인 setDoOutput을 true로
	            
				conn.setRequestMethod("POST");
				conn.setDoOutput(true);
				// POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
	            
				BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
				StringBuilder sb = new StringBuilder();
				sb.append("grant_type=authorization_code");
	            
				sb.append("&client_id=d9d93e271c5b4a57f5de6e5b02476dc2"); //본인이 발급받은 key
				sb.append("&redirect_uri=http://192.168.59.27:8080/mavenNego/user/kakao/callback"); // 본인이 설정한 주소
	            
				sb.append("&code=" + authorize_code);
				bw.write(sb.toString());
				bw.flush();
	            
				// 결과 코드가 200이라면 성공
				int responseCode = conn.getResponseCode();
				System.out.println("responseCode : " + responseCode);
	            
				// 요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
				BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String line = "";
				String result = "";
	            
				while ((line = br.readLine()) != null) {
					result += line;
				}
				System.out.println("response body : " + result);
	            
				// Gson 라이브러리에 포함된 클래스로 JSON파싱 객체 생성
				JsonParser parser = new JsonParser();
				JsonElement element = parser.parse(result);
	            
				access_Token = element.getAsJsonObject().get("access_token").getAsString();
				refresh_Token = element.getAsJsonObject().get("refresh_token").getAsString();
	            
				System.out.println("access_token : " + access_Token);
				System.out.println("refresh_token : " + refresh_Token);
	            
				br.close();
				bw.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			return access_Token;
		}
		
		public HashMap<String, Object> getUserInfo(String access_Token) {

			// 요청하는 클라이언트마다 가진 정보가 다를 수 있기에 HashMap타입으로 선언
			HashMap<String, Object> userInfo = new HashMap<String, Object>();
			String reqURL = "https://kapi.kakao.com/v2/user/me";
			try {
				URL url = new URL(reqURL);
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("GET");

				// 요청에 필요한 Header에 포함될 내용
				conn.setRequestProperty("Authorization", "Bearer " + access_Token);

				int responseCode = conn.getResponseCode();
				System.out.println("responseCode : " + responseCode);

				BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));

				String line = "";
				String result = "";

				while ((line = br.readLine()) != null) {
					result += line;
				}
				System.out.println("response body : " + result);

				JsonParser parser = new JsonParser();
				JsonElement element = parser.parse(result);
				JsonObject properties = element.getAsJsonObject().get("properties").getAsJsonObject();
				
				String id = element.getAsJsonObject().get("id").getAsString();
				String nickname = properties.getAsJsonObject().get("nickname").getAsString();
				
				userInfo.put("properties", properties);
				userInfo.put("nickname", nickname);
				userInfo.put("id",	id);
				
				

			} catch (IOException e) {
				e.printStackTrace();
			}
			return userInfo;
		}
		
		public void kakaoLogout(String accessToken) {
		    String reqUrl = "https://kapi.kakao.com/v1/user/logout";

		    try{
		        URL url = new URL(reqUrl);
		        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		        conn.setRequestMethod("POST");
		        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

		        int responseCode = conn.getResponseCode();
		        System.out.println("[KakaoApi.kakaoLogout] responseCode : {}" + responseCode);

		        BufferedReader br;
		        if (responseCode >= 200 && responseCode <= 300) {
		            br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		        } else {
		            br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		        }

		        String line = "";
		        StringBuilder responseSb = new StringBuilder();
		        while((line = br.readLine()) != null){
		            responseSb.append(line);
		        }
		        String result = responseSb.toString();
		        System.out.println("kakao logout - responseBody = {}"+ result);

		    }catch (Exception e){
		        e.printStackTrace();
		    }
		}
		
		//출석시 신뢰지수
		public int attend_score(String member_id) {
			return sqlSession.update("attend_score",member_id);
		}
		
		public void saveMember(MemberDTO member) {
	        sqlSession.insert("saveMember", member);
	    }
	
}
