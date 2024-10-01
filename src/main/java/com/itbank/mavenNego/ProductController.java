package com.itbank.mavenNego;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.google.gson.Gson;
import com.itbank.mavenNego.dto.CateDTO;
import com.itbank.mavenNego.dto.MboardDTO;
import com.itbank.mavenNego.dto.MemberDTO;
import com.itbank.mavenNego.dto.ProductDTO;
import com.itbank.mavenNego.dto.ReviewsDTO;
import com.itbank.mavenNego.dto.WishListDTO;
import com.itbank.mavenNego.service.ProductMapper;
import com.itbank.mavenNego.service.ReviewsMapper;
import com.itbank.mavenNego.service.SalesCompletedMapper;
import com.itbank.mavenNego.service.WishListMapper;
import com.itbank.mavenNego.service.MemberMapper;
import com.itbank.mavenNego.service.NegoMapper;

@Controller
public class ProductController {
	@Autowired
	ProductMapper productMapper;
	
	@Autowired
	NegoMapper negoMapper;
	
	@Autowired
	WishListMapper wishListMapper;
	
	@Autowired
	ReviewsMapper reviewsMapper;
	
	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	ServletContext servletcontext;
	
	@Autowired
	SalesCompletedMapper salesCompletedMapper;
	


    private List<CateDTO> setCategoryData(HttpServletRequest req) {
		List<CateDTO> mainList = negoMapper.mainList();
		req.setAttribute("mainList", mainList);
		
		for (CateDTO mainCategory : mainList) {
			List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
			mainCategory.setSubList(subList);
			
			for (CateDTO subCategory : subList) {
				List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
				subCategory.setItemList(itemList);
			}
		}
		return mainList;
    }
    
    @GetMapping("/categories")
    public ResponseEntity<List<CateDTO>> getCategories() throws Exception {
        List<CateDTO> categories = negoMapper.mainListAll();
        return ResponseEntity.ok(categories);
    }

    
	
