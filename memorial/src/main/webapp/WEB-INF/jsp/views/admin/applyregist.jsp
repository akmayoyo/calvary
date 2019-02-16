<%@page import="com.calvary.admin.controller.AdminController"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="col-md-9">

    <!-- 신청자 -->
    <div>
    	<div class="pull-left"><h4>신청자</h4></div>
    	<div class="pull-right">
	        <button class="btn btn-primary" type="button" style="width: 60px;" onclick="registApplyUser()">입력</button>
	    </div>	
    </div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table id="tblApplyUser" class="table table-style">
        	<colgroup>
        		<col width="10%">
        		<col width="10%">
        		<col width="10%">
        		<col width="15%">
        		<col width="30%">
        		<col width="10%">
        		<col width="10%">
        	</colgroup>
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
	    	<div class="pull-left"><h4>대리인(대리인 신청시)</h4></div>
	    	<div class="pull-right">
	        	<button id="btnRegistAgentUser" type="button" style="width: 60px;" class="btn btn-primary" onclick="registAgentUser()" disabled>입력</button>
	    	</div>
	    </div>
	    <div class="clearfix"></div>
	    <div class="table-responsive">
	        <table id="tblAgentUser" class="table table-style">
	        	<colgroup>
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="15%">
	        		<col width="30%">
	        		<col width="10%">
	        		<col width="5%">
	        	</colgroup>
	            <thead>
	                <tr>
	                    <th scope="col">성명</th>
	                    <th scope="col">생년월일</th>
	                    <th scope="col">휴대전화</th>
	                    <th scope="col">이메일</th>
	                    <th scope="col">주소</th>
	                    <th scope="col">관계</th>
                    	<th scope="col"></th>
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
    		<button id="btnRegistCouple" style="width: 60px;" class="btn btn-primary" type="button" disabled onclick="registUseUser('couple')">부부형</button>
    		<button id="btnRegistSingle" style="width: 60px;" class="btn btn-primary" type="button" disabled onclick="registUseUser('single')">1인형</button>
    	</div>
	</div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table id="tblUseUser" class="table table-style table-bordered">
        	<colgroup>
        		<col width="8%">
        		<col width="8%">
        		<col width="10%">
        		<col width="12%">
        		<col width="27%">
        		<col width="8%">
        		<col width="8%">
        		<col width="8%">
        		<col width="12%">
        	</colgroup>
            <thead>
                <tr>
                    <th scope="col">장묘형태</th>
                    <th scope="col">성명</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">연락처</th>
                    <th scope="col">주소</th>
                    <th scope="col">관계</th>
                    <th scope="col">교인여부</th>
                    <th scope="col">이장대상</th>
                    <th scope="col"></th>
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
        <table class="table table-style table-horizon" style="border-top: 0;">
        	<colgroup>
        		<col width="18%">
        		<col width="82%">
        	</colgroup>
            <tbody>
            	<tr>
					<th><p class="form-control-static">분양차수</p></th>
	           		<td align="left" class="form-inline">
						<select id="selBunyangTimes" class="form-control" style="width: 110px;">
							<c:forEach items="${bunyangTimesList}" var="bunyangTimesItem">
								<option value="${bunyangTimesItem.code_value}" codeSeq="${bunyangTimesItem.code_seq}">${bunyangTimesItem.code_name}</option>
							</c:forEach>
						</select>
	           		</td>
	           	</tr>
            	<tr>
					<th><p class="form-control-static">분양단가</p></th>
	           		<td align="left">
	           			<span id="sBunyangPrice"></span>
	           			<input id="tiBunyangPrice" type="text" class="form-control" style="width: 110px; display: none;">
	           		</td>
	           	</tr>
            	<tr>
            		<th><p class="form-control-static">신청형태</p></th>
            		<td align="left">
           				<p id="pProductType" class="form-control-static"></p>
            		</td>
            	</tr>
            	<tr>
            		<th><p class="form-control-static">장묘형태</p></th>
            		<td align="left" class="form-inline">
            			<p id="pGraveType" class="form-control-static"></p>
            		</td>
            	</tr>
            	<tr>
            		<th><p class="form-control-static">관리비 납부자</p></th>
            		<td align="left" class="form-inline">
            			<label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_APPLY_USER %>" checked>신청자</label>
	                    <label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_USE_USER %>">각 사용자별 납부</label>
	                    <label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT %>">사용자 중 1인 대표</label>
	                    <select id="selMaintCharger" class="form-control hidden" style="width: 100px; margin-left: 10px;">
							<option value="">선택</option>
						</select>
            		</td>
            	</tr>
            	<tr>
            		<th><p class="form-control-static">총 분양대금</p></th>
            		<td align="left">
            			<p id="totalPrice" class="form-control-static"></p>
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

