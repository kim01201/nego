package com.itbank.mavenNego.dto;

public class SalesCompletedDTO {
	private int pnum;
	private String seller_id;
	private String pname;
	private int price;
	private String pimage;
	private String sale_completion_time;
	
	public String getSeller_id() {
		return seller_id;
	}
	public void setSeller_id(String seller_id) {
		this.seller_id = seller_id;
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
	
	public int getPnum() {
		return pnum;
	}
	public void setPnum(int pnum) {
		this.pnum = pnum;
	}
	public String getSale_completion_time() {
		return sale_completion_time;
	}
	public void setSale_completion_time(String sale_completion_time) {
		this.sale_completion_time = sale_completion_time;
	}
	
}

