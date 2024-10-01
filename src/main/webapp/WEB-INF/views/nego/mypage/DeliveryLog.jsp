<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>택배 조회</title>
     <link rel="stylesheet" type="text/css" href="resources/css/mypage/deliveryLog.css">
    
    <script>
        var dtd_companys = {
            "우체국택배": [13, "https://service.epost.go.kr/trace.RetrieveDomRigiTraceList.comm?displayHeader=N&sid1=", "1234567890123 (13자리)", "1588-1300", "http://parcel.epost.go.kr"],
            "CJ대한통운": [10, "https://trace.cjlogistics.com/next/tracking.html?wblNo=", "1234567890 (10자리)", "1588-1255", "http://www.doortodoor.co.kr"],
            "한진택배": [12, "https://www.hanjin.com/kor/CMS/DeliveryMgr/WaybillResult.do?mCode=MN038&schLang=KR&wblnumText2=", "1234567890 (10,12자리)", "1588-0011", "http://hanex.hanjin.co.kr"],
            "로젠택배": [11, "https://www.ilogen.com/m/personal/trace.pop/", "12345678901 (11자리)", "1588-9988", "http://www.ilogen.com"],
            "롯데택배": [12, "https://www.lotteglogis.com/home/reservation/tracking/linkView?InvNo=", "123456789012 (12자리)", "1588-2121", "https://www.lotteglogis.com/"],
            "CJ GLS": [12, "http://nexs.cjgls.com/web/service02_01.jsp?slipno=", "123456789012 (12자리)", "1588-5353", "http://www.cjgls.co.kr"],
            "대신택배": [13, "https://www.ds3211.co.kr/freight/internalFreightSearch.ht?billno=", "1234567890123 (13자리)", "043-222-4582", "http://apps.ds3211.co.kr"],
            "경동택배": [11, "https://kdexp.com/service/delivery/etc/delivery.do?barcode=", "12345678901 (최대11자리)", "031-460-2400", "http://www.kdexp.com/"],
            "일양로지스택배": [9, "http://www.ilyanglogis.com/functionality/tracking_result.asp?hawb_no=", "123456789 (9자리)", "1588-0002", "http://www.ilyanglogis.com/"],
            "CVSnet 편의점택배": [10, "https://www.cvsnet.co.kr/invoice/tracking.do?invoice_no=", "1234567890 (10자리)", "1566-1025", "http://www.cvsnet.co.kr/"],
            "TNT Express": [13, "http://www.tnt.com/webtracker/tracking.do?respCountry=kr&respLang=ko&searchType=CON&cons=", "GE123456789WW (9,13자리)", "1588-0588", "http://www.tnt.com/express/ko_kr/site/home.html"]
        };

        function doorToDoorSearch() {
            var dtd_select_obj = document.getElementById("dtd_select");
            var company = dtd_select_obj.options[dtd_select_obj.selectedIndex].value;
            var query_obj = document.getElementById('dtd_number_query');
            var query = query_obj.value.replace(' ', '');
            var url = "";

            /* 운송장 번호 값 확인 */
             if (company == "한진택배" || company == "현대택배") {
                if (!isNumeric(query)) {
                    alert("운송장 번호는 숫자만 입력해주세요.");
                    query_obj.focus();
                    return false;
                } else if (query.length != 10 && query.length != 12) {
                    alert(company + "의 운송장 번호는 10자리 또는 12자리의 숫자로 입력해주세요.");
                    query_obj.focus();
                    return false;
                }
            } else if (company == "경동택배") {
                if (!isNumeric(query)) {
                    alert("운송장 번호는 숫자만 입력해주세요.");
                    query_obj.focus();
                    return false;
                } else if (query.length != 9 && query.length != 10 && query.length != 11) {
                    alert(company + "의 운송장 번호는 9자리 또는 10자리 또는 11자리의 숫자로 입력해주세요.");
                    query_obj.focus();
                    return false;
                }
            } else if (company == "TNT Express") {
                var pattern1 = /^[a-zA-Z]{3}[0-9]{9}$/;
                var pattern2 = /^[0-9]{13}$/;
                if (query.search(pattern1) == -1 && query.search(pattern2) == -1) {
                    alert(company + "의 운송장 번호 패턴에 맞지 않습니다.");
                    query_obj.focus();
                    return false;
                }
            } else {
                if (!isNumeric(query)) {
                    alert("운송장 번호는 숫자만 입력해주세요.");
                    query_obj.focus();
                    return false;
                } else if (query.length != dtd_companys[company][0]) {
                    alert(company + "의 운송장 번호는 " + dtd_companys[company][2] + "의 숫자로 입력해주세요.");
                    query_obj.focus();
                    return false;
                }
            }

            url = dtd_companys[company][1] + query;
            var openNewWindow = document.dtd_form.opendata[0].checked;
            if (openNewWindow) {
                window.open(url);
            } else {
                window.location.href = url;
            }
        }

        function isNumeric(s) {
            for (i = 0; i < s.length; i++) {
                c = s.charAt(i);
                if (c < "0" || c > "9") return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div align ="center">
    <h1>택배 조회</h1>
    <form name="dtd_form">
        <select id="dtd_select">
            <option value="우체국택배">우체국택배</option>
            <option value="CJ대한통운">CJ대한통운</option>
            <option value="한진택배">한진택배</option>
            <option value="로젠택배">로젠택배</option>
            <option value="롯데택배">롯데택배</option>
            <option value="CJ GLS">CJ GLS</option>
            <option value="대신택배">대신택배</option>
            <option value="경동택배">경동택배</option>
            <option value="일양로지스택배">일양로지스택배</option>
            <option value="CVSnet 편의점택배">CVSnet 편의점택배</option>
            <option value="TNT Express">TNT Express</option>
        </select>
        <input type="text" id="dtd_number_query" placeholder="운송장 번호 입력">
        <div>
            <input type="radio" name="opendata" value="1" checked> 새 창에서 열기
            <input type="radio" name="opendata" value="0"> 같은 창에서 열기
        </div>
        <button class="butt" type="button" onclick="doorToDoorSearch()">조회</button>
    </form>
</div>
</body>
</html>