// 신청인,대리인,사용자정보
var bunyangRefUser = {
		applyUser:null,
		agentUser:null,
		useUser:[]
};

// init 함수
(function(){
	
	// 분양신청정보 저장 클릭
	$('#btnSaveApply').click(function(e){
		saveApply();
	});
	
	// 취소 클릭
	$('#btnCancelApply').click(function(e){
		cancelApply();
	});
	
	// 관리비 납부자 radio button 변경이벤트
	$("input[name=rbServiceChargeType]:radio").change(function(e) {
		var selectedVal = $(":input:radio[name=rbServiceChargeType]:checked").val();
		if(selectedVal == '<%=CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT%>') {
			//$('#selMaintCharger option[value=""]').attr('selected','selected');
			$('#selMaintCharger').removeClass('hidden');
		} else {
			$('#selMaintCharger').addClass('hidden');
		}
	});
	
	// 분양단가 포커스인/아웃시 포맷처리
	$("#tiBunyangPrice").focusout(function(e){
		var val = $(this).val();
		val = common.toNumeric(val);
		if(val) {
			val = "₩" + $.number(val);
		}
		$(this).val(val);
		updateBunyangInfo();
	}).focusin(function(e){
		var val = $(this).val();
		val = common.toNumeric(val);
		$(this).val(val);
	});
	
	// 분양차수 변경이벤트
	$('#selBunyangTimes').change(function(e) {
		var price = $(this).find('option:selected').val();
		if(!price || price === 0) {
			$('#sBunyangPrice').hide();
			$('#tiBunyangPrice').val('');
			$('#tiBunyangPrice').show();
		} else {
			var priceExp = "₩" + $.number(price) + '원';
			$('#sBunyangPrice').text(priceExp);	
			$('#tiBunyangPrice').val('');
			$('#tiBunyangPrice').hide();
			$('#sBunyangPrice').show();
		}
		updateBunyangInfo();
	});
	$('#selBunyangTimes').trigger('change');
	
})();

/**
 * 사용(봉안) 대상자 입력시 분양 신청정보를 업데이트 해줌
 */
function updateBunyangInfo() {
	var coupleTypeCnt = $("#tblUseUser tbody tr td.coupletype").length;
	var singleTypeCnt = $("#tblUseUser tbody tr td.singletype").length;
	var pricePerCount = $('#selBunyangTimes option:selected').val();
	var totalPrice = 0;
	if(common.isVisible($('#tiBunyangPrice'))) {
		pricePerCount = common.toNumeric($('#tiBunyangPrice').val());
	}
	if($.isNumeric(pricePerCount)) {
		totalPrice = (coupleTypeCnt*2 + singleTypeCnt) * pricePerCount;	
	}
	var productType = '';
	var productTypeName = '';
	if(coupleTypeCnt >= 2 && singleTypeCnt == 0) {
		productType = '<%=CalvaryConstants.PRODUCT_TYPE_FAMILY%>';
	}else if(singleTypeCnt >= 2 && coupleTypeCnt == 0) {
		productType = '<%=CalvaryConstants.PRODUCT_TYPE_FAMILY%>';
	}else if(singleTypeCnt >= 1 &&  coupleTypeCnt >= 1) {
		productType = '<%=CalvaryConstants.PRODUCT_TYPE_EACH%>';
	}else if(singleTypeCnt + coupleTypeCnt == 1) {
		productType = '<%=CalvaryConstants.PRODUCT_TYPE_EACH%>';
	}
	if(productType == '<%=CalvaryConstants.PRODUCT_TYPE_FAMILY%>') {
		productTypeName = '가족형';
	} else if(productType == '<%=CalvaryConstants.PRODUCT_TYPE_EACH%>') {
		productTypeName = '개별형';
	}
	// 신청형태
	$('#pProductType').text(productTypeName);
	$('#pProductType').val(productType);
	
	// 장묘형태
	var graveTypeExp = '';
	if(coupleTypeCnt > 0) {
		graveTypeExp += '부부형 : ' + coupleTypeCnt + ' x 2';
	}
	if(singleTypeCnt > 0) {
		if(coupleTypeCnt > 0) {
			graveTypeExp += ' / ';
		}
		graveTypeExp += '1인형 : ' + singleTypeCnt;
	}
	$('#pGraveType').text(graveTypeExp);
	
	// 총 분양대금
	var val = "₩" + $.number(totalPrice)+'원';
	$('#totalPrice').text(val);
}

