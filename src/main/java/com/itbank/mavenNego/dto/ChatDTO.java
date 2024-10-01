package com.itbank.mavenNego.dto;

public class ChatDTO {

    private String content;
    private String sessionId;
    
    public ChatDTO() {
    	
    }
    
    public ChatDTO(String content, String sessionId) {
        this.content = content;
        this.sessionId = sessionId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }
}
