<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>찜 목록</title>
    <link rel="stylesheet" type="text/css" href="resources/css/header/wish/wishList.css">
</head>
<body>
    <main>
        <header>
            <%@include file="../../Header.jsp"%>	
        </header>

        <div class="container1">
            <div class="content-center">
                <h2><b>찜한 상품</b></h2>
				
				<br><hr><br>
				
                <form class="search-form" name="f" action="find_myWish.do" method="post">
                    <label for="product_name">상품 검색 :</label>
                    <input type="text" name="product_name" id="product_name" placeholder="상품 이름을 입력하세요">
                    <input type="hidden" name="member_id" value="${sessionScope.mbId.id}">
                    <input type="submit" value="검색">
                </form>
                
                
				<c:choose>
    				<c:when test="${not empty myWish}">
        				<c:set var="mergedList" value="${myWish}" />
    				</c:when>
    				<c:when test="${not empty find_myWish}">
        				<c:set var="mergedList" value="${find_myWish}" />
    				</c:when>
    				<c:when test="${empty myWish}">
						<p>등록된 찜목록이 없습니다.</p>
					</c:when>
				</c:choose>
				
                <div id="productList" class="product-grid">
                    <c:forEach var="product" items="${mergedList}">
                    <a href="spec_prod.prod?pnum=${product.product_id}">
                        <div class="card">
                            <img src="${pageContext.request.contextPath}/resources/images/${product.product_image}" class="card-img-top" alt="${product.product_id}">
                            <div class="card-body">
                                <h3 class="card-title">${product.product_name}</h3>
                                <p class="card-text">가격: ${product.product_price}원</p>
                            </div>
                        </div>
                    </a>
                    </c:forEach>
                </div>
            </div>
        </div>

        <footer>
            <%@include file="../../bottom.jsp" %>
        </footer>
    </main>
</body>
</html>
