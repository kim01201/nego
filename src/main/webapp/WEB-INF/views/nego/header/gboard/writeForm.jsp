<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- writeForm.jsp -->
<html>
<head>
    <title>글 쓰기 폼</title>
 	<link rel="stylesheet" type="text/css" href="resources/css/header/gboard/gboardWrite.css">
</head>
<body>
<main>

<header>
    <%@include file="../../Header.jsp"%>
</header>

<div class="container1">
    <div align="center">
        <form name="f" action="write_gboard.do" method="post" onsubmit="return check()">
            <h3 style="color: #007bff;">공지글 작성</h3><br>
            <table>
                <tr>
                    <th>아이디</th>
                    <td><input type="text" name="writer" class="box" value="${sessionScope.mbId.id}" readonly></td>
                </tr>
                <tr>
                    <th>제 목</th>
                    <td><input type="text" name="subject" class="box" size="50"></td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td><input type="text" name="email" class="box" size="50"></td>
                </tr>
                <tr>
                    <th>내 용</th>
                    <td><textarea name="content" rows="11" cols="50" class="box"></textarea></td>
                </tr>
                <tr style="background-color: #ffffff;">
                    <td colspan="2" align="center">
                        <div class="btn-group">
                            <input type="submit" value="글 쓰 기">
                            <input type="reset" value="다시 작성">
                            <input type="button" value="목록 보기" onclick="window.location='gboard.do'">
                        </div>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
		<footer>
        	<%@include file="../../bottom.jsp" %>
    	</footer>
</main>
</body>
</html>
