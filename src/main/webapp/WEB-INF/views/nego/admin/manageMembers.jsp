<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 리스트</title>
    <link rel="stylesheet" type="text/css" href="resources/css/admin/adminMember.css">

    <script type="text/javascript">
    jQuery(document).ready(function($) {
        $('.search-form').on('submit', function(e) {
            e.preventDefault();
            var url = $(this).attr('action') || 'search_user.do'; // 기본적으로 search_user.do를 사용할 수 있도록 설정
            console.log('memberUrl: ', url);
            $('#main-content').load(url, $(this).serialize(), function(response, status, xhr) {
                if (status == "error") {
                    var msg = "Sorry but there was an error: ";
                    $('#main-content').html(msg + xhr.status + " " + xhr.statusText);
                }
            });
        });
    });
    
    jQuery(document).ready(function($) {
        $('.edit').on('click', function(e) {
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
	<h1>회원 관리 페이지</h1>
	<br>
    <div align="center" id="mem">
        <!-- 복합 검색 양식 및 목록 표시 -->
        <form name="searchForm" action="search_user.do" method="get" class="search-form">
            <input type="text" name="name" placeholder="이름">
            <input type="text" name="id" placeholder="아이디">
            <input type="submit" value="검색">
        </form>

        <h2 >회원 리스트</h2>
        <table border="0" width="100%" class="outline">
            <tr>
                <th class="m1">이름</th>
                <th class="m1">아이디</th>
                <th class="m1">비밀번호</th>
                <th class="m1">이메일</th>
                <th class="m1">전화번호</th>
                <th class="m1">수정 | 삭제</th>
            </tr>
            <c:forEach var="dto" items="${listMember}">
            <c:if test="${dto.id != 'admin'}">
                <tr>
                    <td align="center">${dto.name}</td>
                    <td align="center">${dto.id}</td>
                    <td align="center">${dto.passwd}</td>
                    <td align="center">${dto.email}</td>
                    <td align="center">${dto.hp1}-${dto.hp2}-${dto.hp3}</td>
                    <td align="center" >
                        <a href="member_update.do?no=${dto.id}" class="edit">수정</a> | 
                        <a href="member_delete.do?no=${dto.id}" class="delete">삭제</a>
                    </td>
                </tr>
            </c:if>
            </c:forEach>
        </table>

        <c:if test="${empty listMember}">
            <p>회원 데이터가 없습니다.</p>
        </c:if>
    </div>
</body>
</html>
