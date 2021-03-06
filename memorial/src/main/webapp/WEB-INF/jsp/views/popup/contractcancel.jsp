<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="poptitle">
    <strong>분양계약 해약 신청</strong>
    <button type="button" class="close btnClose" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
</div>

<div style="padding: 15px 15px;">

	<!-- 계약 정보 -->
	<div>
		<div class="pull-left"><h4>계약 정보</h4></div>	
	</div>
    <div class="clearfix"></div>
    
    <div class="table-responsive" style="border-top: 1px solid #999;">
        <table class="table table-style" style="border-top: 0;">
        	<colgroup>
        		<col width="18%">
        		<col width="32%">
        		<col width="18%">
        		<col width="32%">
        	</colgroup>
            <tbody>
            	<tr>
            		<th style="background-color: #f5f5f5;">계약자</th>
            		<td align="left" colspan="3">${bunyangInfo.apply_user_name}</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">신청형태</th>
            		<td align="left" colspan="3">${bunyangInfo.product_type_name}</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">장묘형태</th>
            		<td align="left" colspan="3">부부형 : [${bunyangInfo.couple_type_count }] x 2&nbsp;&nbsp;&nbsp;&nbsp;1인형 : [${bunyangInfo.single_type_count }]&nbsp;&nbsp;(총 ${bunyangInfo.couple_type_count*2 + bunyangInfo.single_type_count}기)</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">총 분양대금</th>
            		<td align="left" colspan="3">₩ ${cutil:getThousandSeperatorFormatString(bunyangInfo.total_price)}</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">총 납부금액</th>
            		<td align="left" colspan="3">계약금 : ₩ ${cutil:getThousandSeperatorFormatString(bunyangInfo.down_payment)} + 잔금 : ₩ ${cutil:getThousandSeperatorFormatString(bunyangInfo.balance_payment)} = ₩ ${cutil:getThousandSeperatorFormatString(bunyangInfo.down_payment + bunyangInfo.balance_payment)}
            		</td>
            	</tr>
            </tbody>
        </table>
    </div>
    
    <c:set var="penalty" value="${bunyangInfo.down_payment/2}"/><!-- 위약금 -->
    <c:set var="cancelReturn" value="${bunyangInfo.down_payment + bunyangInfo.balance_payment - penalty}"/><!-- 반환금 -->
    
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
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">해약 위약금</p></th>
            		<td align="left">
            			<p class="form-control-static">₩ ${cutil:getThousandSeperatorFormatString(penalty)}</p>
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">반환금</p></th>
            		<td align="left">
            			<p class="form-control-static">₩ ${cutil:getThousandSeperatorFormatString(cancelReturn)}</p>
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입금예정일</p></th>
            		<td align="left">
            			<input id="tiDepositDate" class="form-control" type="text">
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입금은행</p></th>
            		<td align="left">
            			<input id="tiDepositBank" class="form-control" type="text">
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입금계좌</p></th>
            		<td align="left">
            			<input id="tiDepositAccount" class="form-control" type="text">
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">예금주</p></th>
            		<td align="left">
            			<input id="tiAccountHolder" class="form-control" type="text">
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">해약일자</p></th>
            		<td align="left">
            			<input id="tiCancelDate" class="form-control" type="text">
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">해약사유</p></th>
            		<td align="left" colspan="3">
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
	common.datePicker($("#tiDepositDate"));
	common.datePicker($("#tiCancelDate"));
})();

/**
 * 해약
 */
function _cancel() {
	var data = {};
	data['bunyangSeq'] = '${bunyangInfo.bunyang_seq}';
	data['depositAmount'] = ${cancelReturn};
	data['depositPlanDate'] = $("#tiDepositDate").data('daterangepicker').startDate.format('YYYYMMDD');
	data['depositBank'] = $("#tiDepositBank").val();
	data['depositAccount'] = $("#tiDepositAccount").val();
	data['accountHolder'] = $("#tiAccountHolder").val();
	data['cancelDate'] = $("#tiCancelDate").data('daterangepicker').startDate.format('YYYYMMDD');
	data['cancelReason'] = $("#tiCancelReason").val();
	
	if(!data['depositBank']) {
		common.showAlert('입금은행을 입력해주세요.');
		$("#tiDepositBank").focus();
		return;
	}
	if(!data['depositAccount']) {
		common.showAlert('입금계좌를 입력해주세요.');
		$("#tiDepositAccount").focus();
		return;
	}
	if(!data['accountHolder']) {
		common.showAlert('예금주를 입력해주세요.');
		$("#tiAccountHolder").focus();
		return;
	}
	
	if(confirm('해당계약건을 해약하시겠습니까?')) {
		common.ajax({
    		url:"${contextPath}/admin/cancelapproval", 
    		data:data,
    		success: function(result) {
    			var applyUserName = '${bunyangInfo.apply_user_name}';
				var mobile = '${bunyangInfo.apply_user_mobile}';
				if(result && result.result) {
					var resultCache = result;
					if(confirm('해약처리가 승인되었습니다.\n계약자에게 해약 안내 메세지를 전송하시겠습니까?')) {
						var cancelDate = $("#tiCancelDate").data('daterangepicker').startDate.format('YY/MM/DD');// 해약일자
						var depositPlanDate = $("#tiDepositDate").data('daterangepicker').startDate.format('YY/MM/DD');// 입금예정일
						var bankAccount = data['depositBank'] + ' ' + data['depositAccount'];// 입금계좌
						var depositAmount = $.number(data['depositAmount']);// 입금액
						var sendSmsVo = {};
						sendSmsVo.msgKey = 'M0005';
						sendSmsVo.receivers = mobile;
						sendSmsVo.sequences = [applyUserName, cancelDate, depositPlanDate, bankAccount, depositAmount];
						common.sendSms(sendSmsVo, function(result) {
							common.showAlert('메세지가 전송되었습니다.');
							if(window.opener && window.opener.contractCancelCallBack != 'undefined') {
			        			window.opener.contractCancelCallBack(resultCache);
			        		}
			        		common.closeWindow();
						}, function(xhr, status, message) {
							if(window.opener && window.opener.contractCancelCallBack != 'undefined') {
			        			window.opener.contractCancelCallBack(resultCache);
			        		}
			        		common.closeWindow();
						});
					} else {
						if(window.opener && window.opener.contractCancelCallBack != 'undefined') {
		        			window.opener.contractCancelCallBack(result);
		        		}
		        		common.closeWindow();
					}
    			}
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