<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>판매자의 후기</title>
<style>
	
</style>
</head>
<body>
						<div>
							<h2>판매자에 대한 후기</h2>
							<hr>
							<table class="notice-table">
								<c:if test="${empty sellReviews}">
									<tr>
										<td colspan="4" style="text-align: left;">작성된 후기가 없습니다</td>
									</tr>
								</c:if>

	
									<h4>이런점이 좋았어요 <img src="resources/icon/thumbs-up.png" width="25px" height="25px"></h4>

								<ul id="uniqueGoodPoints">
									<c:choose>
										<c:when test="${empty sellReviews}">
											<li class="review-item">평가된 내용이 없습니다</li>
										</c:when>
										<c:otherwise>
											<c:set var="hasGoodPoints" value="false" />
											<c:forEach var="dto" items="${sellReviews}">
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
								<br><hr>
				
									<h4>이런점이 안 좋았어요 <img src="resources/icon/thumbs-down.png" width="25px" height="25px"></h4>
					
								<ul id="uniqueBadPoints">
									<c:choose>
										<c:when test="${empty sellReviews}">
											<li class="review-item">평가된 내용이 없습니다</li>
										</c:when>
										<c:otherwise>
											<c:set var="hasBadPoints" value="false" />
											<c:forEach var="dto" items="${sellReviews}">
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
								<br><hr>

				
									<h4>상세한 후기 <img src="resources/icon/text.png" width="25px" height="25px"></h4>
						
								<c:forEach var="dto" items="${sellReviews}">
									<div class="review-content">
										<div class="review-header">
											<div>${dto.sender_id}</div>
											<div>${dto.reg_date}</div>
										</div>
										<div class="review-body">
											<a href="#">${dto.content}</a>
										</div>
									</div>
								</c:forEach>
							</table>
						</div>
					</div>
</body>
</html>