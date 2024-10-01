<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- writeForm.jsp -->
<head>

<script type="text/javascript">
    function check() {
        if (f.writer.value == "") {
            alert("이름을 입력해 주세요!!");
            f.writer.focus();
            return false;
        }
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
	<link rel="stylesheet" type="text/css" href="resources/css/header/mboard/mboardWrite.css">
</head>
<body>
<main>

<header>
    <%@include file="../../Header.jsp"%>    
</header>

<div class="container1">
    <form name="f" action="write_board.do" method="post" onsubmit="return check()">
        <input type="hidden" name="num" value="${getBoard.num}" />
        <input type="hidden" name="re_step" value="${getBoard.re_step}" />
        <input type="hidden" name="re_level" value="${getBoard.re_level}" />
        <h2>글 쓰 기</h2>
        <table border="1">
            <tr>
                <th>아이디</th>
                <td><input type="text" name="writer" class="box" value="${sessionScope.mbId.id}"></td>
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
            <tr>
                <td colspan="2">
                    <input type="submit" value="글쓰기">
                    <input type="reset" value="다시작성">
                    <input type="button" value="목록보기" onclick="window.location='mboard.do'">
                </td>
            </tr>
        </table>
    </form>
    
</div>

		<footer>
        	<%@include file="../../bottom.jsp" %>
    	</footer>
</main>
</body>