<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <link rel="stylesheet" type="text/css" href="resources/css/member/findId.css">
    <script>
    function sendVerificationCode() {
        var email = document.getElementById('email').value;
        var name = document.getElementById('name').value;
        
        if (email && name) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "mail.do", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    alert('인증번호가 ' + email + '로 전송되었습니다.');
                }
            };
            xhr.send("email=" + encodeURIComponent(email) + "&name=" + encodeURIComponent(name));
        } else {
            alert('이메일 주소를 입력하세요.');
        }
    }
    </script>
</head>
<body>
<main>
    <header>
        <%@include file="../Header.jsp" %>
    </header>
    
    <div class="container1">
        <h2>아이디 찾기</h2>
        <form action="findIdResult.do" method="post">
            <div class="form-group">
                <label for="name">이름</label>
                <input type="text" id="name" name="name" required>
            </div>
            <br>
            <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" required>
                <br>
                <button type="button" onclick="sendVerificationCode()">인증번호 받기</button>
            </div>

            <div class="form-group">
                <label for="verificationCode">인증번호</label>
                <input type="text" id="verificationCode" name="verificationCode" required>
            </div>

            <div class="form-group" align="center">
                <button type="submit">아이디 찾기</button>
            </div>
        </form>
    </div>

    <footer>
        <%@include file="../bottom.jsp" %>
    </footer>
</main>
</body>
</html>
