<%@page import="com.calvary.admin.controller.AdminController"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="col-md-9">

    <!-- 신청자 -->
    <div>
    	<div class="pull-left"><h4>신청자</h4></div>
    	<div class="pull-right">
	        <div class="dropdown">
	            <button class="btn btn-primary btn-sm" type="button" onclick="registApplyUser(false)">입력
<!-- 	            <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">신청자 입력 -->
<!-- 	                <span class="caret"></span> -->
	            </button>
	            <ul class="dropdown-menu">
	                <li><a href="javascript:void(0)" onclick="registApplyUser(false)">본인</a></li>
	                <li><a href="javascript:void(0)" onclick="registApplyUser(true)">대리인</a></li>
	            </ul>
	        </div>
	    </div>	
    </div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table id="tblApplyUser" class="table table-style">
            <thead>
                <tr>
                    <th scope="col">성명</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">휴대전화</th>
                    <th scope="col">이메일</th>
                    <th scope="col">주소</th>
                    <th scope="col">직분</th>
                    <th scope="col">교구</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
    
    <!-- 대리인(대리인신청시만 표시됨) -->
    <div id="divAgentInfo" style="margin-top: 35px;">
    	<div>
	    	<div class="pull-left"><h4>대리인(대리 신청시)</h4></div>
	    	<div class="pull-right">
	        	<button id="btnRegistAgentUser" type="button" class="btn btn-primary btn-sm" onclick="registApplyUser(true)">입력</button>
	    	</div>
	    </div>
	    <div class="clearfix"></div>
	    <div class="table-responsive">
	        <table id="tblAgentUser" class="table table-style">
	            <thead>
	                <tr>
	                    <th scope="col">성명</th>
	                    <th scope="col">생년월일</th>
	                    <th scope="col">휴대전화</th>
	                    <th scope="col">이메일</th>
	                    <th scope="col">주소</th>
	                    <th scope="col">관계</th>
                    	<th scope="col">교인여부</th>
                    	<th scope="col">&nbsp;</th>
	                </tr>
	            </thead>
	            <tbody>
	            </tbody>
	        </table>
	    </div>
    </div>

	<!-- 사용(봉안) 대상자 -->
	<div style="margin-top: 35px;">
		<div class="pull-left" style=""><h4>사용(봉안) 대상자</h4></div>
    	<div class="pull-right">
        	<button id="btnRegistUseUser" type="button" class="btn btn-primary btn-sm">입력</button>
    	</div>
	</div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table id="tblUseUser" class="table table-style">
            <thead>
                <tr>
                    <th scope="col">성명</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">휴대전화</th>
                    <th scope="col">이메일</th>
                    <th scope="col">주소</th>
                    <th scope="col">관계</th>
                    <th scope="col">교인여부</th>
                    <th scope="col">&nbsp;</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>

	<!-- 동산 신청 정보 -->
	<div style="margin-top: 35px;">
		<div class="pull-left"><h4>동산 신청 정보</h4></div>	
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
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">신청형태</p></th>
            		<td align="left" colspan="3">
            			<label class="radio-inline"><input type="radio" name="rdProductType" value="<%=CalvaryConstants.PRODUCT_TYPE_EACH%>" checked>개별형</label>
                    	<label class="radio-inline"><input type="radio" name="rdProductType" value="<%=CalvaryConstants.PRODUCT_TYPE_FAMILY%>">가족형</label>
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">장묘형태</p></th>
            		<td align="left" colspan="3">
            			<p class="form-control-static" style="display: inline-block;">부부형</p>
	                    <input id="tiCoupleTypeCount" class="form-control" style="width: 95px;display: inline-block; margin-left: 4px;" type="text" placeholder="기수입력">
	                    <p class="form-control-static" style="display: inline-block;">x 2</p>
	                    <p class="form-control-static" style="display: inline-block; margin-left: 20px;">1인형</p>
	                    <input id="tiSingleTypeCount" class="form-control" style="width: 95px;display: inline-block; margin-left: 4px;" type="text" placeholder="기수입력">
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">관리비 납부자</p></th>
            		<td align="left" colspan="3">
            			<label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_APPLY_USER %>" checked>신청자</label>
	                    <label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_USE_USER %>">각 사용자별 납부</label>
	                    <label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT %>">사용자 중 1인 대표</label>
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">총 분양대금</p></th>
            		<td align="left" colspan="3">
            			<p id="totalPrice" class="form-control-static">&nbsp;</p>
            		</td>
            	</tr>
            </tbody>
        </table>
    </div>
    
    <div class="mt-30 text-center">
        <button id="btnSaveApply" type="button" class="btn btn-primary btn-lg">저장</button>
        <button id="btnCancelApply" type="button" class="btn btn-default btn-lg">취소</button>
    </div>
    
