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
	            		<th>성명</th>
	            		<td align="left">${refUserInfo.user_name}</td>
	            	</tr>
	            	<tr>
	            		<th>생년월일</th>
	            		<td align="left" class="form-inline">
	            			${refUserInfo.birth_date}
	            			<span style="margin-left: 5px;">(
	            			<c:choose>
	            				<c:when test="${refUserInfo.gender == '1'}">남성</c:when>
	            				<c:when test="${refUserInfo.gender == '1'}">여성</c:when>
	            			</c:choose>
	            			)
	            			</span>
	            		</td>
	            	</tr>
	            	<c:if test="${not empty refUserInfo.church_officer_name}">
            		<tr>
            			<th>직분/교구</th>
	            		<td align="left" class="form-inline">
	            			${refUserInfo.church_officer_name} / ${refUserInfo.diocese}
	            		</td>
            		</tr>
            		</c:if>
            		<c:if test="${not empty refUserInfo.relation_type_name}">
            		<tr>
            			<th>관계</th>
	            		<td align="left">
	            			${refUserInfo.relation_type_name}
	            		</td>
            		</tr>
            		</c:if>
	            	<tr>
            			<th class="required">휴대전화</th>
            			<td align="left" class="form-inline">
	            			<select id="selMobile1" class="form-control" style="width: 80px;">
	            				<option value="010">010</option>
	            				<option value="011">011</option>
	            				<option value="016">016</option>
	            				<option value="017">017</option>
	            				<option value="018">018</option>
	            				<option value="019">019</option>
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
            				<input name="postNumber" id="tiPostNumber" type="text" class="form-control readonlywhite" style="width: 150px;" readonly="readonly" placeholder="우편번호">
            				<button type="button" class="btn btn-sm btn-primary" onclick="goJusoPopup(this)">검색</button><br>
            				<input name="address1" id="tiAddress1" type="text" class="form-control readonlywhite" readonly="readonly" placeholder="주소" style="width: 100%; margin-top: 5px;"><br>
            				<input name="address2" id="tiAddress2" type="text" class="form-control" placeholder="상세주소" style="width: 100%; margin-top: 5px;">
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
			<button type="button" class="btn btn-primary btn-lg" onclick="_confirm();">저장</button>
			<button type="button" class="btn btn-default btn-lg btnClose">닫기</button>
		</div>
	</form>
	
</div>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function() {
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
    
    var mobile = '${refUserInfo.mobile}';
    var mobile1 = '';
    var mobile2 = '';
    var mobile3 = '';
    var phone = '${refUserInfo.phone}';
    var phone1 = '';
    var phone2 = '';
    var phone3 = '';
    var postNumber = '${refUserInfo.post_number}';
    var address1 = '${refUserInfo.address1}';
    var address2 = '${refUserInfo.address2}';
    var email = '${cutil:replaceNewLine(refUserInfo.email)}';
    var emailAddr = '';
    var emailDomain = '';
    var arrTmp;
    
    if(common.isValidMobile(mobile)) {
    	mobile = common.toNumeric(mobile);
    	if(mobile.length == 10) {
    		mobile1 = mobile.substring(0,3);
    		mobile2 = mobile.substring(3,6);
    		mobile3 = mobile.substring(6,10);
    	} else if(mobile.length == 11) {
    		mobile1 = mobile.substring(0,3);
    		mobile2 = mobile.substring(3,7);
    		mobile3 = mobile.substring(7,11);
    	}
		$('#selMobile1 option[value=' + mobile1 + ']').attr('selected', 'selected');
		$('#tiMobile2').val(mobile2);
		$('#tiMobile3').val(mobile3);
    }
    
    if(common.isValidPhone(phone)) {
    	arrTmp = phone.split('-');
    	if(arrTmp && arrTmp.length == 3) {
    		$('#tiPhone1').val(arrTmp[0]);
    		$('#tiPhone2').val(arrTmp[1]);
    		$('#tiPhone3').val(arrTmp[2]);
    	}
    }
    
    if(common.isValidMail(email)) {
    	arrTmp = email.split('@');
    	emailAddr = arrTmp[0];
    	emailDomain = arrTmp[1];
    }
    $('#tiPostNumber').val(postNumber);
    $('#tiAddress1').val(address1);
    $('#tiAddress2').val(address2);
    if(emailAddr && emailDomain) {
    	$('#tiEmailAddr').val(emailAddr);
    	$('#tiEmailDomain').val(emailDomain);
    }
})();

/**
 * 확인버튼 클릭 핸들러
 */
function _confirm() {
	var userName, birthDate, gender, mobile, mobile2, mobile3, phone, phone1, phone2, phone3, postNumber, address1, address2, fulladdress, officer, officerName, diocese, email, relationType, relationTypeName, changeReason, remarks;
	
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
// 	if(!address2) {
// 		common.showAlert('상세주소를 입력해주세요.');
// 		$('#tblUserInfo input[name="address2"]').focus();
// 		return;
// 	}
	fulladdress = '(' + postNumber + ') ' + address1 + ' ' + (address2 ? address2 : '');
	
    email = $('#tiEmailAddr').val();
    if(email) {
    	email += '@' + $('#tiEmailDomain').val();
    	if(!common.isValidMail(email)) {
    		common.showAlert('이메일 형식이 올바르지 않습니다.');
    		return;
    	}
    }
    
    var selectedItems = [];
    selectedItems.push('${refUserInfo.user_id}');
    selectedItems.push(mobile);
    selectedItems.push(phone);
    selectedItems.push(postNumber);
    selectedItems.push(address1);
    selectedItems.push(address2);
    selectedItems.push(email);
    if(window.opener && window.opener.selectuserCallBack != 'undefined') {
		window.opener.selectuserCallBack(selectedItems);
	}
	common.closeWindow();
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


</script>