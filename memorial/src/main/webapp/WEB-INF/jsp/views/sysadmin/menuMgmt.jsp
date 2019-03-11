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
	<input type="hidden" id="parentMenuSeq" name="parentMenuSeq" value="${parentMenuSeq}">
	<input type="hidden" id="parentMenuName" name="parentMenuName" value="${parentMenuName}">
	
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
	
		<div>
	    	<div class="pull-left">
		    	<h4 style="margin-top: 3;">메뉴 그룹</h4>
	    	</div>
	    	<div class="pull-right">
	    		<button type="button" class="btn btn-default" onclick="_changeDisplayOrder('top','up')"><span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span></button>
	    		<button type="button" class="btn btn-default" onclick="_changeDisplayOrder('top','down')"><span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span></button>
		    	<button class="btn btn-primary" type="button" onclick="_addMenu()">추가</button>
		    	<button class="btn btn-primary" type="button" onclick="_saveMenu()">저장</button>
	    	</div>
    	</div>
    	<div class="clearfix"></div>
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblTopMenu" class="table table-style table-bordered table-hover">
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
						<th scope="col">메뉴아이디</th>
						<th scope="col" class="required">메뉴명</th>
						<th scope="col" class="required">사용유무</th>
						<th scope="col" class="required">권한유무</th>
						<th scope="col">표시순서</th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${topLevelMenuList}" var="rowItem">
					<tr menuSeq="${rowItem.menu_seq}" menuName="${rowItem.menu_name}" <c:if test="${parentMenuSeq == rowItem.menu_seq}">class="selected"</c:if>>
	                    <td name="menuId"><a href="javascript:void(0);" class="tbllink" style="color: #337ab7;" onclick="searchChildMenuList(this)">${rowItem.menu_seq}</a></td>
	                    <td align="left" name="menuName"><input name="menuName" type="text" class="form-control" value="${rowItem.menu_name}"></td>
	                    <td>
	                    	<select name="useYn" class="form-control">
	                    		<option value="Y" <c:if test="${rowItem.use_yn == 'Y'}">selected</c:if>>Y</option>
	                    		<option value="N" <c:if test="${rowItem.use_yn == 'N'}">selected</c:if>>N</option>
	                    	</select>
	                    </td>
	                    <td>
	                    	<select name="hasAuth" class="form-control">
	                    		<option value="Y" <c:if test="${rowItem.has_auth == 'Y'}">selected</c:if>>Y</option>
	                    		<option value="N" <c:if test="${rowItem.has_auth == 'N'}">selected</c:if>>N</option>
	                    	</select>
	                    </td>
	                    <td name="displayOrder">${rowItem.display_order}</td>
	                    <td>
	                    	<button type="button" data-toggle="tooltip" title="삭제" class="btn btn-default btn-sm" onclick="_deleteMenu(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button>
	                    </td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<c:if test="${not empty parentMenuSeq}">
		<div style="margin-top: 25px;">
	    	<div class="pull-left">
		    	<h4 style="margin-top: 3;">${parentMenuName} - 메뉴 리스트</h4>
	    	</div>
	    	<div class="pull-right">
	    		<button type="button" class="btn btn-default" onclick="_changeDisplayOrder('child','up')"><span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span></button>
	    		<button type="button" class="btn btn-default" onclick="_changeDisplayOrder('child','down')"><span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span></button>
		    	<button class="btn btn-primary" type="button" onclick="_addMenu('${parentMenuSeq}')">추가</button>
		    	<button class="btn btn-primary" type="button" onclick="_saveMenu('${parentMenuSeq}')">저장</button>
	    	</div>
    	</div>
    	<div class="clearfix"></div>
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblChildMenu" class="table table-style table-bordered table-hover">
				<colcolgroup>
					<col width="14%">
					<col width="14%">
					<col width="20%">
					<col width="12%">
					<col width="12%">
					<col width="12%">
					<col width="14%">
				</colcolgroup>
				<thead>
					<tr>
						<th scope="col">메뉴아이디</th>
						<th scope="col" class="required">메뉴명</th>
						<th scope="col" class="required">메뉴 URL</th>
						<th scope="col" class="required">사용유무</th>
						<th scope="col" class="required">권한유무</th>
						<th scope="col">표시순서</th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${childeMenuList}" var="rowItem">
					<tr menuSeq="${rowItem.menu_seq}" parentMenuSeq="${rowItem.parent_menu_seq}">
	                    <td name="menuId">${rowItem.menu_seq}</td>
	                    <td align="left" name="menuName"><input name="menuName" type="text" class="form-control" value="${rowItem.menu_name}"></td>
	                    <td align="left"><input name="menuUrl" type="text" class="form-control" value="${rowItem.menu_url}"></td>
	                    <td>
	                    	<select name="useYn" class="form-control">
	                    		<option value="Y" <c:if test="${rowItem.use_yn == 'Y'}">selected</c:if>>Y</option>
	                    		<option value="N" <c:if test="${rowItem.use_yn == 'N'}">selected</c:if>>N</option>
	                    	</select>
	                    </td>
	                    <td>
	                    	<select name="hasAuth" class="form-control">
	                    		<option value="Y" <c:if test="${rowItem.has_auth == 'Y'}">selected</c:if>>Y</option>
	                    		<option value="N" <c:if test="${rowItem.has_auth == 'N'}">selected</c:if>>N</option>
	                    	</select>
	                    </td>
	                    <td name="displayOrder">${rowItem.display_order}</td>
	                    <td>
	                    	<button type="button" data-toggle="tooltip" title="삭제" class="btn btn-default btn-sm" onclick="_deleteMenu(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button>
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
	
	$('.table-hover tbody tr').click(function(e) {
		$(this).parent().find('tr.selected').removeClass();
		$(this).addClass('selected');
	});
	
})();

