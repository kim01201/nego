<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="resources/css/product/default.css">
    <link rel="stylesheet" href="resources/css/product/detail.css">
    <!-- swiper cdn -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

	<!-- 카카오맵 지도 api-->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dd168f46d43a18f92781040aa5622f80&libraries=services"></script>

    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <!-- 부트스트랩 자바스크립트 링크  -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
        crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
    
    <style>
  
    .popup-content {
    
        max-height: 100vh; /* 최대 높이를 설정 */
        overflow-y: auto; /* 수직 스크롤 활성화 */
    }
</style>
    <title>검색결과</title>
    
    <script>
         // WebSocket 연결을 저장할 변수
            var stompClient = null;

            function getParameterByName(name) {
                const url = window.location.href;
                name = name.replace(/[\[\]]/g, '\\$&');
                const regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                    results = regex.exec(url);
                if (!results) return null;
                if (!results[2]) return '';
                return decodeURIComponent(results[2].replace(/\+/g, ' '));
            }
         
            // WebSocket 연결을 초기화하고 열기
            function connectWebSocket() {
            	   var socket = new SockJS("Nego/chat");
            	    stompClient = Stomp.over(socket);
            	    stompClient.connect({}, function(frame) {
            	        console.log('Connected: ' + frame);

            	        sender_Id = "${sessionScope.mbId.id}";
            	        var urlParams = new URLSearchParams(window.location.search);
            	        var receiverId = urlParams.get('receiver_id') || "${specProd.member_id}"; // JSP에서 설정된 receiverId
            	        var pnum = urlParams.get('pnum');

            	        console.log('sender_Id: ' + sender_Id);
            	        console.log('pnum: ' + pnum);
            	        console.log('receiverId: ' + receiverId);

            	        if (!pnum || !receiverId) {
            	            console.error("pnum or receiver_id is missing in the URL");
            	            return;
            	        }

            	        var roomId = pnum + '-' + receiverId;
            	        if (subscribedRoomId !== roomId) {
            	            if (subscribedRoomId) {
            	                stompClient.unsubscribe(subscribedRoomId);
            	            }
            	            subscribeToMessages(roomId);
            	            subscribedRoomId = roomId;
            	        }
            	    }, function(error) {
            	        console.error('Connection failed: ', error);
            	    });
            	}

            // WebSocket 연결 해제
            function disconnectWebSocket() {
                if (stompClient !== null) {
                    stompClient.disconnect(function() {
                        console.log("Disconnected");
                    });
                    stompClient = null;
                }
            }

            // 채팅 팝업 열기
            function openChatPopup() {
                document.getElementById('popup').style.display = 'block';
                document.getElementById('overlay').style.display = 'block';
                connectWebSocket(); // WebSocket 연결
            }

            // 채팅 팝업 닫기
            function closeChatPopup() {
                document.getElementById('popup').style.display = 'none';
                document.getElementById('overlay').style.display = 'none';
                disconnectWebSocket(); // WebSocket 연결 해제
            }

            // 외부 클릭 감지로 팝업 닫기
            document.addEventListener('click', function(event) {
                var popup = document.getElementById('popup');
                var overlay = document.getElementById('overlay');
                if (event.target === overlay) {
                    closeChatPopup();
                }
            });
      </script>
</head>