</div>
<form id="frm" method="post">
<input type="hidden" id="bunyangSeq" name="bunyangSeq">
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.number.min.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	
	// 사용(봉안) 대상자 입력
	$("#btnRegistUseUser").click(function(e){
		registUseUser();
	});
	
	// 분양신청정보 저장 클릭
	$('#btnSaveApply').click(function(e){
		saveApply();
	});
	
	// 취소 클릭
	$('#btnCancelApply').click(function(e){
		cancelApply();
	});
	
	$('#tiCoupleTypeCount, #tiSingleTypeCount').focusout(function(e){
		var val = $(this).val();
		val = common.toNumeric(val);
		$(this).val(val);
		displayTotalPrice();
	});
	
})();

/**
 * 총 분양대금 표시
 */
function displayTotalPrice() {
	var coupleType = $('#tiCoupleTypeCount').val();
	var singleType = $('#tiSingleTypeCount').val();
	var totalPrice = common.calcBunyangPrice(coupleType ? parseInt(coupleType) : 0, singleType ? parseInt(singleType) : 0);
	var val = "₩" + $.number(totalPrice);
	console.log(val);
	$('#totalPrice').text(val);
}

/**
 * 신청자 입력
 * @param isAgent true:대리신청
 */
function registApplyUser(isAgent) {
	var winoption = {width:1024, height:830};
	var param = {popupTitle: isAgent ? "대리인 입력" : "신청자 입력"};
	common.openWindow("${contextPath}/popup/selectuser", "popRegistApplyUser", winoption, param);
	// 신청자 입력 팝업 callback 함수
	window.selectuserCallBack = function(type, item) {
		var idx = 0, userId = '', userName = '', birthDate = '', email = '', mobile = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', diocese = '';
		if(item && item.length > 0) {
			var tr = $("<tr/>");
			userId = item[idx++];
			userName = item[idx++];
			birthDate = item[idx++];
			email = item[idx++];
			mobile = item[idx++];
			postNumber = item[idx++];
			address1 = item[idx++];
			address2 = item[idx++];
			fulladdress = item[idx++];
			churchOfficer = item[idx++];
			churchOfficerName = item[idx++];
			diocese = item[idx++];
			tr.attr('userId', userId);
			tr.attr('userName', userName);
			tr.attr('birthDate', birthDate);
			tr.attr('email', email);
			tr.attr('mobile', mobile);
			tr.attr('postNumber', postNumber);
			tr.attr('address1', address1);
			tr.attr('address2', address2);
			tr.attr('fulladdress', fulladdress);
			tr.attr('churchOfficer', churchOfficer);
			tr.attr('churchOfficerName', churchOfficerName);
			tr.attr('diocese', diocese);
			tr.attr('isAgent', isAgent);
			tr.append('<td><p class="form-control-static">'+userName+"</p></td>");
			tr.append('<td><p class="form-control-static">'+birthDate+"</p></td>");
			tr.append('<td><p class="form-control-static">'+mobile+"</p></td>");
			tr.append('<td><p class="form-control-static">'+email+"</p></td>");
			tr.append('<td><p class="form-control-static">'+fulladdress+"</p></td>");
			if(isAgent) {
				tr.append("<td>"+getUserRelationSelect(isAgent)+"</td>");
				tr.append("<td>"+getIsChurchSelect()+"</td>");
				tr.append('<td><button type="button" class="btn btn-primary btn-sm" onclick="deleteRow(this)">삭제</button></td>');
			}else {
				tr.append('<td><p class="form-control-static">'+churchOfficerName+"</p></td>");
				tr.append('<td><p class="form-control-static">'+diocese+"</p></td>");
			}
			var duplicated = false;
			if(isAgent) {
				var applyTR = $("#tblApplyUser tbody tr");
				if(applyTR && applyTR.length > 0) {
					var applyUserId = applyTR.attr("userId");
					if(userId && applyUserId && userId == applyUserId) {
						common.showAlert("대리인 정보가 신청자와 동일합니다.");
						duplicated = true;
					}
				}
				if(!duplicated) {
					$("#tblAgentUser tbody").html(tr);
				}
			}else {
				var agentTR = $("#tblAgentUser tbody tr");
				if(agentTR && agentTR.length > 0) {
					var agentUserId = agentTR.attr("userId");
					if(userId && agentUserId && userId == agentUserId) {
						common.showAlert("신청자 정보가 대리인 정보와 동일합니다.\n해당 사용자를 신청자로 등록하려면 대리인 정보 삭제 후 등록해주세요.");
						duplicated = true;
					}
				}
				if(!duplicated) {
					$("#tblApplyUser tbody").html(tr);	
				}
			}
		}
	};
}

