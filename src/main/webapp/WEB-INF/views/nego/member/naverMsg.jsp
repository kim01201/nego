<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- message.jsp -->
<script type="text/javascript">
	/* 
	alert("${msg}")
	location.href="${url}"
	 */
	
		alert("${msg}")
	// 네이버 로그아웃 URL 호출
	 var logoutUrl = "${url}";

	 // 현재 창에서 네이버 로그아웃 URL로 이동 후 메인 페이지로 리다이렉트
	 window.location.href = logoutUrl;

	 // 일정 시간(예: 50ms) 후에 메인 페이지로 리다이렉트
	 setTimeout(function() {
	     // 메인 페이지로 리다이렉트
	     window.location.href = "main.do";
	 }, 50);
	
	
	
	
	

</script>