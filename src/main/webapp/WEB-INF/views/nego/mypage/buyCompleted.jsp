<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>구매 내역</title>
    <link rel="stylesheet" type="text/css" href="resources/css/mypage/completed/buyCompleted.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // 페이지 로드 시 실행될 함수
        $(document).ready(function() {
            // 검색 폼 제출 시 이벤트 처리
            $('#searchForm').on('submit', function(e) {
                e.preventDefault(); // 기본 동작 방지
                var url = $(this).attr('action'); // 폼의 action 속성 가져오기
                var formData = $(this).serialize(); // 폼 데이터 직렬화

                // AJAX 요청 보내기
                $.ajax({
                    url: url,
                    method: 'POST',
                    data: formData,
                    success: function(response) {
                        $('#base').html(response); // 결과를 테이블에 적용
                    },
                    error: function(xhr, status, error) {
                        var msg = "Sorry but there was an error: ";
                        alert(msg + xhr.status + " " + xhr.statusText); // 오류 메시지 표시
                    }
                });
            });

            // 삭제 확인 함수
            function confirmDelete(productName, pnum) {
                if (confirm("정말로 '" + productName + "' 상품을 삭제하시겠습니까?")) {
                    $.ajax({
                        url: "deleteBuyComplete.prod",
                        method: "POST",
                        data: {
                            pnum: pnum
                        },
                        success: function(response) {
                            $('#base').html(response); // 결과를 테이블에 적용
                        },
                        error: function(xhr, status, error) {
                            var msg = "Sorry but there was an error: ";
                            alert(msg + xhr.status + " " + xhr.statusText); // 오류 메시지 표시
                        }
                    });
                }
            }
        });
    </script>
</head>
<body>
    <div align="center">
        <table id="base">
            <tr><th align="center">구매내역</th></tr>
            <tr>
                <td>
                    <form id="searchForm" action="searchBuyCompleted.prod" method="POST">
                        <input type="text" placeholder="상품명을 입력해주세요." id="search" name="search">
                        <input type="submit" value="검색" class="submit">
                    </form>
                </td>
            </tr>
            <c:if test="${empty buyCompleted}">
                <tr><td>구매한 상품이 없습니다.</td></tr>
            </c:if>
            <c:forEach var="dto" items="${buyCompleted}">
                <tr><td>
                    <table id="list">
                        <tr>
                            <td><h3>구매완료</h3></td>
                            <td><a href="insert_reviews.do?product_id=${dto.pnum}&sender_id=${sessionScope.mbId.id}">후기쓰기</a></td>
                            <td>${dto.sale_completion_time}</td>
                            <td><a href="javascript:void(0);" onclick="confirmDelete('${dto.pname}', ${dto.pnum})">삭제</a></td>
                        </tr>
                        <tr>
                            <td rowspan="2"><img src="${pageContext.request.contextPath}/resources/images/${dto.pimage}" width="100" height="100"></td>
                            <td colspan="2">${dto.pname}</td>
                        </tr>
                        <tr>
                            <td colspan="2"><fmt:formatNumber value="${dto.price}" pattern="###,###"/>원</td>
                        </tr>
                    </table>
                </td></tr>
            </c:forEach>
        </table>
    </div>
</body>
</html>