/**
 * 사용(봉안) 대상자 입력
 */
function registUseUser() {
	var winoption = {width:1024, height:830};
	var param = {popupTitle: "사용(봉안) 대상자 입력"};
	common.openWindow("${contextPath}/popup/selectuser", "popRegistUser", winoption, param);
	// 사용(봉안) 대상자 입력 팝업 callback 함수
	window.selectuserCallBack = function(type, item) {
		var idx = 0, userId = '', userName = '', birthDate = '', email = '', mobile = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', diocese = '';
		if(item && item.length > 0) {
			var tr = $('<tr/>');
			var duplicated = false;
			userId = item[idx++];
			$("#tblUseUser tbody tr").each(function(idx){
				if(userId && userId == $(this).attr('userId')) {
					common.showAlert('이미 등록된 사용자입니다.');
					duplicated = true;
					return false;
				}
			});
			if(!duplicated) {
				userName = item[idx++];
				birthDate = item[idx++];
				email = item[idx++];
				mobile = item[idx++];
				postNumber = item[idx++];
				address1 = item[idx++];
				address2 = item[idx++];
				fulladdress = item[idx++];
				churchOfficer = item[idx++];
				churchOfficerName = item[idx++];
				diocese = item[idx++];
				tr.attr('userId', userId);
				tr.attr('userName', userName);
				tr.attr('birthDate', birthDate);
				tr.attr('email', email);
				tr.attr('mobile', mobile);
				tr.attr('postNumber', postNumber);
				tr.attr('address1', address1);
				tr.attr('address2', address2);
				tr.attr('fulladdress', fulladdress);
				tr.attr('churchOfficer', churchOfficer);
				tr.attr('churchOfficerName', churchOfficerName);
				tr.attr('diocese', diocese);
				tr.append('<td><p class="form-control-static">'+userName+"</p></td>");
				tr.append('<td><p class="form-control-static">'+birthDate+"</p></td>");
				tr.append('<td><p class="form-control-static">'+mobile+"</p></td>");
				tr.append('<td><p class="form-control-static">'+email+"</p></td>");
				tr.append('<td><p class="form-control-static">'+fulladdress+"</p></td>");
				tr.append("<td>"+getUserRelationSelect()+"</td>");
				tr.append("<td>"+getIsChurchSelect()+"</td>");
				tr.append('<td><button type="button" class="btn btn-primary btn-sm" onclick="deleteRow(this)">삭제</button></td>');
				$("#tblUseUser tbody").append(tr);
			}
		}
	};
}

/**
 * 분양정보 저장
 */
