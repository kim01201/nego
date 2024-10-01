<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>main</title>
<link rel="stylesheet" type="text/css" href="resources/css/mainStyle.css">
</head>
<body>
	<main>
		<header>
			<%@include file="Header.jsp"%>	
		</header>
		
		<div class="">
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
		</div>
		
		<br><br>
		<hr class="footer-line">
		<br>
		
		<div class="">
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

			
		</div>
		
		<br><br>
		<hr class="footer-line">
		<br>
		
		<div class="">
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


		</div>

		<br>
		
		<footer>
        	<%@include file="bottom.jsp" %>
    	</footer>
	</main>
</body>
</html>