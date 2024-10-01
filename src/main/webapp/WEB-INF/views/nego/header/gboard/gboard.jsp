<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항</title>
    <link rel="stylesheet" type="text/css" href="resources/css/header/gboard/gboardStyle.css">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
    <script>
    function performSearch() {
        var searchType = document.getElementById("searchType").value;
        var searchTerm = document.getElementById("search").value.trim();
        
        if (searchTerm !== "") {
            var currentURL = window.location.href.split('?')[0]; // 현재 페이지 URL에서 파라미터 제거
            var queryString = "?searchType=" + searchType + "&search=" + encodeURIComponent(searchTerm);
            window.location.href = currentURL + queryString;
        }else if(searchTerm === ""){
        	var currentURL = window.location.href.split('?')[0];
        	window.location.href =currentURL;
        }
    }
    </script>
    
</head>
<body>
<main>
<header>
    <%@include file="../../Header.jsp"%>
</header>

<div class="gboard">
    <h2>공지사항</h2>
    <br>
    <div class="search-form">
        <select id="searchType">
            <option value="all">전체</option>
            <option value="num">번호</option>
            <option value="subject">제목</option>
        </select>
        <input type="text" placeholder="검색어를 입력하세요" id="search">
        <button onclick="performSearch()">검색</button>
    </div>
    <div id="notices">
        <table class="write-table">
            <tr>
                <c:if test="${sessionScope.mbId.id == 'admin'}">
                    <td align="right">
                        <a href="write_gboard.do?" class="write-btn">글쓰기</a>
                    </td>
                </c:if>
            </tr>
        </table>
        <table class="notice-table">
            <tr class="notice-header">
                <th>번호</th>
                <th width="50%">제목</th>
                <th>작성자</th>
                <th>작성일</th>
            </tr>
            <c:if test="${empty gboardList}">
                <tr>
                    <td colspan="4" class="no-data">등록된 공지글이 없습니다.</td>
                </tr>
            </c:if>
            <c:forEach var="dto" items="${gboardList}">
                <tr class="notice-row">
                    <td align="center">${dto.num}</td>
                    <td align="left">
                        <a href="content_gboard.do?num=${dto.num}" class="notice-link">${dto.subject}</a>
                    </td>
                    <td align="center">${dto.writer}</td>
                    <td align="center">${dto.reg_date}</td>
                </tr>
            </c:forEach>
        </table>

        <c:if test="${not empty gboardList}">
            <div class="pagination">
                <%-- 페이지네이션 출력 --%>
                <%
                    int pageSize = 5; // 한 페이지에 보여질 게시물 수
                    int currentPage = (request.getParameter("pageNum") != null) ? Integer.parseInt(request.getParameter("pageNum")) : 1;
                    int count = (Integer) request.getAttribute("count"); // 전체 게시물 수
                    int pageBlock = 5; // 페이지 블록 수
                    int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1); // 전체 페이지 수
                    int startPage = (currentPage - 1) / pageBlock * pageBlock + 1;
                    int endPage = startPage + pageBlock - 1;
                    if (endPage > pageCount) endPage = pageCount;
                %>
                <%-- 이전 페이지 링크 --%>
                <% if (startPage > pageBlock) { %>
                    <a href="gboard.do?pageNum=<%=startPage-pageBlock%>">&laquo; 이전</a>
                <% } %>

                <%-- 페이지 번호 출력 --%>
                <% for (int i = startPage; i <= endPage; ++i) { %>
                    <a href="gboard.do?pageNum=<%=i%>" class="<%= (i == currentPage) ? "active" : "" %>"><%=i%></a>
                <% } %>

                <%-- 다음 페이지 링크 --%>
                <% if (endPage < pageCount) { %>
                    <a href="gboard.do?pageNum=<%=startPage+pageBlock%>">다음 &raquo;</a>
                <% } %>
            </div>
        </c:if>
    </div>
</div>
		<footer>
        	<%@include file="../../bottom.jsp" %>
    	</footer>
</main>
</body>
</html>
