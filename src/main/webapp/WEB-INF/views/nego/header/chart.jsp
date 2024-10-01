<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>시세조회</title>
    <link rel="stylesheet" type="text/css" href="resources/css/header/chartStyle.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.js"></script>
    
    <script>
    $(document).ready(function() {
        // 카테고리 검색 버튼 클릭 시
        $('button[name="cateSearch"]').click(function() {
            var categoryElement = document.querySelector('#category-level-3 .selected') || 
                                  document.querySelector('#category-level-2 .selected') || 
                                  document.querySelector('#category-level-1 .selected');

            if (categoryElement) {
                var category = categoryElement.getAttribute('data-id').trim();

                $.ajax({
                    url: "${pageContext.request.contextPath}/marketPriceByCategory.prod",
                    type: "POST",
                    data: {
                        category: category
                    },
                    dataType: "json",
                    success: function(data) {
                        console.log(data); // 데이터 확인을 위해 추가
                        if (data.length > 0 && !data.every(value => value === null)) {
                            $('#priceAmount').text(formatCurrency(data[data.length - 1]));
                            $('#price').show();
                            $('#chart').show();
                            $('#searchMessage').hide();
                            updateGraph1(data, categoryElement.textContent.trim());
                        } else {
                            $('#price').hide();
                            $('#chart').hide();
                            $('#searchMessage').show();
                        }
                    },
                    error: function(xhr, status, error) {
                        console.log('데이터를 가져오는 중 오류가 발생했습니다. 오류: ' + error + '\n상태: ' + status + '\n응답: ' + xhr.responseText);
                        alert('데이터를 가져오는 중 오류가 발생했습니다. 오류: ' + error + '\n상태: ' + status + '\n응답: ' + xhr.responseText);
                    }
                });
            } else {
                alert('카테고리를 선택해주세요');
            }
        });

        // 상품명 검색 버튼 클릭 시
        $('button[name="prodSearch"]').click(function() {
            if ($('#product').val() == '') {
                alert('검색어를 작성해주세요');
                $('#product').focus();
            } else {
                var product = $('#product').val().trim();
                console.log("sdfa",product);
                
                $.ajax({
                    url: "${pageContext.request.contextPath}/marketPrice.prod",
                    type: "POST",
                    data: { product: product },
                    dataType: "json",
                    success: function(data) {
                        console.log(data); // 데이터 확인을 위해 추가
                        if (data.length > 0 && !data.every(value => value === null)) {
                            $('#priceAmount').text(formatCurrency(data[data.length - 1]));
                            $('#price').show();
                            $('#chart').show();
                            $('#searchMessage').hide();
                            updateGraph(data, product);
                        } else {
                            $('#price').hide();
                            $('#chart').hide();
                            $('#searchMessage').show();
                        }
                    },
                    error: function(xhr, status, error) {
                        console.log('데이터를 가져오는 중 오류가 발생했습니다. 오류: ' + error + '\n상태: ' + status + '\n응답: ' + xhr.responseText);
                        alert('데이터를 가져오는 중 오류가 발생했습니다. 오류: ' + error + '\n상태: ' + status + '\n응답: ' + xhr.responseText);
                    }
                });
            }
        });

        // 통화 포맷 함수
        function formatCurrency(amount) {
            return amount.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }

        // 그래프 업데이트 함수 (상품명으로)
        function updateGraph(data, productName) {
            let newData = data.map(function(value) {
            	console.log("dddd",data);
                return Math.floor(value);
            });

            let context = document.getElementById('myChart').getContext('2d');
           
            let myChart = new Chart(context, {
                type: 'line',
                data: {
                    labels: ['4주 전', '3주 전', '2주 전', '1주 전', '이번 주'],
                    datasets: [{
                        label: productName + '의 시세',
                        fill: true,
                        data: newData,
                        backgroundColor: 'rgba(80, 188, 223, 0.5)',
                        borderColor: 'rgba(80, 188, 223, 1)',
                        borderWidth: 3
                    }]
                },
                options: {
                    responsive : false,
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true
                            }
                        }]
                    }
                }
            });
        }

        // 그래프 업데이트 함수 (카테고리로)
        function updateGraph1(data, categoryName) {
            let newData = data.map(function(value) {
                return Math.floor(value);
            });

            let context = document.getElementById('myChart').getContext('2d');
            let myChart = new Chart(context, {
                type: 'line',
                data: {
                    labels: ['4주 전', '3주 전', '2주 전', '1주 전', '이번 주'],
                    datasets: [{
                        label: categoryName + '의 시세',
                        fill: true,
                        data: newData,
                        backgroundColor: 'rgba(80, 188, 223, 0.5)',
                        borderColor: 'rgba(80, 188, 223, 1)',
                        borderWidth: 3
                    }]
                },
                options:{  responsive : false,
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true
                            }
                        }]
                    }
                }
            });
        }
        
        // 카테고리 로드
        function loadSubCategories(parentId, level) {
            $.ajax({
                url: 'getSubCategories.do',
                type: 'GET',
                data: { parentId: parentId },
                dataType: 'json',
                success: function (data) {
                    var nextLevel = level + 1;
                    var container = $('#category-level-' + nextLevel);

                    if (container.length === 0) {
                        container = $('<div></div>').attr('id', 'category-level-' + nextLevel);
                        $('.category-container').append(container);
                    }

                    if (data.length === 0) {
                        $('#category-level-' + (nextLevel)).empty();
                        $('#category-level-' + (nextLevel+1)).empty();
                    }
                    
                    container.empty();
                    if (data.length > 0) {
                        var ul = $('<ul></ul>');
                        $.each(data, function (index, category) {
                            var li = $('<li></li>').text(category.name).attr('data-id', category.id).click(function () {
                                loadSubCategories(category.id, nextLevel);
                                setCategoryValues(category.id, nextLevel);
                                highlightSelection($(this), nextLevel);
                            });
                            ul.append(li);
                        });
                        container.append(ul);
                    }
                }
            });
        }

        function setCategoryValues(categoryId, level) {
            $('#pcategory' + level).val(categoryId);
            for (var i = level + 1; i <= 3; i++) {
                $('#pcategory' + i).val('');
            }
        }

        function highlightSelection(element, level) {
            $('#category-level-' + level + ' li').removeClass('selected');
            element.addClass('selected');
            
            element.css({
                'background-color': '#007bff', // 원하는 배경색
                'color': 'white', // 원하는 글자색
            });
            
            // 이전에 선택된 요소의 스타일 초기화
            $('#category-level-' + level+ ' li').not(element).css({
                'background-color': '',
                'color': ''
            });
        }

        $(document).ready(function () {
            $('#category-level-1 li').click(function () {
                var categoryId = $(this).attr('data-id');
                loadSubCategories(categoryId, 1);
                setCategoryValues(categoryId, 1);
                highlightSelection($(this), 1);
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

    <h2 align="center">원하시는 상품이 얼마에 거래되고 있는지 알아보세요</h2>
    <div class="form-group" align="center">
        <label for="category">카테고리로 검색하기</label><br>
        <div class="form-group">
                <section name="productCategory">
                    <div class="category-container">
                        <div id="category-level-1">
                        <ul>
                                <c:forEach var="mainCategory" items="${mainList}">
                                    <li id="main-${mainCategory.id}" data-id="${mainCategory.id}" class="mainCategory">
                                        ${mainCategory.name}
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                        <div id="category-level-2"></div>
                        <div id="category-level-3"></div>
                    </div>
                </section>
            </div>
        <button type="button" name="cateSearch">검색</button>
    </div>
    <br><br><br>
    <div class="search-box" align="center">
        <label for="product">상품명으로 검색하기</label><br>
        <input type="text" id="product" placeholder="어떤 시세 정보가 궁금하세요?">
        <button type="button" name="prodSearch">검색</button>
    </div>

    <div class="price-display" align="center" id="price" style="display: none;">
        <h2>시세금액: <span id="priceAmount"></span></h2>
    </div>
    <div class="search-message" align="center" id="searchMessage" style="display: none;">
        <p>검색한 상품 시세는 준비중입니다.<br>빠르게 확인 드릴 수 있도록 노력하겠습니다!</p>
        <img src="resources/icon/no-data.png" alt="no-data" width="200px" height="auto">
    </div>

    <div class="container1" align="center" id="chart">
        <canvas id="myChart" width="1000px" height="600px"></canvas>
    </div>

    <footer>
        <%@include file="../bottom.jsp" %>
    </footer>
</main>
</body>
</html>
