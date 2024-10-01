<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사기 조회</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        $('button[name="search1"]').click(function() {
        	document.getElementById('fraud').submit();
        });
        
    });
</script>
	<link rel="stylesheet" type="text/css" href="resources/css/header/fraud/fraudStyle.css">
</head>
<body>
<main>
	
		<header>
			<%@include file="../../Header.jsp"%>	
		</header>
    <div class="container1">
        <div>
            <h2><b>안전하고 편리한<br>중고거래 서비스</b></h2>
            <h5>거래 전 사기 이력 조회부터<br>예상치 못한 피해 시 거래 피해 보상체까지</h5>
        </div>
        <hr>
        <div>
            <h3><b>통합 사기조회</b></h3>
            <h5>중고거래 플랫폼, 커뮤니티 어디에서 거래하든 사기 피해사례를 조회할 수 있어요.</h5>
        </div>
        <br>
        <div class="searchFraud">
            <form action="fraud.fraud" method="post" id="fraud">
                <input type="text" id="fraudAccount" name="fraudAccount" placeholder="휴대전화번호, 계좌번호, 메신저 ID, 이메일 입력"> 
                <button type="button" name="search1">조회하기</button>
            </form>
            <a href="insertFraud.fraud">사기 피해 등록하기</a>
        </div>

        <c:if test="${not empty searchFraud}">
            <div class="fraud">
                <table>
                    <tr>
                        <td>
                            <h2>${searchFraud.member_id}<br>피해사례 조회</h2>
                            <h3>누적 신고 횟수 ${searchFraud.fraudCount}회</h3>
                            <h3>누적 피해 금액 <fmt:formatNumber value="${searchFraud.fraudTotalCost}" pattern="###,###"/>원</h3>
                            <a href="updateFraud.fraud?fraudAccount=${fraudAccount}">피해 추가 등록하기</a>
                        </td>
                    </tr>
                </table>
            </div>
        </c:if>

        <c:if test="${searchFraud == null && param.fraudAccount != null}">
            <div class="no-result">
                <h3>신고 건수 없음</h3>
                <span>신고 내역이 없는 경우에도 안전한 거래라는 것을 보장할 수는 없습니다.</span>
            </div>
        </c:if>
    </div>
       
        		<footer>
        	<%@include file="../../bottom.jsp" %>
    	</footer>
</main>
</body>
</html>
