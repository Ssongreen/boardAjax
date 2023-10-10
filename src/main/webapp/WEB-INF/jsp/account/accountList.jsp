<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	String userName = (String) session.getAttribute("userName");
	String userId = (String) session.getAttribute("userId");

	if (userName == null) {
		// 로그인 정보가 없는 경우 처리
		response.sendRedirect("/login/login.do");
		return;
	}
%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.3/xlsx.full.min.js"></script>

<script type="text/javascript">
/* 페이징과 글 목록 조회  */

function linkPage(pageNo){
    location.href = "/account/accountList.do?pageNo=" + pageNo;
}
</script>
<script>
     function exportToExcel() {
    // 테이블 데이터를 JavaScript 객체로 추출
    var tableHeader = [];
    var tableData = [];
    
    $("table thead tr th").each(function () {
        tableHeader.push($(this).text());
    });
    tableData.push(tableHeader);
     
    // 테이블 내용을 추출
    $("table tbody tr").each(function () {
        var row = [];
        $(this).find("td").each(function () {
            var cellValue = $(this).text();
            row.push(cellValue === "" ? "-" : cellValue); // 빈 값을 "-"로 대체
        });
        tableData.push(row);
    });

    // JavaScript 객체를 XLSX 형식으로 변환
    var worksheet = XLSX.utils.aoa_to_sheet(tableData);
    var workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet1");
	var userName = "<%= session.getAttribute("userName") %>"; 
    // XLSX 파일 다운로드 링크를 생성하고 클릭
    XLSX.writeFile(workbook, userName+".xlsx");
}

    </script>
<form name="sendForm" id="sendForm" method="post" onsubmit="return false;">

	<input type="hidden" id="situSeq" name="situSeq" value=""> 
	<input type="hidden" id="mode" name="mode" value="Cre">
	
	<div id="wrap" class="col-md-offset-1 col-sm-10">
		<div align="center">
			<h2>회계정보리스트</h2>
		</div>
		<div class="form_box2 col-md-offset-7" align="right">
			<div class="right">
				<button class="btn btn-primary"
					onclick="location.href='/account/accountInsert.do'">등록</button>
				<button  class="btn btn-primary" onclick="exportToExcel()">엑셀다운로드 </button>
			</div>
		</div>
		<br />
		<table class="table table-hover">
			<thead>
				<tr align="center">
					<th style="text-align: center;">수익/비용</th>
					<th style="text-align: center;">관</th>
					<th style="text-align: center;">항</th>
					<th style="text-align: center;">목</th>
					<th style="text-align: center;">과</th>
					<th style="text-align: center;">금액</th>
					<th style="text-align: center;">등록일</th>
					<th style="text-align: center;">작성자</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="item" items="${result}" varStatus="status">
				<tr align="center">
    			<td style="text-align: center;"><c:out value="${item.profitCostCodeKor}" /></td>
    			<td style="text-align: center;"><c:out value="${item.bigGroupCodeKor}" /></td>
    			<td style="text-align: center;"><c:out value="${item.middleGroupCodeKor}" /></td>
    			<td style="text-align: center;">
            	<c:choose>
                <c:when test="${empty item.smallGroupCodeKor}">-</c:when>
                <c:otherwise><c:out value="${item.smallGroupCodeKor}" /></c:otherwise>
           		</c:choose>
        		</td>
    			<td style="text-align: center;">
            	<c:choose>
                <c:when test="${empty item.detailGroupCodeKor}">-</c:when>
                <c:otherwise><c:out value="${item.detailGroupCodeKor}" /></c:otherwise>
           		</c:choose>
        		</td>
    			<td style="text-align: center;"><c:out value="${item.transactionMoney}" /></td>
    			<td style="text-align: center;"><c:out value="${item.regDate}" /></td>
    			<td style="text-align: center;"><c:out value="${item.writer}" /></td>
				</tr>
				</c:forEach>
			</tbody>
		</table>

		<div style="text-align: center;" class="paging">
			<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="linkPage" />
		</div>
	</div>
</form>


