<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>구매 승인 대기</title>
    <link rel="stylesheet" type="text/css" href="resources/css/mypage/completed/wantBuyList.css">

    <script>
    function denyPurchase(buyer_id, pname, pnum) {
        if (confirm("정말로 '" + buyer_id +"'님의 '"+ pname + "' 상품 구매 요청을 철수하시겠습니까?")) {
            window.location.href = "cancel.prod?buyer_id=" + encodeURIComponent(buyer_id) +"&pnum="+ encodeURIComponent(pnum);
        }
    }
    </script>
</head>
<body>

    <div align="center">
        <table id="base">
            <tr><th align="center">구매 승인 대기 내역</th></tr>
            <c:if test="${empty sendBuyer}">
                <tr><td>구매 승인 대기중인 상품이 없습니다.</td></tr>
            </c:if>
            <c:forEach var="dto" items="${sendBuyer}">
                <tr><td>
                    <table id="list">
                        <tr>
                            <td><h3>구매 승인 대기</h3></td>
                            <td><a href="javascript:void(0);" onclick="denyPurchase('${dto.buyer_id}','${dto.pname}', '${dto.pnum}')">안 살래요</a></td>
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
