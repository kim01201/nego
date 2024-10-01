<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항</title>
	<link rel="stylesheet" type="text/css" href="resources/css/header/mboard/mboardStyle.css">
    
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
    <script>
    function performSearch() {
        var searchTerm = document.getElementById("search").value.trim();
        if (searchTerm !== "") {
            // 현재 페이지 경로를 기반으로 검색 쿼리를 추가하여 이동
            var currentURL = window.location.href.split('?')[0]; // 현재 페이지 URL에서 파라미터 제거
            window.location.href = currentURL + "?search=" + encodeURIComponent(searchTerm);
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

<div class="container1">
    <div class="header">문의하기</div>
    
    <div class="search-form">
        <select>
            <option value="all">전체</option>
        </select>
        <input type="text" placeholder="검색어를 입력하세요" id="search">
        <button onclick="performSearch()">검색</button>
    </div>
    
    <div class="write-button">
        <a href="write_board.do" class="write-link">글쓰기</a>
    </div>
    
    <table class="notice-table">
        <thead>
            <tr>
                <th>번호</th>
                <th width="30%">제목</th>
                <th>작성자</th>
                <th>작성일</th>
                <th>조회</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty mboardList}">        
                <tr>
                    <td colspan="7">등록된 게시글이 없습니다.</td>
                </tr>
            </c:if>    
            <c:forEach var="dto" items="${mboardList}">
                <tr>
                    <td>${dto.num}</td>
                    <td align="right">
                        <c:choose>
                            <c:when test="${dto.re_level > 0}">
                                <div class="reply-level">
                                    <div class="indent" style="margin-left: ${dto.re_level * 20}px;"></div>
                                    <div class="arrow arrow-left"></div>
                                    <a href="content_board.do?num=${dto.num}">${dto.subject}</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                            	<div class="reply-level">
                            		<div class="indent" style="margin-left: 0px;"></div>
                                	<a href="content_board.do?num=${dto.num}">${dto.subject}</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${dto.writer}</td>
                    <td>${dto.reg_date}</td>
                    <td>${dto.readcount}</td>
                </tr>   
            </c:forEach>    
        </tbody>
    </table>
    
    <c:if test="${not empty mboardList}">
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
            <div class="pagination">
                <%-- 이전 페이지 링크 --%>
                <% if (startPage > pageBlock) { %>
                    <a href="mboard.do?pageNum=<%=startPage-pageBlock%>">이전</a>
                <% } %>

                <%-- 페이지 번호 출력 --%>
                <% for (int i = startPage; i <= endPage; ++i) { %>
                    <a href="mboard.do?pageNum=<%=i%>" class="<%= (i == currentPage) ? "active" : "" %>"><%=i%></a>
                <% } %>

                <%-- 다음 페이지 링크 --%>
                <% if (endPage < pageCount) { %>
                    <a href="mboard.do?pageNum=<%=startPage+pageBlock%>">다음</a>
                <% } %>
            </div>
        </c:if>
</div>
		<footer>
        	<%@include file="../../bottom.jsp" %>
    	</footer>
</main>
</body>
</html>
