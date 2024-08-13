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
    
    
<script>
//카테고리 리스트 보이기
function toggleCategoryList() {
    var categoryList = document.getElementById('category-list');
    categoryList.style.display = categoryList.style.display === 'none' ? 'block' : 'none';
}

//서브카테고리 표시
function showSubCategory(id) {
    var subCategory = document.getElementById('sub-' + id);
    if (subCategory) {
        subCategory.style.display = 'block';
    }
}

//
function hideSubCategory(id) {
    var subCategory = document.getElementById('sub-' + id);
    if (subCategory) {
        subCategory.style.display = 'none';
    }
}

function hideAllSubCategories() {
    var subCategories = document.getElementsByClassName('subCategory');
    for (var i = 0; i < subCategories.length; i++) {
        subCategories[i].style.display = 'none';
    }
}

function handleClick(id) {
    console.log('Clicked category ID:', id);
    // 여기에 카테고리 클릭 시 수행할 동작을 추가하세요
}

function searchOnEnter(event) {
    if (event.key === 'Enter') {
        var searchInput = document.getElementById('search-input');
        var searchLink = document.getElementById('searchLink');
        searchLink.href = 'search.do?keyword=' + encodeURIComponent(searchInput.value);
        searchLink.click();
    }
}
</script>
    
    
</head>
<body>
    <div class="container">
    <header>
    <div class="top-1">
        <!-- 로고와 검색바 -->
        <div class="logo"><a href="main.do">NeGO</a></div>
        <div class="search-container">
            <img src="icon/mag.png" class="search-icon">
            <input type="text" onkeydown="searchOnEnter(event)" placeholder="어떤 상품을 찾으시나요?" id="search-input">
            <a id="searchLink" href="#" style="display:none;">Search</a>
        </div>
        <!-- 메뉴 아이콘들 -->
        <div class="menu-icons">
            <ul>
                <li><a href="Login.do"><img src="icon/chat.png"><span>채팅하기</span></a></li>
                <li><a href="Login.do"><img src="icon/addcart.png" alt="판매하기 아이콘"><span>판매하기</span></a></li>
                <li><a href="Login.do"><img src="icon/user.png" alt="마이 아이콘"><span>마이</span></a></li>
            </ul>
        </div>
    </div>
    
    <div class="top-2">
        <!-- 카테고리 버튼 -->
        <div>
            <a href="#" class="category-btn" onclick="toggleCategoryList()">카테고리</a>
        </div>
        <!-- 공지 -->
        <div><a href="gboard.do?member_id=user123">공지</a></div>
        <!-- 문의하기 -->
        <div><a href="mboard.do?member_id=user123">문의하기</a></div>
        <!-- 찜한 상품 -->
        <div>
            <a href="">찜한 상품</a>
        </div>

        <!-- 시세조회 -->
        <div><a href="marketPrice.prod">시세 조회</a></div>
        <div><a href="fraud.fraud">사기 조회</a></div>
        <div><a href="Login.do">출석하기</a></div>
       
        <div class="notice">
            <marquee>고객센터 공지: 새로운 이벤트가 시작되었습니다!</marquee>
        </div>
    </div>

    <div class="category">
        <div id="category-list" style="display:none;">
            <!-- 카테고리 목록 -->
            <ul onmouseout="hideAllSubCategories()">
                <li id="main-1" class="mainCategory" onclick="handleClick('1')" onmouseover="showSubCategory('1')">
                    <a href="#">의류</a>
                </li>
                <li id="main-2" class="mainCategory" onclick="handleClick('2')" onmouseover="showSubCategory('2')">
                    <a href="#">전자기기</a>
                </li>
                <li id="main-3" class="mainCategory" onclick="handleClick('3')" onmouseover="showSubCategory('3')">
                    <a href="#">도서</a>
                </li>
            </ul>
        </div>

        <div id="sub-1" class="subCategory" onmouseover="showSubCategory('1')" onmouseout="hideSubCategory('1')" style="display:none;">
            <div class="subCategoryItem">
                <h3><a href="#" onclick="handleClick('11')">상의</a></h3>
                <ul>
                    <li><a href="#" onclick="handleClick('111')">티셔츠</a></li>
                    <li><a href="#" onclick="handleClick('112')">셔츠</a></li>
                </ul>
            </div>
        </div>
        <!-- 다른 서브 카테고리도 비슷하게 추가 -->
    </div>

</header>

<main>
    <h2>오늘의 상품</h2>
    
    <div id="productList" class="row">
        <a href="spec_prod.prod?pnum=1">
            <div class="card">
                <img src="${pageContext.request.contextPath}/resources/images/product1.jpg" class="card-img-top" alt="제품1">
                <div class="card-body">
                    <h3 class="card-title">아이폰 12</h3>
                    <p class="card-text">가격: 500,000원</p>
                    <p class="card-text">2시간 전</p>
                </div>
            </div>
        </a>
        <!-- 추가 상품들... -->
    </div>

    <br><br>
    <hr class="footer-line">
    <br>

    <h2>인기 상품</h2>
    
    <div id="productList" class="row">
        <a href="spec_prod.prod?pnum=2">
            <div class="card">
                <img src="${pageContext.request.contextPath}/resources/images/product2.jpg" class="card-img-top" alt="제품2">
                <div class="card-body">
                    <h3 class="card-title">나이키 운동화</h3>
                    <p class="card-text">가격: 80,000원</p>
                    <p class="card-text">1일 전</p>
                </div>
            </div>
        </a>
        <!-- 추가 상품들... -->
    </div>

    <br><br>
    <hr class="footer-line">
    <br>

    <h2>방금등록된 상품</h2>
    
    <div id="productList" class="row">
        <a href="spec_prod.prod?pnum=3">
            <div class="card">
                <img src="${pageContext.request.contextPath}/resources/images/product3.jpg" class="card-img-top" alt="제품3">
                <div class="card-body">
                    <h3 class="card-title">맥북 프로</h3>
                    <p class="card-text">가격: 1,500,000원</p>
                    <p class="card-text">방금 전</p>
                </div>
            </div>
        </a>
        <!-- 추가 상품들... -->
    </div>

</main>
  <footer class="footer">
        <hr class="footer-line">
        <div class="footer-content">
            <h4>K G I T B A N K 509호 핀테크반</h4>
            <h4>NeGO, 중고거래 플랫폼</h4>
            <p>조장 : 김효준</p>
            <p>팀원 : 강희승, 김영일, 김우진, 이현민, 황선웅</p>
        </div>
    </footer>
    </div>


</body>
</html>