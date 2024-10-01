<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="resources/css/admin/adminStyle.css">
    <script>
    $(document).ready(function() {
        $('.nav-link').on('click', function(e) {
            e.preventDefault();
            var url = $(this).attr('href');
            $('#main-content').load(url, function(response, status, xhr) {
                if (status == "error") {
                    var msg = "Sorry but there was an error: ";
                    $('#main-content').html(msg + xhr.status + " " + xhr.statusText);
                }
            });
        });
    });
    </script>

</head>
<body>
<main>
<header>
    <%@include file="../Header.jsp" %>
</header>

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-3 col-lg-2 d-md-block bg-light sidebar">
            <div class="position-sticky">
                <div class="pt-3">
                    <h2>관리자 페이지</h2>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="user.do">회원정보관리</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="cate.do">카테고리관리</a> <!-- 카테고리 관리 링크 추가 -->
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="prod.do">상품관리</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="fraud.do">신고관리</a>
                    </li>
                </ul>
            </div>
        </nav>
        
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div id="main-content" class="main-content pt-3">
                <h1>관리자 대시보드</h1>
                <p>좌측 메뉴를 사용하여 관리할 섹션을 선택하세요.</p>
            </div>
        </div>
    </div>
</div>

<footer>
    <%@include file="../bottom.jsp" %>
</footer>
</main>
</body>
</html>
