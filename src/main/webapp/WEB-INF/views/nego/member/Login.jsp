
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>NeGo Login</title>
    <link rel="stylesheet" type="text/css" href="resources/css/member/Login_styles.css">
</head>
<body>
<main>
    <header>
        <%@include file="../Header.jsp" %>
    </header>

    <div class="container1">
        <h1>NeGO</h1>
        <p>중고거래 플랫폼</p>
        <div class="login-buttons">
            <button class="naver button">
               <a href="${url}"> <img height="50" src="http://static.nid.naver.com/oauth/small_g_in.PNG" alt="네이버 로그인"/></a> 
            </button>
            <br>
            <button class="kakao button" onclick="location.href='https://kauth.kakao.com/oauth/authorize?client_id=d9d93e271c5b4a57f5de6e5b02476dc2&redirect_uri=http://192.168.59.27:8080/mavenNego/user/kakao/callback&response_type=code'">
             <img src="resources/icon/kakao_login_medium_wide.png">
			</button>
            <br>
            <button class="phone button" onclick="location.href='NeGOMember_Login.do'">NeGO 회원으로 시작하기</button>
        </div>
        <p class="notice">공용 PC에서는 [로그인 유지하기]를 꺼주세요</p>
    </div>

    <footer>
        <%@include file="../bottom.jsp" %>
    </footer>
</main>
</body>
</html>

