<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<form id="frm" method="post">
	<input name="roleId" type="hidden" value="${roleId}">
</form>

<div class="poptitle">
	<strong>메뉴권한 설정 - ${roleId}</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 10px 10px;">
	
	
	<div style="margin: 15px 0;">
        <button type="button" data-toggle="tooltip" title="펼치기" class="btn btn-default btn-xs" onclick="expandCollapseAll(true)"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button>
        <button type="button" data-toggle="tooltip" title="접기" class="btn btn-default btn-xs" onclick="expandCollapseAll(false)"><span class="glyphicon glyphicon-minus" aria-hidden="true"></span></button>
    </div>
	
	<div id="jstree" style="height: 530px; overflow: auto;">
	<ul>
		<li class="jstree-open">Menu
		<!-- 1 Level -->
		<c:forEach items="${roleMenuList}" var="menu">
			<ul>
				<li id="${menu.menu_seq}" roleId="${menu.role_id}" menu_name="${menu.menu_name}" menu_url="${menu.menu_url}" menu_level="${menu.menu_level}" menu_type="${menu.menu_type}" display_order="${menu.display_order}" parent_menu_seq="${menu.parent_menu_seq}" use_yn="${menu.use_yn}" >
					<c:out value="${menu.menu_name}" />
					<!-- 2 Level -->
					<c:forEach items="${menu.children}" var="menu">
						<ul>
							<li id="${menu.menu_seq}" roleId="${menu.role_id}" menu_name="${menu.menu_name}" menu_url="${menu.menu_url}" menu_level="${menu.menu_level}" menu_type="${menu.menu_type}" display_order="${menu.display_order}" parent_menu_seq="${menu.parent_menu_seq}" use_yn="${menu.use_yn}" >
								<c:out value="${menu.menu_name}" />
								<!-- 3 Level -->
								<c:forEach items="${menu.children}" var="menu">
									<ul>
										<li id="${menu.menu_seq}" roleId="${menu.role_id}" menu_name="${menu.menu_name}" menu_url="${menu.menu_url}" menu_level="${menu.menu_level}" menu_type="${menu.menu_type}" display_order="${menu.display_order}" parent_menu_seq="${menu.parent_menu_seq}" use_yn="${menu.use_yn}" >
											<c:out value="${menu.menu_name}" />
										</li>
									</ul>
								</c:forEach>
							</li>
						</ul>
					</c:forEach>
				</li>
			</ul>
		</c:forEach>		
		</li>
	</ul>
	</div>
	
	<div class="text-center" style="margin-top: 20px;">
        <button type="button" class="btn btn-lg btn-primary" onclick="_save()">저장</button>
        <button type="button" class="btn btn-lg btn-default btnClose">닫기</button>
    </div>
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<script type="text/javascript">
(function() {
	
	$('#jstree').jstree({
	  "plugins" : ["checkbox"]
	}).on("select_node.jstree", function (e, data) { 
		var li_attr = data.node.li_attr;
		if(li_attr.id){
			
		}
	});
	// expand all
	$("#jstree").jstree("open_all");
	
	// 권한있는 메뉴 초기 select 처리
	var roleId = '${roleId}';
	$("#jstree").find('li[roleId="' + roleId +   '"]').each(function(idx) {
		var menu_level = $(this).attr('menu_level');
		if(menu_level > 1) {
			$('#jstree').jstree("check_node","#" + $(this).attr('id'));	
		}
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
	var menuIds = [];
	$.each($("#jstree").jstree("get_checked",true), function(idx){
		var attr = $(this).attr('li_attr');
		if(attr.menu_level > 1) {
    		var menuId = attr.id;
        	var parentMenuId = attr.parent_menu_seq;
        	if(menuIds.indexOf(parentMenuId) < 0) {
        		menuIds.push(parentMenuId);
        	}
        	if(menuIds.indexOf(menuId) < 0) {
        		menuIds.push(menuId);
        	}
    	}
	});
	
	var menuRoleMappingVo = {};
	menuRoleMappingVo.roleId = roleId;
	menuRoleMappingVo.menuIds = menuIds;
	
	// 저장 호출
	common.ajax({
		url:"${contextPath}/sysadmin/saveMenuRole", 
		data:JSON.stringify(menuRoleMappingVo),
		contentType: 'application/json',
		success: function(result) {
			if(result && result.result) {
				common.showAlert("저장되었습니다.");
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/popup/selectMenuRole";
				frm.submit();
			}
		}
	});
}

/**
 * 트리 전체 펼치기/접기
 */
function expandCollapseAll(expand) {
	if(expand) {
		$("#jstree").jstree("open_all");
	} else {
		$("#jstree").jstree("close_all");
	}
}

</script>