<body>
    <main>
    <header>
    	<%@include file="../Header.jsp"%>	
    </header>
    
    <script>
	    function clickWantBuy(buyer_id, pnum, seller_id, pname) {
	    	const sessionId = "${sessionScope.mbId.id}";
	        	  if (!sessionId) {
	                  // 세션 아이디가 없으면 로그인 페이지로 이동
	                  window.location.href = 'Login.do';
	              }else{
	      	        if (confirm("상품 구매 요청하시겠습니까?")) {
	    	            var url = "ifClickBuy.prod?buyer_id=" + encodeURIComponent(buyer_id) + "&pnum=" + encodeURIComponent(pnum);
	    	            if (socket) {
	    		        	let socketMsg = "wantBuy," + buyer_id + "," + seller_id + "," + pname;
	    		        	socket.send(socketMsg);
	    		        } else {
	    		        	alert('WebSocket is not open.');
	    		        }
	    	            window.location.href = url;
	    	        } else {
	    	            // 사용자가 취소한 경우 처리
	    	        }
	              }

	    }
	    
	    function cantBuy() {
			   if (confirm("현재 거래중인 상품입니다.")) {
				   
			   }
		   }
	    
	    document.addEventListener('DOMContentLoaded', function () {
	        const heartIcon = document.getElementById('heartIcon');
	        const wishForm = document.getElementById('wishForm');
	        const sessionId = "${sessionScope.mbId.id}";
	        heartIcon.addEventListener('click', function () {
	        	  if (!sessionId) {
	                  // 세션 아이디가 없으면 로그인 페이지로 이동
	                  window.location.href = 'Login.do';
	              } else {
	                  // 세션 아이디가 있으면 찜하기 폼 제출
	                  wishForm.submit();
	              }
	        });
	    });
	    
	   
    </script>
	<div class="main-content">
        <div class="items-start grid grid-cols-2 first-wrap">
            <div class="carou">
                <div id="carouselExampleInterval" class="carousel slide" data-bs-ride="carousel">
                    <div class="carousel-inner">
                    	<div class="card-img-wrapper ${specProd.pstatus == '판매완료' ? 'sold-out' : ''}">
                        <div class="carousel-item active" data-bs-interval="10000">
                            <img src="${pageContext.request.contextPath}/resources/images/${specProd.pimage}" class="d-block w-100" alt="${specProd.pname}">
                            <c:if test="${specProd.pstatus == '판매완료'}">
			                    <div class="sold-out-overlay">
			                        <span>판매완료</span>
			                    </div>
			                </c:if>
                        </div> 
                        </div>
                        <div class="carousel-item" data-bs-interval="2000">
                            <img src="${pageContext.request.contextPath}/resources/images/${specProd.pimage}" class="d-block w-100" alt="${specProd.pname}">
                        </div>
                        <div class="carousel-item">
                            <img src="${pageContext.request.contextPath}/resources/images/${specProd.pimage}" class="d-block w-100" alt="${specProd.pname}">
                        </div>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleInterval"
                        data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleInterval"
                        data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Next</span>
                    </button>
                </div>
            </div>
            <div class="info">
                <div class="flex items-center w-full ">
                    <!-- 카테고리 불러와서 띄울 부분 -->
                    <ol class="flex felx-wrap items-center w-full ">
                        <li>${categoryName1}</li>
                        <li><svg width="17" height="17" viewBox="0 0 17 17" fill="none"
                                xmlns="http://www.w3.org/2000/svg" class="rotate-[0deg]">
                                <path
                                    d="M5.6665 14.1667L10.9796 8.85363C11.1749 8.65837 11.1749 8.34179 10.9796 8.14653L5.6665 2.83341"
                                    stroke="#9CA3AF" stroke-linecap="round" stroke-linejoin="round"></path>
                            </svg></li>
                       <c:if test="${categoryName2 != null}">
                        <li>${categoryName2} </li>
                        <li><svg width="17" height="17" viewBox="0 0 17 17" fill="none"
                                xmlns="http://www.w3.org/2000/svg" class="rotate-[0deg]">
                                <path
                                    d="M5.6665 14.1667L10.9796 8.85363C11.1749 8.65837 11.1749 8.34179 10.9796 8.14653L5.6665 2.83341"
                                    stroke="#9CA3AF" stroke-linecap="round" stroke-linejoin="round"></path>
                            </svg></li>
                            </c:if>
                            <c:if test="${categoryName3 != null}">
                        <li>${categoryName3} </li>
                        </c:if>
                    </ol>
                </div>
                <div>
                    <div class="flex items-center justify-between mb-1">
                        <h1 class="text-lg font-semibold leading-6 md:text-2xl md:leading-[28.64px] text-jnblack mr-2">
                           ${specProd.pname}</h1><button type="button" aria-label="공유하기"><svg width="24" height="24"
                                viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="">
                                <path
                                    d="M19.5556 12.9408V18.9852C19.5556 19.5196 19.33 20.0321 18.9285 20.4099C18.5271 20.7878 17.9826 21 17.4148 21H5.64074C5.07298 21 4.52848 20.7878 4.12701 20.4099C3.72554 20.0321 3.5 19.5196 3.5 18.9852V7.90373C3.5 7.36937 3.72554 6.85689 4.12701 6.47904C4.52848 6.10119 5.07298 5.88892 5.64074 5.88892H12.063"
                                    stroke="#141313" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                </path>
                                <path d="M14.8334 4H20C20.2762 4 20.5 4.22386 20.5 4.5V9.66667" stroke="#141313"
                                    stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                                <path d="M11.0554 13.4444L20.0276 4.47217" stroke="#141313" stroke-width="1.5"
                                    stroke-linecap="round" stroke-linejoin="round"></path>
                            </svg></button>
                    </div>
                    <div class="flex items-center mb-2 lg:mb-3">
                        <div
                            class="font-bold md:text-[32px] mr-2 text-[26px] leading-9 md:leading-[38.19px] text-heading">
                           ${specProd.price}원</div><svg width="30" height="17" viewBox="0 0 30 17" fill="none"
                            xmlns="http://www.w3.org/2000/svg">
                            <rect y="-0.00012207" width="30" height="16.2857" rx="2.25" fill="#0DCC5A"></rect>
                            <path
                                d="M11.6626 6.31356V6.28956C11.6626 4.57356 10.4506 3.38556 8.44665 3.38556H5.01465V11.7856H6.86265V9.26556H8.26665C10.1506 9.26556 11.6626 8.25756 11.6626 6.31356ZM9.79065 6.34956C9.79065 7.06956 9.25065 7.62156 8.32665 7.62156H6.86265V5.05356H8.29065C9.21465 5.05356 9.79065 5.49756 9.79065 6.32556V6.34956Z"
                                fill="white"></path>
                            <path
                                d="M18.2531 11.7856V8.05356C18.2531 6.31356 17.3771 5.28156 15.3851 5.28156C14.2931 5.28156 13.5971 5.48556 12.8891 5.79756L13.3451 7.18956C13.9331 6.97356 14.4251 6.84156 15.1211 6.84156C16.0331 6.84156 16.5011 7.26156 16.5011 8.01756V8.12556C16.0451 7.96956 15.5771 7.86156 14.9291 7.86156C13.4051 7.86156 12.3371 8.50956 12.3371 9.91356V9.93756C12.3371 11.2096 13.3331 11.9056 14.5451 11.9056C15.4331 11.9056 16.0451 11.5816 16.4891 11.0896V11.7856H18.2531ZM16.5251 9.51756C16.5251 10.1776 15.9491 10.6456 15.0971 10.6456C14.5091 10.6456 14.1011 10.3576 14.1011 9.86556V9.84156C14.1011 9.26556 14.5811 8.95356 15.3611 8.95356C15.8051 8.95356 16.2131 9.04956 16.5251 9.19356V9.51756Z"
                                fill="white"></path>
                            <path
                                d="M25.7083 5.35356H23.8123L22.4083 9.73356L20.9443 5.35356H19.0123L21.5323 11.8096C21.3763 12.1336 21.2083 12.2296 20.8963 12.2296C20.6563 12.2296 20.3563 12.1216 20.1163 11.9776L19.5043 13.2976C19.9723 13.5736 20.4643 13.7416 21.1243 13.7416C22.2163 13.7416 22.7443 13.2496 23.2363 11.9416L25.7083 5.35356Z"
                                fill="white"></path>
                        </svg>
                    </div>
                    <div class="flex items-center justify-between mb-4 text-xs font-normal"><span
                            class="text-jnGray-500 leading-[15px]">2024-03-22 · 조회 ${specProd.preadcount} · 찜 ${specProd.wishCount}</span>
                            <a class="ga4_product_detail_price" href="marketPrice.prod">
                    	        <span class="leading-4 underline underline-offset-4 text-jnGray-700">시세조회</span>
                            </a>
                    </div>
                </div>
                <div>
                    <!-- 제품정보 -->
                    <ul class="box-border flex text-center border rounded items-center py-6 mb-6 border-gray-300">
                        <li class="flex flex-col flex-1 px-3 relative justify-center items-center">
                            <span class="text-xs font-normal ">제품상태</span>
                            <button disabled class="block text-sm font-semibold  mt-1" style="cursor:auto">${specProd.pcontent}</button>
                        </li>
                        <li class="flex flex-col flex-1 px-3 relative after:left-0 justify-center items-center">
                            <span class="text-xs font-normal ">거래방식</span>
                            <button disabled style="cursor:auto"
                                class="block text-sm font-semibold  mt-1 ">${specProd.pdeliverytype}</button>
                        </li>
                        <li class="flex flex-col flex-1 px-3 relative justify-center items-center">
                            <span class="text-xs font-normal ">배송비</span>
                            <button disabled style="cursor:auto" class="block text-sm font-semibold  mt-1 ">별도</button>
                        </li>
                        <c:if test="${empty sessionScope.mbId}">
	                        <li class="flex flex-col flex-1  px-3 relative justify-center items-center">
	                            <span class="text-xs font-normal  ">안전거래</span>
	                            <button disabled style="cursor:auto" class="block text-sm font-semibold mt-1 ">사용</button>
	                        </li>
     					</c:if>
                        <c:if test="${not empty sessionScope.mbId}">
	                        <li class="flex flex-col flex-1  px-3 relative justify-center items-center">
	                            <span class="text-xs font-normal  ">안전거래</span>
	                            <button disabled style="cursor:auto" class="block text-sm font-semibold mt-1 ">사용</button>
	                        </li>
     					</c:if>
                    </ul>

                    <!-- 거래방식 및 결제혜택 -->
                    <ul>
                        <li class="">
                            <div class="sm:mb-5 sm:flex block mb-4">
                                <div class="flex items-center mr-5 min-w-[95px]"><svg xmlns="http://www.w3.org/2000/svg"
                                        width="12" height="12" viewBox="0 0 12 12" fill="none">
                                        <rect x="4.5" y="4.5" width="3" height="3" fill="#141313"></rect>
                                    </svg><span class="text-xs text-jnGray-700 ml-[6px]">거래희망지역</span></div>
                                <div class="pt-1 pl-[18px] sm:p-0">
                                    <div>
                                        <div class="basis-[100%]">
                                            <div class="carouselWrapper relative">
                                                <div class="swiper swiper-initialized swiper-horizontal swiper-pointer-events swiper-backface-hidden"
                                                    dir="ltr">
                                                    <div class="swiper-wrapper">
                                                        <div
                                                            class="swiper-slide swiper-slider-search-price margin8 swiper-slide-active">

                                                            <button id="addr1" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRight" aria-controls="offcanvasRight"
                                                                class="btn inline-flex gap-1 text-xs text-jnblack items-center mr-3 underline underline-offset-[3px]"><svg
                                                                    width="10" height="10" viewBox="0 0 10 10"
                                                                    fill="none" xmlns="http://www.w3.org/2000/svg"
                                                                    class="">
                                                                    <g id="ico_location">
                                                                        <g id="Group 7574">
                                                                            <path id="Subtract" fill-rule="evenodd"
                                                                                clip-rule="evenodd"
                                                                                d="M0.500572 4.33686C0.461335 2.03812 2.44609 0.0664601 4.87009 0.00172047C7.41486 -0.0659179 9.5 1.86951 9.5 4.2668C9.5 5.53695 8.91145 6.67425 7.98201 7.45595L5.51062 9.79962C5.22883 10.0668 4.77124 10.0668 4.48945 9.79962L2.01755 7.45595C1.10543 6.68874 0.521464 5.57899 0.500572 4.33686ZM6.29884 3.7499C5.88477 3.03268 4.96724 2.7871 4.25008 3.2012C3.53291 3.61529 3.28683 4.53237 3.70141 5.2501C4.11548 5.96732 5.03249 6.2129 5.74966 5.7988C6.46734 5.38471 6.7129 4.46763 6.29884 3.7499Z"
                                                                                fill="#787E89"></path>
                                                                        </g>
                                                                    </g>
                                                                </svg>가로수길 5 </button>
                                                              

                                                        </div>
                                                        <div
                                                            class="swiper-slide swiper-slider-search-price margin8 swiper-slide-next">
                                                            <button
                                                                class="inline-flex gap-1 text-xs text-jnblack items-center mr-3 underline underline-offset-[3px]"><svg
                                                                    width="10" height="10" viewBox="0 0 10 10"
                                                                    fill="none" xmlns="http://www.w3.org/2000/svg"
                                                                    class="">
                                                                    <g id="ico_location">
                                                                        <g id="Group 7574">
                                                                            <path id="Subtract" fill-rule="evenodd"
                                                                                clip-rule="evenodd"
                                                                                d="M0.500572 4.33686C0.461335 2.03812 2.44609 0.0664601 4.87009 0.00172047C7.41486 -0.0659179 9.5 1.86951 9.5 4.2668C9.5 5.53695 8.91145 6.67425 7.98201 7.45595L5.51062 9.79962C5.22883 10.0668 4.77124 10.0668 4.48945 9.79962L2.01755 7.45595C1.10543 6.68874 0.521464 5.57899 0.500572 4.33686ZM6.29884 3.7499C5.88477 3.03268 4.96724 2.7871 4.25008 3.2012C3.53291 3.61529 3.28683 4.53237 3.70141 5.2501C4.11548 5.96732 5.03249 6.2129 5.74966 5.7988C6.46734 5.38471 6.7129 4.46763 6.29884 3.7499Z"
                                                                                fill="#787E89"></path>
                                                                        </g>
                                                                    </g>
                                                                </svg>상대원2동</button>
                                                        </div>
                                                        <div class="swiper-slide swiper-slider-search-price margin8">
                                                            <button
                                                                class="inline-flex gap-1 text-xs text-jnblack items-center mr-3 underline underline-offset-[3px]"><svg
                                                                    width="10" height="10" viewBox="0 0 10 10"
                                                                    fill="none" xmlns="http://www.w3.org/2000/svg"
                                                                    class="">
                                                                    <g id="ico_location">
                                                                        <g id="Group 7574">
                                                                            <path id="Subtract" fill-rule="evenodd"
                                                                                clip-rule="evenodd"
                                                                                d="M0.500572 4.33686C0.461335 2.03812 2.44609 0.0664601 4.87009 0.00172047C7.41486 -0.0659179 9.5 1.86951 9.5 4.2668C9.5 5.53695 8.91145 6.67425 7.98201 7.45595L5.51062 9.79962C5.22883 10.0668 4.77124 10.0668 4.48945 9.79962L2.01755 7.45595C1.10543 6.68874 0.521464 5.57899 0.500572 4.33686ZM6.29884 3.7499C5.88477 3.03268 4.96724 2.7871 4.25008 3.2012C3.53291 3.61529 3.28683 4.53237 3.70141 5.2501C4.11548 5.96732 5.03249 6.2129 5.74966 5.7988C6.46734 5.38471 6.7129 4.46763 6.29884 3.7499Z"
                                                                                fill="#787E89"></path>
                                                                        </g>
                                                                    </g>
                                                                </svg>상대원3동</button>
                                                        </div>
                                                    </div>
                                                    <div
                                                        class="swiper-button-prev swiper-button-disabled swiper-button-lock">
                                                    </div>
                                                    <div
                                                        class="swiper-button-next swiper-button-disabled swiper-button-lock">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                        
                        <li class="">
                            <div class="sm:mb-5 sm:flex block mb-4 items-start justify-start">
                                <div class="flex items-center mr-5 min-w-[95px]"><svg xmlns="http://www.w3.org/2000/svg"
                                        width="12" height="12" viewBox="0 0 12 12" fill="none">
                                        <rect x="4.5" y="4.5" width="3" height="3" fill="#141313"></rect>
                                    </svg><span class="text-xs text-jnGray-700 ml-[6px]">결제혜택</span></div>
                                <div class="">
                                    <ul class="pt-1 pl-[18px] items-start flex-col flex p-0">
                                        <li>
                                            <p class="text-xs font-medium text-jnblack tracking-[0.2px]">하나카드 최대 10만원
                                                즉시할인</p>
                                        </li>
                                        <li>
                                            <p class="text-xs font-medium text-jnblack tracking-[0.2px]">KB국민카드 최대 10만원
                                                즉시할인</p>
                                        </li>
                                        <li>
                                            <p class="text-xs font-medium text-jnblack tracking-[0.2px]">KB국민카드 18개월 6%
                                                특별 할부 수수료</p>
                                        </li>
                                        <li>
                                            <p class="text-xs font-medium text-jnblack tracking-[0.2px]">CU알뜰택배 300원 무제한
                                                할인</p>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </li>

                        <li class="">
                            <div class="sm:mb-5 sm:flex block mb-4 items-start justify-start">
                                <div class="flex items-center mr-5 min-w-[95px]"><svg xmlns="http://www.w3.org/2000/svg"
                                        width="12" height="12" viewBox="0 0 12 12" fill="none">
                                        <rect x="4.5" y="4.5" width="3" height="3" fill="#141313"></rect>
                                    </svg><span class="text-xs text-jnGray-700 ml-[6px]">무이자혜택</span></div>
                                <div class="">
                                    <ul class="pt-1 pl-[18px] sm:items-start sm:flex-col sm:flex sm:p-0">
                                        <li><a target="_blank"
                                                class="block text-xs font-medium text-jnblack tracking-[0.2px]"
                                                href="https://web.joongna.com/event/detail/1241">1만원 이상 무이자 할부</a></li>
                                    </ul>
                                </div>
                            </div>
                        </li>


                    </ul>
                    
                    <!-- 찜하기 하트 -->
                    <div class="flex items-center pt-4 bg-white  btn-wrap">
						<c:if test = "${empty wdto}">
						 <div class="heart-icon" id="heartIcon">
					        <svg width="32px" height="32px" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"
					            class="pointer-events-none w-8 h-8">
					            <path
					                d="M5.94197 17.9925L15.2564 26.334C15.3282 26.3983 15.3641 26.4305 15.3975 26.4557C15.7541 26.7249 16.2459 26.7249 16.6025 26.4557C16.6359 26.4305 16.6718 26.3983 16.7436 26.3341L26.058 17.9925C28.8244 15.5151 29.1565 11.3015 26.8124 8.42125L26.5675 8.12029C23.8495 4.78056 18.5906 5.35863 16.663 9.20902C16.3896 9.75505 15.6104 9.75505 15.337 9.20902C13.4094 5.35863 8.1505 4.78056 5.43249 8.12028L5.18755 8.42125C2.84352 11.3015 3.17564 15.5151 5.94197 17.9925Z"
					                stroke-width="1.5" stroke="#9CA3AF"></path>
					        </svg>
					    </div>
					    </c:if>
					    <c:if test = "${not empty wdto}">
					    			 <div class="heart-icon" id="heartIcon">
					    <svg width="32px" height="32px" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"
					        class="pointer-events-none w-8 h-8">
					        <path
					            d="M5.94197 17.9925L15.2564 26.334C15.3282 26.3983 15.3641 26.4305 15.3975 26.4557C15.7541 26.7249 16.2459 26.7249 16.6025 26.4557C16.6359 26.4305 16.6718 26.3983 16.7436 26.3341L26.058 17.9925C28.8244 15.5151 29.1565 11.3015 26.8124 8.42125L26.5675 8.12029C23.8495 4.78056 18.5906 5.35863 16.663 9.20902C16.3896 9.75505 15.6104 9.75505 15.337 9.20902C13.4094 5.35863 8.1505 4.78056 5.43249 8.12028L5.18755 8.42125C2.84352 11.3015 3.17564 15.5151 5.94197 17.9925Z"
					            fill="#FF0000"></path>
					    </svg>
						</div>
					   </c:if>
					
					    <form id="wishForm" action="wish_insert.do" method="post" style="display: none;">
						    <input type="hidden" name="product_id" value="${specProd.pnum}">
						    <input type="hidden" name="product_name" value="${specProd.pname}">
						    <input type="hidden" name="product_price" value="${specProd.price}">
						    <input type="hidden" name="product_image" value="${specProd.pimage}">
						    <input type="hidden" name="member_id" value="${sessionScope.mbId.id}">
						</form>

                            <!-- <input id=":Rficqpb6:" type="checkbox" class="a11yHidden"> -->

                        <div class="btns">
                            <button href="#" id="chatButton" onclick="openChatPopup()"><span>채팅하기</span></button>
                            
                            <!-- 채팅 팝업 -->
							<div id="popup" class="popup">
							    <div class="popup-content">
							        <span id="closePopupBtn" class="close-btn" onclick="closeChatPopup()">&times;</span>
							        <%@ include file="../chat/chatPage.jsp" %>	<!-- 이부분 제거하면 디테일에서 채팅하기 먹통 -->
							         
							    </div>
							</div>
							<div id="overlay" class="overlay" onclick="closeChatPopup()"></div>
                            <%-- 판매완료가 아닌 경우에만 버튼을 표시하도록 합니다. --%>
                              <c:set var="pstatus" value="${specProd.pstatus}" />
                     <c:if test="${pstatus != '판매완료'}">
                         <c:choose>
                             <c:when test="${pstatus == '판매중'}">
                                 <button class="btn-safe-chat" onclick="clickWantBuy('${sessionScope.mbId.id}',${specProd.pnum},'${specProd.member_id}','${specProd.pname}')">안전거래</button>
                             </c:when>
                             <c:when test="${pstatus == '거래중'}">
                                 <button class="btn-cantBuy" onclick="cantBuy()">거래중</button>
                             </c:when>
                         </c:choose>
                     </c:if>
                        </div>
                    </div>

                </div>
            </div>

        </div>
        <div class="flex mb-12 second-wrap">
            <div class="prod-info">
                <h3>상품정보</h3>
                <hr />
                <div>
                    <div class="prod-description">${specProd.pdescription}</div>
                    <div>
                        <div>거래 희망 지역</div>
                        <div class="basis-[100%]" style="margin-bottom:20px;"">
                                <div class=" carouselWrapper relative">
                            <div class="swiper swiper-initialized swiper-horizontal swiper-pointer-events swiper-backface-hidden"
                                dir="ltr">
                                <div class="swiper-wrapper">
                                    <div class="swiper-slide swiper-slider-search-price margin8 swiper-slide-active">
                                        <button
                                            class="inline-flex gap-1 text-xs text-jnblack items-center px-3 py-7 mr-2 rounded bg-jnGray-200 mt-2"><svg
                                                width="10" height="10" viewBox="0 0 10 10" fill="none"
                                                xmlns="http://www.w3.org/2000/svg" class="">
                                                <g id="ico_location">
                                                    <g id="Group 7574">
                                                        <path id="Subtract" fill-rule="evenodd" clip-rule="evenodd"
                                                            d="M0.500572 4.33686C0.461335 2.03812 2.44609 0.0664601 4.87009 0.00172047C7.41486 -0.0659179 9.5 1.86951 9.5 4.2668C9.5 5.53695 8.91145 6.67425 7.98201 7.45595L5.51062 9.79962C5.22883 10.0668 4.77124 10.0668 4.48945 9.79962L2.01755 7.45595C1.10543 6.68874 0.521464 5.57899 0.500572 4.33686ZM6.29884 3.7499C5.88477 3.03268 4.96724 2.7871 4.25008 3.2012C3.53291 3.61529 3.28683 4.53237 3.70141 5.2501C4.11548 5.96732 5.03249 6.2129 5.74966 5.7988C6.46734 5.38471 6.7129 4.46763 6.29884 3.7499Z"
                                                            fill="#787E89"></path>
                                                    </g>
                                                </g>
                                            </svg>상대원1동</button>
                                    </div>
                                    <div class="swiper-slide swiper-slider-search-price margin8 swiper-slide-next">
                                        <button
                                            class="inline-flex gap-1 text-xs text-jnblack items-center px-3 py-7 mr-2 rounded bg-jnGray-200 mt-2"><svg
                                                width="10" height="10" viewBox="0 0 10 10" fill="none"
                                                xmlns="http://www.w3.org/2000/svg" class="">
                                                <g id="ico_location">
                                                    <g id="Group 7574">
                                                        <path id="Subtract" fill-rule="evenodd" clip-rule="evenodd"
                                                            d="M0.500572 4.33686C0.461335 2.03812 2.44609 0.0664601 4.87009 0.00172047C7.41486 -0.0659179 9.5 1.86951 9.5 4.2668C9.5 5.53695 8.91145 6.67425 7.98201 7.45595L5.51062 9.79962C5.22883 10.0668 4.77124 10.0668 4.48945 9.79962L2.01755 7.45595C1.10543 6.68874 0.521464 5.57899 0.500572 4.33686ZM6.29884 3.7499C5.88477 3.03268 4.96724 2.7871 4.25008 3.2012C3.53291 3.61529 3.28683 4.53237 3.70141 5.2501C4.11548 5.96732 5.03249 6.2129 5.74966 5.7988C6.46734 5.38471 6.7129 4.46763 6.29884 3.7499Z"
                                                            fill="#787E89"></path>
                                                    </g>
                                                </g>
                                            </svg>상대원2동</button>
                                    </div>
                                    <div class="swiper-slide swiper-slider-search-price margin8"><button
                                            class="inline-flex gap-1 text-xs text-jnblack items-center px-3 py-7 mr-2 rounded bg-jnGray-200 mt-2"><svg
                                                width="10" height="10" viewBox="0 0 10 10" fill="none"
                                                xmlns="http://www.w3.org/2000/svg" class="">
                                                <g id="ico_location">
                                                    <g id="Group 7574">
                                                        <path id="Subtract" fill-rule="evenodd" clip-rule="evenodd"
                                                            d="M0.500572 4.33686C0.461335 2.03812 2.44609 0.0664601 4.87009 0.00172047C7.41486 -0.0659179 9.5 1.86951 9.5 4.2668C9.5 5.53695 8.91145 6.67425 7.98201 7.45595L5.51062 9.79962C5.22883 10.0668 4.77124 10.0668 4.48945 9.79962L2.01755 7.45595C1.10543 6.68874 0.521464 5.57899 0.500572 4.33686ZM6.29884 3.7499C5.88477 3.03268 4.96724 2.7871 4.25008 3.2012C3.53291 3.61529 3.28683 4.53237 3.70141 5.2501C4.11548 5.96732 5.03249 6.2129 5.74966 5.7988C6.46734 5.38471 6.7129 4.46763 6.29884 3.7499Z"
                                                            fill="#787E89"></path>
                                                    </g>
                                                </g>
                                            </svg>상대원3동</button></div>
                                </div>
                                <div class="swiper-button-prev swiper-button-disabled swiper-button-lock"></div>
                                <div class="swiper-button-next swiper-button-disabled swiper-button-lock"></div>
                            </div>
                        </div>
                    </div>
                </div>


            </div>
            <div>
                <div>거래 희망 편의점</div>
                <div class="basis-[100%]">
                    <div class="carouselWrapper relative">
                        <div class="swiper swiper-initialized swiper-horizontal swiper-pointer-events swiper-backface-hidden"
                            dir="ltr">
                            <div class="swiper-wrapper">
                                <div
                                    class="swiper-slide swiper-slider-search-price margin8 location-tag swiper-slide-active">
                                    <button
                                        class="inline-flex gap-1 text-xs text-jnblack items-center px-3 py-7 mr-2 rounded bg-jnGray-200 mt-2"><svg
                                            width="10" height="10" viewBox="0 0 10 10" fill="none"
                                            xmlns="http://www.w3.org/2000/svg" class="">
                                            <g id="ico_location">
                                                <g id="Group 7574">
                                                    <path id="Subtract" fill-rule="evenodd" clip-rule="evenodd"
                                                        d="M0.500572 4.33686C0.461335 2.03812 2.44609 0.0664601 4.87009 0.00172047C7.41486 -0.0659179 9.5 1.86951 9.5 4.2668C9.5 5.53695 8.91145 6.67425 7.98201 7.45595L5.51062 9.79962C5.22883 10.0668 4.77124 10.0668 4.48945 9.79962L2.01755 7.45595C1.10543 6.68874 0.521464 5.57899 0.500572 4.33686ZM6.29884 3.7499C5.88477 3.03268 4.96724 2.7871 4.25008 3.2012C3.53291 3.61529 3.28683 4.53237 3.70141 5.2501C4.11548 5.96732 5.03249 6.2129 5.74966 5.7988C6.46734 5.38471 6.7129 4.46763 6.29884 3.7499Z"
                                                        fill="#787E89"></path>
                                                </g>
                                            </g>
                                        </svg>
                                        <svg width="16px" height="16px" viewBox="0 0 24 24" fill="none"
                                            xmlns="http://www.w3.org/2000/svg" class="">
                                            <g clip-path="url(#clip0_20108_80071)">
                                                <g clip-path="url(#clip1_20108_80071)">
                                                    <path
                                                        d="M15.6176 17.6567C15.9161 17.6567 16.1574 17.9013 16.1574 18.2001C16.1574 18.4988 15.9161 18.7452 15.6176 18.7452C15.3192 18.7452 15.082 18.4994 15.082 18.2001C15.082 17.9007 15.3204 17.6567 15.6176 17.6567ZM15.6176 18.6375C15.8531 18.6375 16.0385 18.4477 16.0385 18.2001C16.0385 17.9525 15.8531 17.7639 15.6176 17.7639C15.3822 17.7639 15.1968 17.9525 15.1968 18.2001C15.1968 18.4477 15.3822 18.6375 15.6176 18.6375ZM15.5499 18.4917H15.4381V17.8996H15.6426C15.7573 17.8996 15.8429 17.9805 15.8429 18.0852C15.8429 18.168 15.79 18.2352 15.7134 18.2608L15.8459 18.4923H15.7181L15.5945 18.2715H15.5505V18.4923L15.5499 18.4917ZM15.626 18.1739C15.692 18.1739 15.7288 18.1418 15.7288 18.087C15.7288 18.0293 15.692 17.9972 15.626 17.9972H15.5493V18.1739H15.626Z"
                                                        fill="#147350"></path>
                                                    <path
                                                        d="M18.2235 13.5266C17.9328 13.5266 17.7295 13.6623 17.544 13.8164L17.4103 14.0075L17.3621 13.9736L17.525 13.6986V13.5266H16.4883V16.9629H17.4299V14.7823C17.4299 14.4288 17.6671 14.3158 17.8288 14.2955C17.9834 14.2759 18.1825 14.3616 18.1825 14.555V16.9635H19.1241V14.5943C19.1241 13.8623 18.793 13.5266 18.2247 13.5266"
                                                        fill="#147350"></path>
                                                    <path
                                                        d="M7.70394 16.2249H8.69373V16.9635H6.76172V13.5266H7.70394V16.2249Z"
                                                        fill="#147350"></path>
                                                    <path
                                                        d="M4.5 16.9635H6.43201V16.288H5.44223V15.5191H6.43201V14.8752H5.44223V14.2283H6.43201V13.5266H4.5V16.9635Z"
                                                        fill="#147350"></path>
                                                    <path
                                                        d="M9.02344 16.9635H10.956V16.288H9.96566V15.5191H10.956V14.8752H9.96566V14.2283H10.956V13.5266H9.02344V16.9635Z"
                                                        fill="#147350"></path>
                                                    <path
                                                        d="M14.2266 16.9635H16.1586V16.288H15.1688V15.5191H16.1586V14.8752H15.1688V14.2283H16.1586V13.5266H14.2266V16.9635Z"
                                                        fill="#147350"></path>
                                                    <path
                                                        d="M12.999 13.5266V13.5284L12.6352 15.706L12.609 16.0809L12.6061 16.1154H12.5716L12.5692 16.0809L12.5425 15.706L12.1786 13.5284V13.5266H11.2305L12.0122 16.9635H13.1654L13.9478 13.5266H12.999Z"
                                                        fill="#147350"></path>
                                                    <path
                                                        d="M16.7715 3.00781H4.5V7.88311H10.9761C12.42 5.77338 14.4228 4.07726 16.7715 3.00781Z"
                                                        fill="#FF6C00"></path>
                                                    <path d="M9.375 22.5H14.2437L14.2496 17.6277H9.38392L9.375 22.5Z"
                                                        fill="#EC0F2A"></path>
                                                    <path
                                                        d="M19.1269 7.89375V3C14.477 4.27953 10.8484 8.02765 9.73438 12.7482H14.7172C15.4668 10.5927 17.0718 8.83822 19.1263 7.89375H19.1269Z"
                                                        fill="#EC0F2A"></path>
                                                </g>
                                            </g>
                                            <defs>
                                                <clipPath id="clip0_20108_80071">
                                                    <rect width="24" height="24" fill="white"></rect>
                                                </clipPath>
                                                <clipPath id="clip1_20108_80071">
                                                    <rect width="14.625" height="19.5" fill="white"
                                                        transform="translate(4.5 3)"></rect>
                                                </clipPath>
                                            </defs>
                                        </svg>
                                        <p>세종고운11단지점</p>
                                    </button>
                                </div>
                            </div>
                            <div class="swiper-button-prev swiper-button-disabled swiper-button-lock"></div>
                            <div class="swiper-button-next swiper-button-disabled swiper-button-lock"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="store-info">
            <h3>
                가게정보
            </h3>
            <hr />
            <div class="flex">
                <a class="flex items-center justify-between w-full pt-4 pb-4" href="userPage.prod?member_id=${specProd.member_id}">
                    <p class="font-semibold text-jnGray-900 store-name">${specProd.member_id}</p>
                    <div class="flex items-center translate-x-4 ">
                        <img alt="프로파일"
                            src="https://img2.joongna.com/media/original/2024/05/27/1716798194719JcQ_020XB.jpg"
                            width="60" height="60" decoding="async" data-nimg="1"
                            class="rounded-full max-w-none h-[60px] box-content border-4 border-white -translate-x-4"
                            loading="lazy" style="color: transparent;">
                    </div>
                </a>
            </div>
             <div style="width: 100%; max-width: 1000px; margin: 0 auto;">
               <label for="progress"><span>신뢰지수 ${getMember.trust_score} / 1000</span></label>
               <progress value="${getMember.trust_score}" max="1000" class="progress" id="progress"></progress>
           </div>
            <div>
                <ul style="height:77px;"
                    class="box-border flex text-center border border-gray-300 rounded items-center mt-3">
                    <li class="flex flex-col flex-1  px-3  relative  justify-center items-center">
                        <span class="text-xs font-normal text-jnGray-600 ">안전거래</span><button disabled=""
                            class="block text-sm font-semibold text-jnblack mt-1 ">${specProd.sellCount}</button>
                    </li>
                    <li class="flex flex-col flex-1  px-3  relative   justify-center items-center">
                        <span class="text-xs font-normal text-jnGray-600 ">거래후기</span>
                        <button class="block text-sm font-semibold text-jnblack mt-1 underline underline-offset-[3px]" 
                        	id="chatButton" onclick="openReviewsPopup()">
                            ${specProd.reviewsCount}
                        </button>
                    </li>
                    <li class="flex flex-col flex-1  px-3  relative   justify-center items-center">
                        <span class="text-xs font-normal text-jnGray-600 ">단골</span>
                        <button disabled="" class="block text-sm font-semibold text-jnblack mt-1 " >
                            	0
                        </button>
                    </li>
                </ul>
            </div>
				<div class="mt-4 flex">
					<!-- 팔고있는 제품들 3개 나열 ( for문 반복 부분 ) -->
					<c:if test="${not empty idProd_d}">
						<c:forEach var="product" items="${idProd_d}" varStatus="loop">
							<c:if test="${loop.index < 3}">
								<div class="user-card">
									<div>
										<img
											src="https://m.firenzeatelier.com/web/product/medium/202312/95fdb8105b63f067bc4fd149ee86eec2.jpg">
									</div>
									<div class="content">${product.pname}</div>
									<div class="content">가격: ${product.price}원</div>
								</div>
							</c:if>
						</c:forEach>
					</c:if>
				</div>

				<div id="reviews" class="popup">
					<div class="popup-content">
						<span id="closePopupBtn" class="close-btn" onclick="closeReviewsPopup()">&times;</span>
				        <div id="userReviews"></div>
				        <%@include file="../reviews/userReviews.jsp"%>
				    </div>
				</div>
				<div id="overlay" class="overlay" onclick="closeReviewsPopup()"></div>
				<!-- 여기서부터 -->
				
				

        </div>
        <div class="third-wrap">
            <div class="flex flex-wrap items-center mb-4 md:mb-5">
                <h3 class="md:text-[22px] font-bold text-jnBlack mr-2 text-lg empty:h-7">이런 상품은 어때요?</h3>
            </div>
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide">
                        <div class="product-card">
                            <img src="https://img2.joongna.com/media/original/2023/04/19/1681859649846lFp_dx18U.jpg?impolicy=thumb&size=150"
                                alt="Product 1">
                            <div class="product-info">
                                <div class="product-title">&lt;340만=&gt;180만&gt;구찌 GG 미디엄 토트백(2way</div>
                                <div class="product-price">1,800,000원</div>
                            </div>
                        </div>
                    </div>

                    <div class="swiper-slide">
                        <div class="product-card">
                            <img src="https://img2.joongna.com/media/original/2023/04/19/1681859649846lFp_dx18U.jpg?impolicy=thumb&size=150"
                                alt="Product 1">
                            <div class="product-info">
                                <div class="product-title">&lt;340만=&gt;180만&gt;구찌 GG 미디엄 토트백(2way</div>
                                <div class="product-price">1,800,000원</div>
                            </div>
                        </div>
                    </div>


                    <div class="swiper-slide">
                        <div class="product-card">
                            <img src="https://img2.joongna.com/media/original/2023/04/19/1681859649846lFp_dx18U.jpg?impolicy=thumb&size=150"
                                alt="Product 1">
                            <div class="product-info">
                                <div class="product-title">&lt;340만=&gt;180만&gt;구찌 GG 미디엄 토트백(2way</div>
                                <div class="product-price">1,800,000원</div>
                            </div>
                        </div>
                    </div>



                    <div class="swiper-slide">
                        <div class="product-card">
                            <img src="https://img2.joongna.com/media/original/2023/04/19/1681859649846lFp_dx18U.jpg?impolicy=thumb&size=150"
                                alt="Product 1">
                            <div class="product-info">
                                <div class="product-title">&lt;340만=&gt;180만&gt;구찌 GG 미디엄 토트백(2way</div>
                                <div class="product-price">1,800,000원</div>
                            </div>
                        </div>
                    </div>



                    <div class="swiper-slide">
                        <div class="product-card">
                            <img src="https://img2.joongna.com/media/original/2023/04/19/1681859649846lFp_dx18U.jpg?impolicy=thumb&size=150"
                                alt="Product 1">
                            <div class="product-info">
                                <div class="product-title">&lt;340만=&gt;180만&gt;구찌 GG 미디엄 토트백(2way</div>
                                <div class="product-price">1,800,000원</div>
                            </div>
                        </div>
                    </div>


                    <div class="swiper-slide">
                        <div class="product-card">
                            <img src="https://img2.joongna.com/media/original/2023/04/19/1681859649846lFp_dx18U.jpg?impolicy=thumb&size=150"
                                alt="Product 1">
                            <div class="product-info">
                                <div class="product-title">&lt;340만=&gt;180만&gt;구찌 GG 미디엄 토트백(2way</div>
                                <div class="product-price">1,800,000원</div>
                            </div>
                        </div>
                    </div>



                </div>
                <div class="swiper-button-next">
                    <svg width="26" height="28" viewBox="0 0 26 28" fill="none" xmlns="http://www.w3.org/2000/svg"
                        class="rotate-[180deg]">
                        <g filter="url(#filter0_d_19461_8348)">
                            <path fill-rule="evenodd" clip-rule="evenodd"
                                d="M15.8122 5.34218C16.4517 6.0669 16.3825 7.17278 15.6578 7.81224L8.645 14L15.6578 20.1878C16.3825 20.8273 16.4517 21.9331 15.8122 22.6579C15.1727 23.3826 14.0669 23.4517 13.3421 22.8122L5.26706 15.6872C4.25192 14.7914 4.25192 13.2086 5.26706 12.3129L13.3421 5.1878C14.0669 4.54835 15.1727 4.61747 15.8122 5.34218Z"
                                fill="white"></path>
                        </g>
                        <defs>
                            <filter id="filter0_d_19461_8348" x="0.505707" y="0.75" width="19.7443" height="26.5"
                                filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                                <feFlood flood-opacity="0" result="BackgroundImageFix"></feFlood>
                                <feColorMatrix in="SourceAlpha" type="matrix"
                                    values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha">
                                </feColorMatrix>
                                <feOffset></feOffset>
                                <feGaussianBlur stdDeviation="2"></feGaussianBlur>
                                <feComposite in2="hardAlpha" operator="out"></feComposite>
                                <feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.35 0">
                                </feColorMatrix>
                                <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_19461_8348">
                                </feBlend>
                                <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_19461_8348"
                                    result="shape"></feBlend>
                            </filter>
                        </defs>
                    </svg>
                </div>
                <div class="swiper-button-prev">
                    <svg width="26" height="28" viewBox="0 0 26 28" fill="none" xmlns="http://www.w3.org/2000/svg"
                        class="rotate-[0deg]">
                        <g filter="url(#filter0_d_19461_8348)">
                            <path fill-rule="evenodd" clip-rule="evenodd"
                                d="M15.8122 5.34218C16.4517 6.0669 16.3825 7.17278 15.6578 7.81224L8.645 14L15.6578 20.1878C16.3825 20.8273 16.4517 21.9331 15.8122 22.6579C15.1727 23.3826 14.0669 23.4517 13.3421 22.8122L5.26706 15.6872C4.25192 14.7914 4.25192 13.2086 5.26706 12.3129L13.3421 5.1878C14.0669 4.54835 15.1727 4.61747 15.8122 5.34218Z"
                                fill="white"></path>
                        </g>
                        <defs>
                            <filter id="filter0_d_19461_8348" x="0.505707" y="0.75" width="19.7443" height="26.5"
                                filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                                <feFlood flood-opacity="0" result="BackgroundImageFix"></feFlood>
                                <feColorMatrix in="SourceAlpha" type="matrix"
                                    values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha">
                                </feColorMatrix>
                                <feOffset></feOffset>
                                <feGaussianBlur stdDeviation="2"></feGaussianBlur>
                                <feComposite in2="hardAlpha" operator="out"></feComposite>
                                <feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.35 0">
                                </feColorMatrix>
                                <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_19461_8348">
                                </feBlend>
                                <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_19461_8348"
                                    result="shape"></feBlend>
                            </filter>
                        </defs>
                    </svg>
                </div>
            </div>

        </div>
        </div>
        <div>
 <div class="offcanvas offcanvas-start" data-bs-scroll="true" data-bs-backdrop="false" tabindex="-1" id="offcanvasScrolling" aria-labelledby="offcanvasScrollingLabel">
              <div class="offcanvas-header">
                <h5 class="offcanvas-title" id="offcanvasScrollingLabel">Offcanvas with body scrolling</h5>


<!-- * 카카오맵 - 지도퍼가기 -->
<!-- 1. 지도 노드 -->
<div id="daumRoughmapContainer1719757988213" class="root_daum_roughmap root_daum_roughmap_landing"></div>

<!--
	2. 설치 스크립트
	* 지도 퍼가기 서비스를 2개 이상 넣을 경우, 설치 스크립트는 하나만 삽입합니다.
-->
<script charset="UTF-8" class="daum_roughmap_loader_script" src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js"></script>

<!-- 3. 실행 스크립트 -->
<script charset="UTF-8">
	new daum.roughmap.Lander({
		"timestamp" : "1719757988213",
		"key" : "2jv56",
		"mapWidth" : "640",
		"mapHeight" : "360"
	}).render();
</script>




                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
              </div>
              <div class="offcanvas-body">
                <p>Try scrolling the rest of the page to see this option in action.</p>
              </div>
            </div>
            <footer>
                <%@include file="../bottom.jsp" %>
            </footer>
    </main>

    <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
    <script>
        const swiper = new Swiper('.swiper-container', {
            slidesPerView: 5,
            spaceBetween: 12,
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
        });
    </script>

    <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasRight" aria-labelledby="offcanvasRightLabel">
        
        <div class="offcanvas-body">
            <div id="map" style="height:900px;"></div>
        </div>
        <div> 불러온주소  </div>
      </div>
    

      <script>
        const addr = document.getElementById("addr1").textContent; 
		console.log(addr);
      const mapContainer = document.getElementById('map'), // 지도를 표시할 div 
          mapOption = {
              center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
              level: 3 // 지도의 확대 레벨
          };  
      
      // 지도를 생성합니다    
      const map = new kakao.maps.Map(mapContainer, mapOption); 
      
      // 주소-좌표 변환 객체를 생성합니다
      const geocoder = new kakao.maps.services.Geocoder();
      
      // 주소로 좌표를 검색합니다
      geocoder.addressSearch(addr, function(result, status) {
      
          // 정상적으로 검색이 완료됐으면 
           if (status === kakao.maps.services.Status.OK) {
      
              const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
      
              // 결과값으로 받은 위치를 마커로 표시합니다
              const marker = new kakao.maps.Marker({
                  map: map,
                  position: coords
              });
      
              
    
              // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
              map.setCenter(coords);
          } 
      });    
      </script>
     
</body>
</body>
