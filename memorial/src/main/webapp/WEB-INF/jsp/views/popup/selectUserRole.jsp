<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<form id="frm" method="post">
	<input name="roleId" type="hidden" value="${roleId}">
</form>

<div class="poptitle">
	<strong>사용자권한 설정 - ${roleId}</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 10px 10px;">
	
	
	<div class="table-responsive">
			<table id="tblList" class="table table-style table-bordered">
				<colgroup>
					<col width="5%">
					<col width="13%">
					<col width="13%">
					<col width="13%">
					<col width="13%">
					<col width="13%">
					<col width="13%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input id="chkAll" type="checkbox"></th>
						<th scope="col">아이디</th>
						<th scope="col">성명</th>
						<th scope="col">생년월일</th>
						<th scope="col">휴대폰</th>
						<th scope="col">직분</th>
						<th scope="col">교구</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${userRoleList}" var="rowItem">
					<tr userId="${rowItem.user_id}">
	                    <td><input type="checkbox" name="chk" <c:if test="${not empty rowItem.role_id}">checked</c:if>></td>
	                    <td>${rowItem.user_id }</td>
	                    <td>${rowItem.user_name }</td>
	                    <td>${rowItem.birth_date }</td>
	                    <td>${rowItem.mobile }</td>
	                    <td>${rowItem.church_officer_name }</td>
	                    <td>${rowItem.diocese }</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	
	
	<div class="text-center" style="margin-top: 20px;">
        <button type="button" class="btn btn-lg btn-primary" onclick="_save()">저장</button>
        <button type="button" class="btn btn-lg btn-default btnClose">닫기</button>
    </div>
    
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function() {
	
	$('#chkAll').change(function() {
		var selected = $(this).is(':checked');
		$('#tblList tbody tr').each(function(idx) {
			$(this).find('input[name="chk"]').prop('checked', selected);
		});
	});
	
	// 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
	
})();

/**
 * 저장
 */
function _save() {
	var roleId = '${roleId}';
	var userIds = [];
	$('#tblList tbody tr').each(function(idx) {
		var checked = $(this).find('input[name="chk"]').is(':checked');
		var userId = $(this).attr('userId');
		if(checked) {
			userIds.push(userId);
		}
	});
	var userRoleMappingVo = {};
	userRoleMappingVo.roleId = roleId;
	userRoleMappingVo.userIds = userIds;
	
	// 저장 호출
	common.ajax({
		url:"${contextPath}/sysadmin/saveUserRole", 
		data:JSON.stringify(userRoleMappingVo),
		contentType: 'application/json',
		success: function(result) {
			if(result && result.result) {
				common.showAlert("저장되었습니다.");
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/popup/selectUserRole";
				frm.submit();
			}
		}
	});
}


</script>