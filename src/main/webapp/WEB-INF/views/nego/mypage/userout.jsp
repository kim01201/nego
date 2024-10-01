<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 탈퇴</title>
    <link rel="stylesheet" type="text/css" href="resources/css/mypage/userout_styles.css">
</head>
<body>

    <div align="center">
        <h2>회원 탈퇴</h2>
        <% if (request.getParameter("error") != null) { %>
            <p style="color:red;">아이디 또는 비밀번호가 일치하지 않습니다.</p>
        <% } %>
        <form action="withdrawalAction.do" method="post">
            <p>정말로 회원 탈퇴를 하시겠습니까?</p>
            <div class="form-group">
                <label for="Id">아이디 확인:</label>
                <input type="text" class="input" id="Id" name="Id" required>
            </div>
            <div class="form-group">
                <label for="passwd">비밀번호 확인:</label>
                <input type="password" id="passwd" name="passwd" required>
            </div>
            <div class="buttons">
                <input type="submit" class="white-btn" value="탈퇴하기">
                <a href="javascript:history.back()" class="black-btn">취소</a>
            </div>
        </form>
    </div>

</body>
</html>
