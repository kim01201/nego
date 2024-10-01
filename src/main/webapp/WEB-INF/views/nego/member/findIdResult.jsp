<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기 결과</title>
    <link rel="stylesheet" type="text/css" href="resources/css/member/findIdResult.css">
    <script>
    	function goToLogin() {
    	    window.location.href = 'Login.do';
    	}
    </script>
</head>
<body>
<main>
    <header>
        <%@include file="../Header.jsp" %>
    </header>
    <div class="container1">
        <h2>아이디 찾기 결과</h2>
        
        <%-- 이메일로 아이디를 찾습니다. --%>
        <% String foundUsername = (String) request.getAttribute("foundUsername"); %>
        
        <%-- 아이디를 찾은 경우 아이디를 표시합니다. --%>
        <% if (foundUsername != null) { %>
            <p>입력하신 이름과 이메일로 등록된 아이디는 <strong><%= foundUsername %></strong>입니다.</p>
        <% } else { %>
            <p>입력하신 이름과 이메일로 등록된 아이디를 찾을 수 없습니다.</p>
        <% } %>
        
        <button class="btn btn-primary" onclick="goToLogin()">로그인으로</button>
    </div>

    <footer>
        <%@include file="../bottom.jsp" %>
    </footer>
</main>
</body>
</html>
