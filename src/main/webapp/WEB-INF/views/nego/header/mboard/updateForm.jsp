<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>글 수정</title>
  	<link rel="stylesheet" type="text/css" href="resources/css/header/mboard/mboardUpdate.css"> 

</head>
<body>
<main>
    <header>
        <%@include file="../../Header.jsp"%>    
    </header>
    
    <div class="container1">
        <div class="center-align">
            <h3 class="form-title">글 수정</h3>
        </div>
        <form name="f" action="update_board.do" method="post" onsubmit="return checkForm()">
            <input type="hidden" name="num" value="${getBoard.num}"/>    
            <table class="form-table">
                <tr>
                    <th>이름</th>
                    <td><input type="text" name="writer" class="box" value="${getBoard.writer}" readonly></td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td><input type="text" name="subject" class="box" size="50" value="${getBoard.subject}"></td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td><input type="text" name="email" class="box" size="50" value="${getBoard.email}"></td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td><textarea name="content" rows="11" class="box">${getBoard.content}</textarea></td>
                </tr>
                <tr>
                    <td colspan="2" class="center-align">
                        <div class="btn-group">
                            <input type="submit" value="글 수정">
                            <input type="reset" value="다시 작성">
                            <input type="button" value="목록 보기" onclick="window.location='mboard.do'">
                        </div>
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <script type="text/javascript">
        function checkForm() {
            if (document.f.subject.value.trim() === "") {
                alert("제목을 입력해 주세요!!");
                document.f.subject.focus();
                return false;
            }
            if (document.f.content.value.trim() === "") {
                alert("내용을 입력해 주세요!!");
                document.f.content.focus();
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
