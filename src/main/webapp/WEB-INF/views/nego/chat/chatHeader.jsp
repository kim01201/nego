<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- ChatHeader.jsp -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat Header</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/chat/ChatHeader.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery CDN 추가 -->

    <!-- 서버 측 데이터를 가져오는 스크립트 -->
    <script>
    $(document).ready(function() {
        function getParameterByName(name) {
            const url = window.location.href;
            name = name.replace(/[\[\]]/g, '\\$&');
            const regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, ' '));
        }

        const pnum = getParameterByName('pnum');
        const receiver_id = getParameterByName('receiver_id'); // receiver_id 값을 추출

        console.log('URL에서 추출한 pnum: ', pnum);
        console.log('URL에서 추출한 receiver_id: ', receiver_id);

        if (pnum) {
            $.ajax({
                type: "GET",
                url: "${pageContext.request.contextPath}/getProductForChatHeader",
                data: {
                    pnum: pnum,
                    receiver_id: receiver_id
                },
                success: function(response) {
                    try {
                        console.log("Server response: ", response);
                        $(".store-name").text(response.product.member_id);
                        $(".trust-score").text(response.member.trust_score);
                        $(".product-name").text(response.product.pname);
                        $(".product-price").text(response.product.price + "원");
                        $(".product-img").attr("src", "${pageContext.request.contextPath}/resources/images/" + response.product.pimage);
                        $(".product-img").attr("alt", response.product.pname);
                        $(".product-detail").attr("href", "${pageContext.request.contextPath}/productdetail.jsp?pnum=" + pnum); // 상세 페이지 링크 설정
                    } catch (e) {
                        console.error("Error processing response: ", e);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Ajax request failed: ", status, error);
                    alert("상품 정보를 가져오는 데 실패했습니다.");
                }
            });
        } else {
            console.error("No pnum parameter found in URL.");
        }
    });
    </script>
</head>
<body>
    <div class="chat-top-1">
        <div class="sec1">
            <a href="chatroom.jsp">
                <img src="${pageContext.request.contextPath}/resources/img/back.jpg" alt="back Image" style="width:20px;height:20px;border-radius:50%">
            </a>
        </div>
        <div class="sec2">
            <p class="font-semibold text-jnGray-900 store-name"></p>
            <p class="text-base font-medium">신뢰지수<span class="ml-1 text-lg font-semibold trust-score"></span></p>
            
        </div>
    </div>
    
    <div class="chat-top-2">
        <div class="sec1">
            <a href="#" class="product-detail"> <!-- productdetail.html 대신 #으로 임시 대체 -->
                <img src="" class="d-block w-100 product-img" alt="">
            </a>
        </div>
        <div class="sec2">
            <div class="content product-name"></div>
            <div class="content product-price"></div>
        </div>
    </div>
</body>
</html>
