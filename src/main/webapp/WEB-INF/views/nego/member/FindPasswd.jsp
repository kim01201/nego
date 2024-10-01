<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" type="text/css" href="resources/css/member/findPassword.css">
</head>
<body>
<main>
    <header>
        <%@include file="../Header.jsp" %>
    </header>

    <div class="container1">
        <h2>비밀번호 찾기</h2>
        <form action="findPasswordResult.do" method="post">
            <div class="form-group">
                <label for="id">아이디:</label>
                <input type="text" id="id" name="id" required>
            </div>
            <div class="form-group">
                <label for="email">이메일:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group" align="center">
                <button type="submit">비밀번호 찾기</button>
            </div>
        </form>
    </div>

    <footer>
        <%@include file="../bottom.jsp" %>
    </footer>
</main>
</body>
</html>
