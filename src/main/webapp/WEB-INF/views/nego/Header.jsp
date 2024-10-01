<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head> 
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NeGO</title>
    
    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <link rel="stylesheet" type="text/css" href="resources/css/chat/chatStyle.css">
    <link rel="stylesheet" type="text/css" href="resources/css/headStyle.css">

	<script>
	logi = ${sessionScope.loginMethod == 'kakao'};
	console.log("sdddd",logi);
	function toggleCategoryList() {
        var categoryList = document.getElementById('category-list');
        if (categoryList.style.display === "none" || categoryList.style.display === "") {
            categoryList.style.display = "block";
        } else {
            categoryList.style.display = "none";
        }
    }
    
	function handleClick(categoryId) {
	    // 새로운 URL에 pcategory 값 추가
	    var url = 'cateSearch_prod.prod?pcategory=' + encodeURIComponent(categoryId);
	    window.location.href = url; // 페이지 이동
	}


    function showSubCategory(categoryId) {
        var subCategory = document.getElementById('sub-' + categoryId);
        var mainCategory = document.getElementById('main-' + categoryId);
        subCategory.style.display = "block";
        mainCategory.classList.add('active');
    }

    function hideSubCategory(categoryId) {
        var subCategory = document.getElementById('sub-' + categoryId);
        var mainCategory = document.getElementById('main-' + categoryId);
        subCategory.style.display = "none";
        mainCategory.classList.remove('active');
    }

    function hideAllSubCategories() {
        var subCategories = document.getElementsByClassName('subCategory');
        for (var i = 0; i < subCategories.length; i++) {
            subCategories[i].style.display = "none";
        }
        var mainCategories = document.getElementsByClassName('mainCategory');
        for (var j = 0; j < mainCategories.length; j++) {
            mainCategories[j].classList.remove('active');
        }
    }
    
    function searchOnEnter(event) {
        if (event.key === "Enter") {
            var searchTerm = document.getElementById("search-input").value.trim();
            window.location.href = "cateSearch_prod.prod?search=" + encodeURIComponent(searchTerm);

        }
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        const dropbtn = document.querySelector('.dropbtn');
        const dropdown = document.querySelector('.dropdown');

        if (dropbtn && dropdown) {
        	dropbtn.addEventListener('click', function(event) {
                event.stopPropagation();
                dropdown.classList.toggle('open');
            });

            document.addEventListener('click', function(event) {
                if (!dropdown.contains(event.target)) {
                    dropdown.classList.remove('open');
                }
            });
        } else {
            console.error('dropbtn or dropdown element not found');
        }
    });
    
    //후기 평가 중복 관리 스크립트
    document.addEventListener('DOMContentLoaded', function() {
        var uniqueGoodPoints = {};
        var uniqueBadPoints = {};

        // 좋은 점 중복 제거 및 필터링
        var goodPointsList = document.getElementById('uniqueGoodPoints');
        Array.from(goodPointsList.getElementsByClassName('review-item')).forEach(function(li) {
            var textContent = li.textContent.trim();
            if(textContent=="평가된 내용이 없습니다"){
            	uniqueGoodPoints[textContent] = "";
            }
            else if (!uniqueGoodPoints[textContent]) {
                uniqueGoodPoints[textContent] = 1; // 처음 등장한 경우는 1로 초기화
            } else {
                uniqueGoodPoints[textContent]++; // 이미 등장한 경우 수를 증가
            }
        });
        goodPointsList.innerHTML = ''; // 초기화
        Object.keys(uniqueGoodPoints).forEach(function(point) {
            var li = document.createElement('li');
            var count = uniqueGoodPoints[point];
            li.className = 'review-item';
            li.innerHTML = '<span class="text">' + point + '</span><span class="count">' + count + '</span>'; // 텍스트 왼쪽, 숫자 오른쪽
            goodPointsList.appendChild(li);
        });

        // 나쁜 점 중복 제거 및 필터링
        var badPointsList = document.getElementById('uniqueBadPoints');
        Array.from(badPointsList.getElementsByClassName('review-item')).forEach(function(li) {
            var textContent = li.textContent.trim();
            if(textContent=="평가된 내용이 없습니다"){
            	uniqueBadPoints[textContent] = "";
            }
            else if (!uniqueBadPoints[textContent]) {
                uniqueBadPoints[textContent] = 1; // 처음 등장한 경우는 1로 초기화
            } else {
                uniqueBadPoints[textContent]++; // 이미 등장한 경우 수를 증가
            }
        });
        badPointsList.innerHTML = ''; // 초기화
        Object.keys(uniqueBadPoints).forEach(function(point) {
            var li = document.createElement('li');
            var count = uniqueBadPoints[point];
            li.className = 'review-item';
            li.innerHTML = '<span class="text">' + point + '</span><span class="count">' + count + '</span>'; // 텍스트 왼쪽, 숫자 오른쪽
            badPointsList.appendChild(li);
        });
    });

    // 채팅 팝업 관련 스크립트
    function openChatRoomPopup() {
        document.getElementById('popup2').style.display = 'block';
        document.getElementById('overlay').style.display = 'block';
        fetchChatRooms(); // 채팅방 목록을 가져와서 표시
    }

    function closeChatRoomPopup() {
        document.getElementById('popup2').style.display = 'none';
        document.getElementById('overlay').style.display = 'none';
        // 팝업을 닫을 때 페이지 새로고침
        window.location.reload();
    }
    
    //후기 관련 스크립트
	

	function openReviewsPopup() {
        document.getElementById('reviews').style.display = 'block';
        document.getElementById('overlay').style.display = 'block';
    }

	function closeReviewsPopup() {
	    document.getElementById('reviews').style.display = 'none';
	    document.getElementById('overlay').style.display = 'none';
	}
	
	function openAlarmPopup(){
	     document.getElementById("popup1").style.display = 'block';
	     document.getElementById('overlay1').style.display = 'block';
	    }
	     
	 function closeAlarmPopup() {
	 	document.getElementById('popup1').style.display = 'none';
	    document.getElementById('overlay1').style.display = 'none';
	 }
    

    
 		// 웹소켓 객체 저장 변수 선언
	    var socket = null;
	     //로그인이 되었다면 웹소켓 연걸하기
	    $(document).ready(function(){
	        var ws = new SockJS( "<c:url value="/echo"/>" );
	         socket = ws;
	        ws.onmessage = onMessage;
	   });
	
	        // 서버에서 메시지를 받았을 때
	   function onMessage(event) {
            var data = event.data;

            // 메시지를 받았을 때 알림 아이콘에 표시할 부분
            var notificationBadge = document.getElementById('notificationBadge');
            console.log("위",notificationBadge);
            if (notificationBadge) {
                var currentCount = parseInt(notificationBadge.textContent) || 0;
                notificationBadge.textContent = currentCount + 1;
                notificationBadge.style.display = 'block'; // 알림 표시
            } else {
                console.log('notificationBadge 요소를 찾을 수 없습니다.');
            }

            console.log("Message received: " + data); // 수신된 메시지를 로그로 출력
            let toast = "<div class='toast' role='alert' aria-live='assertive' aria-atomic='true'>";
            toast += "<div class='toast-header'><i class='fas fa-bell mr-2'></i><strong class='mr-auto'>알림</strong>";
            toast += "<button type='button' class='ml-2 mb-1 close' data-dismiss='toast' aria-label='Close'>";
            toast += "<span aria-hidden='true'>&times;</span></button>";
            toast += "</div> <div class='toast-body'>" + data + "</div></div>";
            document.getElementById("msgStack").insertAdjacentHTML('beforeend', toast); // msgStack div에 생성한 toast 추가
            var toastElement = document.querySelectorAll('.toast');
            toastElement.forEach(function(el) {
                $(el).toast({"animation": true, "autohide": false});
                $(el).toast('show');
            });
        }
	    //소켓끝
	
	// 알림 아이콘 클릭 시 팝업창 열기
	$('#alarmButton').on('click', function() {
	    openAlarmPopup();
	    notificationBadge.style.display = 'none'; // 알림 아이콘 숨기기
	});
	
	document.addEventListener('DOMContentLoaded', function() {
	    var notificationBadges = document.getElementById('notificationBadge');
	    console.log("아래",notificationBadges); // null이면 요소가 존재하지 않음
	    if (notificationBadges) {
	        notificationBadges.style.display = 'none';
	    } else {
	        console.log('notificationBadges 요소를 찾을 수 없습니다.');
	    }
	});


    document.addEventListener('DOMContentLoaded', function() {
        // 채팅방 링크 설정
        const chatRoomLinks = document.querySelectorAll('.chat-room-link');
        chatRoomLinks.forEach(function(link) {
            link.addEventListener('click', function(event) {
                event.preventDefault();
                const roomId = this.getAttribute('data-room-id');
                fetchChatRoomDetails(roomId);
            });
        });

        // 채팅방 목록 불러오기
        fetchChatRooms();
    });

    function fetchChatRooms() {
        $.ajax({
            url: 'headerChatRooms.do',
            type: 'GET',
            success: function(data) {
                try {
                    console.log("Response data:", data);
                    if (typeof data === 'string') {
                        data = JSON.parse(data);
                    }
                    updateChatRoomList(data);
                } catch (e) {
                    console.error("Error processing response data:", e);
                }
            },
            error: function(error) {
                console.error("Failed to fetch chat rooms:", error);
            }
        });
    }

    function fetchChatRoomDetails(roomId) {
        $.ajax({
            url: 'chatRoomDetails.do',
            type: 'GET',
            data: { room_Id: roomId },
            success: function(data) {
                updateChatRoomContent(data);
            },
            error: function(error) {
                console.error("Failed to fetch chat room details:", error);
            }
        });
    }
    function updateChatRoomContent(data) {
        var chatMessages = data.chatMessages || [];
        var pnum = data.pnum || '';
        var receiverId = data.receiver_Id || '';
        var currentUserId = "${sessionScope.mbId.id}";
        var popupContent = document.querySelector('.popup2-content');
        var senderId = data.sender_Id || '';
        console.log('Received chat data:', JSON.stringify(data));
        console.log('Chat messages:', JSON.stringify(chatMessages));
        
        popupContent.innerHTML =
            '<style>' +
            '.chat-message {  margin-bottom: 15px; }' +
            '.chat-messages { max-height: 300px; overflow-y: auto; }' +
            '.my-message { text-align: right; }' +
            '.other-message { text-align: left; }' +
            '</style>' +
            '<div class="chat-header">' +
            '<h2>' + (data.room_Id || '') + '</h2>' +
            '<p>PNum: ' + pnum + '</p>' +
            '<p>Receiver ID: ' + receiverId + '</p>' +
            '</div>' +
            '<div id="messageArea" class="chat-messages">' +
            chatMessages.map(function (message, index) {
                console.log('Raw message:', message);
                var messageSenderId = 'unknown';
                var content = '';
                if (typeof message === 'object' && message !== null) {
                    console.log('Message is an object:', message);
                    if (message.sender_Id) {
                        console.log('Message has sender_Id:', message.sender_Id);
                        messageSenderId = message.sender_Id;
                    } else {
                        console.log('Message does not have sender_Id');
                    }
                    content = message.content || '';
                } else if (typeof message === 'string') {
                    console.log('Message is a string');
                    content = message;
                }
                console.log('Estimated Sender ID:', messageSenderId);
                var messageClass = messageSenderId === currentUserId ? 'my-message' : 'other-message';
                return '<div class="chat-message ' + messageClass + '">' +
                    '<span class="sender">' + (messageSenderId === currentUserId ? '' : messageSenderId + ': ') + '</span>' +
                    '<span class="content">' + content + '</span>' +
                    '</div><br>'; // 줄바꿈을 \n으로 변경
            }).join('') + // join('')으로 변경하여 추가 줄바꿈 제거
            '</div>' +
            '<div id="messageForm" class="chat-input">' +
            '<input type="text" placeholder="메시지를 입력하세요" id="message">' +
            '<button id="sendButton" class="sendbutton">보내기</button>' +
            '</div>';

        // 나머지 코드는 그대로 유지
        document.getElementById('popup2').style.display = 'block';
        document.getElementById('overlay').style.display = 'block';
        document.getElementById('sendButton').addEventListener('click', sendMessage);
        document.getElementById('message').addEventListener('keydown', function (event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        });
        var messageArea = document.getElementById('messageArea');
        messageArea.scrollTop = messageArea.scrollHeight;
    }

    function updateChatRoomList(rooms) {
        var roomListElement = document.getElementById('chatRoomListContent');
        if (!roomListElement) {
            console.error("chatRoomListContent element not found.");
            return;
        }
        roomListElement.innerHTML = '';
        rooms.forEach(function(room) {
            var listItem = document.createElement('li');
            listItem.innerHTML = '<a href="#" class="chat-room-link" data-room-id="' + room.room_Id + '">' + room.room_Id + '</a>';
            listItem.querySelector('.chat-room-link').addEventListener('click', function(event) {
                event.preventDefault();
                const roomId = this.getAttribute('data-room-id');
                fetchChatRoomDetails(roomId);
            });
            roomListElement.appendChild(listItem);
        });
    }
    

    document.addEventListener('DOMContentLoaded', function() {
        const chatRoomLinks = document.querySelectorAll('.chat-room-link');
        chatRoomLinks.forEach(function(link) {
            link.addEventListener('click', function(event) {
                event.preventDefault();
                const roomId = this.getAttribute('data-room-id');
                fetchChatRoomDetails(roomId);
            });
        });
    });
    
    function initializeChatRoomLinks() {
        const chatRoomLinks = document.querySelectorAll('.chat-room-link');
        chatRoomLinks.forEach(function(link) {
            link.addEventListener('click', function(event) {
                event.preventDefault();
                const roomId = this.getAttribute('data-room-id');
                fetchChatRoomDetails(roomId);
            });
        });
    }
    //setInterval(fetchChatRooms, 5000);  // 5초마다 채팅방 목록 다시 불러옴

    // 채팅 팝업 관련 스크립트
    var stompClient = null;
    var subscribedRoomId = null;
    var currentUserId = "${sessionScope.mbId.id}";
    var sender_Id = null;

    function connect(roomId) {
        var socket = new SockJS("Nego/chat");
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function(frame) {
            console.log('Connected: ' + frame);
            sender_Id = currentUserId;
            console.log('sender_Id: ' + sender_Id);

            if (!roomId) {
                console.error("roomId is missing");
                return;
            }

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

    function sendMessage() {
        var text = document.getElementById('message').value.trim();
        console.log('Sending message:', text);

        if (!text) {
            console.log('Empty message, not sending.');
            return;
        }

        if (stompClient && stompClient.connected) {
            var messageId = generateMessageId();
            var roomId = subscribedRoomId;
            if (!roomId) {
                console.log("Invalid roomId");
                return;
            }

            var messagePayload = JSON.stringify({
                'content': text,
                'room_Id': roomId,
                'receiver_Id': currentUserId,
                'sender_Id': sender_Id,
                'message_Id': messageId
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

    function subscribeToMessages(roomId) {
        if (stompClient && stompClient.connected) {
            stompClient.subscribe('/topic/messages/' + roomId, function(message) {
                var parsedMessage = JSON.parse(message.body);
                console.log('Received message:', parsedMessage);

                var isMyMessage = parsedMessage.sender_Id === sender_Id;
                showMessage(parsedMessage.content, isMyMessage);
            });
        } else {
            console.error('stompClient is not connected for subscription.');
        }
    }
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

    function navigateToChatPage(roomId) {
        console.log('Navigating to chat with room_Id:', roomId);
        document.getElementById('chatRoomList').style.display = 'none'; // Hide room list
        document.getElementById('chatInterface').style.display = 'block'; // Show chat interface
        connect(roomId); // Connect to the chat room
    }

    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById('sendButton').addEventListener('click', function() {
            sendMessage();
        });

        document.getElementById('message').addEventListener('keydown', function(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        });

        const chatRoomLinks = document.querySelectorAll('.chat-room-link');
        chatRoomLinks.forEach(function(link) {
            link.addEventListener('click', function(event) {
                event.preventDefault();
                const roomId = this.getAttribute('data-room-id');
                fetchChatRoomDetails(roomId); 
            });
        });
    });

	</script>

</head>
<body>

<div class="container">
    <div class="top-1">
        <!-- 로고와 검색바 -->
        <div class="logo"><a href="main.do">NeGO</a></div>
<div class="search-container">
    <img src="resources/icon/mag.png" class="search-icon">
    <input type="text" onkeydown="searchOnEnter(event)" placeholder="어떤 상품을 찾으시나요?" id="search-input">
    <a id="searchLink" href="#" style="display:none;">Search</a>
</div>
        <!-- 메뉴 아이콘들 -->
<div class="menu-icons">
    <ul>
        
        
        
        <!-- 로그인X -->
        <c:if test="${empty sessionScope.mbId}">
        	<li><a href="Login.do"><img src="resources/icon/chat.png"><span>채팅하기</span></a></li>
        	<li><a href="Login.do"><img src="resources/icon/addcart.png" alt="판매하기 아이콘"><span>판매하기</span></a></li>
     		<li><a href="Login.do"><img src="resources/icon/user.png" alt="마이 아이콘"><span>마이</span></a></li>
     	</c:if>
     
     	<!-- 로그인을 했을때 -->
     	<c:if test="${not empty sessionScope.mbId}">
	     	<li><a href="#" id="chatButton" onclick="openChatRoomPopup()"><img src="resources/icon/chat.png"><span>채팅하기</span></a></li>
	     	<li><a href="insert_prod.prod?member_id=${sessionScope.mbId.id}">
	     		<img src="resources/icon/addcart.png" alt="판매하기 아이콘">
	     		<span>판매하기</span></a>
	     	</li>
     	<c:if test="${sessionScope.mbId.id == 'admin'}">
     	<li class="dropdown">
     		<button class="dropbtn">
                <img src="resources/icon/user.png" alt="관리자"><span>관리자</span>
        	</button>
        	<div class="dropdown-content">
                <a href="admin.do?member_id=${sessionScope.mbId.id}">관리자페이지</a>

                <a href="Logout.do" 
                	onclick="document.cookie = 'savedId=' + document.getElementById('id').value + '; path=/; max-age=' + (60*60*24*30);">
                	로그아웃
                </a>

            </div>
        </li>
        </c:if>
        <c:if test="${sessionScope.mbId.id != 'admin'}">
        <li class="dropdown">
            <button class="dropbtn">
                <img src="resources/icon/user.png" alt="마이 아이콘"><span>마이</span>
            </button>
            <div class="dropdown-content">
                <a href="mypage.do?member_id=${sessionScope.mbId.id}">마이페이지</a>
                <c:if test="${sessionScope.loginMethod == 'naver'}">
                	 <a href="naver_logout.do" 
                	onclick="document.cookie = 'savedId=' + document.getElementById('id').value + '; path=/; max-age=' + (60*60*24*30);">
                	로그아웃
                </a>
                </c:if>
                <c:if test="${sessionScope.loginMethod == 'kakao'}">
          
                	<a href="https://kauth.kakao.com/oauth/logout?client_id=d9d93e271c5b4a57f5de6e5b02476dc2&logout_redirect_uri=http://192.168.59.27:8080/mavenNego/Logout.do">로그아웃</a>
                </c:if>
                <c:if test="${sessionScope.loginMethod == 'phone'}">
                <a href="Logout.do" 
                	onclick="document.cookie = 'savedId=' + document.getElementById('id').value + '; path=/; max-age=' + (60*60*24*30);">
                	로그아웃
                </a>
                </c:if>
            </div>
        </li>
        </c:if>
         	<li>
	           <a href="#" id="alarmButton" onclick="openAlarmPopup()"><img src="resources/icon/alarm.png">
	           <span>알림</span>
	           <span id="notificationBadge" class="notification-badge">0</span>
	           </a>
          	</li>
        </c:if>
    </ul>
</div>


    </div>
    
    <div class="top-2">
        <!-- 카테고리 버튼 -->
        <div>
            <a href="#" class="category-btn" onclick="toggleCategoryList()">카테고리</a>
        </div>
        <!-- 공지 -->
        <div><a href="gboard.do?member_id=${sessionScope.mbId.id}">공지</a></div>
        <!-- 문의하기 -->
        <div><a href="mboard.do?member_id=${sessionScope.mbId.id}">문의하기</a></div>
        <!-- 찜한 상품 -->
        <c:if test="${empty sessionScope.mbId}">
     		<a href="Login.do">찜한 상품</a>
     	</c:if>
       	<c:if test="${not empty sessionScope.mbId}">
        	<div>
        		<form id="myWishForm" action="myWish.do" method="post">
            		<input type="hidden" name="member_id" value="${sessionScope.mbId.id}">
            		<a href="#" onclick="document.getElementById('myWishForm').submit(); return false;">찜한 상품</a>
        		</form>
    		</div>
    	</c:if>
    	<!-- 시세조회 -->
        <div><a href="marketPrice.prod">시세 조회</a></div>
        <div><a href="fraud.fraud">사기 조회</a></div>
        <c:if test="${empty sessionScope.mbId}">
        	<div><a href="Login.do">출석하기</a></div>
        </c:if>
        
        <c:if test="${not empty sessionScope.mbId}">
        	<div><a href="attendance.do">출석하기</a></div>
        </c:if>
        
        <div class="notice">
            <marquee>고객센터 공지: 새로운 이벤트가 시작되었습니다!</marquee>
        </div>
    </div>

    <div class="category">
	    <div id="category-list" style="display:none;">
	        <!-- 카테고리 목록 -->
	        <ul onmouseout="hideAllSubCategories()">
	            <c:forEach var="mainCategory" items="${mainList}">
	                <c:set var="mainCategoryId" value="${mainCategory.id}" />
	                <li id="main-${mainCategoryId}" class="mainCategory" onclick="handleClick('${mainCategoryId}')" onmouseover="showSubCategory('${mainCategoryId}')">
	                    <a href="#" >
	                        ${mainCategory.name}
	                    </a>
	                </li>
	            </c:forEach>
	        </ul>
	    </div>
	
	    <c:forEach var="mainCategory" items="${mainList}">
	        <div id="sub-${mainCategory.id}" class="subCategory" 
	             onmouseover="showSubCategory('${mainCategory.id}')" 
	             onmouseout="hideSubCategory('${mainCategory.id}')" 
	             style="display:none;">
	            <c:forEach var="subCategory" items="${mainCategory.subList}">
	                <div class="subCategoryItem">
	                    <h3><a href="#" onclick="handleClick('${subCategory.id}')">${subCategory.name}</a></h3>
	                    <ul>
	                        <c:forEach var="itemCategory" items="${subCategory.itemList}">
	                            <li><a href="#" onclick="handleClick('${itemCategory.id}')">${itemCategory.name}</a></li>
	                        </c:forEach>
	                    </ul>
	                </div>
	            </c:forEach>
	        </div>
	    </c:forEach>
	</div>
</div>

<!-- 채팅 팝업 -->
<div id="popup2" class="popup2">
        <div class="popup2-content">
            <span id="closePopupBtn" class="close-btn" onclick="closeChatRoomPopup()">&times;</span>
            <h2>채팅룸</h2>
            <div id="chatRoomList" class="chat-room-list">
                <ul id="chatRoomListContent">
                    <c:forEach var="room" items="${chatRooms}">
                        <li>
                            <a href="#" class="chat-room-link" data-room-id="${room.room_Id}">
                                ${room.room_Id}
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
    <div id="overlay" class="overlay" onclick="closeChatRoomPopup()"></div>

<div id="popup1" class="popup1" style="display:none;">
  	<div class="popup-content1">
  		<span id="closePopupBtn1" class="close-btn1" onclick="closeAlarmPopup()">&times;</span>
   			<div class='msg-content' id="msgStack"></div>
    </div>
</div>
<div id="overlay1" class="overlay1" onclick="closeAlarmPopup()" style="display:none;"></div>





</body>
</html>
