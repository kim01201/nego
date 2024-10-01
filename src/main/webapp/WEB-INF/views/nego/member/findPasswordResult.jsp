<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기 결과</title>
    <link rel="stylesheet" type="text/css" href="resources/css/member/findPasswordResult.css">
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
    
    <div class="foundPw">
        <h2>비밀번호 찾기 결과</h2>
        <br><br>
        <%-- Java 코드를 제거하고 컨트롤러에서 가져온 foundId 값을 사용합니다. --%>
        <%
            String foundPasswd = (String) request.getAttribute("foundPasswd");
        %>
        
        <%-- 아이디를 찾은 경우 아이디를 표시합니다. --%>
        <% if (foundPasswd != null) { %>
            <p>입력하신 이메일로 등록된 비밀번호는 <strong class="found-passwd"><%= foundPasswd %></strong>입니다.</p>
        <% } else { %>
            <p>입력하신 이메일로 등록된 계정을 찾을 수 없습니다.</p>
        <% } %>
        
        <button onclick="goToLogin()">닫기</button>
    </div>

    <footer>
        <%@include file="../bottom.jsp" %>
    </footer>
</main>
</body>
</html>
