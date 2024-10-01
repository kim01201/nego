<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>카테고리 관리 페이지</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="resources/css/admin/adminCategory.css">
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
                } else {
                    $('#category-level-' + nextLevel).empty();
                }
            }
        });
    }

    function setCategoryValues(categoryId, level) {
        $('#pcategory' + level).val(categoryId);
        $('#selectedCategoryId').val(categoryId);
        $('#selectedLevel').val(level);
    }

    function highlightSelection(element, level) {
        $('#category-level-' + level + ' li').removeClass('selected');
        element.addClass('selected');

        element.css({
            'background-color': '#007bff',
            'color': 'white',
        });

        $('#category-level-' + level + ' li').not(element).css({
            'background-color': '',
            'color': ''
        });
    }

    function addMainCategory() {
        var name = $('#mainCategoryName').val();

        if (name) {
            $.ajax({
                url: 'insertCate.do',
                type: 'POST',
                data: { name: name },
                success: function(response) {
                    if (response === "success") {
                        location.reload();
                        alert('최상위 카테고리 등록에 성공했습니다.');
                    } else {
                        alert('최상위 카테고리 등록에 실패했습니다.');
                    }
                }
            });
        } else {
            alert('카테고리 이름을 입력하십시오.');
        }
    }

    function addSubCategory() {
        var name = $('#subCategoryName').val();
        var parentId = $('#selectedCategoryId').val();
        var level = parseInt($('#selectedLevel').val());

        if (name && parentId && level) {
            if (level === 3) {
                alert('최하위 카테고리는 선택할 수 없습니다.');
                return;
            }
            $.ajax({
                url: 'insertSubCate.do',
                type: 'POST',
                data: { name: name, parentId: parentId, level: level },
                success: function(response) {
                    if (response === "success") {
                        loadSubCategories(parentId, level);
                        $('#subCategoryName').val('');
                        alert('하위 카테고리 등록에 성공했습니다.');
                    } else {
                        alert('하위 카테고리 등록에 실패했습니다.');
                    }
                }
            });
        } else {
            alert('카테고리와 하위 카테고리 이름을 선택하십시오.');
        }
    }

    $(document).ready(function() {
        // 최상위 카테고리를 클릭했을 때
        $('#category-level-1').on('click', 'li', function() {
            var categoryId = $(this).attr('data-id');
            var categoryName = $(this).text();
            var level = 1;
            loadSubCategories(categoryId, level);
            setCategoryValues(categoryId, level);
            highlightSelection($(this), level);
            
            // 선택된 카테고리 이름을 두 입력 필드에 모두 넣기
            $('#cateName').val(categoryName);
            $('#cateDelete').val(categoryName);
            $('#subCategoryName').val(categoryName);
            console.log('선택된 카테고리 아이디:', categoryId, '레벨:', level);
        });

        // 하위 카테고리를 클릭했을 때
        $('#category-level-2').on('click', 'li', function() {
            var categoryId = $(this).attr('data-id');
            var categoryName = $(this).text();
            var level = 2;
            loadSubCategories(categoryId, level);
            setCategoryValues(categoryId, level);
            highlightSelection($(this), level);
            
            // 선택된 카테고리 이름을 두 입력 필드에 모두 넣기
            $('#cateName').val(categoryName);
            $('#cateDelete').val(categoryName);
            $('#subCategoryName').val(categoryName);
            console.log('선택된 카테고리 아이디:', categoryId, '레벨:', level);
        });

        // 최하위 카테고리를 클릭했을 때
        $('#category-level-3').on('click', 'li', function() {
            var categoryId = $(this).attr('data-id');
            var categoryName = $(this).text();
            var level = 3;
            setCategoryValues(categoryId, level);
            highlightSelection($(this), level);
            
            // 선택된 카테고리 이름을 세 입력 필드에 모두 넣기
            $('#cateName').val(categoryName);
            $('#cateDelete').val(categoryName);
            $('#subCategoryName').val(categoryName);
            console.log('선택된 카테고리 아이디:', categoryId, '레벨:', level);
        });
    });


    function editCategory() {
        var newName = $('#cateName').val();
        var categoryId = $('#selectedCategoryId').val();

        if (newName && categoryId) {
            $.ajax({
                url: 'editCate.do',
                type: 'POST',
                data: { id: categoryId, name: newName },
                success: function(response) {
                    if (response === "success") {
                        alert('카테고리 이름이 성공적으로 변경되었습니다.');
                        location.reload();
                    } else {
                        alert('카테고리 이름 변경에 실패했습니다.');
                    }
                },
                error: function() {
                    alert('서버 오류로 카테고리 이름을 변경할 수 없습니다.');
                }
            });
        } else {
            alert('카테고리 이름을 입력하고, 수정할 카테고리를 선택해 주세요.');
        }
    }

    function deleteCategory() {
        var categoryId = $('#selectedCategoryId').val();

        $.ajax({
            url: 'deleteCate.do',
            type: 'POST',
            data: { id: categoryId },
            success: function(response) {
                if (response === "success") {
                    alert('카테고리가 삭제되었습니다.');
                    location.reload();
                } else {
                    alert('카테고리 삭제를 실패했습니다.');
                }
            },
            error: function() {
                alert('서버 오류로 카테고리 삭제 할 수 없습니다.');
            }
        });
    }
	</script>
