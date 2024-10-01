<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>피해 등록</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    $('form').submit(function(event) {
        event.preventDefault(); // 기본 폼 제출 방지
        
        $.ajax({
            type: 'POST',
            url: 'updateFraud.fraud',
            data: $(this).serialize(),
            success: function(response) {
                alert('신고가 완료됐습니다.');
                window.location.href = 'fraud.fraud'; // 업데이트 후 이동할 페이지 설정
            },
            error: function() {
                alert('신고 처리 중 오류가 발생했습니다.');
            }
        });
    });
});
</script>
<link rel="stylesheet" type="text/css" href="resources/css/header/fraud/fraudUpdate.css">

</head>
<body>
<main>
	
		<header>
			<%@include file="../../Header.jsp"%>	
		</header>
		
    <div class="container1">
        <div class="header">
            <h2><b>안전하고 편리한<br>중고거래 서비스</b></h2>
            <h5>거래 전 사기 이력 조회부터<br>예상치 못한 피해 시 거래 피해 보상체까지</h5>
        </div>
        <hr>
        <div class="section">
            <h3><b>추가 피해 등록</b></h3>
            <h5>사기 피해를 입으셨나요?</h5>
            <h5>다른 이용자에게도 피해사실을 알려주세요.</h5>
        </div>
        <div class="updateFraud">
            <form>
                <h3>신고 대상</h3>
                <input type="text" name="fraudAccount" value="${fraudAccount}" readOnly><br>
                <h3>피해 금액</h3>
                <input type="text" name="fraudTotalCost" placeholder="피해 금액을 작성해주세요"><br>
                <input type="submit" value="추가 신고하기">
            </form>
        </div>
    </div>
    
            		<footer>
        	<%@include file="../../bottom.jsp" %>
    	</footer>
</main>
</body>
</html>
