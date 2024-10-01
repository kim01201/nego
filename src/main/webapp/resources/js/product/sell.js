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
            reader.onload = function(e) {
                var preview = document.getElementById('imagePreview');
                preview.src = e.target.result;  // 이미지 데이터를 preview.src에 설정
                preview.style.display = 'block';  // 이미지 미리보기를 보이도록 설정
            }
            reader.readAsDataURL(event.target.files[0]);  // 파일을 읽어서 데이터 URL로 변환
        }

        // 파일 선택(input 변경) 이벤트에 대한 리스너 추가
        document.getElementById('img').addEventListener('change', function(event) {
            previewImage(event);  // 파일 선택 시 이미지 미리보기 함수 호출
        });
        