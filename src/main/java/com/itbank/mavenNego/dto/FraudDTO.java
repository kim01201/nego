package com.itbank.mavenNego.dto;

public class FraudDTO {
	private String fraudAccount;	//신고 전화번호, 계좌번호, 메신저ID, 이메일 등
	private int fraudCount;			//누적 신고 횟수
	private int fraudTotalCost;		//누적 사기 금액
	private String member_id;
	
	
	public String getFraudAccount() {
		return fraudAccount;
	}
	public void setFraudAccount(String fraudAccount) {
		this.fraudAccount = fraudAccount;
	}
	public int getFraudCount() {
		return fraudCount;
	}
	public void setFraudCount(int fraudCount) {
		this.fraudCount = fraudCount;
	}
	public int getFraudTotalCost() {
		return fraudTotalCost;
	}
	public void setFraudTotalCost(int fraudTotalCost) {
		this.fraudTotalCost = fraudTotalCost;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	
	
}
