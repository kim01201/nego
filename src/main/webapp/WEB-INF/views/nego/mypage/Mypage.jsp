<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>검색결과</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 마이페이지 스타일 -->
    <link rel="stylesheet" type="text/css" href="resources/css/mypage/mypageStyles.css">
    
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    
    <script>
    $(document).ready(function() {
        $('.alink').on('click', function(e) {
            e.preventDefault();
            var url = $(this).attr('href');
            $('.main-content').load(url, function(response, status, xhr) {
                if (status == "error") {
                    var msg = "Sorry but there was an error: ";
                    $('#main-content').html(msg + xhr.status + " " + xhr.statusText);
                }
            });
        });
    });
    
 // 이벤트 리스너 설정
	document.addEventListener('DOMContentLoaded', function() {
	const sortButtons = document.querySelectorAll('.sort-result div');
	console.log("버튼 : ",sortButtons);
		sortButtons.forEach(button => {
		    button.addEventListener('click', function() {
		        const sortMode = this.dataset.sort;
		        console.log("sortMode: ", sortMode);
		        sortOrder = sortMode;
		        fetchProducts();
		    });
		});
	});
 
	var sortOrder = "NEWEST_SORT";
	
	async function fetchProducts(minPrice, maxPrice) {
	    try {
	        const params = new URLSearchParams();
			
	        params.append('member_id',"${sessionScope.mbId.id}");
	        
	        if (sortOrder) {
	        	params.append('sort', sortOrder);
	        }
			
	        console.log("params:",params)
	
	        const queryString = params.toString();
	        const url = 'myPageInfo.do?' + queryString; // URL 직접 구성
	
	        console.log("Request URL:", url);
	
	        const response = await fetch(url);
	       	console.log("반응",response);
	        if (!response.ok) {
	            throw new Error(`HTTP error! Status: ${response.status}`);
	        }
	
	        const contentType = response.headers.get('content-type');
	        console.log("반환",contentType);
	        
	        if (contentType && contentType.includes('application/json')) {
	            const products = await response.json(); // JSON 형식으로 변환
	            console.log("Products:", products);
	            renderProducts(products); // 받은 상품 데이터를 화면에 출력하는 함수 호출
	        } else {
	            throw new Error('서버가 JSON을 반환하지 않았습니다.');
	        }
	    } catch (error) {
	        console.error('Error fetching products:', error);
	    }
	}
	
	function renderProducts(products) {
	    const productList = document.getElementById('productList');
	    productList.innerHTML = ''; // 기존 내용 초기화

	    if (products.idProd.length == 0) {
	        // 상품이 없을 경우 메시지 추가
	        productList.innerHTML = '<p>현재 등록된 상품이 없습니다.</p>';
	    } else {
	        // 상품 리스트 HTML 문자열 초기화
	        let productListHTML = '<div class="row">';

	        products.idProd.forEach(product => {
	            console.log("product", product);
	            if (product.member_id == "${sessionScope.mbId.id}") {
	                productListHTML += 
	                    '<a href="spec_prod_user.prod?pnum=' + product.pnum + '" class="col-md-4">' +
	                        '<div class="card mb-4 ' + (product.pstatus == '판매완료' ? 'sold-out' : '') + '">' +
	                            '<div class="card-img-wrapper">' +
	                                '<img src="${pageContext.request.contextPath}/resources/images/' + product.pimage + '" class="card-img-top" alt="' + product.pname + '">' +
	                                (product.pstatus == '판매완료' ? '<div class="sold-out-overlay"><span>판매완료</span></div>' : '') +
	                            '</div>' +
	                            '<div class="card-body">' +
	                                '<h3 class="card-title">' + product.pname + '</h3>' +
	                                '<p class="card-text">가격: ' + product.price + '원</p>' +
	                                '<p class="card-text">' + product.hours_difference + '</p>' +
	                            '</div>' +
	                        '</div>' +
	                    '</a>';
	            }
	        });

	        productListHTML += '</div>';

	        // productList에 HTML 추가
	        productList.innerHTML = productListHTML;
	    }
	}
    </script>
    
</head>
<body>
<main>

<header>
    <%@include file="../Header.jsp" %>
</header>

