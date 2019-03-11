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
	
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
	
		<div>
	    	<div class="pull-left">
		    	<h4 style="margin-top: 3;">사용자그룹 리스트</h4>
	    	</div>
	    	<div class="pull-right">
		    	<button class="btn btn-primary" type="button" onclick="_addRole()">추가</button>
		    	<button class="btn btn-primary" type="button" onclick="_saveRole()">저장</button>
	    	</div>
    	</div>
    	<div class="clearfix"></div>
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblRole" class="table table-style table-bordered">
				<colcolgroup>
					<col width="20%">
					<col width="20%">
					<col width="20%">
					<col width="12%">
					<col width="12%">
					<col width="12%">
				</colcolgroup>
				<thead>
					<tr>
						<th scope="col" class="required">그룹아이디</th>
						<th scope="col" class="required">그룹명</th>
						<th scope="col" class="required">설명</th>
						<th scope="col">메뉴권한</th>
						<th scope="col">사용자권한</th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${roleList}" var="rowItem">
					<tr roleId="${rowItem.role_id}">
	                    <td align="left">${rowItem.role_id}</td>
	                    <td><input type="text" name="roleName" class="form-control" value="${rowItem.role_name}"></td>
	                    <td><input type="text" name="roleDesc" class="form-control" value="${rowItem.role_desc}"></td>
	                    <td>
	                    	<button class="btn btn-primary btn-sm" type="button" onclick="_selectMenuRole(this)">메뉴</button>
	                    </td>
	                    <td>
	                    	<button class="btn btn-primary btn-sm" type="button" onclick="_selectUserRole(this)">사용자</button>
	                    </td>
	                    <td>
	                    	<button type="button" data-toggle="tooltip" title="삭제" class="btn btn-default btn-sm" onclick="_deleteRole(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button>
	                    </td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
	</div>
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function(){
	
})();

/**
 * 메뉴권한 등록을 위한 팝업 표시
 */
function _selectMenuRole(btn) {
	var roleId = $(btn).parent('td').parent('tr').attr('roleId');
	var winoption = {width:500, height:750};
	var param = {roleId:roleId};
	common.openWindow("${contextPath}/popup/selectMenuRole", "popSelectMenuRole", winoption, param);
}

/**
 * 사용자권한 등록을 위한 팝업 표시
 */
function _selectUserRole(btn) {
	var roleId = $(btn).parent('td').parent('tr').attr('roleId');
	var winoption = {width:1024, height:700};
	var param = {roleId:roleId};
	common.openWindow("${contextPath}/popup/selectUserRole", "popSelectUserRole", winoption, param);
}

/**
 * 그룹 등록
 */
function _addRole() {
	var tbody = $('#tblRole tbody');
	var tr = $('<tr/>');
	// 그룹아이디
	tr.append('<td align="left"><input name="roleId" type="text" class="form-control"></td>');
	// 그룹명
    tr.append('<td><input name="roleName" type="text" class="form-control"></td>');
 	// 설명
    tr.append('<td><input name="roleDesc" type="text" class="form-control"></td>');
 	// 메뉴권한
    tr.append('<td></td>');
    // 사용자
    tr.append('<td></td>');
    // 삭제버튼
    tr.append('<td><button type="button" data-toggle="tooltip" title="삭제" class="btn btn-default btn-sm" onclick="_deleteRole(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button></td>');
    
    tbody.append(tr);
}

/**
 * 그룹 삭제
 */
function _deleteRole(btn) {
	var tr = $(btn).parent('td').parent('tr');
	var roleId = $(tr).attr('roleId');
	if(!roleId) {// 화면에서 추가된 경우 바로 삭제
		$(tr).remove();
	} else {
		var msg = '해당 그룹을 삭제하시겠습니까?';
		if(confirm(msg)) {
			var data = {};
			data.roleId = roleId;
			// 저장 호출
			common.ajax({
				url:"${contextPath}/sysadmin/deleteRole", 
				data:data,
				success: function(result) {
					if(result && result.result) {
						common.showAlert("삭제되었습니다.");
						var frm = document.getElementById("frm");
						frm.action = "${contextPath}/sysadmin/userRoleMgmt";
						frm.submit();
					}
				}
			});
		}
	}
}

/**
 * 저장
 */
function _saveRole() {
	var tbody = $('#tblRole tbody');
	
	var isValid = true;
	var roleList = [];
	var roleIds = [];
	$(tbody).find('tr').each(function(idx) {
		var roleItem = {};
		var flag = $(this).attr('roleId') ? 'U' : 'C';// 업데이트, 신규생성 플래그
		var roleId;
		if(flag == 'U') {
			roleId = $(this).attr('roleId');
		} else if(flag == 'C') {
			roleId = $(this).find('input[name="roleId"]').val();
		}
		
		if(!roleId) {
			common.showAlert('그룹아이디를 입력하세요.');
			$(this).find('input[name="roleId"]').focus();
			isValid = false;
			return false;
		}
		
		// 아이디 중복 체크
		if(roleIds.indexOf(roleId) < 0) {
			roleIds.push(roleId);
		} else {
			common.showAlert('그룹아이디는 중복될 수 없습니다.(' + roleId+ ')');
			$(this).find('input[name="roleId"]').focus();
			isValid = false;
			return false;
		}
		
		var roleName = $(this).find('input[name="roleName"]').val();
		var roleDesc = $(this).find('input[name="roleDesc"]').val();
		
		if(!roleName) {
			common.showAlert('그룹명을 입력하세요.');
			$(this).find('input[name="roleName"]').focus();
			isValid = false;
			return false;
		}
		if(!roleDesc) {
			common.showAlert('설명을 입력하세요.');
			$(this).find('input[name="roleDesc"]').focus();
			isValid = false;
			return false;
		}
		
		roleItem['flag'] = flag;
		roleItem['roleId'] = roleId;
		roleItem['roleName'] = roleName;
		roleItem['roleDesc'] = roleDesc;
		
		roleList.push(roleItem);
	});
	
	if(!isValid) {
		return;
	}
	
	if(roleList.length == 0) {
		common.showAlert('저장할 데이터가 없습니다.');
		return;
	}
	
	var roleInfo = {};
	roleInfo['roleList'] = roleList;
	
	// 저장 호출
	common.ajax({
		url:"${contextPath}/sysadmin/saveRole", 
		data:JSON.stringify(roleInfo),
		contentType: 'application/json',
		success: function(result) {
			if(result && result.result) {
				common.showAlert("저장되었습니다.");
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/sysadmin/userRoleMgmt";
				frm.submit();
			}
		}
	});
	
}

</script>