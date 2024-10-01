<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>판매 승인 대기</title>
    <link rel="stylesheet" type="text/css" href="resources/css/mypage/completed/waitList.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
    $(document).ready(function() {
        var sellerId = '${seller_id}';

        // 구매 요청 승인
        window.confirmPurchase = function(buyer_id, pname, seller_id, pnum) {
            if (confirm("'" + buyer_id + "'님의 '" + pname + "' 상품 구매 요청을 승인하시겠습니까?")) {
                $.ajax({
                    url: "ifClickSell.prod",
                    method: "POST",
                    data: {
                        buyer_id: buyer_id,
                        seller_id: seller_id,
                        pnum: pnum
                    },
                    success: function(response) {
                        loadWaitList(sellerId);
                        if (socket) {
                            let socketMsg = "wantSell," + buyer_id + "," + seller_id + "," + pname;
                            socket.send(socketMsg);
                        } else {
                        	alert('WebSocket is not open.');
                        }
                    },
                    error: function(xhr, status, error) {
                        var msg = "Sorry but there was an error: ";
                        $('.main-content').html(msg + xhr.status + " " + xhr.statusText);
                    }
                });
            }
        }

        // 구매 요청 거절
        window.denyPurchase = function(buyer_id, pname, pnum) {
            if (confirm("정말로 '" + buyer_id +"'님의 '"+ pname + "' 상품 구매 요청을 거절하시겠습니까?")) {
                $.ajax({
                    url: "deny.prod",
                    method: "POST",
                    data: {
                        buyer_id: buyer_id,
                        pnum: pnum
                    },
                    success: function(response) {
                        loadWaitList(sellerId);
                    },
                    error: function(xhr, status, error) {
                        var msg = "Sorry but there was an error: ";
                        $('.main-content').html(msg + xhr.status + " " + xhr.statusText);
                    }
                });
            }
        }

        // 대기 목록 새로고침
        function loadWaitList(seller_id) {
            $.ajax({
                url: "sendSeller.prod",
                method: "GET",
                data: {
                    seller_id: seller_id
                },
                success: function(response) {
                    $('.main-content').html(response);
                },
                error: function(xhr, status, error) {
                    var msg = "Sorry but there was an error: ";
                    $('.main-content').html(msg + xhr.status + " " + xhr.statusText);
                }
            });
        }


    });
    </script>
</head>
<body>
    <div class="main-content" align="center">
        <table id="base">
            <tr><th align="center">판매 승인 대기 내역</th></tr>
            <c:if test="${empty sendSeller}">
                <tr><td>판매 승인 대기중인 상품이 없습니다.</td></tr>
            </c:if>
            <c:forEach var="dto" items="${sendSeller}">
                <tr><td>
                    <table id="list">
                        <tr>
                            <td><h3>판매 승인 대기</h3></td>
                            <td><a href="#" onclick="confirmPurchase('${dto.buyer_id}', '${dto.pname}', '${dto.seller_id}', '${dto.pnum}')" class="alink">승인하기</a></td>
                            <td><a href="javascript:void(0);" onclick="denyPurchase('${dto.buyer_id}','${dto.pname}','${dto.pnum}')">거절하기</a></td>
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
