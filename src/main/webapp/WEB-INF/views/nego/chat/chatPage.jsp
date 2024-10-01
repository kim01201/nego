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
<script>

    var stompClient = null; // STOMP 클라이언트를 저장하기 위한 변수
    var subscribedRoomId = null; // 구독한 채팅방 ID를 저장할 변수
    var currentUserId = "${sessionScope.mbId.id}"; // 현재 사용자 ID
    var sender_Id = null; // WebSocket URL에서 추출한 sender_Id

 // URL 파라미터를 추출하는 함수
    function getParameterByName(name) {
        const url = window.location.href;
        name = name.replace(/[\[\]]/g, '\\$&');
        const regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, ' '));
    }

    
    // WebSocket 연결을 설정하고 STOMP 클라이언트를 초기화하는 함수
function connect() {
    var socket = new SockJS("Nego/chat"); // WebSocket 엔드포인트 경로
    stompClient = Stomp.over(socket);
    stompClient.connect({}, function(frame) {
        console.log('Connected: ' + frame);

        // sender_Id를 설정
        sender_Id = "${sessionScope.mbId.id}";
        var pnum = getParameterByName('pnum');
        var receiverId = getParameterByName('receiver_id') || "${specProd.member_id}"; // JSP에서 설정된 receiverId 또는 URL에서 추출

        console.log('sender_Id: ' + sender_Id);
        console.log('pnum: ' + pnum);
        console.log('receiverId: ' + receiverId);

        if (!pnum || !receiverId) {
            console.error("pnum or receiver_id is missing in the URL");
            return;
        }

        var roomId = pnum + '-' + receiverId; // 채팅방 ID 생성
        if (subscribedRoomId !== roomId) {
            if (subscribedRoomId) {
                stompClient.unsubscribe(subscribedRoomId); // 기존 구독 취소
            }
            subscribeToMessages(roomId);
            subscribedRoomId = roomId;
        }
    }, function(error) {
        console.error('Connection failed: ', error); // 에러 로그 추가
    });
}


    function generateMessageId() {
        return Math.random().toString(36).substr(2, 9);
    }
    
    // 메시지를 전송하는 함수
   function sendMessage() {
    var text = document.getElementById('message').value.trim();
    console.log('Sending message:', text);

    if (!text) {
        console.log('Empty message, not sending.');
        return; // 공백 문자열인 경우 전송하지 않음
    }

    if (stompClient && stompClient.connected) {
        var messageId = generateMessageId(); // Generate the message ID here
        var pnum = getParameterByName('pnum');
        var receiverId = getParameterByName('receiver_id') || "${specProd.member_id}"; // JSP에서 설정된 receiverId 또는 URL에서 추출

        if (!pnum) {
            console.log("Invalid parameters: pnum is missing");
            console.error("pnum is missing in the URL");
            return;
        }
        
        if (!receiverId) {
            console.log("Invalid parameters: receiver_id is missing");
            console.error("receiver_id is missing in the URL");
            return;
        }

        var roomId = pnum + '-' + receiverId;
        console.log('roomId: ' + roomId);

        var messagePayload = JSON.stringify({
            'content': text,
            'room_Id': roomId,
            'receiver_Id': receiverId,
            'sender_Id': sender_Id, // 메시지 전송 시 추출한 sender_Id 사용
            'message_Id': messageId,
            'pnum': parseInt(pnum) // pnum 값을 정수로 변환하여 페이로드에 포함
        });
        console.log('Message payload:', messagePayload);

        stompClient.send("/app/chat", {}, messagePayload);
        
        document.getElementById('message').value = '';
        document.getElementById('warning').style.display = 'none';
        document.getElementById('messageArea').style.display = 'block';
    } else {
        console.error('stompClient is not connected.');
    }
}
    // 특정 채팅방에 메시지를 구독하는 함수
   function subscribeToMessages(roomId) {
    if (stompClient && stompClient.connected) {
        stompClient.subscribe('/topic/messages/' + roomId, function(message) {
            var parsedMessage = JSON.parse(message.body);
            console.log('Received message:', parsedMessage);

            console.log('currentUserId:', currentUserId);
            console.log('parsedMessage.sender_Id:', parsedMessage.sender_Id);
            console.log('parsedMessage.receiver_Id:', parsedMessage.receiver_Id);
            console.log('parsedMessage.content:', parsedMessage.content);
            console.log('parsedMessage.room_Id:', parsedMessage.room_Id);

            var isMyMessage = parsedMessage.sender_Id === sender_Id; // 메시지의 발신자 ID와 현재 사용자 ID를 비교
            showMessage(parsedMessage.content, isMyMessage); // 수신한 메시지를 표시
        });
    } else {
        console.error('stompClient is not connected for subscription.');
    }
}

    // 메시지를 화면에 표시하는 함수
    function showMessage(message, isMyMessage) {
        var messageArea = document.getElementById('messageArea');
        var messageElement = document.createElement('div');

        messageElement.classList.add('chat-message');
        if (isMyMessage) {
            messageElement.classList.add('my-message');
        } else {
            messageElement.classList.add('other-message');
        }

        messageElement.textContent = message;
        messageArea.appendChild(messageElement);

        var emptyLine = document.createElement('div');
        emptyLine.style.clear = 'both';
        messageArea.appendChild(emptyLine);

        messageArea.scrollTop = messageArea.scrollHeight;
    }

    document.addEventListener("DOMContentLoaded", function() {
        connect();

        document.getElementById('sendButton').addEventListener('click', function() {
            sendMessage();
        });

        document.getElementById('message').addEventListener('keydown', function(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        });
    });

    function getReceiverId() {
        const url = window.location.href;
        const regex = new RegExp('[?&]receiver_id(=([^&#]*)|&|#|$)');
        const results = regex.exec(url);
        if (!results) return null;
        return decodeURIComponent(results[2].replace(/\+/g, ' '));
    }
    
</script>
</head>
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
                    <div id="warning">
                        <p>중고나라 채팅, 중고나라 페이가 가장 안전합니다!</p>
                        <p>카카오톡이나 라인 등으로 대화를 유도하거나 URL(링크)결제 유도 및 직접송금을 요구하는 경우 피해 위험이 있으니 주의하세요!</p>
                    </div>
                    <div id="messageArea">
                        <c:forEach var="message" items="${messages}">
                            <div class="chat-message ${message.sender_Id == sessionScope.mbId.id ? 'my-message' : 'other-message'}">
                                ${message.content}
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