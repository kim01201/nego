<!-- checkVerificationCode.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    int inputCode = Integer.parseInt(request.getParameter("verificationCode"));
    int sessionCode = (Integer) session.getAttribute("verificationCode");
    String name = (String) session.getAttribute("name");
    String email = (String) session.getAttribute("email");

    if (inputCode == sessionCode) {
        // 인증번호가 일치하는 경우
        // DB에서 사용자의 아이디를 조회
        // 여기서는 예시로 아이디를 직접 설정
        String userId = "exampleUserId"; // 실제로는 DB에서 조회해야 함

        out.println("인증번호가 확인되었습니다. 아이디: " + userId);
    } else {
        out.println("인증번호가 일치하지 않습니다. 다시 시도해주세요.");
    }
%>

