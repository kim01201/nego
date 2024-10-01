<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- content.jsp -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>글내용 보기</title>
	<link rel="stylesheet" type="text/css" href="resources/css/header/mboard/mboardContent.css">

    <script>
        function deleteConfirmation() {
            var sessionUserId = '${sessionScope.mbId.id}';
            var writerId = '${getBoard.writer}';

         	// 작성자 본인 또는 관리자인지 확인
            if (sessionUserId !== writerId && sessionUserId !== 'admin') {
                alert('해당 글은 작성자 본인만 삭제할 수 있습니다.');
                return false;
            }

            // 삭제 확인 메시지
            if (!confirm('정말 삭제하시겠습니까?')) {
                return false;
            }

            alert('삭제가 완료되었습니다. 문의 페이지로 이동합니다.');
            window.location.href = 'delete_board.do?num=${getBoard.num}';
            return;
        }

        function updateConfirmation() {
            var sessionUserId = '${sessionScope.mbId.id}';
            var writerId = '${getBoard.writer}';

            if (sessionUserId !== writerId && sessionUserId !== 'admin') {
                alert('해당 글은 작성자 본인만 수정할 수 있습니다.');
                return false;
            }

            window.location.href = 'update_board.do?num=${getBoard.num}';
            return;
        }
    </script>
</head>
<body>
<main>
    <header>
        <%@ include file="../../Header.jsp" %>
    </header>

    <div class="container1">
        <h2>글내용 보기</h2>
        <table>
            <tr>
                <th>글번호</th>
                <td>${getBoard.num}</td>
            </tr>
            <tr>
                <th>조회수</th>
                <td>${getBoard.readcount}</td>
            </tr>
            <tr>
                <th>작성자 아이디</th>
                <td>${getBoard.writer}</td>
            </tr>
            <tr>
                <th>작성일</th>
                <td>${getBoard.reg_date}</td>
            </tr>
            <tr>
                <th>글제목</th>
                <td>${getBoard.subject}</td>
            </tr>
            <tr>
                <th class="full-width-th" colspan="2">글내용</th>
            </tr>
            <tr>
                <td class="full-width-td" colspan="2">${getBoard.content}</td>
            </tr>
        </table>
        <div class="button-group">
            <input type="button" value="답글달기" onclick="window.location='write_board.do?num=${getBoard.num}'">
            <input type="button" value="글수정" onclick="return updateConfirmation()">
            <input type="button" value="글삭제" onclick="return deleteConfirmation()">
            <input type="button" value="글목록" onclick="window.location='mboard.do'">
        </div>
    </div>
    
    		<footer>
        	<%@include file="../../bottom.jsp" %>
    	</footer>
</main>
</body>
</html>