<div class="container1">
    <div class="sidebar">
        <div class="section"> 
            <h2><a href="mypage.do?member_id=${sessionScope.mbId.id}">마이 페이지</a></h2>
        </div>
        <div class="section">
            <h2>거래 정보</h2>
            <ul>
                <li><a class="alink" href="sendBuyer.prod?buyer_id=${sessionScope.mbId.id}">구매승인대기</a></li>
                <li><a class="alink" href="sendSeller.prod?seller_id=${sessionScope.mbId.id}">판매승인하기</a></li>
                <li><a class="alink" href="sellerCompleted.prod?seller_id=${sessionScope.mbId.id}">판매내역</a></li>
                <li><a class="alink" href="buyCompleted.prod?buyer_id=${sessionScope.mbId.id}">구매내역</a></li>
                <li><a class="alink" href="delivery.do">택배내역</a></li>
                <li>
                	<form id="myWishForm" action="myWish.do" method="post">
            			<input type="hidden" name="member_id" value="${sessionScope.mbId.id}">
            			<a href="#" onclick="document.getElementById('myWishForm').submit(); return false;">찜한 상품</a>
        			</form>
        		</li>
            </ul>
        </div>
        <div class="section">
            <h2>내 정보</h2>
            <ul>
            	<li><a class="alink" href="member_update_user.do?no=${sessionScope.mbId.id}">내 정보 수정</a></li>
                <li><a class="alink" href="Address.do?member_id=${sessionScope.mbId.id}">배송지 관리</a></li>
                <li><a href="allReviews.do?sender_id=${sessionScope.mbId.id}&receiver_id=${sessionScope.mbId.id}">거래 후기</a></li>
                <li><a class="alink" href="userout.do">탈퇴하기</a></li>
            </ul>
        </div>
    </div>
    <div class="main-content">
        <div class="header">
            <h1>NeGo, 중고거래 플랫폼</h1>
        </div>
        <div class="content">
	        <h2>${member.name}</h2>
	        <span>응답률 100% | 보통 10분 이내 응답</span>
	
	        <div style="width: 100%; max-width: 600px;">
	            <label for="progress"><span>신뢰지수 ${member.trust_score}/1000</span></label>
	            <progress value="${member.trust_score}" max="1000" class="progress" id="progress"></progress>
	        </div>
	    </div>
        <div class="content">
            <h2>NeGo</h2>
            <p>멤버가 되셔서 거래 사기를 예방하세요.</p>
            <div class="info-box">
                <div>
                    <p>전체</p>
                    <c:choose>
                        <c:when test="${empty idProd}">
                            <p>총 0개</p>
                        </c:when>
                        <c:when test="${not empty idProd}">
                            <p>총 ${fn:length(idProd)}개</p>
                        </c:when>
                    </c:choose>
                </div>
                <div>
                    <p>판매중</p>
                    <c:choose>
                        <c:when test="${empty idProd_sell}">
                            <p>총 0개</p>
                        </c:when>
                        <c:when test="${not empty idProd_sell}">
                            <p>총 ${fn:length(idProd_sell)}개</p>
                        </c:when>
                    </c:choose>
                </div>
                <div>
                    <p>판매완료</p>
                    <c:choose>
                        <c:when test="${empty idProd_complete}">
                            <p>총 0개</p>
                        </c:when>
                        <c:when test="${not empty idProd_complete}">
                            <p>총 ${fn:length(idProd_complete)}개</p>
                        </c:when>
                    </c:choose>
                </div>
            </div>
            
            <br>
            <div class="line"></div>
            <br>
            
            <div>
                <h3>내 상품</h3>
                <div class="sort">
                    <div class="sort-result">
	                	<div data-sort="NEWEST_SORT">최신순</div>
	                	<div data-sort="PRICE_ASC_SORT">낮은가격순</div>
	                	<div data-sort="PRICE_DESC_SORT">높은가격순</div>
            		</div>
                </div>
                
                <c:if test="${empty idProd}">
                    <p>현재 등록된 상품이 없습니다.</p>
                </c:if>

                <c:if test="${not empty idProd}">
                <div id="productList" class="row">
                    <c:forEach var="product" items="${idProd}">
                        <c:if test="${product.member_id == sessionScope.mbId.id}">
                        <a href="spec_prod_user.prod?pnum=${product.pnum}" class="col-md-4">
                            <div class="card mb-4">
								<div class="card-img-wrapper ${product.pstatus == '판매완료' ? 'sold-out' : ''}">
                					<img src="${pageContext.request.contextPath}/resources/images/${product.pimage}" class="card-img-top" alt="${product.pname}">
                					<c:if test="${product.pstatus == '판매완료'}">
                    					<div class="sold-out-overlay">
                        					<span>판매완료</span>
                    					</div>
                					</c:if>
                
            				</div>
                              	<div class="card-body">
                                    <h3 class="card-title">${product.pname}</h3>
                                    <p class="card-text">가격: ${product.price}원</p>
                                    <p class="card-text">${product.hours_difference}</p>
                                </div>
                            </div>
                        </a>
                        </c:if>
                    </c:forEach>
                </div>
                </c:if>
            </div>
        </div>
        <div class="footer">
            <p>NeGo@nego.com</p>
        </div>
    </div>
</div>
<footer>
    <%@include file="../bottom.jsp" %>
</footer>
</main>
</body>
</html>
