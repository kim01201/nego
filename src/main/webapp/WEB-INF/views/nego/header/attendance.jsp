<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>출석체크</title>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

    <script>
    function checkAttendance(day) {
        var name =  '${sessionScope.mbId.id}';  // 실제 사용자 이름을 여기에 넣어야 합니다.
        
        var today = new Date();  //현재 날짜 가져오기 , today 변수에 현재 날짜와 시간을 저장
        //todayDate 변수에 현재 날짜를 "YYYY-MM-DD" 형식으로 저장합니다.
        var todayDate = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
        
        //selectedDate 변수에는 현재 연도와 월, 그리고 함수 인자로 받은 day 값을 사용하여 새로운 Date 객체를 생성
        var selectedDate = new Date(today.getFullYear(), today.getMonth(), day);
        //selectedDateString 변수에는 선택한 날짜를 "YYYY-MM-DD" 형식으로 저장
        var selectedDateString = selectedDate.getFullYear() + '-' + (selectedDate.getMonth() + 1) + '-' + selectedDate.getDate();
		
        if (selectedDateString !== todayDate) {
            alert("오늘 날짜만 출석체크 할 수 있습니다.");  
            return;
        }
        
        $.ajax({
            url: 'checkAttendance.do',
            type: 'POST',
            data: {member_id: name },
            success: function(response) {
                if (response === "success") {
                    location.reload();
                    alert('출석 체크에 성공했습니다.');
                } else if(response ==="notToday") {
                    location.reload();
                    alert('오늘은 더 이상 출석할수 없습니다.');
                }
            },
            error: function() {
                alert('서버 오류가 발생했습니다.');
            }
        });
    }
    </script>
    <link rel="stylesheet" type="text/css" href="resources/css/header/attendance.css">
</head>
<body>
<main>
    <header>
        <jsp:include page="../Header.jsp"/>
    </header>
    <div class="calendar">
        <h1>출석체크 하고 오늘의 <span class="highlight">에코마일</span>을 받으세요!</h1>
        <div class="calendar-container">
            <div class="calendar-content">
                <img src="resources/img/stamp.png" alt="출석체크 이미지" style="width: 150px; height: auto;">
                <h2><%= Calendar.getInstance().get(Calendar.YEAR) %>년 <%= Calendar.getInstance().get(Calendar.MONTH) + 1 %>월</h2>
                <table>
                    <tr>
                        <th>일</th>
                        <th>월</th>
                        <th>화</th>
                        <th>수</th>
                        <th>목</th>
                        <th>금</th>
                        <th>토</th>
                    </tr>
                    <%
                        Calendar calendar = Calendar.getInstance();
                        calendar.set(Calendar.DAY_OF_MONTH, 1);
                        int firstDayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
                        int daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

                        int currentDay = 1;
                        for (int i = 1; i <= 6; i++) {
                            out.print("<tr>");
                            for (int j = 1; j <= 7; j++) {
                                if (i == 1 && j < firstDayOfWeek || currentDay > daysInMonth) {
                                    out.print("<td></td>");
                                } else {
                                    if (currentDay == Calendar.getInstance().get(Calendar.DAY_OF_MONTH)) {
                                        out.print("<td class='today' onclick='checkAttendance(" + currentDay + ")'>" + currentDay + "</td>");
                                    } else {
                                        out.print("<td onclick='checkAttendance(" + currentDay + ")'>" + currentDay + "</td>");
                                    }
                                    currentDay++;
                                }
                            }
                            out.print("</tr>");
                            if (currentDay > daysInMonth) break;
                        }
                    %>
                </table>
            </div>
        </div>
    </div>
    <footer>
        <jsp:include page="../bottom.jsp"/>
    </footer>
</main>
</body>
</html>
