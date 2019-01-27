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
	
	<div class="form-group">
	  <textarea class="form-control" rows="5" id="taComment" autofocus="autofocus"></textarea>
	</div>

	<div class="text-center" style="margin-top: 20px;">
        <button type="button" class="btn btn-primary btn-lg" onclick="_confirm()">확인</button>
        <button type="button" class="btn btn-default btn-lg btnClose">취소</button>
    </div>
    
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function() {
    // 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
})();

/**
 * 확인
 */
function _confirm() {
	var ta = $('#taComment');
    var val = ta.val();
    if(!val) {
    	common.showAlert('내용을 입력해주세요.');
    	ta.focus();
    	return;
    }
    if (window.opener && window.opener.registCommentCallBack != 'undefined') {
        window.opener.registCommentCallBack(val);
        common.closeWindow();
    }
}

</script>