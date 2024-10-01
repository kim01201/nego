<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- reviewsWrite.jsp -->
<html>
<head>
    <title>후기 작성</title>
    <link rel="stylesheet" type="text/css" href="resources/css/header/gboard/gboardWrite.css">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            let goodPointsRadios = document.querySelectorAll('input[name="goodPoints"]');
            let badPointsRadios = document.querySelectorAll('input[name="badPoints"]');

            function handleRadioClick(event) {
                let selected = event.target;
                let selectedGroup = selected.name;
                let otherGroup = selectedGroup === 'goodPoints' ? 'badPoints' : 'goodPoints';

                let radios = document.querySelectorAll('input[name="' + selectedGroup + '"]');
                let otherRadios = document.querySelectorAll('input[name="' + otherGroup + '"]');

                // 클릭된 라디오 버튼이 이미 선택되어 있는 경우 선택 해제
                if (selected.previousChecked) {
                    selected.checked = false;
                }

                // 다른 라디오 버튼의 이전 선택 상태 초기화
                radios.forEach(function(radio) {
                    radio.previousChecked = false;
                });

                // 현재 라디오 버튼의 이전 선택 상태 설정
                selected.previousChecked = selected.checked;

                // 다른 그룹의 라디오 버튼 선택 해제
                otherRadios.forEach(function(radio) {
                    radio.checked = false;
                    radio.previousChecked = false;
                });
            }

            // 각 라디오 버튼에 클릭 이벤트 핸들러 추가
            goodPointsRadios.forEach(function(radio) {
                radio.addEventListener('click', handleRadioClick);
            });

            badPointsRadios.forEach(function(radio) {
                radio.addEventListener('click', handleRadioClick);
            });

         // 폼 제출 시 라디오 버튼 선택 여부 확인
            document.querySelector('form[name="f"]').onsubmit = function() {
                var isGoodPointSelected = Array.prototype.some.call(goodPointsRadios, function(radio) {
                    return radio.checked;
                });
                var isBadPointSelected = Array.prototype.some.call(badPointsRadios, function(radio) {
                    return radio.checked;
                });

                if (!isGoodPointSelected && !isBadPointSelected) {
                    alert('좋은 점과 나쁜 점 중 하나를 선택해주세요.');
                    return false; // 폼 제출을 막음
                }

                return true; // 폼 제출 허용
            };
        });
    </script>
</head>
<body>
<main>
<header>
    <%@include file="../Header.jsp"%>
</header>
<div class="container1">
    <div align="center">
        <form name="f" action="insert_reviews.do" method="post" onsubmit="return check()">                                    
            <input type="hidden" name="product_id" value="${getBuyCompleted.pnum}"/>
            <h3 style="color: #007bff;">후기글 작성</h3><br>
            <table>
                <tr>
                    <th>작성자</th>
                    <td>
                        <input type="text" name="sender_id" class="box" value="${sessionScope.mbId.id}" readOnly>
                    </td>
                </tr>
                <tr>
                    <th>판매자</th>
                    <td>
                        <input type="text" name="receiver_id" class="box" value="${getProd.member_id}" readOnly>
                    </td>
                </tr>
                <tr>
                    <th>상품 이름</th>
                    <td>
                        <input type="text" name="product_name" class="box" size="50" value="${getBuyCompleted.pname}" readOnly>
                    </td>
                </tr>
                <tr>
                    <th>내 용</th>
                    <td><textarea name="content" rows="11" cols="50" class="box"></textarea></td>
                </tr>
                <tr>
                    <th>이런점이 좋았어요</th>
                    <td>
                        <div class="radio-group">
                            <label><input type="radio" name="goodPoints" value="친절/매너가 좋아요"> 친절/매너가 좋아요</label>
                            <label><input type="radio" name="goodPoints" value="응답이 빨라요"> 응답이 빨라요</label>
                            <label><input type="radio" name="goodPoints" value="상품 상태가 좋아요"> 상품 상태가 좋아요</label>
                            <label><input type="radio" name="goodPoints" value="택배 거래가 수월했어요"> 택배 거래가 수월했어요</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>이런점이 안 좋았어요</th>
                    <td>
                        <div class="radio-group">
                            <label><input type="radio" name="badPoints" value="친절하지 않았어요"> 친절하지 않았어요</label>
                            <label><input type="radio" name="badPoints" value="응답이 느려요"> 응답이 느려요</label>
                            <label><input type="radio" name="badPoints" value="상품 상태가 나빠요"> 상품 상태가 나빠요</label>
                            <label><input type="radio" name="badPoints" value="택배 거래가 원활하지 않았어요"> 택배 거래가 원활하지 않았어요</label>
                        </div>
                    </td>
                </tr>
                <tr style="background-color: #ffffff;">
                    <td colspan="2" align="center">
                        <div class="btn-group">
                            <input type="submit" value="글쓰기">
                            <input type="reset" value="다시작성">
                            <input type="button" value="목록보기" onclick="window.location='allCompleted.prod'">
                        </div>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<footer>
    <%@include file="../bottom.jsp" %>
</footer>
</main>
</body>
</html>
