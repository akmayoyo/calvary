<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="poptitle">
    <strong>${popupTitle}</strong>
    <button type="button" class="close btnClose" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
</div>

<div class="content" style="padding: 10px 10px;">

    <form id="frmInputUser" class="form-horizontal">
		<div class="table-responsive" style="border-top: 1px solid #999;">
	        <table id="tblUserInfo" class="table table-style table-horizon" style="border-top: 0;">
	        	<colgroup>
	        		<col width="150">
	        		<col width="*">
	        	</colgroup>
	            <tbody>
	            	<tr>
	            		<th class="required">신청자성명</th>
	            		<td><input id="tiUserName" class="form-control" type="text" style="width: 200px;" autofocus="autofocus"></td>
	            	</tr>
	            	<tr>
	            		<th class="required">생년월일</th>
	            		<td align="left" class="form-inline">
	            			<select id="selBirthYear" class="form-control" style="width: 80px;">
	            				<c:forEach items="${yearList}" var="yearItem">
	            					<option value="${yearItem.year_val}" <c:if test="${yearItem.year_val == 1970}">selected</c:if>>${yearItem.year_val}</option>
	            				</c:forEach>
	            			</select>
	            			<span>-</span>
	            			<select id="selBirthMonth" class="form-control" style="width: 80px;">
	            				<c:forEach begin="1" end="12" varStatus="loop">
	            					<c:choose>
	            						<c:when test="${loop.index >= 10}"><option value="${loop.index}">${loop.index}</option></c:when>
	            						<c:otherwise><option value="${loop.index}">0${loop.index}</option></c:otherwise>
	            					</c:choose>
								</c:forEach>
	            			</select>
	            			<span>-</span>
	            			<select id="selBirthDay" class="form-control" style="width: 80px; margin-right: 15px;">
	            				<option value="1">01</option>
	            			</select>
	            			<span style="font-size: 13px;">성별</span>
	            			<select id="selGender" class="form-control" style="width: 80px; margin-left: 5px;">
	            				<option value="1">남성</option>
	            				<option value="2">여성</option>
	            			</select>
	            		</td>
	            	</tr>
	            	<c:choose>
	            		<c:when test="${popupType == '1'}">
	            		<tr>
	            			<th class="required">직분/교구</th>
		            		<td align="left" class="form-inline">
		            			<span style="font-size: 13px;">직분</span>
		            			<select id="selOfficer" class="form-control" style="width: 98px; margin-left: 5px; margin-right: 18px;">
		            				<option value="">선택</option>
		            				<c:forEach items="${officerList}" var="officer">
		            					<option value="${officer.code_seq}">${officer.code_name}</option>
		            				</c:forEach>
		            			</select>
		            			<span style="font-size: 13px;">교구</span>
		            			<input id="tiDiocese" type="text" class="form-control" style="width: 80px; margin-left: 5px;">
		            		</td>
	            		</tr>
	            		</c:when>
	            		<c:when test="${popupType == '2'}">
	            		<tr>
	            			<th class="required">신청자와의 관계</th>
		            		<td align="left" class="form-inline">
		            			<select id="selAgentRealtion" class="form-control" style="width: 98px;">
		            				<option value="">선택</option>
		            				<c:forEach items="${relationList}" var="relationItem">
		            					<c:if test="${relationItem.code_seq != 'ONESELF'}">
		            					<option value="${relationItem.code_seq}">${relationItem.code_name}</option>
		            					</c:if>
		            				</c:forEach>
		            			</select>
		            		</td>
	            		</tr>
	            		</c:when>
	            	</c:choose>
	            	<tr>
            			<th class="required">휴대전화</th>
            			<td align="left" class="form-inline">
	            			<select id="selMobile1" class="form-control" style="width: 80px;">
	            				<option>010</option>
	            				<option>011</option>
	            				<option>016</option>
	            				<option>017</option>
	            				<option>018</option>
	            				<option>019</option>
	            			</select>
	            			<span>-</span>
	            			<input id="tiMobile2" type="text" class="form-control" style="width: 80px;" maxlength="4">
	            			<span>-</span>
	            			<input id="tiMobile3" type="text" class="form-control" style="width: 80px;" maxlength="4">
	            		</td>
            		</tr>
            		<tr>
            			<th class="required">전화</th>
            			<td align="left" class="form-inline">
	            			<input id="tiPhone1" type="text" class="form-control" style="width: 80px;" maxlength="4">
	            			<span>-</span>
	            			<input id="tiPhone2" type="text" class="form-control" style="width: 80px;" maxlength="4">
	            			<span>-</span>
	            			<input id="tiPhone3" type="text" class="form-control" style="width: 80px;" maxlength="4">
	            		</td>
            		</tr>
	            	<tr>
            			<th class="required">주소</th>
            			<td align="left" class="form-inline" >
            				<input name="postNumber" type="text" class="form-control readonlywhite" style="width: 150px;" readonly="readonly" placeholder="우편번호">
            				<button type="button" class="btn btn-sm btn-primary" onclick="goJusoPopup(this)">검색</button><br>
            				<input name="address1" type="text" class="form-control readonlywhite" readonly="readonly" placeholder="주소" style="width: 100%; margin-top: 5px;"><br>
            				<input name="address2" type="text" class="form-control" placeholder="상세주소" style="width: 100%; margin-top: 5px;">
            			</td>
            		</tr>
            		<tr>
            			<th>이메일</th>
	            		<td align="left" class="form-inline">
	            			<input id="tiEmailAddr" type="text" class="form-control" style="width: 140px;">
	            			<span>@</span>
	            			<input id="tiEmailDomain" type="text" class="form-control readonlywhite" style="width: 140px;">
	            			<select id="selEmailDomain" class="form-control" style="width: 140px;">
								<option value="">직접입력</option>
								<option value="naver.com">naver.com</option>
								<option value="daum.net">daum.net</option>
								<option value="hotmail.com">hotmail.com</option>
								<option value="nate.com">nate.com</option>
								<option value="yahoo.co.kr">yahoo.co.kr</option>
								<option value="paran.com">paran.com</option>
								<option value="empas.com">empas.com</option>
								<option value="dreamwiz.com">dreamwiz.com</option>
								<option value="freechal.com">freechal.com</option>
								<option value="lycos.co.kr">lycos.co.kr</option>
								<option value="korea.com">korea.com</option>
								<option value="gmail.com">gmail.com</option>
								<option value="hanmir.com">hanmir.com</option>
	            			</select>
	            		</td>
            		</tr>
	            </tbody>
	        </table>
	    </div>
	    <div class="mt-30 text-center">
			<button type="button" class="btn btn-primary btn-lg" onclick="_confirm();">확인</button>
			<button type="button" class="btn btn-default btn-lg btnClose">닫기</button>
		</div>
	</form>
	
	<!-- 메인화면에서 입력한 사용자 정보 참조용 -->
	<ul id="userList" style="display: none;">
		<c:forEach var="user" items="${users}">
			<li refType="${user.refType}" userName="${user.userName}" birthDate="${user.birthDate }" gender="${user.gender }"
			churchOfficer="${user.churchOfficer}" diocese="${user.diocese}" relationType="${user.relationType}"  
			mobile="${user.mobile }" phone="${user.phone }" email="${user.email}"
			postNumber="${user.postNumber }" address1="${user.address1 }" address2="${user.address2}"
			></li>
		</c:forEach>
	</ul>
	