    @GetMapping("/cateSearch_prod.prod") // 카테고리 선택 검색
    public String cateSearchProd(
            HttpServletRequest req,
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "pcategory", required = false) String pcategory,
            @RequestParam(value = "sort", required = false) String sort,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "minPrice", required = false) Integer minPrice,
            @RequestParam(value = "maxPrice", required = false) Integer maxPrice) {

        List<CateDTO> mainList = setCategoryData(req);
        req.setAttribute("mainList", mainList);

        Map<String, Object> params = new HashMap<>();
        params.put("search", search != null ? search : "");
        params.put("pcategory",pcategory != null ? pcategory : "");
        params.put("sort", sort);
        params.put("status", status);
        params.put("minPrice", minPrice);
        params.put("maxPrice", maxPrice);
        
        if (pcategory != null && !pcategory.isEmpty()) {
        	System.out.println("pcategory:"+pcategory);

            String pcategoryName = negoMapper.categoryName(Integer.parseInt(pcategory)); 
            System.out.println("pcategoryName:"+pcategoryName);
            params.put("pcategoryName", pcategoryName);
        }

        // 검색어와 카테고리에 따른 가격 통계 조회
        Map<String, Object> priceStats = productMapper.searchPriceStats(params);

        // 상품 목록 조회
        List<ProductDTO> list = productMapper.cateSearchProd(params);

        System.out.println("params: " + params);
        System.out.println("priceStats: " + priceStats);
        System.out.println("list: " + list);
        System.out.println("avg1Price: " + priceStats.get("AVG1PRICE"));
        System.out.println("avgPrice2: " + priceStats.get("AVGPRICE2"));

        // 각 상품의 찜 개수 조회
        for (ProductDTO product : list) {
            int productId = product.getPnum();
            int count = wishListMapper.wishCount(productId);
            product.setWishCount(count);
        }

        req.setAttribute("params", params);
        req.setAttribute("cateSearchProd", list);
        req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));

        // 검색어에 따른 평균, 최소, 최대 가격 결과 설정
        req.setAttribute("avg1Price", priceStats.get("AVG1PRICE"));
        req.setAttribute("min1Price", priceStats.get("MIN1PRICE"));
        req.setAttribute("max1Price", priceStats.get("MAX1PRICE"));
        req.setAttribute("avg2Price", priceStats.get("AVGPRICE2"));
        req.setAttribute("min2Price", priceStats.get("MINPRICE2"));
        req.setAttribute("max2Price", priceStats.get("MAXPRICE2"));

        return "nego/product/productSearchResult";
    }



    @GetMapping("/cateSearch.prod")
    public ResponseEntity<Map<String, Object>> cateSearchProd(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "pcategory", required = false) String pcategory,
            @RequestParam(value = "sort", required = false) String sort,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "minPrice", required = false) Integer minPrice,
            @RequestParam(value = "maxPrice", required = false) Integer maxPrice) {

        Map<String, Object> response = new HashMap<>();

        // 검색 조건 설정
        Map<String, Object> params = new HashMap<>();
        params.put("search", search != null ? search : "");
        params.put("pcategory", pcategory != null ? pcategory : "");
        params.put("sort", sort);
        params.put("status", status);
        params.put("minPrice", minPrice);
        params.put("maxPrice", maxPrice);

        System.out.println(params);
        
        
        // 상품 목록 조회
        List<ProductDTO> productList = productMapper.cateSearchProd(params);

        List<Integer> pnumList = new ArrayList<>();
        for (ProductDTO product : productList) {
            pnumList.add(product.getPnum());
        }
        
        System.out.println("pnumList:"+pnumList);
        
        Map<String, Object> statsParams = new HashMap<>();
        statsParams.put("search", search != null ? search : "");
        statsParams.put("pcategory", pcategory != null ? pcategory : "");
        statsParams.put("pnumList",pnumList);
        
        
        System.out.println("statsParams"+statsParams);
        
        System.out.println("productList"+productList);

        Map<String, Object> priceStats = productMapper.searchPriceStats(statsParams);
        System.out.println("priceStats"+priceStats);
        
        // 각 상품의 찜 개수 설정
        for (ProductDTO product : productList) {
            int productId = product.getPnum();
            int count = wishListMapper.wishCount(productId);
            product.setWishCount(count);
        }

        // 결과 설정
        response.put("cateSearchProd", productList);
        response.put("avg1Price", priceStats.get("AVG1PRICE"));
        response.put("min1Price", priceStats.get("MIN1PRICE"));
        response.put("max1Price", priceStats.get("MAX1PRICE"));
        response.put("avg2Price", priceStats.get("AVGPRICE2"));
        response.put("min2Price", priceStats.get("MINPRICE2"));
        response.put("max2Price", priceStats.get("MAXPRICE2"));
        System.out.println(response);

        return ResponseEntity.status(HttpStatus.OK).body(response);
    }


	
	
	
	@RequestMapping("/spec_prod.prod")
	public String specProd(HttpServletRequest req, HttpSession session,@RequestParam("pnum") int pnum) {
		setCategoryData(req);
	    // 상품 정보 가져오기
	    ProductDTO dto = productMapper.getProd(pnum);

	    MemberDTO mdto = memberMapper.getMember(dto.getMember_id());
	    int res = productMapper.plusPreadcount(pnum); // 상세보기 후 조회수 증가
	    int count = wishListMapper.wishCount(pnum);
	    int recount = reviewsMapper.reviewsCount(dto.getMember_id());
	    int sellCount = salesCompletedMapper.sellerCount(dto.getMember_id());// 안전거래
	    dto.setWishCount(count);
	    dto.setReviewsCount(recount);
	    dto.setSellCount(sellCount); 
	    
	    // 카테고리 정보 가져오기
	    MemberDTO member = (MemberDTO) session.getAttribute("mbId"); // 세션에서 MemberDTO 객체를 가져온다고 가정
		if(member !=null) {
			String memberId = member.getId(); // MemberDTO의 getId() 메서드를 통해 회원 ID를 가져옴
			WishListDTO wdto = wishListMapper.findWish(pnum,memberId);
			req.setAttribute("wdto", wdto);
		}
	 
	    String categoryName1 = negoMapper.categoryName(Integer.parseInt(dto.getPcategory1()));
	    String categoryName2 = dto.getPcategory2() != null ? negoMapper.categoryName(Integer.parseInt(dto.getPcategory2())) : null;
	    String categoryName3 = dto.getPcategory3() != null ? negoMapper.categoryName(Integer.parseInt(dto.getPcategory3())) : null;


	    // 카테고리 정보를 요청 객체에 저장
	    req.setAttribute("categoryName1", categoryName1);
	    req.setAttribute("categoryName2", categoryName2);
	    req.setAttribute("categoryName3", categoryName3);

	    // 판매 리뷰 목록 가져오기
	    List<ReviewsDTO> list = reviewsMapper.sellReviews(dto.getMember_id());
	    req.setAttribute("sellReviews", list);
	    req.setAttribute("specProd", dto);
	    req.setAttribute("getMember", mdto);
	    req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));

	    return "nego/product/productDetail"; // 상품 상세페이지
	}
	
	//판매자용 specProd
	@RequestMapping("/spec_prod_user.prod")
	public String specProd_User(HttpServletRequest req, @RequestParam("pnum") int pnum) {
	    // 상품 정보 가져오기
	    ProductDTO dto = productMapper.getProd(pnum);

	    MemberDTO mdto = memberMapper.getMember(dto.getMember_id());
	    //int res = productMapper.plusPreadcount(pnum); // 판매자가 볼 때는 조회수 증가하지 않음
	    int count = wishListMapper.wishCount(pnum);
	    int recount = reviewsMapper.reviewsCount(dto.getMember_id());
	    dto.setWishCount(count);
	    dto.setReviewsCount(recount);

	    // 카테고리 정보 가져오기
	    
	    String categoryName1 = negoMapper.categoryName(Integer.parseInt(dto.getPcategory1()));
	    String categoryName2 = dto.getPcategory2() != null ? negoMapper.categoryName(Integer.parseInt(dto.getPcategory2())) : null;
	    String categoryName3 = dto.getPcategory3() != null ? negoMapper.categoryName(Integer.parseInt(dto.getPcategory3())) : null;


	    // 카테고리 정보를 요청 객체에 저장
	    req.setAttribute("categoryName1", categoryName1);
	    req.setAttribute("categoryName2", categoryName2);
	    req.setAttribute("categoryName3", categoryName3);

	    // 판매 리뷰 목록 가져오기
	    List<ReviewsDTO> list = reviewsMapper.sellReviews(dto.getMember_id());
	    req.setAttribute("sellReviews", list);
	    req.setAttribute("specProd", dto);
	    req.setAttribute("getMember", mdto);
	    req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));

	    return "nego/product/productDetailUser"; // 판매자용 상품 상세페이지
	}
	
	@RequestMapping(value="/insert_prod.prod", method=RequestMethod.GET)	//상품등록 페이지 이동
	public String insertProd(HttpServletRequest req) {
        List<CateDTO> mainList = negoMapper.mainList();
		req.setAttribute("mainList", mainList);
		
		for (CateDTO mainCategory : mainList) {
			List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
			mainCategory.setSubList(subList);
			
			for (CateDTO subCategory : subList) {
				List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
				subCategory.setItemList(itemList);
			}
		}
		return "nego/product/Sell";
	}
	
	
	@RequestMapping(value="insert_comp.prod", method=RequestMethod.POST)
    public String submitProd(@RequestParam("img") MultipartFile mf, ProductDTO dto, HttpServletRequest req) {
        try {
        	// 원본 파일 이름 가져오기
			String originalFilename = mf.getOriginalFilename();

			// 고유한 파일 이름 생성 (타임스탬프 사용)
			String timeStamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
			String uniqueFilename = timeStamp + "_" + originalFilename;

			// 파일 저장 경로 설정
			String path = servletcontext.getRealPath("/resources/images/");
			File file = new File(path, uniqueFilename);

			// 파일 저장
			mf.transferTo(file);

			// 파일 경로를 DTO의 다른 필드에 저장
			dto.setPimage(uniqueFilename); // 고유한 파일명을 DTO에 저장

            // 상품 추가
            int res = productMapper.insertProd(dto);
            int newProductPnum = productMapper.getLastInsertId(); // 마지막 삽입된 상품의 pnum 값을 가져옴
            
            // 카테고리 목록 설정
            List<CateDTO> mainList = negoMapper.mainList();
            req.setAttribute("mainList", mainList);
            for (CateDTO mainCategory : mainList) {
                List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
                mainCategory.setSubList(subList);
                for (CateDTO subCategory : subList) {
                    List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
                    subCategory.setItemList(itemList);
                }
            }

            // 상품 목록 설정
            List<ProductDTO> list = productMapper.allProd();
            req.setAttribute("allProd", list);
            req.setAttribute("path", servletcontext.getRealPath("/resources/images/")); //파일경로 설정

            // 세션에 pnum 값 저장
            HttpSession session = req.getSession();
            session.setAttribute("pnum", newProductPnum);

            return "nego/product/productCheckOk";
        } catch (Exception e) {
            e.printStackTrace();
            return "nego/product/productCheckFail";
        }
    }

	
	
	@RequestMapping(value="edit_prod.prod", method=RequestMethod.GET)	//상품 수정 페이지 이동
	public String editProd(HttpServletRequest req, @RequestParam("pnum")int pnum) {
		 List<CateDTO> mainList = negoMapper.mainList();
		   req.setAttribute("mainList", mainList);
		  
			
			for (CateDTO mainCategory : mainList) {
				List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
				mainCategory.setSubList(subList);
				
				for (CateDTO subCategory : subList) {
					List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
					subCategory.setItemList(itemList);
				}
			}
			
			ProductDTO dto = productMapper.getProd(pnum);
			req.setAttribute("getProd", dto);
			req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));
		return "nego/product/edit";
	}
	
	@RequestMapping(value="/edit_comp.prod", method=RequestMethod.POST)	
	public String editProProd(@RequestParam(name = "img", required = false) MultipartFile mf, 
			@RequestParam("previousImg") String previousImg, ProductDTO dto,HttpServletRequest req,
			BindingResult result) {
		 try {
			 if (mf != null && !mf.isEmpty()) {
		            // 새로운 이미지가 업로드된 경우 처리
		            String filename = mf.getOriginalFilename();
		            String path = servletcontext.getRealPath("/resources/images/");
		            File file = new File(path, filename);
		            mf.transferTo(file);
		            dto.setPimage(filename); // 새로운 이미지 파일명을 DTO에 저장
		        } else {
		            // 새로운 이미지가 업로드되지 않은 경우 기존 이미지 파일명을 그대로 사용
		            dto.setPimage(previousImg);
		        }
		        
		        
		        List<CateDTO> mainList = negoMapper.mainList();
				req.setAttribute("mainList", mainList); 
				
				for (CateDTO mainCategory : mainList) {
					List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
					mainCategory.setSubList(subList);
					
					for (CateDTO subCategory : subList) {
						List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
						subCategory.setItemList(itemList);
					}
				}
		if (result.hasErrors()) {	//만약에 dto객체를 만드는 중 오류가 발생했다면.. 
			//여기는 오류를 내가 알아서 해결하는 코드
			dto.setPnum(0);
		} 
		int res = productMapper.editProd(dto);
		
		//찜 목록 수정 코드
		WishListDTO wishDTO = new WishListDTO();
        wishDTO.setProduct_id(dto.getPnum()); // 수정된 상품의 ID
        wishDTO.setProduct_name(dto.getPname()); // 수정된 상품의 이름
        wishDTO.setProduct_price(dto.getPrice()); // 수정된 상품의 가격
        wishDTO.setProduct_image(dto.getPimage()); // 수정된 상품의 이미지 경로

        int res2 = wishListMapper.updateWish(wishDTO);

        HttpSession session = req.getSession();
        session.setAttribute("pnum", Integer.parseInt(req.getParameter("pnum")));
        
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/")); //파일경로 설정
	
		return "nego/product/productEditOk";		//수정 후 상세페이지로 이동 ..? 값 수정해주세용
		 }catch (Exception e) {
			 e.printStackTrace();
				return "nego/product/productEditFail";
		}
	}
	
	
	@RequestMapping(value="/edit_admin.prod", method=RequestMethod.POST)	
	public String editadminProd(@RequestParam(name = "img", required = false) MultipartFile mf, @RequestParam("previousImg") String previousImg, 
			ProductDTO dto,HttpServletRequest req,
			BindingResult result) {
		 try {
			 if (mf != null && !mf.isEmpty()) {
		            // 새로운 이미지가 업로드된 경우 처리
		            String filename = mf.getOriginalFilename();
		            String path = servletcontext.getRealPath("/resources/images/");
		            File file = new File(path, filename);
		            mf.transferTo(file);
		            dto.setPimage(filename); // 새로운 이미지 파일명을 DTO에 저장
		        } else {
		            // 새로운 이미지가 업로드되지 않은 경우 기존 이미지 파일명을 그대로 사용
		            dto.setPimage(previousImg);
		        } // 고유한 파일명을 DTO에 저장

		        
		        
		        List<CateDTO> mainList = negoMapper.mainList();
				req.setAttribute("mainList", mainList); 
				
				for (CateDTO mainCategory : mainList) {
					List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
					mainCategory.setSubList(subList);
					
					for (CateDTO subCategory : subList) {
						List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
						subCategory.setItemList(itemList);
					}
				}
		if (result.hasErrors()) {	//만약에 dto객체를 만드는 중 오류가 발생했다면.. 
			//여기는 오류를 내가 알아서 해결하는 코드
			dto.setPnum(0);
		} 
		int res = productMapper.editProd(dto);
		
		//찜 목록 수정 코드
		WishListDTO wishDTO = new WishListDTO();
        wishDTO.setProduct_id(dto.getPnum()); // 수정된 상품의 ID
        wishDTO.setProduct_name(dto.getPname()); // 수정된 상품의 이름
        wishDTO.setProduct_price(dto.getPrice()); // 수정된 상품의 가격
        wishDTO.setProduct_image(dto.getPimage()); // 수정된 상품의 이미지 경로

        int res2 = wishListMapper.updateWish(wishDTO);

        HttpSession session = req.getSession();
        session.setAttribute("pnum", Integer.parseInt(req.getParameter("pnum")));
        
		req.setAttribute("path", servletcontext.getRealPath("/resources/images/")); //파일경로 설정
	
		return "nego/admin/admin";		//수정 후 상세페이지로 이동 ..? 값 수정해주세용
		 }catch (Exception e) {
			 e.printStackTrace();
				return "nego/admin/admin";
		}
	}
	@RequestMapping("/delete_prod.prod")	//상품 삭제
	public String deleteProProd(HttpServletRequest req, int pnum) {
	    int res = productMapper.deleteProd(pnum);
	    // int res2 = wishListMapper.prod_delete(pnum); // wishList 삭제는 필요한 경우 주석 해제
	    System.out.println("상품 삭제 완료: " + res);
	    return "redirect:main.do";
	}
    
	@RequestMapping(value="/marketPrice.prod", method=RequestMethod.GET)	//시세조회
    public String marketPrice(HttpServletRequest req) {
		List<CateDTO> mainList = negoMapper.mainList();
		req.setAttribute("mainList", mainList);
		
		for (CateDTO mainCategory : mainList) {
			List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
			mainCategory.setSubList(subList);
			
			for (CateDTO subCategory : subList) {
				List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
				subCategory.setItemList(itemList);
			}
		}
        return "nego/header/chart";
    }
    
	@ResponseBody
	@RequestMapping(value = "/marketPriceByCategory.prod", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
	public String marketPriceByCategory(@RequestParam("category") String category) {
	    System.out.println("Received category: " + category); // 디버깅을 위한 로그 추가

	    List<Double> marketPrices1 = productMapper.marketPriceByCategory(category);
	    if (marketPrices1 == null || marketPrices1.isEmpty()) {
	        return new Gson().toJson("등록된 상품이 없습니다.");
	    }
	    Gson gson = new Gson();
	    return gson.toJson(marketPrices1);
	}


	
    @ResponseBody
    @RequestMapping(value = "/marketPrice.prod", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String marketPrice(@RequestParam("product") String product) {
        List<Double> marketPrices = productMapper.marketPrice(product);
        if (marketPrices == null || marketPrices.isEmpty()) {
            return new Gson().toJson("등록된 상품이 없습니다.");
        }
        Gson gson = new Gson();
        return gson.toJson(marketPrices);
    }

 

 	// 관리자 페이지 전체/상품검색
 	@RequestMapping("/prod.do")
 	public String adminSearch(HttpServletRequest req, @RequestParam(value = "search", required = false) String search) {
 		
 		int pageSize = 5; // 한 페이지당 보여줄 게시물 수
	    String pageNumStr = req.getParameter("pageNum"); // 현재 페이지 번호를 파라미터로 받아옴

	    int pageNum = (pageNumStr == null) ? 1 : Integer.parseInt(pageNumStr); // 현재 페이지 번호, 기본값은 1

	    // 게시판 목록 가져오기
	    List<ProductDTO> list = productMapper.allProd();
	    int totalCount;

        if (search != null && !search.isEmpty()) {
            list = productMapper.searchProd(search);
            totalCount = list.size(); // 검색 결과의 전체 게시물 수
        } else {
            list = productMapper.allProd();
            totalCount = list.size(); // 전체 게시물 수
        }
	    // 현재 페이지에 해당하는 게시물만 자르기
	    int start = (pageNum - 1) * pageSize;
	    int end = Math.min(start + pageSize, totalCount);
	    List<ProductDTO> paginatedList = list.subList(start, end);

	    // 페이지 정보 계산
	    int pageCount = (int) Math.ceil((double) totalCount / pageSize); // 전체 페이지 수
	    int pageBlock = 5; // 페이지 블록 사이즈
	    int startPage = (pageNum - 1) / pageBlock * pageBlock + 1; // 시작 페이지 번호
	    int endPage = Math.min(startPage + pageBlock - 1, pageCount); // 끝 페이지 번호

	    // 결과를 request에 저장
	    req.setAttribute("count", totalCount);
	    req.setAttribute("allProd", paginatedList); // 현재 페이지에 해당하는 게시판 목록
	    req.setAttribute("pageNum", pageNum); // 현재 페이지 번호
	    req.setAttribute("pageCount", pageCount); // 전체 페이지 수
	    req.setAttribute("startPage", startPage); // 시작 페이지 번호
	    req.setAttribute("endPage", endPage); // 끝 페이지 번호
	    req.setAttribute("search", search);
	 
 		return "nego/admin/manageProducts";
 	}

 	// 관리자 상품 수정 페이지 이동
 	@RequestMapping(value = "/adminProdEdit.prod", method = RequestMethod.GET)
 	public String adminProdEdit(HttpServletRequest req, @RequestParam("pnum") int pnum) {

 		List<CateDTO> mainList = negoMapper.mainList();
		   req.setAttribute("mainList", mainList);
		  
			
			for (CateDTO mainCategory : mainList) {
				List<CateDTO> subList = negoMapper.subList(mainCategory.getId());
				mainCategory.setSubList(subList);
				
				for (CateDTO subCategory : subList) {
					List<CateDTO> itemList = negoMapper.itemList(subCategory.getId());
					subCategory.setItemList(itemList);
				}
			}
			
			ProductDTO dto = productMapper.getProd(pnum);
			req.setAttribute("getProd", dto);
			req.setAttribute("path", servletcontext.getRealPath("/resources/images/"));

 		return "nego/admin/manageProductEdit";

 	}
 	
 	@RequestMapping("/userPage.prod")
	public String userPage(HttpServletRequest req, @RequestParam String member_id) {
 		
 		Map<String, Object> params = new HashMap<>();
        params.put("member_id", member_id);
 		
		List<ProductDTO> list = productMapper.idProd(params);
		List<ProductDTO> slist = productMapper.idProd_sell(member_id);
		List<ProductDTO> clist = productMapper.idProd_complete(member_id);
		List<ProductDTO> rlist = productMapper.idProd_reserve(member_id);
		
		MemberDTO dto = memberMapper.getMember(member_id);
		
		List<ReviewsDTO> reviews = reviewsMapper.sellReviews(member_id);
		int reviews_count = reviewsMapper.reviewsCount(member_id);
		
		req.setAttribute("idProd", list);
		req.setAttribute("idProd_sell", slist);
		req.setAttribute("idProd_complete", clist);
		req.setAttribute("idProd_reserve", rlist);
		req.setAttribute("member", dto);
		req.setAttribute("sellReviews", reviews);
		req.setAttribute("rCount", reviews_count);
		return "nego/mypage/userPage";
	}

	@RequestMapping("/getProducts")
	@ResponseBody
	public List<ProductDTO> getProducts(@RequestParam String type, @RequestParam String memberId) {
		Map<String, Object> params = new HashMap<>();
        params.put("member_id", memberId);
		
	    List<ProductDTO> products = new ArrayList<>();
	    switch(type) {
	        case "전체":
	            products = productMapper.idProd(params);
	            break;
	        case "판매중":
	            products = productMapper.idProd_sell(memberId);
	            break;
	        case "거래중":
	            products = productMapper.idProd_reserve(memberId);
	            break;
	        case "판매완료":
	            products = productMapper.idProd_complete(memberId);
	            break;
	    }
	    return products;
	}

}
