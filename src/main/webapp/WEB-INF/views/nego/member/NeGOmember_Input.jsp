<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="resources/css/member/memberInput.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        var ck = false; // 아이디 중복 확인 상태를 저장하는 변수

        function check() {
            var form = document.forms['f'];
            
            if (form.id.value == "") {
                alert("아이디를 입력해 주세요!!");
                form.id.focus();
                return false;
            }
            if (!form.passwd.value) {
                alert("비밀번호를 입력해 주세요!!");
                form.passwd.focus();
                return false;
            }
            if (!form.name.value) {
                alert("이름을 입력해 주세요!!");
                form.name.focus();
                return false;
            }
            if (form.ssn1.value.length !== 6 || form.ssn2.value.length !== 7) {
                alert("주민번호 자리수가 틀렸습니다!!");
                return false;
            }
            if (!form.email.value) {
                alert("이메일을 입력해 주세요!!");
                form.email.focus();
                return false;
            }
            if (!form.hp1.value) {
                alert("전화번호를 입력해 주세요!!");
                form.hp1.focus();
                return false;
            }
            if (!form.hp2.value) {
                alert("전화번호를 입력해 주세요!!");
                form.hp2.focus();
                return false;
            }
            if (!form.hp3.value) {
                alert("전화번호를 입력해 주세요!!");
                form.hp3.focus();
                return false;
            }
            if (!form.addr.value) {
                alert("주소를 입력해 주세요!!");
                form.addr.focus();
                return false;
            }
            if (!ck) {
                alert("아이디 중복확인을 먼저 해 주세요");
                return false;
            }
            return true;
        }

        function idCheck() {
            let id = $("#id").val();

            if (id === "") {
                alert("아이디를 입력해 주세요");
                $("#id").focus();
                return;
            }

            $.ajax({
                url: "idCheck.do",
                type: "post",
                data: {"id": id},
                success: function(res) {
                    if (res === 'OK') {
                        alert("사용 가능한 아이디 입니다.");
                        ck = true;
                    } else {
                        alert("이미 사용중인 아이디 입니다.");
                        $("#id").val("");
                        $("#id").focus();
                        ck = false;
                    }
                },
                error: function(err) {
                    console.log(err);
                    ck = false;
                }
            });
        }
    </script>
</head>  
<body onload="document.forms['f'].id.focus()">
<main>
    <header>
        <%@include file="../Header.jsp" %>
    </header>
    
    <form name="f" method="post" action="NeGOmember_Inputok.do" onsubmit="return check();" style="align:center;">
        <table class="outline" style="display:flex;align-content: center;flex-direction: row;justify-content: center;align-items: center;">
            <tr>
                <td colspan="2" class="m2">회원가입</td>
            </tr>
            <tr class="m3">
                <td>
                    <label for="name">이름</label>
                    <input type="text" id="name" name="name" class="box" value="${name}">
                </td>
            </tr>
            <tr class="m3">
                <td>
                    <label for="id">아이디</label>
                    <input type="text" id="id" name="id" class="box">
                    <button type="button" class="check-button" onclick="idCheck()">중복확인</button>
                </td>
            </tr>
            <tr class="m3">
                <td>
                    <label for="passwd">비밀번호</label>
                    <input type="password" id="passwd" name="passwd" class="box">
                </td>
            </tr>
            <tr class="m3">
                <td>
                    <label for="ssn1">주민번호</label>
                    <div class="box-container">
                        <input type="text" id="ssn1" name="ssn1" class="box" value="${ssn1}">
                        <span>-</span>
                        <input type="password" id="ssn2" name="ssn2" class="box" value="${ssn2}">
                    </div>
                </td>
            </tr>
            <tr class="m3">
                <td>
                    <label for="email">이메일</label>
                    <input type="text" id="email" name="email" class="box">
                </td>
            </tr>
            <tr class="m3">
                <td>
                    <label for="hp1">연락처</label>
                    <div class="box-container">
                        <input type="text" id="hp1" name="hp1" class="box" size="3" maxlength="3">
                        <span>-</span>
                        <input type="text" id="hp2" name="hp2" class="box" size="4" maxlength="4">
                        <span>-</span>
                        <input type="text" id="hp3" name="hp3" class="box" size="4" maxlength="4">
                    </div>
                </td>
            </tr>
            <tr class="m3">
                <td>
                    <label for="addr">주소</label>
                    <input type="text" id="addr" name="addr" class="box" value="${addr}">
                </td>
            </tr>
            <tr class="m3">
                <td colspan="2" class="buttons">
                    <button type="submit">전송</button>
                    <button type="button" onclick="location.href='Login.do'">취소</button>
                </td>
            </tr>
        </table>
    </form>
    
    <footer>
        <%@include file="../bottom.jsp" %>
    </footer>
</main>
</body>
</html>
