function toggleCategoryList() {
            var categoryList = document.getElementById('category-list');
            if (categoryList.style.display === "none" || categoryList.style.display === "") {
                categoryList.style.display = "block";
            } else {
                categoryList.style.display = "none";
            }
        }
        
        function selectCategory(pcategory) {
            var form = document.createElement('form');
            form.action = 'cateSearch_prod.prod';
            form.method = 'post';

            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'pcategory';
            input.value = pcategory;

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }

        function showSubCategory(categoryId) {
            var subCategory = document.getElementById('sub-' + categoryId);
            var mainCategory = document.getElementById('main-' + categoryId);
            subCategory.style.display = "block";
            mainCategory.classList.add('active');
        }

        function hideSubCategory(categoryId) {
            var subCategory = document.getElementById('sub-' + categoryId);
            var mainCategory = document.getElementById('main-' + categoryId);
            subCategory.style.display = "none";
            mainCategory.classList.remove('active');
        }

        function hideAllSubCategories() {
            var subCategories = document.getElementsByClassName('subCategory');
            for (var i = 0; i < subCategories.length; i++) {
                subCategories[i].style.display = "none";
            }
            var mainCategories = document.getElementsByClassName('mainCategory');
            for (var j = 0; j < mainCategories.length; j++) {
                mainCategories[j].classList.remove('active');
            }
        }
        
        function searchOnEnter(event) {
            if (event.key === "Enter") {
                var searchTerm = document.getElementById("search-input").value.trim();
                window.location.href = "search_prod.prod?search=" + encodeURIComponent(searchTerm);

            }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            const dropbtn = document.querySelector('.dropbtn');
            const dropdown = document.querySelector('.dropdown');

            dropbtn.addEventListener('click', function(event) {
                event.stopPropagation();
                dropdown.classList.toggle('open');
            });

            document.addEventListener('click', function(event) {
                if (!dropdown.contains(event.target)) {
                    dropdown.classList.remove('open');
                }
            });
        });

        // 채팅 팝업 관련 스크립트
        function openChatPopup() {
            document.getElementById('popup').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
        }

        function closeChatPopup() {
            document.getElementById('popup').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
        }
        
        //후기 관련 스크립트
        function openReviewsPopup() {
            document.getElementById('reviews').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
        }

        function closeReviewsPopup() {
            document.getElementById('reviews').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
        }
        
        
 			
        //후기 평가 중복 관리 스크립트
         document.addEventListener('DOMContentLoaded', function() {
             var uniqueGoodPoints = {};
             var uniqueBadPoints = {};

             // 좋은 점 중복 제거 및 필터링
             var goodPointsList = document.getElementById('uniqueGoodPoints');
             Array.from(goodPointsList.getElementsByClassName('review-item')).forEach(function(li) {
                 var textContent = li.textContent.trim();
                 if (!uniqueGoodPoints[textContent]) {
                     uniqueGoodPoints[textContent] = 1; // 처음 등장한 경우는 1로 초기화
                 } else {
                     uniqueGoodPoints[textContent]++; // 이미 등장한 경우 수를 증가
                 }
             });
             goodPointsList.innerHTML = ''; // 초기화
             Object.keys(uniqueGoodPoints).forEach(function(point) {
                 var li = document.createElement('li');
                 var count = uniqueGoodPoints[point];
                 li.className = 'review-item';
                 li.innerHTML = '<span class="text">' + point + '</span><span class="count">(' + count + ')</span>'; // 텍스트 왼쪽, 숫자 오른쪽
                 goodPointsList.appendChild(li);
             });

             // 나쁜 점 중복 제거 및 필터링
             var badPointsList = document.getElementById('uniqueBadPoints');
             Array.from(badPointsList.getElementsByClassName('review-item')).forEach(function(li) {
                 var textContent = li.textContent.trim();
                 if (!uniqueBadPoints[textContent]) {
                     uniqueBadPoints[textContent] = 1; // 처음 등장한 경우는 1로 초기화
                 } else {
                     uniqueBadPoints[textContent]++; // 이미 등장한 경우 수를 증가
                 }
             });
             badPointsList.innerHTML = ''; // 초기화
             Object.keys(uniqueBadPoints).forEach(function(point) {
                 var li = document.createElement('li');
                 var count = uniqueBadPoints[point];
                 li.className = 'review-item';
                 li.innerHTML = '<span class="text">' + point + '</span><span class="count">(' + count + ')</span>'; // 텍스트 왼쪽, 숫자 오른쪽
                 badPointsList.appendChild(li);
             });
         });