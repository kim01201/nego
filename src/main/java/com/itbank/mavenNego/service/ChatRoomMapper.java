package com.itbank.mavenNego.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.itbank.mavenNego.dto.ChatRoomDTO;

import java.util.List;

@Service
public class ChatRoomMapper {
    @Autowired
    private SqlSession sqlSession;

    public void insertChatRoom(ChatRoomDTO chatRoom) {
        sqlSession.insert("com.itbank.mavenNego.dto.ChatRoomMapper.insertChatRoom", chatRoom);
    }

    public void updateChatRoomPnum(ChatRoomDTO chatRoom) {
        sqlSession.update("com.itbank.mavenNego.dto.ChatRoomMapper.updateChatRoomPnum", chatRoom);
    }

    public ChatRoomDTO getChatRoomById(String roomId) {
        return sqlSession.selectOne("com.itbank.mavenNego.dto.ChatRoomMapper.getChatRoomById", roomId);
    }

    public List<ChatRoomDTO> getChatRooms() {
        return sqlSession.selectList("com.itbank.mavenNego.dto.ChatRoomMapper.getChatRooms");
    }
}
