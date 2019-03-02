<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="poptitle">
    <strong>사용(봉안)자 해약 신청</strong>
    <button type="button" class="close btnClose" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
</div>

<div style="padding: 15px 15px;">

	<!-- 사용(봉안)자 정보 -->
	<div>
		<div class="pull-left"><h4>해약 대상자</h4></div>	
	</div>
    <div class="clearfix"></div>
    
    <div class="table-responsive">
        <table id="tblUseUser" class="table table-style table-bordered">
        	<colgroup>
        		<col width="5%">
        		<col width="8%">
        		<col width="8%">
        		<col width="20%">
        		<col width="5%">
        		<col width="5%">
        		<col width="5%">
        		<col width="7%">
        		<col width="7%">
        	</colgroup>
            <thead>
                <tr>
                    <th scope="col">성명</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">휴대전화</th>
                    <th scope="col">주소</th>
                    <th scope="col">관계</th>
                    <th scope="col">교인여부</th>
                    <th scope="col">이장대상</th>
                    <th scope="col">상태</th>
                    <th scope="col">승인일자</th>
                </tr>
            </thead>
            <tbody>
            	<tr approvalDate="${userInfo1.approval_date}">
            		<td>${userInfo1.user_name}</td>
            		<td>${userInfo1.birth_date}</td>
            		<td>${userInfo1.mobile}</td>
            		<td>(${userInfo1.post_number})${userInfo1.address1}${userInfo1.address2}</td>
            		<td>${userInfo1.relation_type_name}</td>
            		<td>${userInfo1.is_church_person}</td>
            		<td>${userInfo1.is_move}</td>
            		<td>
            			<c:choose>
            				<c:when test="${not empty userInfo1.approval_date}">
            					<c:choose>
            						<c:when test="${userInfo1.assign_status == 'OCCUPIED'}">사용(봉안)</c:when>
            						<c:otherwise>사용승인</c:otherwise>
            					</c:choose>
            				</c:when>
            				<c:otherwise>
            				사용미승인
            				</c:otherwise>
            			</c:choose>
            		</td>
            		<td>${userInfo1.approval_date}</td>
            	</tr>
            	<c:if test="${not empty userInfo2}">
            	<tr approvalDate="${userInfo2.approval_date}">
            		<td>${userInfo2.user_name}</td>
            		<td>${userInfo2.birth_date}</td>
            		<td>${userInfo2.mobile}</td>
            		<td>(${userInfo2.post_number})${userInfo2.address1}${userInfo2.address2}</td>
            		<td>${userInfo2.relation_type_name}</td>
            		<td>${userInfo2.is_church_person}</td>
            		<td>${userInfo2.is_move}</td>
            		<td>
            			<c:choose>
            				<c:when test="${not empty userInfo2.approval_date}">
            					<c:choose>
            						<c:when test="${userInfo2.assign_status == 'OCCUPIED'}">사용(봉안)</c:when>
            						<c:otherwise>사용승인</c:otherwise>
            					</c:choose>
            				</c:when>
            				<c:otherwise>
            				사용미승인
            				</c:otherwise>
            			</c:choose>
            		</td>
            		<td>${userInfo2.approval_date}</td>
            	</tr>
            	</c:if>
            </tbody>
        </table>
    </div>
    
	<c:choose>
		<c:when test="${not empty userInfo2}">
		<c:set var="totalPrice" value="${bunyangInfo.price_per_count * 2}"/>
		</c:when>
		<c:otherwise>
		<c:set var="totalPrice" value="${bunyangInfo.price_per_count * 1}"/>
		</c:otherwise>
	</c:choose>
    
    <!-- 해약 정보 -->
	<div style="margin-top: 15px;">
		<div class="pull-left"><h4>해약 정보</h4></div>	
	</div>
    <div class="clearfix"></div>
    
    <div class="table-responsive" style="border-top: 1px solid #999;">
        <table class="table table-style" style="border-top: 0;">
        	<colgroup>
        		<col width="13%">
        		<col width="20%">
        		<col width="13%">
        		<col width="20%">
        		<col width="13%">
        		<col width="20%">
        	</colgroup>
            <tbody>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">분양금액</p></th>
            		<td align="left">
            			<p class="form-control-static">₩ ${cutil:getThousandSeperatorFormatString(totalPrice)}</p>
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">해약 위약금</p></th>
            		<td align="left">
            			<p id="pPenalty" class="form-control-static"></p>
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">반환금</p></th>
            		<td align="left">
            			<p id="pSurrender" class="form-control-static"></p>
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입금예정일</p></th>
            		<td align="left">
            			<input id="tiDepositDate" class="form-control" type="text">
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입금은행</p></th>
            		<td align="left">
            			<input id="tiDepositBank" class="form-control" type="text">
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입금계좌</p></th>
            		<td align="left">
            			<input id="tiDepositAccount" class="form-control" type="text">
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">예금주</p></th>
            		<td align="left">
            			<input id="tiAccountHolder" class="form-control" type="text">
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">해약일자</p></th>
            		<td align="left">
            			<input id="tiCancelDate" class="form-control" type="text">
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">해약사유</p></th>
            		<td align="left">
            			<input id="tiCancelReason" class="form-control" type="text">
            		</td>
            	</tr>
            </tbody>
        </table>
    </div>

	<div class="mt-30 text-center">
    	<button id="btnConfrim" type="button" class="btn btn-danger btn-lg" onclick="_cancel()">해약</button>
        <button type="button" class="btn btn-default btn-lg btnClose" onclick="_close()">취소</button>
	</div>

