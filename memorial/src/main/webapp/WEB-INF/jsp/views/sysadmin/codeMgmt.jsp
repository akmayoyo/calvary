<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
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
tr.selected {
	background-color: #E0EFFC;
}
</style>
<form id="frm" method="post">
	<input type="hidden" id="parentCodeSeq" name="parentCodeSeq" value="${parentCodeSeq}">
	<input type="hidden" id="parentCodeName" name="parentCodeName" value="${parentCodeName}">
	
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
	
		<div>
	    	<div class="pull-left">
		    	<h4 style="margin-top: 3;">코드 리스트</h4>
	    	</div>
	    	<div class="pull-right">
	    		<button type="button" class="btn btn-default" onclick="_changeDisplayOrder('top','up')"><span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span></button>
	    		<button type="button" class="btn btn-default" onclick="_changeDisplayOrder('top','down')"><span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span></button>
		    	<button class="btn btn-primary" type="button" onclick="_addCode()">추가</button>
		    	<button class="btn btn-primary" type="button" onclick="_saveCode()">저장</button>
	    	</div>
    	</div>
    	<div class="clearfix"></div>
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblTopCode" class="table table-style table-bordered table-hover">
				<colcolgroup>
					<col width="16%">
					<col width="16%">
					<col width="16%">
					<col width="16%">
					<col width="16%">
					<col width="16%">
				</colcolgroup>
				<thead>
					<tr>
						<th scope="col" class="required">CODE</th>
						<th scope="col" class="required">코드명</th>
						<th scope="col" class="required">코드설명</th>
						<th scope="col">코드값</th>
						<th scope="col">표시순서</th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${topLevelCodeList}" var="rowItem">
					<tr codeSeq="${rowItem.code_seq}" codeName="${rowItem.code_name}" <c:if test="${parentCodeSeq == rowItem.code_seq}">class="selected"</c:if>>
	                    <td align="left" name="codeSeq"><a href="javascript:void(0);" class="tbllink" style="color: #337ab7;" onclick="searchChildCodeList(this)">${rowItem.code_seq}</a></td>
	                    <td><input name="codeName" type="text" class="form-control" value="${rowItem.code_name}"></td>
	                    <td><input name="codeDesc" type="text" class="form-control" value="${rowItem.code_desc}"></td>
	                    <td><input name="codeValue" type="text" class="form-control" value="${rowItem.code_value}"></td>
	                    <td name="displayOrder">
	                    	${rowItem.display_order}
	                    </td>
	                    <td>
	                    	<button type="button" data-toggle="tooltip" title="삭제" class="btn btn-default btn-sm" onclick="_deleteCode(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button>
	                    </td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<c:if test="${not empty parentCodeSeq}">
		<div style="margin-top: 25px;">
	    	<div class="pull-left">
		    	<h4 style="margin-top: 3;">상세 코드 리스트 - ${parentCodeName}</h4>
	    	</div>
	    	<div class="pull-right">
	    		<button type="button" class="btn btn-default" onclick="_changeDisplayOrder('child','up')"><span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span></button>
	    		<button type="button" class="btn btn-default" onclick="_changeDisplayOrder('child','down')"><span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span></button>
		    	<button class="btn btn-primary" type="button" onclick="_addCode('${parentCodeSeq}')">추가</button>
		    	<button class="btn btn-primary" type="button" onclick="_saveCode('${parentCodeSeq}')">저장</button>
	    	</div>
    	</div>
    	<div class="clearfix"></div>
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblChildCode" class="table table-style table-bordered table-hover">
				<colcolgroup>
					<col width="16%">
					<col width="16%">
					<col width="16%">
					<col width="16%">
					<col width="16%">
					<col width="16%">
				</colcolgroup>
				<thead>
					<tr>
						<th scope="col" class="required">CODE</th>
						<th scope="col" class="required">코드명</th>
						<th scope="col" class="required">코드설명</th>
						<th scope="col">코드값</th>
						<th scope="col">표시순서</th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${childeCodeList}" var="rowItem">
					<tr parentCodeSeq="${parentCodeSeq}" codeSeq="${rowItem.code_seq}">
						<td align="left" name="codeSeq">${rowItem.code_seq}</td>
	                    <td><input name="codeName" type="text" class="form-control" value="${rowItem.code_name}"></td>
	                    <td><input name="codeDesc" type="text" class="form-control" value="${rowItem.code_desc}"></td>
	                    <td><input name="codeValue" type="text" class="form-control" value="${rowItem.code_value}"></td>
	                    <td name="displayOrder">${rowItem.display_order}</td>
	                    <td>
	                    	<button type="button" data-toggle="tooltip" title="삭제" class="btn btn-default btn-sm" onclick="_deleteCode(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button>
	                    </td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		</c:if>
		
	</div>
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function(){
	
	// 그리드 로우 선택시
	$('#tblTopCode').on('click', '.clickable-row', function(event) {
		var parentCodeSeq = $(this).attr("codeSeq");
		var parentCodeName = $(this).attr("codeName");
	});
	
	$('.table-hover tbody tr').click(function(e) {
		$(this).parent().find('tr.selected').removeClass();
		$(this).addClass('selected');
	});
	
})();

