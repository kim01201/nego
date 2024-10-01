package com.itbank.mavenNego.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.itbank.mavenNego.dto.ChatMessageDTO;

import java.util.List;

@Service
public class ChatMessageMapper {
    @Autowired
    private SqlSession sqlSession;

    public void insertChatMessage(ChatMessageDTO chatMessage) {
        sqlSession.insert("com.itbank.mavenNego.dto.ChatMessageMapper.insertChatMessage", chatMessage);
    }

    public List<ChatMessageDTO> getMessagesByRoomId(String roomId) {
        return sqlSession.selectList("com.itbank.mavenNego.dto.ChatMessageMapper.getMessagesByRoomId", roomId);
    }

    public int getPnumByRoomId(String roomId) {
        return sqlSession.selectOne("com.itbank.mavenNego.dto.ChatMessageMapper.getPnumByRoomId", roomId);
    }

    public String getReceiverIdByPnum(int pnum) {
        return sqlSession.selectOne("com.itbank.mavenNego.dto.ChatMessageMapper.getReceiverIdByPnum", pnum);
    }

    public List<ChatMessageDTO> getByPnum(int pnum) {
        return sqlSession.selectList("getByPnum", pnum);
    }
}
