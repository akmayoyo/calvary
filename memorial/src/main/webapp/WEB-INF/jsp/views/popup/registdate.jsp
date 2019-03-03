<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="poptitle">
	<strong>${popupTitle}</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 10px 10px;">
	
	<div class="input-group date" data-provide="datepicker"><input id="tiDate" type="text" class="form-control text-center"><div class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></div></div>

	<div class="text-center" style="margin-top: 20px;">
        <button type="button" class="btn btn-primary btn-lg" onclick="_confirm()">확인</button>
        <button type="button" class="btn btn-default btn-lg btnClose">취소</button>
    </div>
    
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/daterangepicker.js"></script>
<script type="text/javascript">
(function() {
	
	common.datePicker($('#tiDate'));
	
    // 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
})();

/**
 * 확인
 */
function _confirm() {
	var dateVal = $('#tiDate').data('daterangepicker').startDate.format('YYYYMMDD');
    if(!dateVal) {
    	common.showAlert('날짜를 입력해주세요.');
    	$('#tiDate').focus();
    	return;
    }
    if (window.opener && window.opener.registDateCallBack != 'undefined') {
        window.opener.registDateCallBack(dateVal);
        common.closeWindow();
    }
}

</script>