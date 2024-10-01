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
    <link rel="stylesheet" href="resources/css/mypage/mypageStyles.css">
    
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <title>유저페이지</title>
    <script>
    function loadProducts(type) {
        var memberId = '${member.id}'; // 서버에서 전달된 member_id 사용
        fetch('getProducts?type=' + type + '&memberId=' + memberId)
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(function(data) {
                var productList = document.getElementById('productList');
                productList.innerHTML = ''; // 기존 내용을 초기화

                if (data.length > 0) {
                    data.forEach(function(product) {
                        var productDiv = document.createElement('div');
                        productDiv.className = 'product-item';
                        console.log(""+product.pnum+product.pname+product.price);
                        if(type=='판매완료') {
                        	productDiv.innerHTML = '<a href="spec_prod.prod?pnum=' + product.pnum + '" class="col-md-4">' +
                            '<div class="card">' +
                                '<div class="card-img-wrapper ${product.pstatus == "판매완료"}">' +
                                    '<img src="${pageContext.request.contextPath}/resources/images/' + product.pimage + '" class="card-img-top" alt="' + product.pname + '">' +
                                	'<div class="sold-out-overlay">'+
                        					'<span>판매완료</span>'+
                    				'</div>'+
                                '</div>' +
                                '<div class="card-body">' +
                                    '<h3 class="card-title">' + product.pname + '</h3>' +
                                    '<p class="card-text">가격: ' + product.price + '원</p>' +
                                    '<p class="card-text">' + product.hours_difference + '</p>' +
                                '</div>' +
                            '</div>' +
                        '</a>';
                        }else if(type=='거래중') {
                        	productDiv.innerHTML = '<a href="spec_prod.prod?pnum=' + product.pnum + '" class="col-md-4">' +
                            '<div class="card">' +
                                '<div class="card-img-wrapper ${product.pstatus == "거래중"}">' +
                                    '<img src="${pageContext.request.contextPath}/resources/images/' + product.pimage + '" class="card-img-top" alt="' + product.pname + '">' +
                                	'<div class="sold-out-overlay">'+
                        					'<span>거래중</span>'+
                    				'</div>'+
                                '</div>' +
                                '<div class="card-body">' +
                                    '<h3 class="card-title">' + product.pname + '</h3>' +
                                    '<p class="card-text">가격: ' + product.price + '원</p>' +
                                    '<p class="card-text">' + product.hours_difference + '</p>' +
                                '</div>' +
                            '</div>' +
                        '</a>';
                        }else{
                        	productDiv.innerHTML = '<a href="spec_prod.prod?pnum=' + product.pnum + '" class="col-md-4">' +
                            '<div class="card">' +
                                '<div class="card-img-wrapper">' +
                                    '<img src="${pageContext.request.contextPath}/resources/images/' + product.pimage + '" class="card-img-top" alt="' + product.pname + '">' +
                                '</div>' +
                                '<div class="card-body">' +
                                    '<h3 class="card-title">' + product.pname + '</h3>' +
                                    '<p class="card-text">가격: ' + product.price + '원</p>' +
                                    '<p class="card-text">' + product.hours_difference + '</p>' +
                                '</div>' +
                            '</div>' +
                        '</a>';
                        }
                        
                        productList.appendChild(productDiv);
                    });
                } else {
                    productList.innerHTML = '<p>해당 항목에 대한 상품이 없습니다.</p>';
                }
            })
            .catch(function(error) {
                console.error('Error fetching data:', error);
                // 오류 발생 시 사용자에게 알리는 코드 추가
                var productList = document.getElementById('productList');
                productList.innerHTML = '<p>상품을 가져오는 중 오류가 발생했습니다.</p>';
            });
    }

    // 페이지 로드 후 기본적으로 전체 상품 로드
   
    document.addEventListener('DOMContentLoaded', function() {
        const navLinks = document.querySelectorAll('nav a');
        const navUnderline = document.querySelector('.nav-underline');
        window.onload = function() {
            loadProducts('전체');
        };


        navLinks.forEach(function(link) {
            link.addEventListener('click', function(e) {
                e.preventDefault();

                // 기존 is-current 클래스 제거
                navLinks.forEach(function(navLink) {
                    navLink.classList.remove('is-current');
                });

                // 클릭된 탭에 is-current 클래스 추가
                this.classList.add('is-current');

                // 언더바 위치를 클릭된 탭 아래로 이동
                const navRect = this.getBoundingClientRect(); // 클릭된 탭의 위치 정보
                const navUnderlineWidth = navUnderline.offsetWidth; // 언더바의 너비

                // 언더바 위치 설정
                navUnderline.style.left = `${navRect.left}px`; // 클릭된 탭의 왼쪽 위치로 설정
                navUnderline.style.width = `${navRect.width}px`; // 클릭된 탭의 너비로 설정
            });
        });
    });

</script>

</head>
<body>
<main>
<header>
    <%@include file="../Header.jsp" %>
</header>
<div class="container2">
    <div class="content">
        <h2>${member.name}</h2>
        <span>응답률 100% | 보통 10분 이내 응답</span>

        <div style="width: 100%; max-width: 600px; margin: 0 auto;">
            <label for="progress"><span>신뢰지수 ${member.trust_score}/1000</span></label>
            <progress value="${member.trust_score}" max="1000" class="progress" id="progress"></progress>
        </div>
    </div>

    <div class="content">
        <div class="content">
            <div class="info-box1">
                <div>
                    <b>안전거래</b>
                    <p>0</p>
                </div>
                <div onclick="openReviewsPopup()">
                    <u><strong>거래후기</strong></u>
                    <p>${rCount}</p>
                </div>
                <div>
                    <b>단골</b>
                    <p>0</p>
                </div>
            </div>
            <br>
        </div>
    </div>
</div>


<div class="container3">
    <h2>판매상품</h2>
    <nav id="nav">
        <a href="javascript:void(0);" onclick="loadProducts('전체')" class="is-current">전체</a>
        <a href="javascript:void(0);" onclick="loadProducts('판매중')">판매중</a>
        <a href="javascript:void(0);" onclick="loadProducts('거래중')">거래중</a>
        <a href="javascript:void(0);" onclick="loadProducts('판매완료')">판매완료</a>
        <div class="nav-underline"></div>
    </nav>

    <div id="productList" class="d-flex" ></div>
</div>


<div id="reviews" class="popup">
	<div class="popup-content">
		<span id="closePopupBtn" class="close-btn" onclick="closeReviewsPopup()">&times;</span>
        <div id="userReviews"></div>
         <%@include file="../reviews/userReviews.jsp"%>
    </div>
</div>
<div id="overlay" class="overlay" onclick="closeReviewsPopup()"></div>


<footer>
    <%@include file="../bottom.jsp" %>
</footer>
</main>
</body>
</html>
