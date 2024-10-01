package com.itbank.mavenNego.dto;

public class BuyCompletedDTO {
	private int pnum;
	private String buyer_id;
	private String pname;
	private int price;
	private String pimage;
	private String sale_completion_time;
	
	public String getBuyer_id() {
		return buyer_id;
	}
	public void setBuyer_id(String buyer_id) {
		this.buyer_id = buyer_id;
	}
	public String getPname() {
		return pname;
	}
	public void setPname(String pname) {
		this.pname = pname;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public String getPimage() {
		return pimage;
	}
	public void setPimage(String pimage) {
		this.pimage = pimage;
	}
	
	public String getSale_completion_time() {
		return sale_completion_time;
	}
	public void setSale_completion_time(String sale_completion_time) {
		this.sale_completion_time = sale_completion_time;
	}
	public int getPnum() {
		return pnum;
	}
	public void setPnum(int pnum) {
		this.pnum = pnum;
	}
}