/** 
 * 상세 코드 리스트 조회
 */
function searchChildCodeList(btn) {
	var tr = $(btn).parent('td').parent('tr');
	var parentCodeSeq = $(tr).attr("codeSeq");
	var parentCodeName = $(tr).attr("codeName"); 
	$('#parentCodeSeq').val(parentCodeSeq);
	$('#parentCodeName').val(parentCodeName);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/sysadmin/codeMgmt";
	frm.submit();
}

/**
 * 코드 등록
 */
function _addCode(parentCodeSeq) {
	var tbody;
	if(parentCodeSeq) {
		tbody = $('#tblChildCode tbody');
	} else {
		tbody = $('#tblTopCode tbody');
	}
	var tr = $('<tr/>');
	var displayOrder = $(tbody).find('tr').length + 1;
	// 코드
	tr.append('<td align="left"><input name="codeSeq" type="text" class="form-control"></td>');
	// 코드명
    tr.append('<td><input name="codeName" type="text" class="form-control"></td>');
 	// 코드설명
    tr.append('<td><input name="codeDesc" type="text" class="form-control"></td>');
 	// 코드값
    tr.append('<td><input name="codeValue" type="text" class="form-control"></td>');
    // 표시순서
    tr.append('<td name="displayOrder">' + displayOrder + '</td>');
    // 삭제버튼
    tr.append('<td><button type="button" data-toggle="tooltip" title="삭제" class="btn btn-default btn-sm" onclick="_deleteCode(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button></td>');
    
    tbody.append(tr);
}

/**
 * 코드삭제
 */
function _deleteCode(btn) {
	var tr = $(btn).parent('td').parent('tr');
	var parentCodeSeq = $(tr).attr('parentCodeSeq') ? $(tr).attr('parentCodeSeq') : null;
	var codeSeq = $(tr).attr('codeSeq');
	if(!codeSeq) {// 화면에서 추가된 경우 바로 삭제
		$(tr).remove();
	} else {
		var msg = '해당 코드를 삭제하시겠습니까?';
		if(!parentCodeSeq) {
			msg = '해당 코드를 삭제하시겠습니까?\n삭제시 해당 코드에 소속된 코드가 모두 삭제됩니다.';
		}
		if(confirm(msg)) {
			var codeVo = {};
			codeVo['parentCodeSeq'] = parentCodeSeq;
			codeVo['codeSeq'] = codeSeq;
			// 저장 호출
			common.ajax({
				url:"${contextPath}/sysadmin/deleteCode", 
				data:JSON.stringify(codeVo),
				contentType: 'application/json',
				success: function(result) {
					if(result && result.result) {
						common.showAlert("저장되었습니다.");
						if(!parentCodeSeq) {
							$("#parentCodeSeq").val('');
							$("#parentCodeName").val('');	
						}
						var frm = document.getElementById("frm");
						frm.action = "${contextPath}/sysadmin/codeMgmt";
						frm.submit();
					}
				}
			});
		}
	}
}

/**
 * 코드 변경 내용 저장
 */