function saveApply() {
	var tr, bunyangUser = {}, useUsers = [], bunyangInfo = {};
	var coupleTypeCount = $("#tiCoupleTypeCount").val();
	var singleTypeCount = $("#tiSingleTypeCount").val();
	coupleTypeCount = coupleTypeCount ? parseInt(coupleTypeCount) : 0;
	singleTypeCount = singleTypeCount ? parseInt(singleTypeCount) : 0;
	
	// 신청자 정보
	tr = $("#tblApplyUser tbody tr");
	if(tr.exists()) {
		bunyangUser = {};
		bunyangUser["userId"] = tr.attr("userId");
		if(!bunyangUser["userId"]) {// 등록교인이 아닌 경우만 기타 정보 저장
			bunyangUser["userName"] = tr.attr("userName");
			bunyangUser["birthDate"] = tr.attr("birthDate");
			bunyangUser["email"] = tr.attr("email");
			bunyangUser["mobile"] = tr.attr("mobile");
			bunyangUser["postNumber"] = tr.attr("postNumber");
			bunyangUser["address1"] = tr.attr("address1");
			bunyangUser["address2"] = tr.attr("address2");
			bunyangUser["churchOfficer"] = tr.attr("churchOfficer");	
		}
		bunyangUser["refType"] = "<%=CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER%>";
		
		bunyangInfo["applyUser"] = bunyangUser;
	} else {
		common.showAlert("신청자 정보가 없습니다.");
		return;
	}
	
	// 대리인
	tr = $("#tblAgentUser tbody tr");
	if(tr.exists()) {
		bunyangUser = {};
		bunyangUser["userId"] = tr.attr("userId");
		if(!bunyangUser["userId"]) {// 등록교인이 아닌 경우만 기타 정보 저장
			bunyangUser["userName"] = tr.attr("userName");
			bunyangUser["birthDate"] = tr.attr("birthDate");
			bunyangUser["email"] = tr.attr("email");
			bunyangUser["mobile"] = tr.attr("mobile");
			bunyangUser["postNumber"] = tr.attr("postNumber");
			bunyangUser["address1"] = tr.attr("address1");
			bunyangUser["address2"] = tr.attr("address2");
			bunyangUser["churchOfficer"] = tr.attr("churchOfficer");	
		}
		bunyangUser["refType"] = "<%=CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER%>";
		bunyangUser["relationType"] = tr.find("td .relation option:selected").val();
		if(!bunyangUser["relationType"]) {
			common.showAlert("대리인의 신청자와의 관계를 입력해주세요.");
			return;
		}
		bunyangUser["isChurchPerson"] = tr.find("td .ischurch option:selected").val();
		
		bunyangInfo["agentUser"] = bunyangUser;
	}
	
	var registeredRelation = true;
	
	// 사용(봉안) 대상자
	tr = $("#tblUseUser tbody tr");
	if(tr.exists()) {
		tr.each(function(idx){
			bunyangUser = {};
			bunyangUser["userId"] = $(this).attr("userId");
			if(!bunyangUser["userId"]) {// 등록교인이 아닌 경우만 기타 정보 저장
				bunyangUser["userName"] = $(this).attr("userName");
				bunyangUser["birthDate"] = $(this).attr("birthDate");
				bunyangUser["email"] = $(this).attr("email");
				bunyangUser["mobile"] = $(this).attr("mobile");
				bunyangUser["postNumber"] = $(this).attr("postNumber");
				bunyangUser["address1"] = $(this).attr("address1");
				bunyangUser["address2"] = $(this).attr("address2");
				bunyangUser["churchOfficer"] = $(this).attr("churchOfficer");
			}
			bunyangUser["refType"] = "<%=CalvaryConstants.BUNYANG_REF_TYPE_USE_USER%>";
			bunyangUser["relationType"] = $(this).find("td .relation option:selected").val();
			if(!bunyangUser["relationType"]) {
				registeredRelation = false;
				return false;
			}
			bunyangUser["isChurchPerson"] = $(this).find("td .ischurch option:selected").val();
			useUsers.push(bunyangUser);
		});
		if(!registeredRelation) {
			common.showAlert("사용(봉안) 대상자의 신청자와의 관계를 입력해주세요.");
			return;
		}
		bunyangInfo["useUsers"] = useUsers;
	}else {
		common.showAlert("사용(봉안) 대상자 정보가 없습니다.");
		return;
	}
	
	if(coupleTypeCount == 0 && singleTypeCount == 0) {
		common.showAlert("부부형 또는 1인형 기수를 입력해주세요.");
		return;
	}
	
	if($(":input:radio[name=rdProductType]:checked").val() == '<%=CalvaryConstants.PRODUCT_TYPE_FAMILY%>') {
		if(coupleTypeCount > 0 && singleTypeCount > 0) {
			common.showAlert('가족형의 경우 부부형 또는 1인형 둘중 한가지만 선택가능합니다.');
			return;
		}
	}
	
	// 분양신청정보
	bunyangInfo['productType'] = $(":input:radio[name=rdProductType]:checked").val();
	bunyangInfo['serviceChargeType'] = $(":input:radio[name=rbServiceChargeType]:checked").val();
	bunyangInfo['coupleTypeCount'] = coupleTypeCount;
	bunyangInfo['singleTypeCount'] = singleTypeCount;
	bunyangInfo['progressStatus'] = "<%=CalvaryConstants.PROGRESS_STATUS_NEW%>";
	
	// 저장 호출
	common.ajax({
		url:"${contextPath}/admin/saveapply", 
		data:JSON.stringify(bunyangInfo),
		contentType: 'application/json',
		success: function(result) {
			if(result && result.result) {
				common.showAlert("저장되었습니다.");
				// 상세정보 페이지로 이동
				var bunyangSeq = result.bunyangSeq;
				$("#bunyangSeq").val(bunyangSeq);
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/admin/applydetail";
				frm.submit();
			}
		}
	});
}

/**
 * 취소 클릭
 */
function cancelApply() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/applymgmt";
	frm.submit();
}

/** 
 * 사용자 관계 select box html 반환 
 */
function getUserRelationSelect(isAgent) {
	var select = '<select class="form-control relation"><option value="">선택</option>';
	<c:forEach items="${codeUserRelation}" var="code">
	if(!isAgent || '${code.code_seq}' != 'ONESELF'){
		select += '<option value="${code.code_seq}">${code.code_name}</option>';	
	}
	</c:forEach>
	select += "</select>";
	return select;
}

/** 
 * Y/N select box html 반환 
 */
function getIsChurchSelect() {
	var select = '<select class="form-control ischurch"><option>Y</option><option>N</option></select>';
	return select;
}

/**
 * 행삭제
 * @param btn 삭제 버튼
 */
function deleteRow(btn) {
	$(btn).parent("td").parent("tr").remove();
}


</script>