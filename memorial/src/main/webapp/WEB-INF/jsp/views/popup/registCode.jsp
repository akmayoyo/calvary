<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.table-style > tbody > tr > td {
	padding: 3px 7px;
	font-size: 13px;
}
.btn-sm {
	padding: 4px 7px;
	font-size: 12px;
}
</style>
<div class="poptitle">
    <strong>코드 등록</strong>
    <button type="button" class="close btnClose" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
</div>

<div class="content" style="padding: 10px 10px;">

	<div>
		<h4>코드 정보</h4>
	</div>
	<div class="table-responsive" style="border-top: 1px solid #999;">
        <table class="table table-style table-horizon">
        	<colgroup>
        		<col width="180">
        		<col width="*">
        	</colgroup>
            <tbody>
            	<tr>
            		<th class="required">CODE</th>
            		<td><input id="tiCode" class="form-control"></td>
            	</tr>
            	<tr>
            		<th class="required">코드명</th>
            		<td><input id="tiCodeName" class="form-control"></td>
            	</tr>
            	<tr>
            		<th class="required">코드설명</th>
            		<td><input id="tiCodeDesc" class="form-control"></td>
            	</tr>
            	<tr>
            		<th>코드값</th>
            		<td><input id="tiCodeValue" class="form-control"></td>
            	</tr>
            	<tr>
            		<th class="required">표시순서</th>
            		<td><input id="tiDisplayOrder" class="form-control"></td>
            	</tr>
            </tbody>
        </table>
    </div>
    
    <div class="text-center" style="margin-top: 20px; margin-bottom: 10px;">
		<button type="button" class="btn btn-primary btn-lg" onclick="_confirm();">확인</button>
		<button type="button" class="btn btn-default btn-lg btnClose">닫기</button>
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

</script>