function _saveCode(parentCodeSeq) {
	var tbody;
	if(parentCodeSeq) {
		tbody = $('#tblChildCode tbody');
	} else {
		tbody = $('#tblTopCode tbody');
	}
	
	var isValid = true;
	var codeList = [];
	var codeSeqs = [];
	$(tbody).find('tr').each(function(idx) {
		var codeItem = {};
		var flag = $(this).attr('codeSeq') ? 'U' : 'C';// 업데이트, 신규생성 플래그
		var codeSeq;
		if(flag == 'U') {
			codeSeq = $(this).find('td[name="codeSeq"]').text();
		} else if(flag == 'C') {
			codeSeq = $(this).find('input[name="codeSeq"]').val();
		}
		
		if(!codeSeq) {
			common.showAlert('CODE 를 입력하세요.');
			$(this).find('input[name="codeSeq"]').focus();
			isValid = false;
			return false;
		}
		
		// 코드 중복 체크
		if(codeSeqs.indexOf(codeSeq) < 0) {
			codeSeqs.push(codeSeq);
		} else {
			common.showAlert('CODE는 중복될 수 없습니다.(' + codeSeq+ ')');
			$(this).find('input[name="codeSeq"]').focus();
			isValid = false;
			return false;
		}
		
		var codeName = $(this).find('input[name="codeName"]').val();
		var codeDesc = $(this).find('input[name="codeDesc"]').val();
		var codeValue = $(this).find('input[name="codeValue"]').val();
		var codeLevel = parentCodeSeq ? 2 : 1;
		var displayOrder = $(this).find('td[name="displayOrder"]').text();
		
		if(!codeName) {
			common.showAlert('코드명을 입력하세요.');
			$(this).find('input[name="codeName"]').focus();
			isValid = false;
			return false;
		}
		if(!codeDesc) {
			common.showAlert('코드설명을 입력하세요.');
			$(this).find('input[name="codeDesc"]').focus();
			isValid = false;
			return false;
		}
// 		if(codeValue && codeValue != common.toNumeric(codeValue)) {
// 			common.showAlert('코드값은 숫자만 입력가능합니다.');
// 			$(this).find('input[name="codeValue"]').focus();
// 			isValid = false;
// 			return false;
// 		}
		codeItem['flag'] = flag;
		codeItem['codeSeq'] = codeSeq;
		codeItem['codeName'] = codeName;
		codeItem['codeDesc'] = codeDesc;
		codeItem['codeValue'] = codeValue;
		codeItem['codeLevel'] = codeLevel;
		codeItem['displayOrder'] = displayOrder;
		codeItem['parentCodeSeq'] = parentCodeSeq ? parentCodeSeq : '';
		
		codeList.push(codeItem);
	});
	
	if(!isValid) {
		return;
	}
	
	if(codeList.length == 0) {
		common.showAlert('저장할 데이터가 없습니다.');
		return;
	}
	
	var codeInfo = {};
	codeInfo['parentCodeSeq'] = parentCodeSeq;
	codeInfo['codeList'] = codeList;
	
	// 저장 호출
	common.ajax({
		url:"${contextPath}/sysadmin/saveCode", 
		data:JSON.stringify(codeInfo),
		contentType: 'application/json',
		success: function(result) {
			if(result && result.result) {
				common.showAlert("저장되었습니다.");
				if(!parentCodeSeq) {
					$("#parentCodeSeq").val('');
					$("#parentCodeName").val('');	
				}
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/sysadmin/codeMgmt";
				frm.submit();
			}
		}
	});
	
}

/**
 * 행순서 변경
 */
function _changeDisplayOrder(target, direction) {
	var tbl = target == 'top' ? $('#tblTopCode') : $('#tblChildCode');
	var tr = tbl.find('tr.selected');
	if(direction == 'up') {
		$(tr).prev().before($(tr));
	} else if(direction == 'down') {
		$(tr).next().after($(tr));
	}
	// 표시순서 번호 업데이트
	tbl.find('tr').each(function(idx) {
		$(this).find('td[name="displayOrder"]').text(idx);
	});
}

</script>