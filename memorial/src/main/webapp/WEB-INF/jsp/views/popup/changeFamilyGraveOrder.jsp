<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<style>
.grid-text {
    pointer-events: none;
}
</style>
<div class="poptitle">
	<strong>가족형 순서변경</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content">

	<div style="padding: 10px 10px;">
		<div class="table-responsive">
	        <table id="tblModifyInfo" class="table table-style table-bordered">
	        	<colgroup>
	        		<col width="150">
	        		<col width="150">
	        		<col width="150">
	        		<col width="150">
	        		<col width="200">
	        		<col width="80">
	        	</colgroup>
	            <thead>
	                <tr>
	                    <th scope="col">계약번호</th>
	                    <th scope="col">계약자</th>
	                    <th scope="col">장묘형태</th>
	                    <th scope="col">사용자</th>
	                    <th scope="col">위치</th>
	                    <th scope="col">순서변경</th>
	                </tr>
	            </thead>
	            <tbody>
            		<c:forEach var="row" items="${graveAssignList }" varStatus="status">
            		<tr 
            		group_seq="${row.group_seq }" 
            		bunyang_seq="${row.bunyang_seq }"
            		assign_status="${row.assign_status }"
            		use_user_seq1="${row.use_user_seq1 }"
            		use_user_seq2="${row.use_user_seq2 }"
            		couple_seq="${row.couple_seq }"
            		assign_date1="${row.assign_date1 }"
            		assign_date2="${row.assign_date2 }"
            		rowNo="${status.count}"
            		>
            			<td>${cutil:nullToEmpty(row.bunyang_no) }</td>
            			<td>${cutil:nullToEmpty(row.apply_user_name) }</td>
            			<td>
            				<c:choose>
            					<c:when test="${row.grave_type eq 'COUPLE' }">부부형</c:when>
            					<c:when test="${row.grave_type eq 'SINGLE' }">1인형</c:when>
            				</c:choose>
            			</td>
            			<td>${cutil:nullToEmpty(row.use_user_exp) }</td>
            			<td>
            				${cutil:getGraveSectionExp(row.section_seq, row.row_seq, row.col_seq, row.seq_no) }
            			</td>
            			<td 
            				name="graveInfo"
            				sectionSeq="${row.section_seq }"
            				rowSeq="${row.row_seq }"
            				colSeq="${row.col_seq }"
            				>
            				<button type="button" class="btn btn-sm btn-default" onclick="_changeDisplayOrder('up', this)"><span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span></button>
	    					<button type="button" class="btn btn-sm btn-default" onclick="_changeDisplayOrder('down', this)"><span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span></button>
            			</td>
            		</tr>
            		</c:forEach>
	            </tbody>
	        </table>
	    </div>
	    <div class="text-center" style="margin-top: 5px;">
	        <button type="button" class="btn btn-primary btn-lg" onclick="_save()">저장</button>
	        <button type="button" class="btn btn-default btn-lg btnClose">닫기</button>
	    </div>
	</div>
    
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/d3.min.js"></script>
<script type="text/javascript">
(function() {
	// 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
})();

/** 
 * 순서 저장
 */
function _save() {
	var approvalGraveVo = {};
	var requestGraveList = [];
	var graveInfoVo;
	var existChangedRow = false;
	$('#tblModifyInfo tbody tr').each(function(idx) {
		if(Number($(this).attr('rowNo')) != idx+1) {
			existChangedRow = true;
		}
		graveInfoVo = {};
		graveInfoVo.groupSeq = $(this).attr('group_seq');
		graveInfoVo.bunyangSeq = $(this).attr('bunyang_seq');
		graveInfoVo.assignStatus = $(this).attr('assign_status');
		graveInfoVo.useUserSeq1 = $(this).attr('use_user_seq1');
		graveInfoVo.useUserSeq2 = $(this).attr('use_user_seq2');
		graveInfoVo.coupleSeq = $(this).attr('couple_seq');
		graveInfoVo.assignDate1 = $(this).attr('assign_date1');
		graveInfoVo.assignDate2 = $(this).attr('assign_date2');
		graveInfoVo.sectionSeq = $(this).find('td[name="graveInfo"]').attr('sectionSeq');
		graveInfoVo.rowSeq = $(this).find('td[name="graveInfo"]').attr('rowSeq');
		graveInfoVo.colSeq = $(this).find('td[name="graveInfo"]').attr('colSeq');
		requestGraveList.push(graveInfoVo);
	});
	
	if(!existChangedRow) {
		common.showAlert('변경된 정보가 없습니다.');
		return;
	}
	if(requestGraveList.length == 0) {
		common.showAlert('저장할 정보가 없습니다.');
		return;
	}
	
	approvalGraveVo.requestGraveList = requestGraveList;
	common.ajax({
		url:"${contextPath}/popup/saveFamilyGraveOrder", 
		data:JSON.stringify(approvalGraveVo),
		contentType: 'application/json',
		success: function(result) {
			if(result.result) {
				common.showAlert('순서가 변경되었습니다.');
				if (window.opener && window.opener.changeFamilyCallBack != 'undefined') {
			        window.opener.changeFamilyCallBack(true);
			    }
				common.closeWindow();
    		} else {
    			common.showAlert('순서변경에 실패하였습니다.');
    		}
		},
		error: function(xhr, status, message) {
			common.showAlert('저장시 에러가 발생하였습니다.');
		}
	});
}

