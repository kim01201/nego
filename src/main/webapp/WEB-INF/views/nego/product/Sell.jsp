<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>판매창</title>
    <link rel="stylesheet" type="text/css" href="resources/css/product/Sell_styles.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript">
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
        $('#category-level-' + level + ' li').not(element).css({
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
        
        document.getElementById('img').addEventListener('change', function(event) {
            console.log("File input changed");
            previewImage(event);  // 파일 선택 시 이미지 미리보기 함수 호출
        });
    });
    
    function togglePrice() {
        var priceField = document.getElementById("price");
        var freeCheckbox = document.getElementById("free");
        if (freeCheckbox.checked) {
            priceField.value = "0";
            priceField.setAttribute("readonly", true);
        } else {
            priceField.removeAttribute("readonly");
            priceField.value = ""; // 가격 필드를 빈 문자열로 설정하여 사용자가 다시 입력할 수 있도록 함
        }
    }
    
    function previewImage(event) {
        var reader = new FileReader();
        console.log("FileReader created:", reader);
        reader.onload = function(e) {
            console.log("File loaded");
            var preview = document.getElementById('imagePreview');
            console.log("Preview element:", preview);
            preview.src = e.target.result;  // 이미지 데이터를 preview.src에 설정
            preview.style.display = 'block';  // 이미지 미리보기를 보이도록 설정
        }
        console.log("Reading file");
        reader.readAsDataURL(event.target.files[0]);  // 파일을 읽어서 데이터 URL로 변환
    }

    // 파일 선택(input 변경) 이벤트에 대한 리스너 추가
    document.getElementById('img').addEventListener('change', function(event) {
        console.log("File input changed");
        previewImage(event);  // 파일 선택 시 이미지 미리보기 함수 호출
    });

    function validateForm() {
        var pcategory1 = document.getElementById('pcategory1').value;
        var pcategory2 = document.getElementById('pcategory2').value;
        var pcategory3 = document.getElementById('pcategory3').value;

        if (!pcategory1 && !pcategory2 && !pcategory3) {
            alert("카테고리를 선택해 주세요");
            return false;
        }

        return true;
    }
    
    </script>

</head>
<body>
<main>
<header>
<%@include file="../Header.jsp" %>
</header>

    <div class="container1">
    	
    
        <h2>판매하기</h2>
        <br>

        <form action="insert_comp.prod" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        	<input type="hidden" id="member_id" name="member_id" value="${sessionScope.mbId.id}">
            <div class="form-group">
                <label for="pname">제목</label>
                <input class="input" type="text" id="pname" name="pname" required>
            </div>
            <div class="form-group">
                <label for="img">상품이미지</label><br>
                <input type="file" id="img" name="img"><br>
                <img id="imagePreview" src="" alt="이미지 미리보기" style="max-width: 200px; height: auto; display: none;">
            </div>

            <div class="form-group">
                <label for="category">카테고리</label>
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

            <input type="hidden" id="pcategory1" name="pcategory1">
            <input type="hidden" id="pcategory2" name="pcategory2">
            <input type="hidden" id="pcategory3" name="pcategory3">

			
			
            <div class="form-group">
                <label for="pdescription">내용</label>
                <textarea id="pdescription" name="pdescription" rows="10" required></textarea>
            </div>
            <div class="form-group">
                <label for="price">가격</label>
                <input class="input" type="text" id="price" name="price" required>
            </div>
            <div class="form-group">
                <label>무료나눔</label>
                <input type="checkbox" id="free" name="free" label="무료나눔" value="5" onchange="togglePrice()">
            </div>
            <div class="form-group">
                <label for="pdeliverytype">거래방식</label>
                <select id="pdeliverytype" name="pdeliverytype">
                    <option value="택배">택배</option>
                    <option value="직거래">직거래</option>
                </select>
            </div>
            <div class="form-group">
                <label for="pcontent">상품상태</label>
                <select id="pcontent" name="pcontent">
                    <option value="used">중고</option>
                    <option value="new">새제품</option>
                </select>
            </div>
            <div class="buttons">
                <input type="submit" class="green-btn" value="등록">
                <input type="reset" class="red-btn" value="취소">
            </div>

        </form>
    </div>
<footer>
    <%@include file="../bottom.jsp" %>
</footer>
</main>
</body>
</html>