</div>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function() {
	
	// 생년월일의 연도,월 변경이벤트
	$('#selBirthYear, #selBirthMonth').change(function(){
		generateDays();
	});
	
	// 이메일 도메인 select box 변경이벤트
	$('#selEmailDomain').change(function(){
		var selectedVal = $(this).find('option:selected').val();
		$('#tiEmailDomain').val(selectedVal);
		if(selectedVal) {
			$('#tiEmailDomain').attr('readonly', true);
		} else {
			$('#tiEmailDomain').attr('readonly', false);
		}
	});

    // 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
    
   	// 메인화면에서 기입력된 데이터가 있을 경우 초기입력해줌
    var userInfo;
    if('${popupType}' == '1') {// 신청인
    	userInfo = getRefUserInfo('<%=CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER%>');
    } else if('${popupType}' == '2') {// 대리인
    	userInfo = getRefUserInfo('<%=CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER%>');
    }
    if(userInfo && userInfo.length > 0 && userInfo[0].userName) {
    	$('#tiUserName').val(userInfo[0].userName);
    	var birthDate = userInfo[0].birthDate;
    	var gender = userInfo[0].gender;
    	var churchOfficer = userInfo[0].churchOfficer;
    	var diocese = userInfo[0].diocese;
    	var relationType = userInfo[0].relationType;
    	var mobile = userInfo[0].mobile;
    	var phone = userInfo[0].phone;
    	var postNumber = userInfo[0].postNumber;
    	var address1 = userInfo[0].address1;
    	var address2 = userInfo[0].address2;
    	var email = userInfo[0].email;
    	var splited;
    	if(birthDate) {
    		splited = birthDate.split('-');
    		if(splited && splited.length == 3) {
    			$('#selBirthYear option[value=' + splited[0] + ']').attr('selected', 'selected');
            	$('#selBirthMonth option[value=' + parseInt(splited[1]) + ']').attr('selected', 'selected');
            	$('#selBirthYear').trigger('change');
            	$('#selBirthDay option[value=' + parseInt(splited[2]) + ']').attr('selected', 'selected');
    		}
    	}
    	$('#selGender option[value=' + gender + ']').attr('selected', 'selected');
    	
    	if('${popupType}' == '1') {// 신청인
    		if(churchOfficer) {
    			$('#selOfficer option[value=' + churchOfficer + ']').attr('selected', 'selected');	
    		}
    		if(diocese) {
    			$('#tiDiocese').val(diocese);
    		}
    	}else if('${popupType}' == '2') {// 대리인
    		if(relationType) {
    			$('#selAgentRealtion option[value=' + relationType + ']').attr('selected', 'selected');	
    		}
    	}
    	if(mobile) {
    		splited = mobile.split('-');
    		if(splited && splited.length == 3) {
    			$('#selMobile1 option[value=' + splited[0] + ']').attr('selected', 'selected');
            	$('#tiMobile2').val(splited[1]);
            	$('#tiMobile3').val(splited[2]);
    		}
    	}
    	if(phone) {
    		splited = phone.split('-');
    		if(splited && splited.length == 3) {
            	$('#tiPhone1').val(splited[0]);
            	$('#tiPhone2').val(splited[1]);
            	$('#tiPhone3').val(splited[2]);
    		}
    	}
    	if(postNumber) {
    		$('#tblUserInfo input[name="postNumber"]').val(postNumber);
    	}
    	if(address1) {
    		$('#tblUserInfo input[name="address1"]').val(address1);
    	}
    	if(address2) {
    		$('#tblUserInfo input[name="address2"]').val(address2);
    	}
    	if(email) {
    		splited = email.split('@');
    		if(splited && splited.length == 2) {
            	$('#tiEmailAddr').val(splited[0]);
            	$('#tiEmailDomain').val(splited[1]);
            	$('#selEmailDomain option[value="' + splited[1] + '"]').attr('selected', 'selected');
    		}
    	}
    }
    $('#selBirthYear').trigger('change');
    $('#selEmailDomain').trigger('change');
})();