/** 
 * 메뉴 리스트 조회
 */
function searchChildMenuList(btn) {
	var tr = $(btn).parent('td').parent('tr');
	var parentMenuSeq = $(tr).attr("menuSeq");
	var parentMenuName = $(tr).attr("menuName"); 
	$('#parentMenuSeq').val(parentMenuSeq);
	$('#parentMenuName').val(parentMenuName);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/sysadmin/menuMgmt";
	frm.submit();
}

/**
 * 메뉴 등록
 */
function _addMenu(parentMenuSeq) {
	var tbody;
	if(parentMenuSeq) {
		tbody = $('#tblChildMenu tbody');
	} else {
		tbody = $('#tblTopMenu tbody');
	}
	var tr = $('<tr/>');
	var displayOrder = $(tbody).find('tr').length + 1;
	// 메뉴아이디
	tr.append('<td align="left"></td>');
	// 메뉴명
    tr.append('<td><input name="menuName" type="text" class="form-control"></td>');
 	// 메뉴URL
	if(parentMenuSeq) {
	    tr.append('<td><input name="menuUrl" type="text" class="form-control"></td>');	
	}
 	// 사용유무
    tr.append('<td><select name="useYn" class="form-control"><option value="Y">Y</option><option value="N">N</option></select></td>');
 	// 권한유무
    tr.append('<td><select name="hasAuth" class="form-control"><option value="Y">Y</option><option value="N">N</option></select></td>');
    // 표시순서
    tr.append('<td name="displayOrder">' + displayOrder + '</td>');
    // 삭제버튼
    tr.append('<td><button type="button" data-toggle="tooltip" title="삭제" class="btn btn-default btn-sm" onclick="_deleteMenu(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button></td>');
    
    tbody.append(tr);
}

/**
 * 메뉴삭제
 */
