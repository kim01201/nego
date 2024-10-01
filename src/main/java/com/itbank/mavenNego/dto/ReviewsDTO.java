package com.itbank.mavenNego.dto;

public class ReviewsDTO {
   private String sender_id;
   private String receiver_id;
   private String content;
   private String reg_date;
   private String product_name;
   private int product_id;
   private String goodPoints;
   private String badPoints;
   
   
public String getSender_id() {
	return sender_id;
}
public void setSender_id(String sender_id) {
	this.sender_id = sender_id;
}
public String getReceiver_id() {
	return receiver_id;
}
public void setReceiver_id(String receiver_id) {
	this.receiver_id = receiver_id;
}
public String getContent() {
	return content;
}
public void setContent(String content) {
	this.content = content;
}
public String getReg_date() {
	return reg_date;
}
public void setReg_date(String reg_date) {
	this.reg_date = reg_date;
}
public String getProduct_name() {
	return product_name;
}
public void setProduct_name(String product_name) {
	this.product_name = product_name;
}
public int getProduct_id() {
	return product_id;
}
public void setProduct_id(int product_id) {
	this.product_id = product_id;
}
public String getGoodPoints() {
	return goodPoints;
}
public void setGoodPoints(String goodPoints) {
	this.goodPoints = goodPoints;
}
public String getBadPoints() {
	return badPoints;
}
public void setBadPoints(String badPoints) {
	this.badPoints = badPoints;
}
   

   
}
