<%@page import="com.calvary.admin.controller.AdminController"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="maintYear" name="maintYear" value="${searchVo.maintYear}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq" value="${bunyangSeq}">
	<input type="hidden" id="paymentYn" name="paymentYn" value="${paymentYn}">
</form>

<div class="poptitle">
	<strong>관리비 납부 상세 정보</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 15px 15px;">
    <!-- 신청자 -->
    <div>
    	<div class="pull-left">
	    	<h4>
	    		<c:choose>
		    		<c:when test="${paymentYn == 'Y'}">관리비 납부리스트</c:when>
		    		<c:otherwise>관리비 미납리스트</c:otherwise>
		    	</c:choose>
	    	</h4>
    	</div>
    </div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table class="table table-style table-bordered">
        	<colgroup>
        		<col width="8%">
        		<col width="8%">
        		<col width="10%">
        		<col width="15%">
        		<col width="8%">
        		<col width="8%">
        		<col width="8%">
        		<col width="20%">
        		<col width="10%">
        	</colgroup>
            <thead>
                <tr>
                    <th scope="col" colspan="2">계약정보</th>
                    <th scope="col" colspan="4">관리비정보</th>
                    <th scope="col" colspan="3">납부자정보</th>
                </tr>
                <tr>
                    <th scope="col">계약번호</th>
                    <th scope="col">계약자명</th>
                    <th scope="col">사용(봉안)자</th>
                    <th scope="col">관리비기간</th>
                    <th scope="col">관리비</th>
                    <th scope="col">관리비유형</th>
                    <th scope="col">성명</th>
                    <th scope="col">주소</th>
                    <th scope="col">연락처</th>
				</tr>
            </thead>
            <tbody>
            	<c:forEach items="${maintPaymentDetailList}" var="rowItem">
            	<tr>
            		<td>${rowItem.bunyang_no}</td>
            		<td>${rowItem.apply_user_name}</td>
            		<td>${rowItem.user_name}(${rowItem.relation_type_name})</td>
            		<td>${rowItem.maint_start_date} ~ ${rowItem.maint_end_date}</td>
            		<td align="right">${cutil:getThousandSeperatorFormatString(rowItem.payment_price)}</td>
            		<td>${rowItem.payment_type_name}</td>
            		<td>${rowItem.charger_name}</td>
            		<td align="left">(${rowItem.post_number}) ${rowItem.address1} ${rowItem.address2}</td>
            		<td>${rowItem.charger_phone}</td>
            	</tr>
            	</c:forEach>
            </tbody>
        </table>
    </div>
    
    <!-- 페이징 -->
	<div id="divPagination" class="text-center">
	</div>

</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	
	// 페이징 표시 설정
	$('#divPagination').bootpag({
	   total: Math.ceil(${searchVo.totalCount/searchVo.countPerPage}),
	   page: ${searchVo.pageIndex},
	   maxVisible: 5
	}).on('page', function(event, num){
		_search(num);
	});
	
	// 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/popup/maintPaymentDetailInfo";
	frm.submit();
}

</script>