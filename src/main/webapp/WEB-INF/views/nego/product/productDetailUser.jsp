<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="resources/css/product/default.css">
    <link rel="stylesheet" href="resources/css/product/detail.css">
    <!-- swiper cdn -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <!-- 부트스트랩 자바스크립트 링크  -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
        crossorigin="anonymous"></script>
    <title>검색결과</title>
    <script>
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
    	<script>
    		function editProd(pnum) {
    			if(confirm("상품을 수정하시겠습니까?")) {
    	            window.location.href = "${pageContext.request.contextPath}/edit_prod.prod?pnum=" + pnum;
    	        } else {
    	            alert("상품 수정 요청하는 도중 오류가 발생했습니다. 관리자에게 문의하세요.");
    	        }
    		}
    		
    		function deleteProd(pnum, member_id) {
    		    if (confirm("정말로 해당 상품을 삭제하겠습니까?")) {
    		        window.location.href="${pageContext.request.contextPath}/delete_prod.prod?pnum=" + pnum;
    		        alert("삭제 성공했습니다.");
    		    } else {
    		        alert("삭제가 취소되었습니다.");
    		    }
    		}



    	</script>
    </header>
	<div class="main-content">
        <div class="items-start grid grid-cols-2 first-wrap">
            <div class="carou">
                <div id="carouselExampleInterval" class="carousel slide" data-bs-ride="carousel">
                    <div class="carousel-inner">
                        <div class="carousel-item active" data-bs-interval="10000">
                            <img src="${pageContext.request.contextPath}/resources/images/${specProd.pimage}" class="d-block w-100" alt="${specProd.pname}">
                                
                        </div>
                        <div class="carousel-item" data-bs-interval="2000">
                            <img src="https://m.firenzeatelier.com/web/product/medium/202312/95fdb8105b63f067bc4fd149ee86eec2.jpg"
                                class="d-block w-100" alt="...">
                        </div>
                        <div class="carousel-item">
                            <img src="https://m.firenzeatelier.com/web/product/medium/202312/95fdb8105b63f067bc4fd149ee86eec2.jpg"
                                class="d-block w-100" alt="...">
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
                            class="text-jnGray-500 leading-[15px]">2024-03-22 · 조회 ${specProd.preadcount} · 찜 ${specProd.plike}</span>
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
                                class="block text-sm font-semibold  mt-1 ">직거래,택배</button>
                        </li>
                        <li class="flex flex-col flex-1 px-3 relative justify-center items-center">
                            <span class="text-xs font-normal ">배송비</span>
                            <button disabled style="cursor:auto" class="block text-sm font-semibold  mt-1 ">별도</button>
                        </li>
                        <li class="flex flex-col flex-1  px-3 relative justify-center items-center">
                            <span class="text-xs font-normal  ">안전거래</span>
                            <button disabled style="cursor:auto" class="block text-sm font-semibold mt-1 ">사용</button>
                        </li>
                    </ul>

                    <!-- 거래방식 및 결제혜택 -->
                    <ul>

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
                    <div class="box-border flex text-center border rounded items-center py-6 mb-6 border-gray-300">
                        <button class="flex flex-col flex-1 px-3 relative justify-center items-center" onclick="editProd(${specProd.pnum})">
                        	<img src="resources/icon/edit.png" width="30px" height="30px">
                        	<span>상품 수정</span>
                        </button>
                        <button href="#" id="chatButton" onclick="openChatPopup()">
                        	<img src="resources/icon/chat1.png" width="25px" height="25px">
                        	<span>채팅하기</span>
                        </button>
                            
                            <!-- 채팅 팝업 -->
							<div id="popup" class="popup">
							    <div class="popup-content">
							        <span id="closePopupBtn" class="close-btn" onclick="closeChatPopup()">&times;</span>
							        <%@ include file="../chat/chatPage.jsp" %>	<!-- 이부분 제거하면 디테일에서 채팅하기 먹통 -->
							         
							    </div>
							</div>
							<div id="overlay" class="overlay" onclick="closeChatPopup()"></div>
                        <button class="flex flex-col flex-1 px-3 relative justify-center items-center" onclick="deleteProd(${specProd.pnum},'${sessionScope.mbId.id}')">
                        	<img src="resources/icon/delete.png" width="25px" height="25px">
                        	<span>상품 삭제</span>
                        </button>
                        </div>
                    </div>
                    
					<div class="flex mb-12 second-wrap">
            			<div class="prod-info">
                			<h3>상품정보</h3>
                			<hr>

                    			<div class="prod-description">${specProd.pdescription}</div>

                    	</div>
                    </div>
                </div>
            </div>

        </div>
        
		<footer>
        	<%@include file="../bottom.jsp" %>
    	</footer>
    </main>

</body>
