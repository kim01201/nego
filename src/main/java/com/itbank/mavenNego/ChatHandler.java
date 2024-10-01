package com.itbank.mavenNego;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.itbank.mavenNego.dto.ChatMessageDTO;
import com.itbank.mavenNego.dto.MemberDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.*;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import java.util.HashMap;
import java.util.Map;

public class ChatHandler extends TextWebSocketHandler {

    private static final Logger log = LoggerFactory.getLogger(ChatHandler.class);
    private Map<String, Map<String, WebSocketSession>> roomSessionsMap = new HashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        String userId = currentUserName(session);
        if (userId != null) {
            String roomId = (String) session.getAttributes().get("roomId");
            if (roomId != null) {
                roomSessionsMap.computeIfAbsent(roomId, k -> new HashMap<>()).put(userId, session);
                log.info("New connection established. User ID: " + userId + " in Room ID: " + roomId);
            } else {
                log.warn("No room ID found in session attributes.");
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        String userId = currentUserName(session);
        if (userId != null) {
            String roomId = (String) session.getAttributes().get("roomId");
            if (roomId != null) {
                Map<String, WebSocketSession> roomSessions = roomSessionsMap.get(roomId);
                if (roomSessions != null) {
                    roomSessions.remove(userId);
                    if (roomSessions.isEmpty()) {
                        roomSessionsMap.remove(roomId);
                    }
                }
                log.info("Connection closed. User ID: " + userId + " in Room ID: " + roomId);
            }
        }
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        ChatMessageDTO chatMessage = mapper.readValue(message.getPayload(), ChatMessageDTO.class);
        String roomId = chatMessage.getRoom_Id();

        log.info("Received message: " + chatMessage);

        Map<String, WebSocketSession> roomSessions = roomSessionsMap.get(roomId);
        if (roomSessions != null) {
            for (WebSocketSession s : roomSessions.values()) {
                if (s.isOpen()) {
                    TextMessage textMessage = new TextMessage(mapper.writeValueAsString(chatMessage));
                    s.sendMessage(textMessage);
                }
            }
        } else {
            log.warn("No sessions found for Room ID: " + roomId);
        }
    }

    private String currentUserName(WebSocketSession session) {
        Map<String, Object> httpSession = session.getAttributes();
        MemberDTO loginUser = (MemberDTO) httpSession.get("loggedInMember");
        return loginUser != null ? loginUser.getId() : session.getId();
    }
}
