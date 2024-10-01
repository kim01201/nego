<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="resources/css/admin/adminFraud.css">
 <script type="text/javascript">
    
    jQuery(document).ready(function($) {
        $('.delete').on('click', function(e) {
            e.preventDefault(); // 기본 동작 방지
            
            var url = $(this).attr('href'); // 클릭한 링크의 URL을 가져옴
            console.log('memberUrl: ', url); // 디버깅용 콘솔 로그

            $('#main-content').load(url, function(response, status, xhr) {
                if (status === "error") {
                    var msg = "Sorry but there was an error: ";
                    $('#main-content').html(msg + xhr.status + " " + xhr.statusText);
                }
            });
        });
    });
    </script>
</head>
<body>

<div class="container1">
    <h1 class="title">신고회원 관리</h1>
    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>신고횟수</th>
                <th>회원삭제</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty fraudList}">
                    <c:forEach var="dto" items="${fraudList}">
                        <tr>
                            <td>${dto.member_id}</td>
                            <td>${dto.fraudCount}</td>
                            <td>
                            <a class="btn btn-danger" href="member_delete.do?no=${dto.member_id}" class="delete">삭제</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:when test="${not empty searchFraud}">
                    <c:forEach var="dto" items="${searchFraud}">
                        <tr>
                            <td>${dto.member_id}</td>
                            <td>${dto.fraudCount}</td>
                            <td>
                            <a class="btn btn-danger" href="member_delete.do?no=${dto.member_id}"class="delete">삭제</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="3" class="no-results">검색결과가 없습니다</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>
</body>
</html>
