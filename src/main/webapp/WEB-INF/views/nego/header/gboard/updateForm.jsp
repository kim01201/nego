<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- updateForm.jsp -->
<html>
<head>
    <title>글 수정 폼</title>
    <link rel="stylesheet" type="text/css" href="resources/css/header/gboard/gboardUpdate.css">
</head>
<body>
<main>

<header>
    <%@include file="../../Header.jsp"%>
</header>

<div class="container1">
    <div align="center">
        <form name="f" action="update_gboard.do" method="post" onsubmit="return check()">
            <input type="hidden" name="num" value="${getGboard.num}"/>
            <h3 style="color: #007bff;">공지글 수정</h3><br>
            <table>
                <tr>
                    <th>이 름</th>
                    <td><input type="text" name="writer" class="box" value="${getGboard.writer}" readonly></td>
                </tr>
                <tr>
                    <th>제 목</th>
                    <td><input type="text" name="subject" class="box" size="50" value="${getGboard.subject}"></td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td><input type="text" name="email" class="box" size="50" value="${getGboard.email}"></td>
                </tr>
                <tr>
                    <th>내 용</th>
                    <td><textarea name="content" rows="11" cols="50" class="box">${getGboard.content}</textarea></td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <div class="btn-group">
                            <input type="submit" value="글 수정">
                            <input type="reset" value="다시 작성">
                            <input type="button" value="목록 보기" onclick="window.location='gboard.do'">
                        </div>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

<script type="text/javascript">
    function check() {
        if (f.subject.value == "") {
            alert("제목을 입력해 주세요!!");
            f.subject.focus();
            return false;
        }
        if (f.content.value == "") {
            alert("내용을 입력해 주세요!!");
            f.content.focus();
            return false;
        }
        return true;
    }
</script>
		<footer>
        	<%@include file="../../bottom.jsp" %>
    	</footer>
</main>
</body>
</html>
