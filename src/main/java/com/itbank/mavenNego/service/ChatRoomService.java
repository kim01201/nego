package com.itbank.mavenNego.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.itbank.mavenNego.dto.ChatRoomDTO;

@Service
public class ChatRoomService {

    @Autowired
    private ChatRoomMapper chatRoomMapper;

    public ChatRoomDTO createChatRoom(int pnum, String sellerId, String buyerId) {
        // 판매글 ID와 유저 ID를 조합하여 고유한 채팅방 ID 생성
        String roomId = pnum + "-" + sellerId;
        ChatRoomDTO chatRoom = new ChatRoomDTO(roomId, "Room for " + pnum);
        chatRoom.setPnum(pnum); // pnum 설정
        chatRoomMapper.insertChatRoom(chatRoom);
        return chatRoom;
    }

    public void updateChatRoomPnum(String roomId, int pnum) {
        ChatRoomDTO chatRoom = chatRoomMapper.getChatRoomById(roomId);
        if (chatRoom != null) {
            chatRoom.setPnum(pnum); // pnum 설정
            chatRoomMapper.updateChatRoomPnum(chatRoom);
            System.out.println("Updated chat room with ID: " + chatRoom.getRoomId() + " with pnum: " + chatRoom.getPnum());
        } else {
            System.out.println("Chat room with ID: " + roomId + " not found");
        }
    }

    public List<ChatRoomDTO> getChatRooms() {
        return chatRoomMapper.getChatRooms();
    }

    public ChatRoomDTO getChatRoomById(String roomId) {
        return chatRoomMapper.getChatRoomById(roomId);
    }
}
