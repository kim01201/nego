package com.itbank.mavenNego.dto;

import java.util.HashSet;
import java.util.Set;

public class ChatRoomDTO {

    private String room_Id;
    private String roomName;
    private Set<String> participants = new HashSet<>();
    
    private int pnum;
    public ChatRoomDTO() {}

    public ChatRoomDTO(String roomId, String roomName) {
        this.room_Id = roomId;
        this.roomName = roomName;
    }

    public String getRoomId() {
        return room_Id;
    }

    public void setRoomId(String roomId) {
        this.room_Id = roomId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public Set<String> getParticipants() {
        return participants;
    }

    public void setParticipants(Set<String> participants) {
        this.participants = participants;
    }

    public void addParticipant(String participant) {
        this.participants.add(participant);
    }

    public void removeParticipant(String participant) {
        this.participants.remove(participant);
    }

	public int getPnum() {
		return pnum;
	}

	public void setPnum(int pnum) {
		this.pnum = pnum;
	}
    
}
