<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>배송지 관리</title>
    <link rel="stylesheet" type="text/css" href="resources/css/mypage/addressStyles.css">

    <script>
        // 배송지 추가 관련 스크립트
        function openAddressPopup() {
            document.getElementById('addresspop').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
        }

        function closeAddressPopup() {
            document.getElementById('addresspop').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
        }

        function sample4_execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function (data) {
                    var roadAddr = data.roadAddress;
                    var extraRoadAddr = '';

                    if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                        extraRoadAddr += data.bname;
                    }
                    if (data.buildingName !== '' && data.apartment === 'Y') {
                        extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    if (extraRoadAddr !== '') {
                        extraRoadAddr = ' (' + extraRoadAddr + ')';
                    }

                    document.getElementById("postcode").value = data.zonecode;
                    document.getElementById("road_address").value = roadAddr;
                }
            }).open();
        }

        function insertAdd() {
            var id = $('#id').val();
            var member_id = $('#member_id').val();
            var nickname = $('#nickname').val();
            var name = $('#name').val();
            var phone = $('#phone').val();
            var postcode = $('#postcode').val();
            var road_address = $('#road_address').val();
            var detail_address = $('#detail_address').val();

            $.ajax({
                url: 'insert_add.do',
                type: 'POST',
                data: {
                    id: id,
                    member_id: member_id,
                    nickname: nickname,
                    name: name,
                    phone: phone,
                    postcode: postcode,
                    road_address: road_address,
                    detail_address: detail_address
                },
                success: function (response) {
                    if (response === "success") {
                        location.reload();
                        alert('배송지 등록에 성공했습니다.');
                    } else if (response === "full") {
                        location.reload();
                        alert('배송지는 5개만 등록 할 수 있습니다.');
                    } else {
                        location.reload();
                        alert('배송지 등록에 실패했습니다.');
                    }
                }
            });
        }
    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
<div align="center">
    <h2>배송지 관리</h2>
    <c:if test="${empty addList}">
        <div style="text-align: center; margin-bottom: 20px;">
            등록된 배송지가 없습니다.
        </div>
    </c:if>

    <c:forEach var="dto" items="${addList}">
        <div class="address-card">
            <div class="info">
                <div>장소: ${dto.nickname}</div>
                <div>이름: ${dto.name}</div>
                <div>번호: ${dto.phone}</div>
                <div>주소: [${dto.postcode}] ${dto.road_address}, ${dto.detail_address}</div>
            </div>
            <div class="delete-form">
                <form action="delete_add.do?member_id=${sessionScope.mbId.id}" method="post" style="display: inline;">
                    <input type="hidden" name="id" value="${dto.id}">
                    <input type="submit" value="삭제">
                </form>
            </div>
        </div>
    </c:forEach>

   <div style="text-align: center; margin-top: 20px;">
    <button onclick="openAddressPopup()" style="padding: 10px 20px; background-color: #007bff; color: #fff; border: none; border-radius: 3px; cursor: pointer; transition: background-color 0.3s;">
       	 배송지 추가
    </button>
</div>
</div>

<!-- 배송지 추가 팝업 -->
<div id="addresspop" class="popup">
    <div class="popup-content">
        <span id="closePopupBtn" class="close-btn" onclick="closeAddressPopup()">&times;</span>
        <div align="center" class="address-container">
            <h1>배송지 추가</h1>
            <form name="f" onsubmit="event.preventDefault(); insertAdd();">
                <input type="text" id="nickname" name="nickname" maxlength="10" placeholder="배송지명 (최대 10글자)" required>
                <input type="text" id="name" name="name" placeholder="이름" required>
                <input type="tel" id="phone" name="phone" placeholder="전화번호" required>
                <input type="text" id="road_address" name="road_address" placeholder="주소 검색" onclick="sample4_execDaumPostcode()" required>
                <input type="text" id="detail_address" name="detail_address" placeholder="상세주소 (예시: 101동 101호)" required>
                <input type="hidden" id="postcode" name="postcode">
                <input type="hidden" id="member_id" name="member_id" value="${sessionScope.mbId.id}">
                <input type="submit" value="추가">
            </form>
        </div>
    </div>
</div>

<div id="overlay" class="overlay" onclick="closeAddressPopup()"></div>
</body>
</html>
