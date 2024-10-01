<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="resources/css/admin/adminProduct.css">
    
    <script type="text/javascript">
    jQuery(document).ready(function($) {
        $('.search-form').on('submit', function(e) {
            e.preventDefault();
            var url = $(this).attr('action') || 'prod.do';
            console.log('memberUrl: ', url);
            $('#main-content').load(url, $(this).serialize(), function(response, status, xhr) {
                if (status == "error") {
                    var msg = "Sorry but there was an error: ";
                    $('#main-content').html(msg + xhr.status + " " + xhr.statusText);
                }
            });
        });

        $('.edit').on('click', function(e) {
            e.preventDefault();
            var url = $(this).attr('href');
            console.log('memberUrl: ', url);

            $('#main-content').load(url, function(response, status, xhr) {
                if (status === "error") {
                    var msg = "Sorry but there was an error: ";
                    $('#main-content').html(msg + xhr.status + " " + xhr.statusText);
                }
            });
        });

        $(document).on('click', '.pagination a', function(e) {
            e.preventDefault();
            var url = $(this).attr('href');
            console.log('paginationUrl: ', url);

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
    <h1 class="title">상품 수정/삭제</h1>
    <div class="search-container">
      <form name="searchForm" action="prod.do" method="get" class="search-form">
        <img src="resources/icon/mag.png" class="search-icon">
        <input type="text" placeholder="어떤 상품을 찾으시나요?" name="search">
        <input type="submit" value="검색">
      </form>
    </div>
    <table class="table">
      <thead>
        <tr>
          <th>상품 ID</th>
          <th>상품명</th>
          <th>수정</th>
          <th>삭제</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${not empty allProd}">
            <c:forEach var="dto" items="${allProd}">
              <tr>
                <td>${dto.pnum}</td>
                <td>${dto.pname}</td>
                <td><a href="adminProdEdit.prod?pnum=${dto.pnum}" class="edit">수정</a></td>
                <td><a class="btn btn-danger" href="delete_prod.prod?pnum=${dto.pnum}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a></td>
              </tr>
            </c:forEach>
          </c:when>
          <c:when test="${not empty searchProd}">
            <c:forEach var="dto" items="${searchProd}">
              <tr>
                <td>${dto.pnum}</td>
                <td>${dto.pname}</td>
                <td><a href="adminProdEdit.prod?pnum=${dto.pnum}" class="edit">수정</a></td>
                <td><a class="btn btn-danger" href="delete_prod.prod?pnum=${dto.pnum}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a></td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="4" class="no-results">검색결과가 없습니다</td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
    
    <c:if test="${not empty allProd}">
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
          <a href="prod.do?pageNum=<%=startPage-pageBlock%>">&laquo; 이전</a>
        <% } %>

        <%-- 페이지 번호 출력 --%>
        <% for (int i = startPage; i <= endPage; ++i) { %>
          <a href="prod.do?pageNum=<%=i%>" class="<%= (i == currentPage) ? "active" : "" %>"><%=i%></a>
        <% } %>

        <%-- 다음 페이지 링크 --%>
        <% if (endPage < pageCount) { %>
          <a href="prod.do?pageNum=<%=startPage+pageBlock%>">다음 &raquo;</a>
        <% } %>
      </div>
    </c:if>
  </div>
</body>
</html>
