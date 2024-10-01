<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>
    <link rel="stylesheet" type="text/css" href="resources/css/admin/adminMemberUpdate.css">

</head>
<body>
    <div  align="center">
        <h2>회원 정보 수정</h2>
        <form action="member_update.do" method="post">
            <input type="hidden" name="id" value="${member.id}">
            <p>
                <label>이름:</label>
                <input type="text" name="name" value="${member.name}" required>
            </p>
            <p>
                <label>비밀번호:</label>
                <input type="password" name="passwd" value="${member.passwd}" required>
            </p>
            <p>
                <label>이메일:</label>
                <input type="email" name="email" value="${member.email}" required>
            </p>
            <p class="form-row">
                <label>전화번호:</label>
                <input type="text" name="hp1" value="${member.hp1}" required>-
                <input type="text" name="hp2" value="${member.hp2}" required>-
                <input type="text" name="hp3" value="${member.hp3}" required>
            </p>
            <p>
                <label>주민번호 앞자리:</label>
                <input type="text" name="ssn1" value="${member.ssn1}" required>
            </p>
            <p>
                <label>주민번호 뒷자리:</label>
                <input type="text" name="ssn2" value="${member.ssn2}" required>
            </p>
            <p>
                <label>주소:</label>
                <input type="text" name="addr" value="${member.addr}" required>
            </p>
            <p>
                <input type="submit" value="수정">
            </p>
        </form>
    </div>
</body>
</html>