</head>
<body>
    <h1>카테고리 관리 페이지</h1>
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
    
    <br>
    
    <h2 class="section-title">카테고리 등록</h2>
<div style="display: flex; justify-content: space-between; margin-bottom: 20px; padding-top:5px;">
    <div style="width: calc(50% - 10px);">
        <div class="form-container">
            <form name="f" onsubmit="event.preventDefault(); addMainCategory();" class="category-form">
                <table border="1">
                	<caption>
                    	<h5>최상위 카테고리 등록</h5>
                	</caption>
                    <tr>
                        <th bgcolor="yellow">카테고리 이름</th>
                        <td><input type="text" id="mainCategoryName" class="box"></td>
                    </tr>
                    <tr bgcolor="orange">
                        <td colspan="2" align="center"><input type="submit" value="등록"> <input type="reset" value="취소"></td>
                    </tr>
                </table>
            </form>
        </div>
    </div>

    <div style="width: calc(50% - 10px);">
        <div class="form-container">
            <form name="f2" onsubmit="event.preventDefault(); addSubCategory();" class="category-form">
                <table border="1">
                	<caption>
                    	<h5>하위 카테고리 등록</h5>
                	</caption>
                    <tr>
                        <th bgcolor="yellow">하위 카테고리 이름</th>
                        <td><input type="text" id="subCategoryName" class="box"></td>
                    </tr>
                    <tr bgcolor="orange">
                        <td colspan="2" align="center"><input type="submit" value="등록"> <input type="reset" value="취소"></td>
                    </tr>
                </table>
                <input type="hidden" id="selectedCategoryId">
                <input type="hidden" id="selectedLevel">
            </form>
        </div>
    </div>
</div>

<br>

<h2 class="section-title">카테고리  수정/삭제</h2>
<div style="display: flex; justify-content: space-between; padding-top:5px;">
    <div style="width: calc(50% - 10px);">
        <div class="form-container">
            <form name="f3" onsubmit="event.preventDefault(); editCategory();" class="category-form">
                <table border="1">
                	<caption>
                    	<h5>카테고리 수정</h5>
                	</caption>
                    <tr>
                        <th bgcolor="yellow">카테고리 이름</th>
                        <td><input type="text" id="cateName" class="box"></td>
                    </tr>
                    <tr bgcolor="orange">
                        <td colspan="2" align="center"><input type="submit" value="수정"> <input type="reset" value="취소"></td>
                    </tr>
                </table>
                <input type="hidden" id="selectedCategoryId">
            </form>
        </div>
    </div>

    <div style="width: calc(50% - 10px);">
        <div class="form-container">
            <form name="f4" onsubmit="event.preventDefault(); deleteCategory();" class="category-form">
                <table border="1">
                	<caption>
                    	<h5>카테고리 삭제</h5>
                	</caption>
                    <tr>
                        <th bgcolor="yellow">카테고리 이름</th>
                        <td><input type="text" id="cateDelete" class="box"></td>
                    </tr>
                    <tr bgcolor="orange">
                        <td colspan="2" align="center"><input type="submit" value="삭제"> <input type="reset" value="취소"></td>
                    </tr>
                </table>
                <input type="hidden" id="selectedCategoryId">
            </form>
        </div>
    </div>
</div>


</body>
</html>