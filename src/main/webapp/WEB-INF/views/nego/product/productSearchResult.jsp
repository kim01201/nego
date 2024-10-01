<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="resources/css/product/productSearch.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    
    <title>검색결과</title>

	<script>
	function clickCategoryBtn() {
	    const button = document.querySelector('.cate-btn');

	    if (button.textContent === '+') {
	        button.textContent = '-';
	    } else {
	        button.textContent = '+';
	    }
	    const noBorderRow = document.querySelector('.no-border');
	    if (noBorderRow.style.display === 'none' || noBorderRow.style.display === '') {
	        noBorderRow.style.display = 'table-row';
	    } else {
	        noBorderRow.style.display = 'none';
	    }
	}
	
	

	function renderChildCategories(categories) {
	    const categoryList = $('.category-list-1');
	    categoryList.empty(); // 기존 리스트를 비웁니다.

	    categories.forEach(pcategory => {
	        if (pcategory) { // null 값 필터링
	            console.log("category.id: ", pcategory.id);
	            const li = $('<li></li>').addClass('flex justify-start items-center p-2 pl-0 w');
	            const pathName = window.location.pathname; // 현재 경로 (/products)
	            console.log("pathName: ", pathName); // 현재 경로 확인

	            // pcategroy.id 값이 있는지도 확인해주세요
	            console.log("pcategory.id: ", pcategory.id); // pcategroy.id 값이 있는지도 확인해주세요

	            const newUrl = pathName + '?pcategory=' + pcategory.id;
	            console.log("newUrl: ", newUrl); // newUrl 확인

	            const a = $('<a></a>').attr('href', newUrl).text(pcategory.name);
	            li.append(a);
	            categoryList.append(li);
	        }
	    });
	}

	function renderCategoryPath(categoryPath) {
	    const categoryPathContainer = $('#category-name-path');
	    categoryPathContainer.empty(); // 기존 경로를 비웁니다.

	    const pathName = window.location.pathname; // 현재 경로 (/products)
	    const allUrl = pathName + '?pcategory=';

	    // '전체 >' 링크 추가
	    const allLink = $('<a></a>').attr('href', allUrl).text('전체 > ');
	    categoryPathContainer.append(allLink);

	    categoryPath.forEach((pcategory, index) => {
	        const newUrl = pathName + '?pcategory=' + pcategory.id;
	        const a = $('<a></a>').attr('href', newUrl).text(pcategory.name);

	        categoryPathContainer.append(a);

	        if (index < categoryPath.length - 1) {
	            categoryPathContainer.append(' > '); // 경로 사이에 구분자 추가
	        }
	    });
	}

	function getCategoryPath(categories, currentCategory) {
	    const path = [];
	    let pcategory = currentCategory;

	    while (pcategory) {
	        path.unshift(pcategory); // 현재 카테고리를 경로의 처음에 추가
	        pcategory = categories.find(cat => cat.id === pcategory.parent_id);
	    }

	    return path;
	}

	const fetchCategories = async () => {
	    try {
	        const response = await fetch('categories');
	        if (!response.ok) {
	            throw new Error(`HTTP error! Status: ${response.status}`);
	        }
	        const categories = await response.json();
	        console.log("categories: ", categories);

	        const filteredCategories = categories.filter(pcategory => pcategory !== null);
	        console.log("filteredCategories:", filteredCategories);

	        const numericCategoryId = parseInt(new URLSearchParams(window.location.search).get('pcategory'), 10);
	        console.log("pcategory:", numericCategoryId);

	        if (!isNaN(numericCategoryId)) {
	            const currentCategory = filteredCategories.find(pcategory => pcategory.id === numericCategoryId);
	            if (!currentCategory) {
	                console.error("현재 카테고리를 찾을 수 없습니다.");
	                console.log("numericCategoryId:", numericCategoryId);
	                console.log("filteredCategories IDs:", filteredCategories.map(pcategory => pcategory.id));
	                return;
	            }
	            console.log('currentCategory: ', currentCategory);

	            const currentChildCategory = filteredCategories.filter(pcategory => numericCategoryId === pcategory.parent_id);
	            console.log('currentChildCategory: ', currentChildCategory);

	            const categoryPath = getCategoryPath(filteredCategories, currentCategory);
	            console.log('categoryPath: ', categoryPath);
	            renderCategoryPath(categoryPath);

	            if (currentCategory.category_level === 3) {
	                const sameCategoryLevel = filteredCategories.filter(pcategory => pcategory.parent_id === currentCategory.parent_id);
	                console.log("sameCategoryLevel: ", sameCategoryLevel);
	                // 렌더링 함수 호출
	                renderChildCategories(sameCategoryLevel);
	            } else {
	                // 하위 카테고리 렌더링 함수 호출
	                renderChildCategories(currentChildCategory);
	            }
	        } else {
	            console.log("pcategory 값이 URL에서 찾을 수 없습니다.");
	            renderCategoryPath([]); // pcategory 값이 없을 때 '전체 >' 링크를 렌더링

	            // category_level이 1인 카테고리들 렌더링
	            const levelOneCategories = filteredCategories.filter(pcategory => pcategory.category_level === 1);
	            console.log("levelOneCategories:", levelOneCategories);
	            renderChildCategories(levelOneCategories);
	        }
	    } catch (error) {
	        console.error('Error fetching categories:', error);
	    }
	};

	$(document).ready(() => {
	    fetchCategories();
	});


	//카테고리 끝
	
	//정렬
	var sortOrder = "RECOMMENDED_SORT";
	var status = '';
	
	async function fetchProducts(minPrice, maxPrice) {
	    try {
	        const params = new URLSearchParams();
	    	const search = new URLSearchParams(window.location.search).get('search'); 
	        const pcategory = new URLSearchParams(window.location.search).get('pcategory');
	        if (search) {
	            params.append('search', search);
	        }
	        if (pcategory) {
	        	params.append('pcategory', pcategory);
	        }
	        if (sortOrder) {
	        	params.append('sort', sortOrder);
	        }
	        if (status) {
	            params.append('status', status);
	        }
	        if (minPrice) {
	            params.append('minPrice', minPrice);
	        }
	        if (maxPrice) {
	            params.append('maxPrice', maxPrice);
	        }
	
	        const queryString = params.toString();
	        const url = 'cateSearch.prod?' + queryString; // URL 직접 구성
	
	        console.log("Request URL:", url);
	
	        const response = await fetch(url);
	       	console.log("반응",response);
	        if (!response.ok) {
	            throw new Error(`HTTP error! Status: ${response.status}`);
	        }
	
	        const contentType = response.headers.get('content-type');
	        console.log("반환",contentType);
	        
	        if (contentType && contentType.includes('application/json')) {
	            const products = await response.json(); // JSON 형식으로 변환
	            console.log("Products:", products);
	            renderProducts(products); // 받은 상품 데이터를 화면에 출력하는 함수 호출
	            renderPriceInfo(products);
	        } else {
	            throw new Error('서버가 JSON을 반환하지 않았습니다.');
	        }
	    } catch (error) {
	        console.error('Error fetching products:', error);
	    }
	}


	
	function renderProducts(products) {
	    const productList = document.getElementById('productList');
	    console.log("랜더", productList);
	    productList.innerHTML = '';
	    console.log("prod", products);
	    
	    if (products.cateSearchProd.length == 0) {
	    	console.log("products.cateSearchProd.length",products.cateSearchProd.length);
	        productList.innerHTML = '<p>해당하는 상품이 없습니다.</p>';
	    } else {

		    products.cateSearchProd.forEach(product => {
		        const productDiv = document.createElement('div');
		        productDiv.className = 'col-md-3';
	
		        const pnumValue = product.pnum;
		        console.log(pnumValue);
	
		        // 문자열 연결을 이용한 방식
		        productDiv.innerHTML = '<a href="spec_prod.prod?pnum=' + product.pnum + '">' +
		            '<div class="card">' +
		            '<div class="card-img-wrapper ' + (product.pstatus == '판매완료' ? 'sold-out' : '') + '">' +
		            '<img src="${pageContext.request.contextPath}/resources/images/' + product.pimage + '" class="card-img-top" alt="' + product.pname + '">' +
		            (product.pstatus == '판매완료' ? '<div class="sold-out-overlay"><span>판매완료</span></div>' : '') +
		            (product.pstatus == '거래중' ? '<div class="sold-out-overlay"><span>거래중</span></div>' : '') +
		            '</div>' +
		            '<div class="card-body">' +
		            '<h5 class="card-title">' + product.pname + '</h5>' +
		            '<p class="card-text">가격: ' + product.price + '원</p>' +
		            '<p class="card-text">조회수: ' + product.preadcount + '</p>' +
		            '<p class="card-text">찜: ' + product.wishCount + '</p>' +
		            '<p class="card-text">' + product.hours_difference + '</p>' +
		            '<p class="card-text">상태: ' + product.pstatus + '</p>' +
		            '</div>' +
		            '</div>' +
		            '</a>';
	
		        productList.appendChild(productDiv);
		    });
		}
	}
	
	function renderPriceInfo(response) {
	    const container = document.getElementById("prod-price-container");
	    console.log("container:", container);
	    
		console.log("avg1Price:", response.avg1Price);
		console.log("max1Price:", response.max1Price);
		console.log("min1Price:", response.min1Price);
		console.log("avg2Price:", response.avg2Price);
		console.log("max2Price:", response.max2Price);
		console.log("min2Price:", response.min2Price);
		
		
	    if (response.avg1Price != 0) {
	        const avgPriceHTML =
	            '<div class="prod-price-info">' +
	            '<div class="avg-price">' +
	            '<span class="avg-price-title">평균 가격</span>' +
	            '<span class="price">' + formatNumber(response.avg1Price) + '원</span>' +
	            '</div>' +
	            '<div class="highest-price">' +
	            '<span class="avg-price-title">가장 높은 가격</span>' +
	            '<span class="price">' + formatNumber(response.max1Price) + '원</span>' +
	            '</div>' +
	            '<div class="lowest-price">' +
	            '<span class="avg-price-title">가장 낮은 가격</span>' +
	            '<span class="price">' + formatNumber(response.min1Price) + '원</span>' +
	            '</div>' +
	            '</div>';

	        // 생성된 HTML을 컨테이너에 삽입
	        container.innerHTML = avgPriceHTML;
	    } else if (response.avg2Price != 0) {
	        const avgPriceHTML =
	            '<div class="prod-price-info">' +
	            '<div class="avg-price">' +
	            '<span class="avg-price-title">평균 가격</span>' +
	            '<span class="price">' + formatNumber(response.avg2Price) + '원</span>' +
	            '</div>' +
	            '<div class="highest-price">' +
	            '<span class="avg-price-title">가장 높은 가격</span>' +
	            '<span class="price">' + formatNumber(response.max2Price) + '원</span>' +
	            '</div>' +
	            '<div class="lowest-price">' +
	            '<span class="avg-price-title">가장 낮은 가격</span>' +
	            '<span class="price">' + formatNumber(response.min2Price) + '원</span>' +
	            '</div>' +
	            '</div>';

	        // 생성된 HTML을 컨테이너에 삽입
	        container.innerHTML = avgPriceHTML;
	    }else{
	        console.error("응답에서 유효한 데이터를 찾을 수 없습니다.");
	    }
	}

	// 숫자 포맷팅 함수
	function formatNumber(num) {
		 // 소수점 이하를 버리고 정수 부분만 가져옴
	    const integerPart = Math.floor(num);

	    // 정수 부분을 세 자리마다 콤마(,)로 구분하여 문자열로 변환
	    return integerPart.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	
	// 이벤트 리스너 설정
	document.addEventListener('DOMContentLoaded', function() {
	const sortButtons = document.querySelectorAll('.sort-result div');
	console.log("버튼 : ",sortButtons);
	sortButtons.forEach(button => {
	    button.addEventListener('click', function() {
	        const sortMode = this.dataset.sort;
	        console.log("sortMode: ", sortMode);
	        sortOrder = sortMode;
	        fetchProducts();
	    });
	});
	});
	
	document.addEventListener('DOMContentLoaded', function() {
        const checkSale = document.getElementById('flexCheck');
        const checkSolding = document.getElementById('flexChecking');
        const checkSoldOut = document.getElementById('flexCheckDefault');

        console.log("판매중 : ", checkSale);
        console.log("거래중 : ", checkSale);
        console.log("판매완료 : ", checkSoldOut);

        checkSale.addEventListener('change', function() {
            if (this.checked) {
                status = '판매중';  // 체크된 경우 status 설정
                checkSoldOut.checked = false;  // 다른 체크박스 해제
                checkSoldOut.disabled = true;  // 다른 체크박스 비활성화
                checkSolding.checked = false;  // 다른 체크박스 해제
                checkSolding.disabled = true;  // 다른 체크박스 비활성화
            } else {
                status = '';  // 체크 해제된 경우 status 초기화
                checkSoldOut.disabled = false;  // 다른 체크박스 활성화
                checkSolding.disabled = false;  // 다른 체크박스 활성화
            }
            fetchProducts();  // 상태 변경 후 제품 목록 다시 가져오기
        });

        checkSolding.addEventListener('change', function() {
            if (this.checked) {
                status = '거래중';  // 체크된 경우 status 설정
                checkSale.checked = false;  // 다른 체크박스 해제
                checkSale.disabled = true;  // 다른 체크박스 비활성화
                checkSoldOut.checked = false;  // 다른 체크박스 해제
                checkSoldOut.disabled = true;  // 다른 체크박스 비활성화
            } else {
                status = '';  // 체크 해제된 경우 status 초기화
                checkSoldOut.disabled = false;  // 다른 체크박스 활성화
                checkSale.disabled = false;  // 다른 체크박스 활성화
            }
            fetchProducts();  // 상태 변경 후 제품 목록 다시 가져오기
        });
        
        checkSoldOut.addEventListener('change', function() {
            if (this.checked) {
                status = '판매완료';  // 체크된 경우 status 설정
                checkSale.checked = false;  // 다른 체크박스 해제
                checkSale.disabled = true;  // 다른 체크박스 비활성화
                checkSolding.checked = false;  // 다른 체크박스 해제
                checkSolding.disabled = true;  // 다른 체크박스 비활성화
            } else {
                status = '';  // 체크 해제된 경우 status 초기화
                checkSale.disabled = false;  // 다른 체크박스 활성화
                checkSolding.disabled = false;  // 다른 체크박스 활성화
            }
            fetchProducts();  // 상태 변경 후 제품 목록 다시 가져오기
        });
    });
	
	document.addEventListener('DOMContentLoaded', function() {
	    document.querySelector('.price-btn').addEventListener('click', function() {
	        const minPriceInput = document.querySelector('.left-input').value;
	        const maxPriceInput = document.querySelector('.right-input').value;
	        console.log("가격: ",maxPriceInput);
	        fetchProducts(minPriceInput, maxPriceInput);
	    });
	});


	</script>
</head>

<body>
<main>

		<header>
			<%@include file="../Header.jsp"%>	
		</header>
		
<div class="allprod">
<div class="wrap-title">
	<c:choose>
		<c:when test="${not empty params.search}">
	    	<h2 class="keyword">'${params.search}' 검색결과</h2>
	    </c:when>
		<c:when test="${not empty params.pcategoryName}">
	    	<h2 class="keyword">'${params.pcategoryName}' 검색결과</h2>
	    </c:when>
	   	<c:when test="${empty params.search and empty params.pcategory}">
	    	<h2 class="keyword">'전체' 검색결과</h2>
	    </c:when>
	    
	</c:choose>
    <c:choose>
     <c:when test="${not empty cateSearchProd}">
     <div class="total-count">총 ${fn:length(cateSearchProd)}개</div>
     </c:when>
     </c:choose>
</div>

<div class="relation-keyword"></div>


       <div>
            <table class="filterTable">
                <tr>
                    <td style='display:flex' class="filterTable td:first-child">
                        <p style="margin-bottom:0">카테고리 </p>
                        <button class='cate-btn' onclick="clickCategoryBtn()">+</button>
                    </td>
                    <td id="category-name-1">
                        <div id="category-name-path" style="display: flex">

                        </div>
                    </td>
                </tr>
                <tr class="no-border" style="display: none;">
                    <td></td>
                    <td class="pypy">
                        <ul class="grid grid-cols-6 text-sm category-list-1" id="category-list-1">

                        </ul>
                    </td>
                </tr>
                <tr>
                    <td>가격</td>
                    <td>
                    <input type=text class="left-input" placeholder="최소 가격" /> ~ 
                    <input type=text class="right-input" placeholder="최대 가격" /> 
                    <button class="price-btn">적용 </button>
                    </td>
                </tr>
                <tr>
                    <td>옵션</td>
                    <td style="display:flex">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="" id="flexCheck">
                            <label class="form-check-label" for="flexCheck">
                                	판매중
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="" id="flexChecking">
                            <label class="form-check-label" for="flexCheckDefault">
                               		거래중
                            </label>
                        </div>
						<div class="form-check">
                            <input class="form-check-input" type="checkbox" value="" id="flexCheckDefault">
                            <label class="form-check-label" for="flexCheck">
                                	판매완료
                            </label>
                        </div>
                    </td>
                </tr>
                
            </table>
        </div>

<div class="price-compare">
    <div>
        <h4 class="price-title">현재 페이지의 상품 가격을 비교해봤어요</h4>
    </div>
    
<c:choose>
    <c:when test="${ avg1Price != 0 }">
        <div class="prod-price-info" id="prod-price-container">
            <div class="avg-price">
                <span class="avg-price-title">평균 가격</span>
                <span class="price"><fmt:formatNumber value="${avg1Price}" pattern="###,###"/>원</span>
            </div>
            <div class="highest-price">
                <span class="avg-price-title">가장 높은 가격</span>
                <span class="price"><fmt:formatNumber value="${max1Price}" pattern="###,###"/>원</span>
            </div>
            <div class="lowest-price">
                <span class="avg-price-title">가장 낮은 가격</span>
                <span class="price"><fmt:formatNumber value="${min1Price}" pattern="###,###"/>원</span>
            </div>
        </div>
    </c:when>
    <c:when test="${ avg2Price != 0 }">
        <!-- 카테고리에 따른 가격 통계 -->
        <div class="prod-price-info" id="prod-price-container">
            <div class="avg-price">
                <span class="avg-price-title">평균 가격</span>
                <span class="price"><fmt:formatNumber value="${avg2Price}" pattern="###,###"/>원</span>
            </div>
            <div class="highest-price">
                <span class="avg-price-title">가장 높은 가격</span>
                <span class="price"><fmt:formatNumber value="${max2Price}" pattern="###,###"/>원</span>
            </div>
            <div class="lowest-price">
                <span class="avg-price-title">가장 낮은 가격</span>
                <span class="price"><fmt:formatNumber value="${min2Price}" pattern="###,###"/>원</span>
            </div>
        </div>
    </c:when>
</c:choose>

</div>
		<div class="sort">
            <div class="sort-result">
                <div data-sort="RECOMMENDED_SORT">추천순</div>
                <div data-sort="NEWEST_SORT">최신순</div>
                <div data-sort="PRICE_ASC_SORT">낮은가격순</div>
                <div data-sort="PRICE_DESC_SORT">높은가격순</div>
            </div>
        </div>
<div class="prod-container">
     <h2 class="result-prod-list">검색 상품 목록</h2>
    <div id="productList" class="row">
<c:choose>
    <c:when test="${not empty searchProd}">
        <c:set var="mergedList" value="${searchProd}" />
    </c:when>
    <c:when test="${not empty cateSearchProd}">
        <c:set var="mergedList" value="${cateSearchProd}" />
    </c:when>
</c:choose>

<c:forEach var="product" items="${mergedList}">
    <div class="col-md-3">
     <c:choose>
    	<c:when test="${sessionScope.mbId.id==product.member_id}">
    		<a href="spec_prod_user.prod?pnum=${product.pnum}">
    	</c:when>
    	<c:otherwise>
    		<a href="spec_prod.prod?pnum=${product.pnum}">
    	</c:otherwise>
    </c:choose>
        <div class="card">
        	<div class="card-img-wrapper ${product.pstatus == '판매완료' ? 'sold-out' : ''}">
                
                    <img src="${pageContext.request.contextPath}/resources/images/${product.pimage}" class="card-img-top" alt="${product.pname}">
                <c:if test="${product.pstatus == '판매완료'}">
                    <div class="sold-out-overlay">
                        <span>판매완료</span>
                    </div>
                </c:if>
                <c:if test="${product.pstatus == '거래중'}">
                    <div class="sold-out-overlay">
                        <span>거래중</span>
                    </div>
                </c:if>
            </div>
            <div class="card-body">
                <h5 class="card-title">${product.pname}</h5>
                <p class="card-text">가격: ${product.price}원</p>
                <p class="card-text">조회수: ${product.preadcount}</p>
                <p class="card-text">찜: ${product.wishCount}</p>
                <p class="card-text">${product.hours_difference}</p>
                <p class="card-text">상태: ${product.pstatus}</p>
            </div>
        </div>
        </a>
    </div>
</c:forEach>          
    </div>
</div>
</div>
		<footer>
        	<%@include file="../bottom.jsp" %>
    	</footer>
</main>
</body>
</html>
