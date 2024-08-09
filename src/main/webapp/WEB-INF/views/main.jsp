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
        <div><a href="gboard.do?member_id=${sessionScope.mbId.id}">공지</a></div>
        <!-- 문의하기 -->
        <div><a href="mboard.do?member_id=${sessionScope.mbId.id}">문의하기</a></div>
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

</header>



<main>
			<h2>오늘의 상품</h2>
			
			<div id="productList" class="row">
			    <c:set var="displayCount" value="0" scope="page" />
			    <c:forEach var="product" items="${randomProd}" varStatus="loop">
			        <c:choose>
			            <c:when test="${product.pstatus != '판매완료' && displayCount < 5}">
			                <c:set var="displayCount" value="${displayCount + 1}" scope="page" />
			                 <c:choose>
						    	<c:when test="${sessionScope.mbId.id==product.member_id}">
						    		<a href="spec_prod_user.prod?pnum=${product.pnum}">
						    	</c:when>
						    	<c:otherwise>
						    		<a href="spec_prod.prod?pnum=${product.pnum}">
						    	</c:otherwise>
						    </c:choose>
			                    <div class="card">
			                        <img src="${pageContext.request.contextPath}/resources/images/${product.pimage}" class="card-img-top" alt="${product.pname}">
			                        <div class="card-body">
			                            <h3 class="card-title">${product.pname}</h3>
			                            <p class="card-text">가격: ${product.price}원</p>
			                            <p class="card-text">${product.hours_difference}</p>
			                        </div>
			                    </div>
			                </a>
			            </c:when>
			        </c:choose>
			    </c:forEach>
			</div>
		
		
		<br><br>
		<hr class="footer-line">
		<br>
		
		
		<h2>인기 상품</h2>
			
			<div id="productList" class="row">
			    <c:set var="displayCount" value="0" scope="page" />
			    <c:forEach var="product" items="${readCountProd}" varStatus="loop">
			        <c:choose>
			            <c:when test="${product.pstatus != '판매완료' && displayCount < 5}">
			                <c:set var="displayCount" value="${displayCount + 1}" scope="page" />
			                 <c:choose>
						    	<c:when test="${sessionScope.mbId.id==product.member_id}">
						    		<a href="spec_prod_user.prod?pnum=${product.pnum}">
						    	</c:when>
						    	<c:otherwise>
						    		<a href="spec_prod.prod?pnum=${product.pnum}">
						    	</c:otherwise>
						    </c:choose>
			                    <div class="card">
			                        <img src="${pageContext.request.contextPath}/resources/images/${product.pimage}" class="card-img-top" alt="${product.pname}">
			                        <div class="card-body">
			                            <h3 class="card-title">${product.pname}</h3>
			                            <p class="card-text">가격: ${product.price}원</p>
			                            <p class="card-text">${product.hours_difference}</p>
			                        </div>
			                    </div>
			                </a>
			            </c:when>
			        </c:choose>
			    </c:forEach>
			</div>

			

		
		<br><br>
		<hr class="footer-line">
		<br>
		

		<h2>방금등록된 상품</h2>
			
			<div id="productList" class="row">
			    <c:set var="displayCount" value="0" scope="page" />
			    <c:forEach var="product" items="${dateProd}" varStatus="loop">
			        <c:choose>
			            <c:when test="${product.pstatus != '판매완료' && displayCount < 5}">
			                <c:set var="displayCount" value="${displayCount + 1}" scope="page" />
			                 <c:choose>
						    	<c:when test="${sessionScope.mbId.id==product.member_id}">
						    		<a href="spec_prod_user.prod?pnum=${product.pnum}">
						    	</c:when>
						    	<c:otherwise>
						    		<a href="spec_prod.prod?pnum=${product.pnum}">
						    	</c:otherwise>
						    </c:choose>
			                    <div class="card">
			                        <img src="${pageContext.request.contextPath}/resources/images/${product.pimage}" class="card-img-top" alt="${product.pname}">
			                        <div class="card-body">
			                            <h3 class="card-title">${product.pname}</h3>
			                            <p class="card-text">가격: ${product.price}원</p>
			                            <p class="card-text">${product.hours_difference}</p>
			                        </div>
			                    </div>
			                </a>
			            </c:when>
			        </c:choose>
			    </c:forEach>
			</div>
	
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
    </main>
    

</body>
    

</html>