function _deleteMenu(btn) {
	var tr = $(btn).parent('td').parent('tr');
	var parentMenuSeq = $(tr).attr('parentMenuSeq') ? $(tr).attr('parentMenuSeq') : null;
	var menuSeq = $(tr).attr('menuSeq');
	if(!menuSeq) {// 화면에서 추가된 경우 바로 삭제
		$(tr).remove();
	} else {
		var msg = '해당 메뉴를 삭제하시겠습니까?';
		if(!parentMenuSeq) {
			msg = '해당 메뉴 그룹을 삭제하시겠습니까?\n삭제시 메뉴그룹 내 모든 메뉴가 삭제됩니다.';
		}
		if(confirm(msg)) {
			var menuVo = {};
			menuVo['parentMenuSeq'] = parentMenuSeq;
			menuVo['menuSeq'] = menuSeq;
			// 저장 호출
			common.ajax({
				url:"${contextPath}/sysadmin/deleteMenu", 
				data:JSON.stringify(menuVo),
				contentType: 'application/json',
				success: function(result) {
					if(result && result.result) {
						common.showAlert("저장되었습니다.");
						if(!parentMenuSeq) {
							$("#parentMenuSeq").val('');
							$("#parentMenuName").val('');	
						}
						var frm = document.getElementById("frm");
						frm.action = "${contextPath}/sysadmin/menuMgmt";
						frm.submit();
					}
				}
			});
		}
	}
}

/**
 * 메뉴 변경 내용 저장
 */
function _saveMenu(parentMenuSeq) {
	var tbody;
	if(parentMenuSeq) {
		tbody = $('#tblChildMenu tbody');
	} else {
		tbody = $('#tblTopMenu tbody');
	}
	
	var isValid = true;
	var menuList = [];
	$(tbody).find('tr').each(function(idx) {
		var menuItem = {};
		var flag = $(this).attr('menuSeq') ? 'U' : 'C';// 업데이트, 신규생성 플래그
		var menuSeq;
		if(flag == 'U') {
			menuSeq = $(this).attr('menuSeq');
		}
		
		var menuName = $(this).find('input[name="menuName"]').val();
		var menuUrl = $(this).find('input[name="menuUrl"]').val();
		var menuLevel = parentMenuSeq ? 2 : 1;
		var displayOrder = $(this).find('td[name="displayOrder"]').text();
		var useYn = $(this).find('select[name="useYn"] option:selected').val();
		var hasAuth = $(this).find('select[name="hasAuth"] option:selected').val();
		
		if(!menuName) {
			common.showAlert('메뉴명을 입력하세요.');
			$(this).find('input[name="menuName"]').focus();
			isValid = false;
			return false;
		}
		if(parentMenuSeq && !menuUrl) {
			common.showAlert('메뉴URL을 입력하세요.');
			$(this).find('input[name="menuUrl"]').focus();
			isValid = false;
			return false;
		}
		menuItem['flag'] = flag;
		menuItem['menuSeq'] = menuSeq;
		menuItem['menuName'] = menuName;
		menuItem['menuUrl'] = menuUrl;
		menuItem['menuLevel'] = menuLevel;
		menuItem['displayOrder'] = displayOrder;
		menuItem['useYn'] = useYn;
		menuItem['hasAuth'] = hasAuth;
		menuItem['parentMenuSeq'] = parentMenuSeq ? parentMenuSeq : '';
		
		menuList.push(menuItem);
	});
	
	if(!isValid) {
		return;
	}
	
	if(menuList.length == 0) {
		common.showAlert('저장할 데이터가 없습니다.');
		return;
	}
	
	var menuInfo = {};
	menuInfo['parentMenuSeq'] = parentMenuSeq;
	menuInfo['menuList'] = menuList;
	
	// 저장 호출
	common.ajax({
		url:"${contextPath}/sysadmin/saveMenu", 
		data:JSON.stringify(menuInfo),
		contentType: 'application/json',
		success: function(result) {
			if(result && result.result) {
				common.showAlert("저장되었습니다.");
				if(!parentMenuSeq) {
					$("#parentMenuSeq").val('');
					$("#parentMenuName").val('');	
				}
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/sysadmin/menuMgmt";
				frm.submit();
			}
		}
	});
	
}

/**
 * 행순서 변경
 */
function _changeDisplayOrder(target, direction) {
	var tbl = target == 'top' ? $('#tblTopMenu') : $('#tblChildMenu');
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