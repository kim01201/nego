<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<link rel="stylesheet" href="main.css">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>중고 거래 플랫폼</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <div class="logo">중고 거래 플랫폼</div>
        <div class="search-bar">
            <input type="text" placeholder="검색어를 입력하세요">
            <button>검색</button>
        </div>
        <div class="user-options">
            <button>로그인</button>
            <button>회원가입</button>
        </div>
    </header>
    
    <main>
        <section class="main-banner">
            <img src="banner.jpg" alt="메인 배너">
        </section>
        
        <section class="categories">
            <h2>인기 카테고리</h2>
            <div class="category-list">
                <div class="category-item">전자제품</div>
                <div class="category-item">패션</div>
                <div class="category-item">가구</div>
                <div class="category-item">도서</div>
            </div>
        </section>
        
        <section class="product-list">
            <h2>최신 상품</h2>
            <div class="products">
                <div class="product-item">
                    <img src="product1.jpg" alt="상품1">
                    <p>상품명 1</p>
                    <p>₩10,000</p>
                </div>
                <div class="product-item">
                    <img src="product2.jpg" alt="상품2">
                    <p>상품명 2</p>
                    <p>₩20,000</p>
                </div>
                <!-- 더 많은 상품들 -->
            </div>
        </section>
    </main>
    
    <footer>
        <p>회사 정보 | 이용약관 | 개인정보처리방침 | 고객센터</p>
    </footer>
</body>
</html>
