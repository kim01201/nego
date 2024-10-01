<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>후기 작성</title>
<link rel="stylesheet" type="text/css"
	href="resources/css/header/gboard/gboardWrite.css">
<link rel="stylesheet" href="resources/css/product/reviews.css">
</head>
<body>
	<main> 
		<header>
			<%@include file="../Header.jsp"%>
		</header>
		<table style="width: 100%;">
			<tr>
				<!-- 나에 대한 후기 섹션 -->
				<td style="vertical-align: top; width: 50%;">

						<div class="container1">
							<div class="header">나에 대한 후기</div>
							<table class="notice-table">
								<tbody>
									<c:if test="${empty sellReviews}">
										<tr>
											<td colspan="4">작성받은 후기가 없습니다</td>
										</tr>
									</c:if>
								</tbody>
							</table>

							<h2>이런점이 좋았어요</h2>
							<ul id="uniqueGoodPoints">
								<c:choose>
									<c:when test="${empty sellPoint}">
										<li class="review-item">평가된 내용이 없습니다</li>
									</c:when>
									<c:otherwise>
										<c:set var="hasGoodPoints" value="false" />
										<c:forEach var="dto" items="${sellPoint}">
											<c:if test="${not empty dto.goodPoints}">
												<li class="review-item">${dto.goodPoints}</li>
												<c:set var="hasGoodPoints" value="true" />
											</c:if>
										</c:forEach>
										<c:if test="${not hasGoodPoints}">
											<li class="review-item">평가된 내용이 없습니다</li>
										</c:if>
									</c:otherwise>
								</c:choose>
							</ul>
							<br>

							<h2>이런점이 안 좋았어요</h2>
							<ul id="uniqueBadPoints">
								<c:choose>
									<c:when test="${empty sellPoint}">
										<li class="review-item">평가된 내용이 없습니다</li>
									</c:when>
									<c:otherwise>
										<c:set var="hasBadPoints" value="false" />
										<c:forEach var="dto" items="${sellPoint}">
											<c:if test="${not empty dto.badPoints}">
												<div class="review-body">
													<li class="review-item">${dto.badPoints}</li>
													<c:set var="hasBadPoints" value="true" />
												</div>
											</c:if>
										</c:forEach>
										<c:if test="${not hasBadPoints}">
											<li class="review-item">평가된 내용이 없습니다</li>
										</c:if>
									</c:otherwise>
								</c:choose>
							</ul>
							<br>

							<h2>상세한 후기</h2>
							<c:forEach var="dto" items="${sellReviews}">
								<div class="review-content">
									<div class="review-header">
										<div>${dto.sender_id}</div>
										<div>${dto.reg_date}</div>
									</div>
									<div class="review-body">
										<p>${dto.content}</p>
									</div>
								</div>
							</c:forEach>
							
							 <c:if test="${not empty sellReviews}">
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
                    <a href="allReviews.do?pageNum=<%=startPage-pageBlock%>&sender_id=${sessionScope.mbId.id}&receiver_id=${sessionScope.mbId.id}">이전</a>
                <% } %>

                <%-- 페이지 번호 출력 --%>
                <% for (int i = startPage; i <= endPage; ++i) { %>
                    <a href="allReviews.do?pageNum=<%=i%>&sender_id=${sessionScope.mbId.id}&receiver_id=${sessionScope.mbId.id}" class="<%= (i == currentPage) ? "active" : "" %>"><%=i%></a>
                <% } %>

                <%-- 다음 페이지 링크 --%>
                <% if (endPage < pageCount) { %>
                    <a href="allReviews.do?pageNum=<%=startPage+pageBlock%>&sender_id=${sessionScope.mbId.id}&receiver_id=${sessionScope.mbId.id}">다음</a>
                <% } %>
            </div>
        </c:if>
							
							
						</div>
				</td>
				<!-- 내가 작성한 후기 섹션 -->
				<td style="vertical-align: top; width: 50%;">

						<div class="container1">
							<div class="header">내가 작성한 후기</div>
							<table class="notice-table">
								<thead>
									<tr>
										<th>작성자</th>
										<th>상품이름</th>
										<th>작성일</th>
										<th width="30%">내용</th>
										<th>수정/삭제</th>
									</tr>
								</thead>
								<tbody>
									<c:if test="${empty myReviews}">
										<tr>
											<td colspan="5">작성한 후기가 없습니다</td>
										</tr>
									</c:if>
									<c:forEach var="dto" items="${myReviews}">
										<tr>
											<td align="center">${dto.sender_id}</td>
											<td align="center">${dto.product_name}</td>
											<td align="center">${dto.reg_date}</td>
											<td align="left">${dto.content}</td>
											<td align="center">
												<a href="edit_Reviews.do?product_id=${dto.product_id}&sender_id=${sessionScope.mbId.id}">수정</a> /
												<a href="delete_Reviews.do?product_id=${dto.product_id}&sender_id=${sessionScope.mbId.id}">삭제</a>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						
						<c:if test="${not empty myReviews}">
            <%-- 페이지네이션 출력 --%>
            <%
                int pageSize = 5; // 한 페이지에 보여질 게시물 수
                int currentPage = (request.getParameter("myPageNum") != null) ? Integer.parseInt(request.getParameter("myPageNum")) : 1;
                int count = (Integer) request.getAttribute("myCount"); // 전체 게시물 수
                int pageBlock = 5; // 페이지 블록 수
                int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1); // 전체 페이지 수
                int startPage = (currentPage - 1) / pageBlock * pageBlock + 1;
                int endPage = startPage + pageBlock - 1;
                if (endPage > pageCount) endPage = pageCount;
            %>
            <div class="pagination" style="align=center">
                <%-- 이전 페이지 링크 --%>
                <% if (startPage > pageBlock) { %>
                    <a href="allReviews.do?myPageNum=<%=startPage-pageBlock%>&sender_id=${sessionScope.mbId.id}&receiver_id=${sessionScope.mbId.id}">이전</a>
                <% } %>

                <%-- 페이지 번호 출력 --%>
                <% for (int i = startPage; i <= endPage; ++i) { %>
                    <a href="allReviews.do?myPageNum=<%=i%>&sender_id=${sessionScope.mbId.id}&receiver_id=${sessionScope.mbId.id}" class="<%= (i == currentPage) ? "active" : "" %>"><%=i%></a>
                <% } %>

                <%-- 다음 페이지 링크 --%>
                <% if (endPage < pageCount) { %>
                    <a href="allReviews.do?myPageNum=<%=startPage+pageBlock%>&sender_id=${sessionScope.mbId.id}&receiver_id=${sessionScope.mbId.id}">다음</a>
                <% } %>
            </div>
        </c:if>
						
						
						</div>
				</td>
			</tr>
		</table>

		<footer>
			<%@include file="../bottom.jsp"%>
		</footer> 
	</main>
</body>
</html>
