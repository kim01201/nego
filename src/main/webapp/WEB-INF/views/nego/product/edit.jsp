<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>수정창</title>
    <link rel="stylesheet" type="text/css" href="resources/css/product/Sell_styles.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="<c:url value='/resources/js/product/sell.js' />" defer/></script>
	<script>
		var existingMainCategory = ${getProd.pcategory1}; // 정수형으로 변환
		var existingSubCategory1 = ${getProd.pcategory2}; // 정수형으로 변환
		var existingSubCategory2 = ${getProd.pcategory3}; // 정수형으로 변환
		
		console.log('Existing values:', existingMainCategory, existingSubCategory1, existingSubCategory2);
		
		
		function loadSubCategories(parentId, level, selectedCategoryId) {
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
		
		                    if (category.id == selectedCategoryId) { // 값 비교 수정
		                        li.addClass('selected');
		                        setCategoryValues(category.id, level);
		                        loadSubCategories(category.id, nextLevel, level === 1 ? existingSubCategory1 : existingSubCategory2);
		                    }
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
		
		$(document).ready(function () {
		    if (existingMainCategory) {
		    	setTimeout(function() {
		        var selectedMainCategory = $('[data-id="' + existingMainCategory + '"]');
		        highlightSelection(selectedMainCategory, 1);
		        loadSubCategories(existingMainCategory, 1, existingSubCategory1);
		    	}, 10);
		
		        if (existingSubCategory1) {
		            setTimeout(function() {
		                var selectedSubCategory1 = $('[data-id="' + existingSubCategory1 + '"]');
		                highlightSelection(selectedSubCategory1, 2);
		                loadSubCategories(existingSubCategory1, 2, existingSubCategory2);
		            }, 500);
		        }
		
		        if (existingSubCategory2) {
		            setTimeout(function() {
		                var selectedSubCategory2 = $('[data-id="' + existingSubCategory2 + '"]');
		                highlightSelection(selectedSubCategory2, 3);
		            }, 1000);
		        }
		    }
		});
		
		function highlightSelection(element, level) {
		    $('#category-level-' + level + ' li').removeClass('selected');
		    element.addClass('selected');
		    $('#category-level-' + level + ' li.selected').css({
		        'background-color': '#007bff',
		        'color': 'white'
		    });
		    $('#category-level-' + level + ' li').not('.selected').css({
		        'background-color': '',
		        'color': ''
		    });
		}
		
		function togglePrice() {
		    var priceField = document.getElementById("price");
		    var freeCheckbox = document.getElementById("free");
		    if (freeCheckbox.checked) {
		        priceField.value = "0";
		        priceField.setAttribute("readonly", true);
		    } else {
		        priceField.removeAttribute("readonly");
		        priceField.value = "";
		    }
		}
		
		function triggerFileInput() {
		    document.getElementById('img').click();
		}
		
		function previewImage(event) {
		    var reader = new FileReader();
		    reader.onload = function(e) {
		        var output = document.getElementById('imagePreview');
		        output.src = e.target.result;
		        output.style.display = 'inline-block';
		    }
		    reader.readAsDataURL(event.target.files[0]);
		}
	</script>

</head>
<body>
<main>
<header>
<%@include file="../Header.jsp" %>
</header>

    <div class="container1">
        <h2>상품 수정하기</h2>
        <br>
        <form action="edit_comp.prod?pnum=${getProd.pnum}" method="post" enctype="multipart/form-data">
            <input type="hidden" id="pnum" name="pnum" value="${getProd.pnum}">
            <input type="hidden" id="member_id" name="member_id" value="${sessionScope.mbId.id}">
            <div class="form-group">
                <label for="pname">제목</label>
                <input class="input" type="text" id="pname" name="pname" value="${getProd.pname}" required>
            </div>
            <div class="form-group">
                <label for="img">상품이미지를 수정하려면 이미지를 클릭하세요</label><br>
                <img id="imagePreview" src="${pageContext.request.contextPath}/resources/images/${getProd.pimage}" width="150px" height="150px" style="display: inline-block;" onclick="triggerFileInput()" style="cursor: pointer;">
                <input type="file" id="img" name="img" style="display: none;" onchange="previewImage(event)">
                <input type="hidden" id="previousImg" name="previousImg" value="${getProd.pimage}">
            </div>
    
            <div class="form-group">
                <label for="category">카테고리</label>
                <section name="productCategory">
                    <div class="category-container">
                        <div id="category-level-1" class="category-level">
                            <ul>
                               <c:forEach var="mainCategory" items="${mainList}">
                                <li id="main-${mainCategory.id}" data-id="${mainCategory.id}" class="mainCategory">
                                    ${mainCategory.name}
                                </li>
                            </c:forEach>
                            </ul>
                        </div>
                        <div id="category-level-2" class="category-level"></div>
                        <div id="category-level-3" class="category-level"></div>
                    </div>
                </section>
            </div>

            <input type="hidden" id="pcategory1" name="pcategory1" value="${getProd.pcategory1}">
            <input type="hidden" id="pcategory2" name="pcategory2" value="${getProd.pcategory2}">
            <input type="hidden" id="pcategory3" name="pcategory3" value="${getProd.pcategory3}">

            <div class="form-group">
                <label for="pdescription">내용</label>
                <textarea id="pdescription" name="pdescription" rows="10" required>${getProd.pdescription}</textarea>
            </div>
            <div class="form-group">
                <label for="price">가격</label>
                <input class="input" type="text" id="price" name="price" value="${getProd.price}">
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
                <select id="pcontent" name="pcontent" value="${getProd.pcontent}">
                    <option value="used">중고</option>
                    <option value="new">새제품</option>
                </select>
            </div>
            <div class="buttons">
                <input type="submit" class="green-btn" value="수정">
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