/**
 * 행순서 변경
 */
function _changeDisplayOrder(direction, btn) {
	var tbl = $('#tblModifyInfo');
	var tr = $(btn).parent('td').parent('tr');
	var srcTR = tr;
	var targetTR;
	if(direction == 'up') {
		targetTR = $(tr).prev(); 
	} else if(direction == 'down') {
		targetTR = $(tr).next(); 
	}
	if(targetTR && targetTR.length > 0) {
		var src_group_seq = srcTR.attr('group_seq');  
		var src_bunyang_seq = srcTR.attr('bunyang_seq');  
		var src_assign_status = srcTR.attr('assign_status');  
		var src_use_user_seq1 = srcTR.attr('use_user_seq1');  
		var src_use_user_seq2 = srcTR.attr('use_user_seq2');  
		var src_couple_seq = srcTR.attr('couple_seq');  
		var src_assign_date1 = srcTR.attr('assign_date1');  
		var src_assign_date2 = srcTR.attr('assign_date2');  
		var src_rowNo = srcTR.attr('rowNo');  
		var target_group_seq = targetTR.attr('group_seq');  
		var target_bunyang_seq = targetTR.attr('bunyang_seq');  
		var target_assign_status = targetTR.attr('assign_status');  
		var target_use_user_seq1 = targetTR.attr('use_user_seq1');  
		var target_use_user_seq2 = targetTR.attr('use_user_seq2');  
		var target_couple_seq = targetTR.attr('couple_seq');
		var target_assign_date1 = targetTR.attr('assign_date1');  
		var target_assign_date2 = targetTR.attr('assign_date2');
		var target_rowNo = targetTR.attr('rowNo');
		var srcBunyangNo = srcTR.find('td').eq(0).text();
		var srcApplyUser = srcTR.find('td').eq(1).text();
		var srcGraveType = srcTR.find('td').eq(2).text();
		var srcUseUser = srcTR.find('td').eq(3).text();
		var targetBunyangNo = targetTR.find('td').eq(0).text();
		var targetApplyUser = targetTR.find('td').eq(1).text();
		var targetGraveType = targetTR.find('td').eq(2).text();
		var targetUseUser = targetTR.find('td').eq(3).text();
		srcTR.attr('group_seq', target_group_seq);
		srcTR.attr('bunyang_seq', target_bunyang_seq);
		srcTR.attr('assign_status', target_assign_status);
		srcTR.attr('use_user_seq1', target_use_user_seq1);
		srcTR.attr('use_user_seq2', target_use_user_seq2);
		srcTR.attr('couple_seq', target_couple_seq);
		srcTR.attr('assign_date1', target_assign_date1);
		srcTR.attr('assign_date2', target_assign_date2);
		srcTR.attr('rowNo', target_rowNo);
		srcTR.find('td').eq(0).text(targetBunyangNo);
		srcTR.find('td').eq(1).text(targetApplyUser);
		srcTR.find('td').eq(2).text(targetGraveType);
		srcTR.find('td').eq(3).text(targetUseUser);
		targetTR.attr('group_seq', src_group_seq);
		targetTR.attr('bunyang_seq', src_bunyang_seq);
		targetTR.attr('assign_status', src_assign_status);
		targetTR.attr('use_user_seq1', src_use_user_seq1);
		targetTR.attr('use_user_seq2', src_use_user_seq2);
		targetTR.attr('couple_seq', src_couple_seq);
		targetTR.attr('assign_date1', src_assign_date1);
		targetTR.attr('assign_date2', src_assign_date2);
		targetTR.attr('rowNo', src_rowNo);
		targetTR.find('td').eq(0).text(srcBunyangNo);
		targetTR.find('td').eq(1).text(srcApplyUser);
		targetTR.find('td').eq(2).text(srcGraveType);
		targetTR.find('td').eq(3).text(srcUseUser);
	}
}

</script>