<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Real-time Chat</title>

    <link rel="stylesheet" type="text/css" href="resources/css/chat/chatStyle.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.0/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
</head>
<body>
<div class="chatbody">
    <main>
        <header>
            <%@ include file="chatHeader.jsp" %>
        </header>
        <div id="chatPage">
            <c:choose>
                <c:when test="${empty sessionScope.mbId.id}">
                    <p>로그인해주세요. <a href="Login.do">로그인 페이지로 이동</a></p>
                </c:when>
                <c:otherwise>
                    <div id="warning" style="display: none;">
                        <p>중고나라 채팅, 중고나라 페이가 가장 안전합니다!</p>
                        <p>카카오톡이나 라인 등으로 대화를 유도하거나 URL(링크)결제 유도 및 직접송금을 요구하는 경우 피해 위험이 있으니 주의하세요!</p>
                    </div>
                    <div id="messageArea">
                        <c:forEach var="message" items="${messages}">
                            <div class="chat-message ${message.sender_Id == sessionScope.mbId.id ? 'my-message' : 'other-message'}">
                                <p><strong>${message.sender_Id}:</strong> ${message.content}</p>
                            </div>
                        </c:forEach>
                    </div>
                    <div id="messageForm">
                        <input type="text" id="message" placeholder="메시지를 입력하세요" />
                        <button id="sendButton" class="sendbutton">보내기</button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>
</body>
</html>
