package com.itbank.mavenNego;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.itbank.mavenNego.dto.MemberDTO;


public class EchoHandler extends TextWebSocketHandler {
    // 로그인 한 인원 전체
    private List<WebSocketSession> sessions = new ArrayList<WebSocketSession>();
    // 1:1로 할 경우
    private Map<String, WebSocketSession> userSessionsMap = new HashMap<String, WebSocketSession>();

    // 웹소켓 연결 성공 시
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
        log("Socket 연결");
        String senderId = currentUserName(session); // 메세지를 보낼 사람 연결
        if (senderId != null) {
            userSessionsMap.put(senderId, session); // 현재 접속한 사람 1:1 맵에 사용자 연결하기
            log("Socket 연결 성공: " + senderId);
        } else {
            log("Socket 연결 실패: senderId가 null입니다.");
        }
    }

    // 메세지 송수신 시
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        log("session: " + currentUserName(session));
        String msg = message.getPayload(); // 자바스크립트에서 넘어온 메시지
        log("msg=" + msg);

        if (!StringUtils.isEmpty(msg)) {
            log("if문 들어옴?");
            String[] strs = msg.split(",");
            if (strs != null && strs.length == 4) {
                String code = strs[0]; // wantBuy, wantSell, noSell도 추가? 할 수 있으면 추가하기 
                String buyer_id = strs[1]; // 구매자
                String seller_id = strs[2]; // 판매자
                String pname = strs[3]; // 상품명

                log("length 성공? " + code);

                WebSocketSession buySession = userSessionsMap.get(buyer_id); // 판매자가 구매자한테 보낼 소켓
                WebSocketSession sellSession = userSessionsMap.get(seller_id); // 구매자가 판매자한테 보낼 소켓

                log("buyer_id: " + buyer_id + ", buySession: " + buySession);
                log("seller_id: " + seller_id + ", sellSession: " + sellSession);

                // 구매자가 구매 버튼을 눌렀을 때
                if ("wantBuy".equals(code)) {
                    if (sellSession != null) {
                        TextMessage tmpMsg = new TextMessage(buyer_id + "님이 "
                                + "<a href='mypage.do?member_id=" + seller_id + "' style=\"color: black\">"
                                + pname + "을 구매하고 싶어합니다!</a>");
                        log("tmpMsg: " + tmpMsg);
                        sellSession.sendMessage(tmpMsg);
                        log("session에 담김: " + seller_id);
                    } else {
                        log("sellSession is null for seller_id: " + seller_id);
                    }
                }

                // 판매자가 판매하기 버튼을 눌렀을 때
                else if ("wantSell".equals(code)) {
                    if (buySession != null) {
                        TextMessage tmpMsg = new TextMessage(seller_id + "님이 "
                                + "<a href='mypage.do?member_id=" + buyer_id + "' style=\"color: black\"><strong>"
                                + pname + "</strong>을 구매 수락했습니다!</a>");
                        log("tmpMsg: " + tmpMsg);
                        buySession.sendMessage(tmpMsg);
                        log("session에 담김: " + buyer_id);
                    } else {
                        log("buySession is null for buyer_id: " + buyer_id);
                    }
                }
            }
        }
    }

    // 연결 종료 시
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        log("Socket 끊음");
        String senderId = currentUserName(session);
        if (senderId != null) {
            userSessionsMap.remove(senderId);
            log("Socket 연결 종료: " + senderId);
        } else {
            log("Socket 연결 종료 실패: senderId가 null입니다.");
        }
    }

    // 에러 발생 시
    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        log(session.getId() + " 익셉션 발생: " + exception.getMessage());
    }

    // 로그 메시지
    private void log(String logmsg) {
        System.out.println(logmsg); // 로그 출력, 필요 시 다른 로그 방식 사용
    }

    // 로그인한 ID 가져오기
    private String currentUserName(WebSocketSession session) {
        Map<String, Object> httpSession = session.getAttributes();
        MemberDTO loginUser = (MemberDTO) httpSession.get("mbId");

        if (loginUser == null) {
            String mid = session.getId();
            return mid;
        }

        String mid = loginUser.getId();
        return mid;
    }
}
