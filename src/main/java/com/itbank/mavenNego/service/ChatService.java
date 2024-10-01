package com.itbank.mavenNego.service;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.itbank.mavenNego.dto.ChatMessageDTO;
import com.itbank.mavenNego.dto.ChatRoomDTO;

@Service
public class ChatService {

    @Autowired
    private SqlSession sqlSession;

    public void saveMessage(ChatMessageDTO message) {
    	 if (message.getRoom_Id() == null || message.getRoom_Id().trim().isEmpty()) { 
             throw new IllegalArgumentException("room_Id must not be null or empty");
         }

         // Ensure the chat room exists before saving the message
         ChatRoomDTO chatRoom = getChatRoomById(message.getRoom_Id());
         if (chatRoom == null) {
             chatRoom = new ChatRoomDTO();
             chatRoom.setRoomId(message.getRoom_Id());
             createChatRoom(chatRoom);
             System.out.println("Created new chat room with ID: " + chatRoom.getRoomId());
         }

         sqlSession.insert("com.itbank.mavenNego.dto.ChatMessageMapper.insertChatMessage", message);
         System.out.println("Saved message with ID: " + message.getMessage_Id() + " in room ID: " + message.getRoom_Id());
     }
    

    public List<ChatMessageDTO> getMessagesByRoomId(String roomId) {
        System.out.println("Fetching messages for room ID: " + roomId);
        return sqlSession.selectList("com.itbank.mavenNego.dto.ChatMessageMapper.getMessagesByRoomId", roomId);
    }

    public ChatRoomDTO createChatRoom(ChatRoomDTO chatRoom) {
        sqlSession.insert("com.itbank.mavenNego.dto.ChatRoomMapper.insertChatRoom", chatRoom);
        System.out.println("Created chat room with ID: " + chatRoom.getRoomId());
        return chatRoom;
    }

    public List<ChatRoomDTO> getChatRooms() {
        System.out.println("Fetching all chat rooms");
        return sqlSession.selectList("com.itbank.mavenNego.dto.ChatRoomMapper.getChatRooms");
    }

    public ChatRoomDTO getChatRoomById(String roomId) {
        System.out.println("Fetching chat room with ID: " + roomId);
        return sqlSession.selectOne("com.itbank.mavenNego.dto.ChatRoomMapper.getChatRoomById", roomId);
    }

    public Integer getPnumByRoomId(String roomId) {
        System.out.println("Fetching pnum for room ID: " + roomId);
        return sqlSession.selectOne("com.itbank.mavenNego.dto.ChatMessageMapper.getPnumByRoomId", roomId);
    }

    public String getReceiverIdByPnum(int pnum) {
        System.out.println("Fetching receiver ID for pnum: " + pnum);
        return sqlSession.selectOne("com.itbank.mavenNego.dto.ChatMessageMapper.getReceiverIdByPnum", pnum);
    }
    
    public List<ChatMessageDTO> getByPnum(int pnum) {
        return sqlSession.selectList("com.itbank.mavenNego.dto.ChatMessageMapper.getByPnum", pnum);
    }
}
