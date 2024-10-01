package com.itbank.mavenNego.dto;

import org.springframework.web.multipart.MultipartFile;

public class ProductDTO {
	private int pnum;
    private String member_id;
    private String create_date;
    private String pcategory1;
    private String pcategory2;
    private String pcategory3;
    private String pname;
    private int price;
    private String pimage; // 변경된 필드

    
	private int preadcount;
    private int plike;
    private String pdescription;
    private String pcontent;
    private String pdeliverytype;
    private String pstatus;
    
    private int avgPrice;
    
    private int wishCount;
    private int reviewsCount;
    private int sellCount;
    
    private String hours_difference; // 등록 시간 차이 필드 추가
    private MultipartFile img;
    
    //trust_score NUMBER DEFAULT 500 컬럼 추가
    private int trust_score;
    public String getHours_difference() {
        return hours_difference;
    }

    public void setHours_difference(String hours_difference) {
        this.hours_difference = hours_difference;
    }
    public MultipartFile getImg() {
		return img;
	}
	public void setImg(MultipartFile img) {
		this.img = img;
	}
	public int getPnum() {
		return pnum;
	}
	public void setPnum(int pnum) {
		this.pnum = pnum;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
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
	public int getPreadcount() {
		return preadcount;
	}
	public void setPreadcount(int preadcount) {
		this.preadcount = preadcount;
	}
	public int getPlike() {
		return plike;
	}
	public void setPlike(int plike) {
		this.plike = plike;
	}
	public String getPdescription() {
		return pdescription;
	}
	public void setPdescription(String pdescription) {
		this.pdescription = pdescription;
	}
	public String getPcontent() {
		return pcontent;
	}
	public void setPcontent(String pcontent) {
		this.pcontent = pcontent;
	}
	public String getPdeliverytype() {
		return pdeliverytype;
	}
	public void setPdeliverytype(String pdeliverytype) {
		this.pdeliverytype = pdeliverytype;
	}
	public String getPstatus() {
		return pstatus;
	}
	public void setPstatus(String pstatus) {
		this.pstatus = pstatus;
	}
	
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getPcategory3() {
		return pcategory3;
	}
	public void setPcategory3(String pcategory3) {
		this.pcategory3 = pcategory3;
	}
	public String getPcategory1() {
		return pcategory1;
	}
	public void setPcategory1(String pcategory1) {
		this.pcategory1 = pcategory1;
	}
	public String getPcategory2() {
		return pcategory2;
	}
	public void setPcategory2(String pcategory2) {
		this.pcategory2 = pcategory2;
	}
	public int getAvgPrice() {
		return avgPrice;
	}
	public void setAvgPrice(int avgPrice) {
		this.avgPrice = avgPrice;
	}
	public int getWishCount() {
		return wishCount;
	}
	public void setWishCount(int wishCount) {
		this.wishCount = wishCount;
	}

	public int getTrust_score() {
		return trust_score;
	}

	public void setTrust_score(int trust_score) {
		this.trust_score = trust_score;
	}

	public int getReviewsCount() {
		return reviewsCount;
	}

	public void setReviewsCount(int reviewsCount) {
		this.reviewsCount = reviewsCount;
	}

	public int getSellCount() {
		return sellCount;
	}

	public void setSellCount(int sellCount) {
		this.sellCount = sellCount;
	}
	
}


