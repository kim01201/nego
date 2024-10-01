package com.itbank.mavenNego;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.http.server.ServletServerHttpRequest;

import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ChatHttpSessionHandshakeInterceptor implements HandshakeInterceptor {

    private static final Logger logger = Logger.getLogger(ChatHttpSessionHandshakeInterceptor.class.getName());
    private static final String SESSION_ATTRIBUTE_NAME = "HTTP_SESSION";

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                   WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {
        if (request instanceof ServletServerHttpRequest) {
            HttpServletRequest servletRequest = ((ServletServerHttpRequest) request).getServletRequest();
            HttpSession session = servletRequest.getSession(false); // 기존 세션을 가져옴, 없으면 null 반환

            if (session != null) {
                attributes.put(SESSION_ATTRIBUTE_NAME, session);
                logger.info("HTTP Session added to WebSocket attributes");
            } else {
                logger.warning("No HTTP Session found");
            }
        }
        return true;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response,
                               WebSocketHandler wsHandler, Exception ex) {
        if (ex != null) {
            logger.log(Level.SEVERE, "Exception during WebSocket handshake: ", ex);
        }
    }
}
