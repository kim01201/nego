<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- content.jsp -->
<html>
<head>
    <title>글 내용 보기</title>
    <link rel="stylesheet" type="text/css" href="resources/css/header/gboard/gboardContent.css">
</head>
<body>
    <main>
        <header>
            <%@include file="../../Header.jsp"%>
        </header>

        <div class="container1">
            <h2>글 내용 보기</h2>
            <table>
                <tr>
                    <th>글번호</th>
                    <td>${getGboard.num}</td>
                </tr>
                <tr>
                    <th>작성자 아이디</th>
                    <td>${getGboard.writer}</td>
                </tr>
                <tr>
                	<th>작성일</th>
                    <td>${getGboard.reg_date}</td>
                </tr>
                <tr>
                    <th>글제목</th>
                    <td colspan="3">${getGboard.subject}</td>
                </tr>
                <tr>
                    <th>글내용</th>
                    <td colspan="3">${getGboard.content}</td>
                </tr>
            </table>
            <div class="btn-group">
                <c:if test="${sessionScope.mbId.id == 'admin'}">
                	<input type="button" value="글 수정" onclick="updateConfirmation()">
                	<input type="button" value="글 삭제" onclick="deleteConfirmation()">
                </c:if>

                <input type="button" value="공지 글 목록으로 돌아가기" onclick="window.location='gboard.do'">
            </div>
        </div>

        <script>
            function deleteConfirmation() {
                var sessionUserId = '${sessionScope.mbId.id}';
                var writerId = '${getGboard.writer}';

                if (sessionUserId !== writerId) {
                    alert('해당 글은 관리자만 삭제할 수 있습니다.');
                    return false; // 삭제 작업 중단
                }
                if (!confirm('정말로 삭제하시겠습니까?')) {
                    return false; // 사용자가 취소한 경우
                }
                alert('삭제가 완료되었습니다. 공지 페이지로 이동합니다.');
                window.location.href = 'delete_gboard.do?num=${getGboard.num}';
            }

            function updateConfirmation() {
                var sessionUserId = '${sessionScope.mbId.id}';
                var writerId = '${getGboard.writer}';

                if (sessionUserId !== writerId) {
                    alert('해당 글은 관리자만 수정할 수 있습니다.');
                    return false; // 수정 작업 중단
                }
                window.location.href = 'update_gboard.do?num=${getGboard.num}';
            }
        </script>
        
		<footer>
        	<%@include file="../../bottom.jsp" %>
    	</footer>
   </main>
</body>
</html>
