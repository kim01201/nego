package com.itbank.mavenNego.dto;

public class ChatMessageDTO {
    private String sender_Id;
    private String Receiver_Id;
    private String content;
    private String room_Id;
    private String message_Id;
    private int pnum;
    public ChatMessageDTO() {}

    public ChatMessageDTO(String sender_Id, String receiver_Id, String content, String room_Id, String message_Id) {
        this.sender_Id = sender_Id;
        this.Receiver_Id = receiver_Id;
        this.content = content;
        this.room_Id = room_Id;
        this.message_Id = message_Id;
    }

    // Getters and Setters
    public String getSender_Id() {
        return sender_Id;
    }

    public void setSender_Id(String sender_Id) {
        this.sender_Id = sender_Id;
    }

    public String getReceiver_Id() {
        return Receiver_Id;
    }

    public void setReceiver_Id(String receiver_Id) {
        this.Receiver_Id = receiver_Id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getRoom_Id() {
        return room_Id;
    }

    public void setRoom_Id(String room_Id) {
        this.room_Id = room_Id;
    }

    public String getMessage_Id() {
        return message_Id;
    }

    public void setMessage_Id(String message_Id) {
        this.message_Id = message_Id;
    }

	public int getPnum() {
		return pnum;
	}
 
	public void setPnum(int pnum) {
		this.pnum = pnum;
	}
    
}