</div>

<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/daterangepicker.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.number.min.js"></script>
<script type="text/javascript">
(function(){
	// 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
	common.datePicker($("#tiDepositDate"));
	common.datePicker($("#tiCancelDate"));
	// 해약일자 변경시 위약금 및 반환금 재계산
	$("#tiCancelDate").change(function(e) {
		calcCancelPrice();
	});
	calcCancelPrice();
})();

/**
 * 해약 위약금 및 반환금 계산
 */
function calcCancelPrice() {
	var totalPrice = ${totalPrice};// 분양금액
	var pricePerCount = ${bunyangInfo.price_per_count};// 기수당 단가
	var penalty = 0;// 위약금
	var surrender = 0;// 해약반환금
	$('#tblUseUser tbody tr').each(function(idx) {
		var approvalDate = $(this).attr('approvalDate');// 사용승인일
		var cancelDate = $("#tiCancelDate").data('daterangepicker').startDate.format('YYYYMMDD');// 해약일자
		// 사용승인이후에는 해약경과일수 율로 위약금 계산
		if(approvalDate) {
			var start = moment(common.toNumeric(approvalDate), "YYYYMMDD");
			var end = moment(cancelDate, "YYYYMMDD");
			var elapsedDay = moment.duration(end.diff(start)).asDays();
			var elapsedRate = Math.round((365 + elapsedDay) / (15 * 365) * 100);
			penalty += pricePerCount * elapsedRate / 100;
		} else {// 사용승인 이전은 계약금의 50%
			penalty += pricePerCount * 0.1 * 0.5;
		}
	});
	surrender = totalPrice - penalty;
    $('#pPenalty').text('₩ '+$.number(penalty));
    $('#pSurrender').text('₩ '+$.number(surrender));
}

/**
 * 해약
 */
function _cancel() {
	var data = {};
	data['bunyangSeq'] = '${bunyangInfo.bunyang_seq}';
	data['userId1'] = '${userInfo1.user_id}';
	data['userId2'] = '${userInfo2.user_id}';
	data['cancelDepositPlanDate'] = $("#tiDepositDate").data('daterangepicker').startDate.format('YYYYMMDD');
	data['cancelBank'] = $("#tiDepositBank").val();
	data['cancelAccount'] = $("#tiDepositAccount").val();
	data['cancelAccountHolder'] = $("#tiAccountHolder").val();
	data['cancelDate'] = $("#tiCancelDate").data('daterangepicker').startDate.format('YYYYMMDD');
	data['cancelReason'] = $("#tiCancelReason").val();
	data['surrenderValue'] = common.toNumeric($('#pSurrender').text());
	data['penaltyValue'] = common.toNumeric($('#pPenalty').text());
	
	if(!data['cancelBank']) {
		common.showAlert('입금은행을 입력해주세요.');
		$("#tiDepositBank").focus();
		return;
	}
	if(!data['cancelAccount']) {
		common.showAlert('입금계좌를 입력해주세요.');
		$("#tiDepositAccount").focus();
		return;
	}
	if(!data['cancelAccountHolder']) {
		common.showAlert('예금주를 입력해주세요.');
		$("#tiAccountHolder").focus();
		return;
	}
	
	if(confirm('해당 사용자 계약건을 해약하시겠습니까?')) {
		common.ajax({
    		url:"${contextPath}/admin/cancelUseUser", 
    		data:data,
    		success: function(result) {
    			if(window.opener && window.opener.useUserCancelCallBack != 'undefined') {
        			window.opener.useUserCancelCallBack(result);
        		}
        		common.closeWindow();
    		}
    	});
	}
}

/**
 * 취소
 */
function _close() {
	common.closeWindow();
}



</script>