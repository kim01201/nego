<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NeGO 로그인 페이지</title>
    <link rel="stylesheet" href="resources/css/member/NeGOLogin_styles.css">
    <script type="text/javascript">
        function checkMember() {
            window.open("memberSsn.do", "check", "width=640, height=400");
        }
        function searchMember(mode) {
            window.open("searchMember.do?mode=" + mode, "search", "width=650, height=400");
        }
        function loginCheck() {
            var f = document.forms["loginForm"];
            if (f.id.value == "") {
                alert("아이디를 입력해 주세요!!");
                f.id.focus();
                return false;
            }
            if (f.passwd.value == "") {
                alert("비밀번호를 입력해 주세요!!");
                f.passwd.focus();
                return false;
            }
            
            if (document.getElementById("remember-id").checked) {
                document.cookie = "savedId=" + f.id.value + "; path=/; max-age=" + (60*60*24*30);
            } else {
                document.cookie = "savedId=; path=/; max-age=0";
            }
            
            return true;
        }
        function getCookie(name) {
            let cookieArr = document.cookie.split(";");
            for (let i = 0; i < cookieArr.length; i++) {
                let cookiePair = cookieArr[i].split("=");
                if (name == cookiePair[0].trim()) {
                    return decodeURIComponent(cookiePair[1]);
                }
            }
            return null;
        }
        window.onload = function() {
            var savedId = getCookie("savedId");
            if (savedId) {
                document.getElementById("id").value = savedId;
                document.getElementById("remember-id").checked = true;
            }
        }
    </script>
</head>
<body>
<main>
    <header>
        <%@include file="../Header.jsp" %>
    </header>

    <div class="login-container">
        <h1>NeGO, 중고거래의 시작!</h1>
        <form name="loginForm" action="login_ok.do" method="post" onsubmit="return loginCheck();">
            <label for="id">아이디</label>
            <input type="text" id="id" name="id">
            <label for="passwd">비밀번호</label>
            <input type="password" id="passwd" name="passwd">
            <button type="submit">LOGIN</button>
            
            <div class="options">
                <input type="checkbox" id="remember-id" name="saveId">
                <label for="remember-id">아이디 기억하기</label>
            </div>
            <div class="links">
                <a href="NeGOmember_Input.do">회원가입</a>
                <a href="FindId.do">아이디 찾기</a>
                <a href="FindPasswd.do">비밀번호 찾기</a>
            </div>
        </form>
    </div>
    
    <footer>
        <%@include file="../bottom.jsp" %>
    </footer>
</main>
</body>
</html>
