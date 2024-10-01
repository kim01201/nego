<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품확인</title>
    <link rel="stylesheet" type="text/css" href="resources/css/product/prodCheck_styles.css">
</head>
<body>
<main>
<header>
    <%@include file="../Header.jsp" %>
</header>
    <div class="container1">
    
    	<img src="resources/icon/fail.png" alt="판매하기 아이콘">
        <h2>상품등록실패</h2>
        
        <div class="form-group">
			<button onclick="location.href='insert_prod.prod?member_id=${sessionScope.mbId.id}'">
                	상품 다시 등록
            </button>
        </div>

    </div>
        <footer>
        <%@include file="../bottom.jsp" %>
    </footer>
    </main>
</body>
</html>
