<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>판매 내역</title>
    <link rel="stylesheet" type="text/css" href="resources/css/mypage/completed/sellCompleted.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    $(document).ready(function() {
        // 검색 폼 제출 처리
        $('#searchForm').on('submit', function(e) {
            e.preventDefault();
            var searchKeyword = $('#search').val();
            loadSellerCompleted(searchKeyword);
        });

        // 상품 삭제 확인 처리
        function confirmDelete(productName, pnum) {
            if (confirm("정말로 '" + productName + "' 상품을 삭제하시겠습니까?")) {
                $.ajax({
                    url: "deleteComplete.prod",
                    method: "POST",
                    data: {
                        pnum: pnum
                    },
                    success: function(response) {
                        loadSellerCompleted('');
                    },
                    error: function(xhr, status, error) {
                        var msg = "Sorry but there was an error: ";
                        alert(msg + xhr.status + " " + xhr.statusText);
                    }
                });
            }
        }

        // 판매 완료 목록 새로고침
        function loadSellerCompleted(searchKeyword) {
            $.ajax({
                url: "searchCompleted.prod",
                method: "POST",
                data: {
                    search: searchKeyword
                },
                success: function(response) {
                    $('#base').html(response);
                },
                error: function(xhr, status, error) {
                    var msg = "Sorry but there was an error: ";
                    alert(msg + xhr.status + " " + xhr.statusText);
                }
            });
        }
    });
    </script>
</head>
<body>
    <div align="center">
        <table id="base">
            <tr><th align="center">판매내역</th></tr>
            <tr><td>
                <form id="searchForm" action="searchCompleted.prod" method="POST">
                     <input type="text" placeholder="상품명을 입력해주세요." id="search" name="search">
                     <input type="submit" value="검색" class="submit">
                </form>
            </td></tr>
            <c:if test="${empty sellerCompleted}">
                <tr><td>판매한 상품이 없습니다.</td></tr>
            </c:if>
            <c:forEach var="dto" items="${sellerCompleted}">
                <tr><td>
                    <table id="list">
                        <tr>
                            <td><h3>판매완료</h3></td>
                            <td>${dto.sale_completion_time}</td>
                            <td><a href="javascript:void(0);" onclick="confirmDelete('${dto.pname}',${dto.pnum})">삭제</a></td>
                        </tr>
                        <tr>
                            <td rowspan="2"><img src="${pageContext.request.contextPath}/resources/images/${dto.pimage}" width="200" height="200"></td>
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
