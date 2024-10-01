package com.itbank.mavenNego.dto;

public class MemberDTO {
	 private String id;
	    private String passwd;
	    private String name;
	    private String ssn1;
	    private String ssn2;
	    private String email;
	    private String hp1;
	    private String hp2;
	    private String hp3;
	    private String addr;
	    private int  trust_score;
	    
	    
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
		public String getPasswd() {
			return passwd;
		}
		public void setPasswd(String passwd) {
			this.passwd = passwd;
		}
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public String getSsn1() {
			return ssn1;
		}
		public void setSsn1(String ssn1) {
			this.ssn1 = ssn1;
		}
		public String getSsn2() {
			return ssn2;
		}
		public void setSsn2(String ssn2) {
			this.ssn2 = ssn2;
		}
		public String getEmail() {
			return email;
		}
		public void setEmail(String email) {
			this.email = email;
		}
		public String getHp1() {
			return hp1;
		}
		public void setHp1(String hp1) {
			this.hp1 = hp1;
		}
		public String getHp2() {
			return hp2;
		}
		public void setHp2(String hp2) {
			this.hp2 = hp2;
		}
		public String getHp3() {
			return hp3;
		}
		public void setHp3(String hp3) {
			this.hp3 = hp3;
		}
		public String getAddr() {
			return addr;
		}
		public void setAddr(String addr) {
			this.addr = addr;
		}
		public int getTrust_score() {
			return trust_score;
		}
		public void setTrust_score(int trust_score) {
			this.trust_score = trust_score;
		}
	    
		/*
		 CREATE TABLE member (
		    id VARCHAR(50) PRIMARY KEY,        ---아이디
		    passwd VARCHAR(255) NOT NULL,      ---비밀번호
		    name VARCHAR(100) NOT NULL,        ---이름
		    Ssn1 VARCHAR(6) NOT NULL,          ---주민번호 앞자리
		    Ssn2 VARCHAR(7) NOT NULL,          ---주민번호 뒷자리
		    email VARCHAR(100) NOT NULL,       ---이메일
		    hp1 VARCHAR(3) NOT NULL,           ---전화번호
		    hp2 VARCHAR(4) NOT NULL,
		    hp3 VARCHAR(4) NOT NULL,
		    addr VARCHAR(255) NOT NULL         ---주소
		);
		*/

}