/**
 * 사용자 중 1인 대표에서 선택할 사용자 리스트 업데이트
 */
function updateSelectBoxMaintCharger() {
	var useUsers = bunyangRefUser['useUser'];
	var options = '<option value="">선택</option>';
	if(useUsers && useUsers.length > 0) {
		$.each(useUsers, function(idx, item) {
			var delimiter = '__';
			//var uid =  item['userName'] + delimiter + item['birthDate'] + delimiter + item['gender'] + delimiter + item['mobile'];
			var uid =  item['userName'] + idx;
			options += '<option value="' + uid + '" userName="' + item['userName'] + '" birthDate="' + item['birthDate'] + '" gender="' + item['gender'] + '" mobile="' + item['mobile'] + '">' + item['userName'] + '</option>';
		});
	}
	var selectedVal = $('#selMaintCharger option:selected').val();
	$('#selMaintCharger').html(options);
	$('#selMaintCharger option[value="' + selectedVal + '"]').attr('selected', 'selected');
}

/**
 * 신청자 입력
 */
function registApplyUser() {
	var winoption = {width:1024, height:640};
	var param = {popupTitle: "신청자 입력", popupType:'1'};
	param = getUserParam(param);
	common.openWindow("${contextPath}/popup/selectuser", "popRegistApplyUser", winoption, param);
	
	// 신청자 입력 팝업 callback 함수
	window.selectuserCallBack = function(item) {
		var idx = 0, userName = '', birthDate = '', gender = '', email = '', mobile = '', phone = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', diocese = '';
		if(item && item.length > 0) {
			var tr = $("<tr/>");
			userName = item[idx++];
			birthDate = item[idx++];
			gender = item[idx++];
			mobile = item[idx++];
			phone = item[idx++];
			postNumber = item[idx++];
			address1 = item[idx++];
			address2 = item[idx++];
			fulladdress = item[idx++];
			churchOfficer = item[idx++];
			churchOfficerName = item[idx++];
			diocese = item[idx++];
			email = item[idx++];
			
			var applyUser = {};
			applyUser['userName'] = userName;
			applyUser['birthDate'] = birthDate;
			applyUser['gender'] = gender;
			applyUser['mobile'] = mobile;
			applyUser['phone'] = phone;
			applyUser['postNumber'] = postNumber;
			applyUser['address1'] = address1;
			applyUser['address2'] = address2;
			applyUser['fulladdress'] = fulladdress;
			applyUser['churchOfficer'] = churchOfficer;
			applyUser['churchOfficerName'] = churchOfficerName;
			applyUser['diocese'] = diocese;
			applyUser['isAgent'] = false;
			applyUser['email'] = email;
			applyUser['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER%>';
			
			tr.append('<td>'+userName+"</td>");
			tr.append('<td>'+birthDate+"</td>");
			tr.append('<td>'+mobile+"</td>");
			tr.append('<td>'+email+"</td>");
			tr.append('<td align="left">'+fulladdress+"</td>");
			tr.append('<td>'+churchOfficerName+"</td>");
			tr.append('<td>'+diocese+"</td>");
			
			bunyangRefUser.applyUser = applyUser;
			$("#tblApplyUser tbody").html(tr);
			$('#btnRegistAgentUser').attr('disabled', false);
			$('#btnRegistCouple').attr('disabled', false);
			$('#btnRegistSingle').attr('disabled', false);
		}
	};
}

/**
 * 대리인 입력
 */
function registAgentUser() {
	var applyUser = bunyangRefUser.applyUser;
	if(!applyUser || !applyUser.userName) {
		common.showAlert('신청자 정보를 먼저 입력해주세요.');
		return;
	}
	var winoption = {width:1024, height:640};
	var param = {popupTitle: "대리인 입력", popupType:'2'};
	param = getUserParam(param);
	common.openWindow("${contextPath}/popup/selectuser", "popRegistAgentUser", winoption, param);
	
	// 대리인 입력 팝업 callback 함수
	window.selectuserCallBack = function(item) {
		var idx = 0, userName = '', birthDate = '', gender = '', email = '', mobile = '', phone = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', diocese = '', relationType = '', relationTypeName = '';
		if(item && item.length > 0) {
			var tr = $("<tr/>");
			userName = item[idx++];
			birthDate = item[idx++];
			gender = item[idx++];
			mobile = item[idx++];
			phone = item[idx++];
			postNumber = item[idx++];
			address1 = item[idx++];
			address2 = item[idx++];
			fulladdress = item[idx++];
			churchOfficer = item[idx++];
			churchOfficerName = item[idx++];
			diocese = item[idx++];
			email = item[idx++];
			relationType = item[idx++];
			relationTypeName = item[idx++];
			
			var agentUser = {};
			agentUser['userName'] = userName;
			agentUser['birthDate'] = birthDate;
			agentUser['gender'] = gender;
			agentUser['mobile'] = mobile;
			agentUser['phone'] = phone;
			agentUser['postNumber'] = postNumber;
			agentUser['address1'] = address1;
			agentUser['address2'] = address2;
			agentUser['fulladdress'] = fulladdress;
			agentUser['isAgent'] = true;
			agentUser['email'] = email;
			agentUser['relationType'] = relationType;
			agentUser['relationTypeName'] = relationTypeName;
			agentUser['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER%>';
			
			tr.append('<td>'+userName+"</td>");
			tr.append('<td>'+birthDate+"</td>");
			tr.append('<td>'+mobile+"</td>");
			tr.append('<td>'+email+"</td>");
			tr.append('<td align="left">'+fulladdress+"</td>");
			tr.append('<td>'+relationTypeName+"</td>");
			tr.append('<td><button type="button" class="btn btn-default btn-sm" onclick="deleteAgentUserRow(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button></td>');
			
			bunyangRefUser.agentUser = agentUser;
			$("#tblAgentUser tbody").html(tr);
		}
	};
}

/**
 * 사용(봉안) 대상자 입력
 */
function registUseUser(type) {
	var applyUser = bunyangRefUser.applyUser;
	if(!applyUser || !applyUser.userName) {
		common.showAlert('신청자 정보를 먼저 입력해주세요.');
		return;
	}
	var winoption = {width:1024, height:750};
	if(type == 'single') {
		winoption['height'] = 640;
	}
	var param = {popupTitle: "사용(봉안) 대상자 입력 " + (type == 'couple' ? "(부부형)" : "(1인형)"), popupType:type};
	param = getUserParam(param);
	common.openWindow("${contextPath}/popup/registuseuser", "popRegistUseUser", winoption, param);
	
	if(type == 'couple') {// 부부형
		// 사용(봉안) 대상자 입력 팝업 callback 함수
		window.selectuserCallBack = function(item1, item2, isOneSelf) {
			if(!item1 || item1.length == 0 || !item2 || item2.length == 0) {
				return;
			}
			var coupleTypeCount = $("#tblUseUser tbody tr td.coupletype").length;
			var coupleSeq = coupleTypeCount+1;
			var useUser1 = getUseUser(item1);
			var useUser2 = getUseUser(item2);
			useUser1['coupleSeq'] = coupleSeq;
			useUser2['coupleSeq'] = coupleSeq;
			
			bunyangRefUser.useUser.push(useUser1);
			bunyangRefUser.useUser.push(useUser2);
			
			var tr1 = $('<tr coupleSeq="'+coupleSeq+'"/>');
			var tr2 = $('<tr coupleSeq="'+coupleSeq+'"/>');
			tr1.append('<td rowspan="2" class="coupletype">부부형</td>');
			tr1.append('<td name="userName">' + useUser1['userName'] + '</td>');
			tr1.append('<td name="birthDate">' + useUser1['birthDate'] + '</td>');
			tr1.append('<td name="mobile">' + useUser1['mobile'] + '</td>');
			tr1.append('<td name="address" align="left">' + useUser1['fulladdress'] + '</td>');
			tr1.append('<td name="relation">' + useUser1['relationTypeName'] + '</td>');
			tr1.append('<td name="ischurch">' + useUser1['isChurchPerson'] + '</td>');
			tr1.append('<td>' + useUser1['isMove'] + '</td>');
			tr1.append('<td rowspan="2" class="form-inline"><button type="button" class="btn btn-primary btn-sm" onclick="editUseUser(this,\'couple\')">수정</button><button type="button" class="btn btn-danger btn-sm" style="margin-left:3px;" onclick="deleteUseUserRow(this)">삭제</button></td>');
			
			tr2.append('<td name="userName">' + useUser2['userName'] + '</td>');
			tr2.append('<td name="birthDate">' + useUser2['birthDate'] + '</td>');
			tr2.append('<td name="mobile">' + useUser2['mobile'] + '</td>');
			tr2.append('<td name="address" align="left">' + useUser2['fulladdress'] + '</td>');
			tr2.append('<td name="relation">' + useUser2['relationTypeName'] + '</td>');
			tr2.append('<td name="ischurch">' + useUser2['isChurchPerson'] + '</td>');
			tr2.append('<td>' + useUser2['isMove'] + '</td>');
			
			$("#tblUseUser tbody").append(tr1);
			$("#tblUseUser tbody").append(tr2);
			
			updateBunyangInfo();
			updateSelectBoxMaintCharger();
		};
	} else {// 1인형
		// 사용(봉안) 대상자 입력 팝업 callback 함수
		window.selectuserCallBack = function(item1, isOneSelf) {
			if(!item1 || item1.length == 0) {
				return;
			}
			var useUser1 = getUseUser(item1);
			bunyangRefUser.useUser.push(useUser1);
			
			var tr1 = $('<tr/>');
			tr1.append('<td rowspan="1" class="singletype">1인형</td>');
			tr1.append('<td name="userName">' + useUser1['userName'] + '</td>');
			tr1.append('<td name="birthDate">' + useUser1['birthDate'] + '</td>');
			tr1.append('<td name="mobile">' + useUser1['mobile'] + '</td>');
			tr1.append('<td name="address" align="left">' + useUser1['fulladdress'] + '</td>');
			tr1.append('<td name="relation">' + useUser1['relationTypeName'] + '</td>');
			tr1.append('<td name="ischurch">' + useUser1['isChurchPerson'] + '</td>');
			tr1.append('<td>' + useUser1['isMove'] + '</td>');
			tr1.append('<td rowspan="1" class="form-inline"><button type="button" class="btn btn-primary btn-sm" onclick="editUseUser(this, \'single\')">수정</button><button type="button" class="btn btn-danger btn-sm" style="margin-left:3px;" onclick="deleteUseUserRow(this)">삭제</button></td>');
			
			$("#tblUseUser tbody").append(tr1);
			
			updateBunyangInfo();
			updateSelectBoxMaintCharger();
		};
	}
}

/**
 * 사용(봉안)대상자 정보 수정
 */
function editUseUser(btn, type) {
	// 선택한 행 index
	var startIdx = $(btn).parent('td').parent('tr').index();
	var count = $(btn).parent('td').attr('rowspan');
	
	var winoption = {width:1024, height:750};
	if(type == 'single') {
		winoption['height'] = 640;
	}
	var param = {popupTitle: "사용(봉안) 대상자 입력 " + (type == 'couple' ? "(부부형)" : "(1인형)"), popupType:type};
	param = getUserParam(param);
	param['rowIdx'] = startIdx;
	common.openWindow("${contextPath}/popup/registuseuser", "popRegistUseUser", winoption, param);
	
	if(type == 'couple') {// 부부형
		// 사용(봉안) 대상자 입력 팝업 callback 함수
		window.selectuserCallBack = function(item1, item2, isOneSelf) {
			if(!item1 || item1.length == 0 || !item2 || item2.length == 0) {
				return;
			}
			var coupleSeq = $("#tblUseUser tbody tr").eq(startIdx).attr('coupleSeq');
			var useUser1 = getUseUser(item1);
			var useUser2 = getUseUser(item2);
			useUser1['coupleSeq'] = coupleSeq;
			useUser2['coupleSeq'] = coupleSeq;
			
			bunyangRefUser.useUser[startIdx] = useUser1;
			bunyangRefUser.useUser[startIdx+1] = useUser2;
			
			var tr1 = $('<tr/>');
			var tr2 = $('<tr/>');
			tr1.append('<td rowspan="2" class="coupletype">부부형</td>');
			tr1.append('<td name="userName">' + useUser1['userName'] + '</td>');
			tr1.append('<td name="birthDate">' + useUser1['birthDate'] + '</td>');
			tr1.append('<td name="mobile">' + useUser1['mobile'] + '</td>');
			tr1.append('<td name="address" align="left">' + useUser1['fulladdress'] + '</td>');
			tr1.append('<td name="relation">' + useUser1['relationTypeName'] + '</td>');
			tr1.append('<td name="ischurch">' + useUser1['isChurchPerson'] + '</td>');
			tr1.append('<td>' + useUser1['isMove'] + '</td>');
			tr1.append('<td rowspan="2" class="form-inline"><button type="button" class="btn btn-primary btn-sm" onclick="editUseUser(this,\'couple\')">수정</button><button type="button" class="btn btn-danger btn-sm" style="margin-left:3px;" onclick="deleteUseUserRow(this)">삭제</button></td>');
			
			tr2.append('<td name="userName">' + useUser2['userName'] + '</td>');
			tr2.append('<td name="birthDate">' + useUser2['birthDate'] + '</td>');
			tr2.append('<td name="mobile">' + useUser2['mobile'] + '</td>');
			tr2.append('<td name="address" align="left">' + useUser2['fulladdress'] + '</td>');
			tr2.append('<td name="relation">' + useUser2['relationTypeName'] + '</td>');
			tr2.append('<td name="ischurch">' + useUser2['isChurchPerson'] + '</td>');
			tr2.append('<td>' + useUser2['isMove'] + '</td>');
			
			$("#tblUseUser tbody tr").eq(startIdx).replaceWith(tr1);
			$("#tblUseUser tbody tr").eq(startIdx+1).replaceWith(tr2);
			
			updateBunyangInfo();
			updateSelectBoxMaintCharger();
		};
	} else {// 1인형
		// 사용(봉안) 대상자 입력 팝업 callback 함수
		window.selectuserCallBack = function(item1, isOneSelf) {
			if(!item1 || item1.length == 0) {
				return;
			}
			var useUser1 = getUseUser(item1);
			bunyangRefUser.useUser[startIdx] = useUser1;
			
			var tr1 = $('<tr/>');
			tr1.append('<td rowspan="1" class="singletype">1인형</td>');
			tr1.append('<td name="userName">' + useUser1['userName'] + '</td>');
			tr1.append('<td name="birthDate">' + useUser1['birthDate'] + '</td>');
			tr1.append('<td name="mobile">' + useUser1['mobile'] + '</td>');
			tr1.append('<td name="address" align="left">' + useUser1['fulladdress'] + '</td>');
			tr1.append('<td name="relation">' + useUser1['relationTypeName'] + '</td>');
			tr1.append('<td name="ischurch">' + useUser1['isChurchPerson'] + '</td>');
			tr1.append('<td>' + useUser1['isMove'] + '</td>');
			tr1.append('<td rowspan="1" class="form-inline"><button type="button" class="btn btn-primary btn-sm" onclick="editUseUser(this, \'single\')">수정</button><button type="button" class="btn btn-danger btn-sm" style="margin-left:3px;" onclick="deleteUseUserRow(this)">삭제</button></td>');
			
			$("#tblUseUser tbody tr").eq(startIdx).replaceWith(tr1);
			
			updateBunyangInfo();
			updateSelectBoxMaintCharger();
		};
	}
}

/**
 * 팝업에서 입력한 사용(봉안)대상자 정보반환
 */
function getUseUser(item) {
	var useUser = {};
	var idx = 0, userId = '', userName = '', birthDate = '', gender = '', email = '', mobile = '', phone = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', diocese = '', relationType = '', relationTypeName = '', isChurchPerson = '', isMove = '';
	if(item && item.length > 0) {
		userId = item[idx++];
		userName = item[idx++];
		birthDate = item[idx++];
		gender = item[idx++];
		mobile = item[idx++];
		phone = item[idx++];
		postNumber = item[idx++];
		address1 = item[idx++];
		address2 = item[idx++];
		fulladdress = item[idx++];
		churchOfficer = item[idx++];
		churchOfficerName = item[idx++];
		diocese = item[idx++];
		email = item[idx++];
		relationType = item[idx++];
		relationTypeName = item[idx++];
		isChurchPerson = item[idx++];
		isMove = item[idx++];
		
		useUser['userName'] = userName;
		useUser['birthDate'] = birthDate;
		useUser['gender'] = gender;
		useUser['mobile'] = mobile;
		useUser['phone'] = phone;
		useUser['postNumber'] = postNumber;
		useUser['address1'] = address1;
		useUser['address2'] = address2;
		useUser['fulladdress'] = fulladdress;
		useUser['email'] = email;
		useUser['relationType'] = relationType;
		useUser['relationTypeName'] = relationTypeName;
		useUser['isChurchPerson'] = isChurchPerson;
		useUser['isMove'] = isMove;
		useUser['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_USE_USER%>';
	}
	return useUser;
}

/**
 * 분양정보 저장
 */
function saveApply() {
	var i = 0;
	var idx = 0;
	
	var applyUser = bunyangRefUser.applyUser;
	var agentUser = bunyangRefUser.agentUser;
	var useUsers = bunyangRefUser.useUser;
	
	var coupleTypeCount = $("#tblUseUser tbody tr td.coupletype").length;
	var singleTypeCount = $("#tblUseUser tbody tr td.singletype").length;
	var maintCharger = $('#selMaintCharger option:selected').val();
	var productType = $('#pProductType').val();
	var serviceChargeType = $(":input:radio[name=rbServiceChargeType]:checked").val();
	var bunyangTimes = $('#selBunyangTimes option:selected').attr('codeSeq');
	var bunyangInfo = {};
	var pricePerCount = 0;
	
	if(!applyUser || !applyUser.userName) {
		common.showAlert("신청자 정보가 없습니다.");
		return;
	}
	if(!useUsers || useUsers.length == 0) {
		common.showAlert("사용(봉안) 대상자 정보가 없습니다.");
		return;
	}
	
	// 분양단가 직접입력 차수에서 단가체크
	if(common.isVisible($('#tiBunyangPrice'))) {
		if(!$('#tiBunyangPrice').val()){
			common.showAlert("분양단가를 입력해주세요.");
			$('#tiBunyangPrice').focus();
			return;
		}
		pricePerCount = common.toNumeric($('#tiBunyangPrice').val());
		if(!pricePerCount || pricePerCount <= 0) {
			common.showAlert("분양단가가 올바르지 않습니다.");
			$('#tiBunyangPrice').focus();
			return;
		}
	} else {
		pricePerCount = common.toNumeric($('#sBunyangPrice').text());
	}
	
	for(i = 0; i < useUsers.length; i++) {
		var user = useUsers[i];
		user['isMaintCharger'] = 'N';
	}
	// 사용자중 관리비납부자로 선택된 사용자
	if(serviceChargeType == '<%=CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT%>') {
		if(!maintCharger) {
			common.showAlert("사용자중 관리비 납부자를 선택해주세요.");
			$('#selMaintCharger').focus();
			return;
		}
		var maintChargerName = $('#selMaintCharger option:selected').attr('userName');
		var maintChargerBirthDate = $('#selMaintCharger option:selected').attr('birthDate');
		var maintChargerGender = $('#selMaintCharger option:selected').attr('gender');
		var maintChargerMobile = $('#selMaintCharger option:selected').attr('mobile');
		
		// 사용자중 관리비납부자로 선택된 사용자
		for(var i = 0; i < useUsers.length; i++) {
			var user = useUsers[i];
			if(user.userName == maintChargerName 
					&& user.birthDate == maintChargerBirthDate
					&& user.gender == maintChargerGender
					&& user.mobile == maintChargerMobile
			) {
				user['isMaintCharger'] = 'Y';
			} else {
				user['isMaintCharger'] = 'N';
			}
		}
	}
	
	// 신청자,대리인,사용자
	bunyangInfo["applyUser"] = applyUser;
	bunyangInfo["agentUser"] = agentUser;
	bunyangInfo["useUsers"] = useUsers;
	
	// 분양신청정보
	bunyangInfo['productType'] = productType;
	bunyangInfo['serviceChargeType'] = serviceChargeType;
	bunyangInfo['coupleTypeCount'] = coupleTypeCount;
	bunyangInfo['singleTypeCount'] = singleTypeCount;
	bunyangInfo['bunyangTimes'] = bunyangTimes;
	bunyangInfo['pricePerCount'] = pricePerCount;
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
 * 대리인 행 삭제
 */
function deleteAgentUserRow(btn) {
	deleteRow(btn);
	bunyangRefUser.agentUser = null;
}

/**
 * 사용(봉안) 대상자 행 삭제
 */
function deleteUseUserRow(btn) {
	var startIdx = $(btn).parent('td').parent('tr').index();
	var count = $(btn).parent('td').attr('rowspan');
	bunyangRefUser.useUser.splice(startIdx, count);
	deleteRow(btn);
	updateBunyangInfo();
	updateSelectBoxMaintCharger();
}

/**
 * 행삭제
 * @param btn 삭제 버튼
 */
function deleteRow(btn) {
	var td = $(btn).parent("td"); 
	var rowspan = td.attr('rowspan');
	var tr = td.parent("tr"); 
	if(rowspan > 0) {
		var nexttR;
		for(var i = 0; i < rowspan; i++) {
			nextTr = tr.next('tr'); 
			tr.remove();
			tr = nextTr;
		}
	}else {
		tr.remove();
	}
}

/**
 * 두개의 사용자 정보가 중복인지 체크
 */
function isDuplicateUser(user1, user2) {
	// 성명이 있으면 기타 정보는 모두 있다고 가정하며 성명,생년월일,성별,휴대폰이 일치할 경우 동일인
	if(user1 != null && user2 != null && user1.userName && user2.userName) {
		if(user1.userName != user2.userName) {// 성명
			return false;
		}
		if(user1.birthDate != user2.birthDate) {// 생년월일
			return false;
		}
		if(user1.gender != user2.gender) {// 성별
			return false;
		}
		if(user1.mobile != user2.mobile) {// 휴대폰
			return false;
		}
		return true;
	}
	return false;
}

/**
 * 신청자,대리인,사용(봉안)대상자 입력팝업에서 참조할 사용자정보 반환 
 */
function getUserParam(param) {
	var applyUser = bunyangRefUser.applyUser;
	var agentUser = bunyangRefUser.agentUser;
	var useUser = bunyangRefUser.useUser;
	var idx = 0;
	if(applyUser && applyUser.userName) {// 신청자
		param['users['+idx+'].userName'] = applyUser.userName;
		param['users['+idx+'].birthDate'] = applyUser.birthDate;
		param['users['+idx+'].gender'] = applyUser.gender;
		param['users['+idx+'].churchOfficer'] = applyUser.churchOfficer;
		param['users['+idx+'].diocese'] = applyUser.diocese;
		param['users['+idx+'].mobile'] = applyUser.mobile;
		param['users['+idx+'].phone'] = applyUser.phone;
		param['users['+idx+'].postNumber'] = applyUser.postNumber;
		param['users['+idx+'].address1'] = applyUser.address1;
		param['users['+idx+'].address2'] = applyUser.address2;
		param['users['+idx+'].fulladdress'] = applyUser.fulladdress;
		param['users['+idx+'].email'] = applyUser.email;
		param['users['+idx+'].refType'] = applyUser.refType;
		idx++;
	}
	if(agentUser && agentUser.userName) {// 대리인
		param['users['+idx+'].userName'] = agentUser.userName;
		param['users['+idx+'].birthDate'] = agentUser.birthDate;
		param['users['+idx+'].gender'] = agentUser.gender;
		param['users['+idx+'].relationType'] = agentUser.relationType;
		param['users['+idx+'].relationTypeName'] = agentUser.relationTypeName;
		param['users['+idx+'].mobile'] = agentUser.mobile;
		param['users['+idx+'].phone'] = agentUser.phone;
		param['users['+idx+'].postNumber'] = agentUser.postNumber;
		param['users['+idx+'].address1'] = agentUser.address1;
		param['users['+idx+'].address2'] = agentUser.address2;
		param['users['+idx+'].fulladdress'] = agentUser.fulladdress;
		param['users['+idx+'].email'] = agentUser.email;
		param['users['+idx+'].refType'] = agentUser.refType;
		idx++;
	}
	if(useUser && useUser.length > 0) {// 사용자
		$.each(useUser, function(i, item) {
			param['users['+idx+'].userName'] = item.userName;
			param['users['+idx+'].birthDate'] = item.birthDate;
			param['users['+idx+'].gender'] = item.gender;
			param['users['+idx+'].relationType'] = item.relationType;
			param['users['+idx+'].relationTypeName'] = item.relationTypeName;
			param['users['+idx+'].mobile'] = item.mobile;
			param['users['+idx+'].phone'] = item.phone;
			param['users['+idx+'].postNumber'] = item.postNumber;
			param['users['+idx+'].address1'] = item.address1;
			param['users['+idx+'].address2'] = item.address2;
			param['users['+idx+'].fulladdress'] = item.fulladdress;
			param['users['+idx+'].email'] = item.email;
			param['users['+idx+'].refType'] = item.refType;
			param['users['+idx+'].isChurchPerson'] = item.isChurchPerson;
			param['users['+idx+'].isMove'] = item.isMove;
			idx++;
		});
	}
	return param;
}


</script>