/**
 * 확인버튼 클릭 핸들러
 */
function _confirm() {
	var userName, birthDate, gender, mobile, mobile2, mobile3, phone, phone1, phone2, phone3, postNumber, address1, address2, fulladdress, officer, officerName, diocese, email, relationType, relationTypeName;
	
	// 성명
	userName = $('#tiUserName').val();
	if(!userName) {
		common.showAlert('성명을 입력해주세요.');
		$('#tiUserName').focus();
		return;
	}
	
	// 생년월일
	birthDate = $('#selBirthYear option:selected').text();
	birthDate += '-' + $('#selBirthMonth option:selected').text();
	birthDate += '-' + $('#selBirthDay option:selected').text();
	
	// 성별
	gender = $('#selGender option:selected').val();
	
	// 직분/교구
	if($('#selOfficer').length > 0) {
		officer = $('#selOfficer option:selected').val();
		officerName = officer ? $('#selOfficer option:selected').text() : '';
		if(!officer) {
			common.showAlert('직분을 선택해주세요.');
			$('#selOfficer').focus();
			return;
		}
		diocese = $('#tiDiocese').val();
		if(!diocese) {
			common.showAlert('교구를 입력해주세요.');
			$('#tiDiocese').focus();
			return;
		}
	}
	
	// 신청자와의 관계
	if($('#selAgentRealtion').length > 0) {
		relationType = $('#selAgentRealtion option:selected').val();
		relationTypeName = relationType ? $('#selAgentRealtion option:selected').text() : '';
		if(!relationType) {
			common.showAlert('신청자와의 관계를 입력해주세요.');
			$('#selAgentRealtion').focus();
			return;
		}
	}
	
	// 휴대전화
	mobile = $('#selMobile1 option:selected').text();
	mobile2 = $('#tiMobile2').val();
	mobile3 = $('#tiMobile3').val();
	if(!mobile2 || !mobile3) {
		common.showAlert('휴대전화를 입력해주세요.');
		return;
	}
	mobile = mobile + '-' + mobile2 + '-' + mobile3;
	
	if(!common.isValidMobile(mobile)) {
		common.showAlert('휴대전화 양식이 올바르지 않습니다.');
		return;
	}
	
	// 전화
	phone1 = $('#tiPhone1').val();
	phone2 = $('#tiPhone2').val();
	phone3 = $('#tiPhone3').val();
	if(!phone1 || !phone2 || !phone3) {
		common.showAlert('전화를 입력해주세요.');
		return;
	}
	phone = phone1 + '-' + phone2 + '-' + phone3;
	
	if(!common.isValidPhone(phone)) {
		common.showAlert('전화 양식이 올바르지 않습니다.');
		return;
	}
	
	// 주소
	postNumber = $('#tblUserInfo input[name="postNumber"]').val();
	address1 = $('#tblUserInfo input[name="address1"]').val();
	address2 = $('#tblUserInfo input[name="address2"]').val();
	
	if(!postNumber || !address1) {
		common.showAlert('주소를 입력해주세요.');
		return;
	}
	if(!address2) {
		common.showAlert('상세주소를 입력해주세요.');
		$('#tblUserInfo input[name="address2"]').focus();
		return;
	}
	fulladdress = '(' + postNumber + ') ' + address1 + ' ' + address2;
	
    email = $('#tiEmailAddr').val();
    if(email) {
    	email += '@' + $('#tiEmailDomain').val();
    	if(!common.isValidMail(email)) {
    		common.showAlert('이메일 형식이 올바르지 않습니다.');
    		return;
    	}
    }
    
    // 신청자-대리인 동일한지 체크
    if('${popupType}' == '1') {
    	var agentUserInfo = getRefUserInfo('<%=CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER%>');
    	if(agentUserInfo && agentUserInfo.length > 0 && agentUserInfo[0].userName) {
    		if(userName == agentUserInfo[0]['userName']
    		&& birthDate == agentUserInfo[0]['birthDate']
    		&& gender == agentUserInfo[0]['gender']
    		&& mobile == agentUserInfo[0]['mobile']
    		) {
    			common.showAlert('입력하신 신청자 정보가 대리인 정보와 동일합니다.\n대리인 정보 삭제후 입력해주세요.');
    			return;		
    		}
    	}
    }else if('${popupType}' == '2') {
    	var applyUserInfo = getRefUserInfo('<%=CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER%>');
    	if(applyUserInfo && applyUserInfo.length > 0) {
    		if(userName == applyUserInfo[0]['userName']
    		&& birthDate == applyUserInfo[0]['birthDate']
    		&& gender == applyUserInfo[0]['gender']
    		&& mobile == applyUserInfo[0]['mobile']
    		) {
    			common.showAlert('입력하신 대리인 정보가 신청자 정보와 동일합니다.\n대리인신청시만 입력해주세요.');
    			return;		
    		}
    	}
    }
    
    var userVo = {};
    userVo['userName'] = userName;
    userVo['birthDate'] = birthDate;
    userVo['gender'] = gender;
    userVo['mobile'] = mobile;
    if('${popupType}' == '1') {
    	userVo['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER%>';	
    }else if('${popupType}' == '2') {
    	userVo['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER%>';	
    }
    
    common.ajax({
		url:"${contextPath}/popup/checkduplicateduser", 
		data:userVo,
		success: function(result) {
			if(result && result.duplicatedUser) {
				common.showAlert('입력하신 성명/생년월일/휴대번호로 이미 등록된 정보가 있습니다.');	
			}else {
				var selectedItems = [];
    	        selectedItems.push(userName);
    	        selectedItems.push(birthDate);
    	        selectedItems.push(gender);
    	        selectedItems.push(mobile);
    	        selectedItems.push(phone);
    	        selectedItems.push(postNumber);
    	        selectedItems.push(address1);
    	        selectedItems.push(address2);
    	        selectedItems.push(fulladdress);
    	        selectedItems.push(officer);
    	        selectedItems.push(officerName);
    	        selectedItems.push(diocese);
    	        selectedItems.push(email);
    	        selectedItems.push(relationType);
    	        selectedItems.push(relationTypeName);
    	        if(window.opener && window.opener.selectuserCallBack != 'undefined') {
        			window.opener.selectuserCallBack(selectedItems);
        		}
        		common.closeWindow();
			}
		},
		error: function(xhr, status, message) {
			alert(message);
		}
	});
}

/**
 * 도로명주소 Open API 팝업호출
 */
function goJusoPopup(btn){
// 	var winoption = {width:570, height:420};
// 	common.openWindow("${contextPath}/popup/jusopopup.jsp", "jusopopup", winoption, {});
// 	window.jusoCallBack = function(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn , detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo){
// 		var td = $(btn).parent('td');
// 		td.find('input[name="postNumber"]').val(zipNo);
// 		td.find('input[name="address1"]').val(roadAddrPart1 + roadAddrPart2);
// 		td.find('input[name="address2"]').val(addrDetail);
// 		td.find('input[name="address2"]').focus();
// 	};
	new daum.Postcode({
        oncomplete: function(data) {
        	var td = $(btn).parent('td');
        	var postNumber = data.zonecode;
        	var address1 = data.address;
        	if(data.buildingName) {
        		address1 += '(' + data.buildingName + ')';
        	}
        	td.find('input[name="postNumber"]').val(postNumber);
        	td.find('input[name="address1"]').val(address1);
        	td.find('input[name="address2"]').focus();
        }
    }).open();
}

/**
 * 연월에 해당하는 날짜 선택용 select box 생성
 */
function generateDays()
{
	var year = $('#selBirthYear option:selected').val();
	var month = $('#selBirthMonth option:selected').val();
	var firstDay = 1;
	var lastDay = new Date(year, month, 0).getDate();
	var options = "";
	for(var i = firstDay; i <= lastDay; i++) {
		options += '<option value="' + i + '">' + (i >= 10 ? i : '0'+i) + '</option>';
	}
	var selectedDay = $('#selBirthDay option:selected').val();
	
	$('#selBirthDay').html(options);
	
	if(selectedDay > 0 && selectedDay <= lastDay) {
		$('#selBirthDay option[value=' + selectedDay + ']').attr('selected', 'selected');
	}
}

/**
 * 메인화면에서 전달된 참조용 사용자 정보반환
 */
function getRefUserInfo(refType) {
	var userInfoes = [];
	$('#userList li[refType="' + refType + '"]').each(function(idx) {
		var userInfo = {};
		userInfo.userName = $(this).attr('userName');
		userInfo.birthDate = $(this).attr('birthDate');
		userInfo.gender = $(this).attr('gender');
		userInfo.churchOfficer = $(this).attr('churchOfficer');
		userInfo.diocese = $(this).attr('diocese');
		userInfo.relationType = $(this).attr('relationType');
		userInfo.mobile = $(this).attr('mobile');
		userInfo.phone = $(this).attr('phone');
		userInfo.postNumber = $(this).attr('postNumber');
		userInfo.address1 = $(this).attr('address1');
		userInfo.address2 = $(this).attr('address2');
		userInfo.email = $(this).attr('email');
		userInfo.refType = $(this).attr('refType');
		userInfoes.push(userInfo);
	});
	return userInfoes;
}

</script>