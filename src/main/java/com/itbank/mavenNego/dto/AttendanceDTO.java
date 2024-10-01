package com.itbank.mavenNego.dto;

import java.sql.Date;

public class AttendanceDTO {
    private String member_id;     // 멤버 아이디
    private int count;           // 출석 횟수
    private Date attendance_date; // 출석 시간
 


    public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public Date getAttendance_date() {
		return attendance_date;
	}

	public void setAttendance_date(Date attendance_date) {
		this.attendance_date = attendance_date;
	}

}



