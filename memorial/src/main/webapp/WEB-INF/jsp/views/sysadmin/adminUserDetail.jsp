<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
    <input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
    <input type="hidden" id="searchVal" name="searchVal" value="${searchVo.searchVal}">
    <input type="hidden" id="searchKey" name="searchKey" value="${searchVo.searchKey}">
    <input type="hidden" id="userId" name="userId" value="${userId}">

    <!-- 그리드 샘플 -->
    <div class="col-md-9">
        <div>
            <h4>사용자 정보</h4>
        </div>
        <div class="table-responsive" style="border-top: 1px solid #999;">
            <table class="table table-style table-horizon">
                <colgroup>
                    <col width="180">
                    <col width="*">
                </colgroup>
                <tbody>
                    <tr>
                        <th>아이디</th>
                        <td align="left">${userInfo.user_id}</td>
                    </tr>
                    <tr>
                        <th class="required">성명</th>
                        <td><input id="tiUserName" class="form-control" style="width: 600px;" value="${userInfo.user_name}"></td>
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
                                        <c:when test="${loop.index >= 10}">
                                            <option value="${loop.index}">${loop.index}</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="${loop.index}">0${loop.index}</option>
                                        </c:otherwise>
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
                    <tr>
                        <th class="required">직분</th>
                        <td align="left" class="form-inline">
                            <select id="selOfficer" class="form-control" style="width: 80px;">
                                <option value="">선택</option>
                                <c:forEach items="${officerList}" var="officer">
                                    <option value="${officer.code_seq}">${officer.code_name}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="required">교구</th>
                        <td align="left" class="form-inline">
                            <input id="tiDiocese" type="text" class="form-control" style="width: 80px;">
                        </td>
                    </tr>
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
            			<th>전화</th>
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
                        <td align="left" class="form-inline">
                            <input id="postNumber" type="text" class="form-control readonlywhite" style="width: 150px;" readonly="readonly" placeholder="우편번호">
                            <button type="button" class="btn btn-sm btn-primary" onclick="goJusoPopup(this)">검색</button><br>
                            <input id="address1" type="text" class="form-control readonlywhite" readonly="readonly" placeholder="주소" style="width: 600px; margin-top: 5px;"><br>
                            <input id="address2" type="text" class="form-control" placeholder="상세주소" style="width: 600px; margin-top: 5px;">
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
            <button type="button" class="btn btn-primary btn-lg" onclick="saveUserInfo()">저장</button>
            <button type="button" class="btn btn-danger btn-lg" onclick="deleteUserInfo()">삭제</button>
            <button type="button" class="btn btn-default btn-lg" onclick="goToList()">목록</button>
        </div>

    </div>
</form>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function(){
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
	
	displayUserInfo();
})();

/**
 * 사용자정보 표시
 */
function displayUserInfo() {
	var birthDate = '${userInfo.birth_date}';
	var gender = '${userInfo.gender}';
	var churchOfficer = '${userInfo.church_officer}';
	var diocese = '${userInfo.diocese}';
	var mobile = '${userInfo.mobile}';
	var phone = '${userInfo.phone}';
	var postNumber = '${userInfo.post_number}';
	var address1 = '${userInfo.address1}';
	var address2 = '${userInfo.address2}';
	var email = '${userInfo.email}';
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
	if(gender) {
		$('#selGender option[value=' + gender + ']').attr('selected', 'selected');
	}
	if(churchOfficer) {
		$('#selOfficer option[value=' + churchOfficer + ']').attr('selected', 'selected');	
	}	
	$('#tiDiocese').val(diocese);
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
		$('#postNumber').val(postNumber);
	}
	if(address1) {
		$('#address1').val(address1);
	}
	if(address2) {
		$('#address2').val(address2);
	}
	if(email) {
		splited = email.split('@');
		if(splited && splited.length == 2) {
        	$('#tiEmailAddr').val(splited[0]);
        	$('#tiEmailDomain').val(splited[1]);
        	$('#selEmailDomain option[value="' + splited[1] + '"]').attr('selected', 'selected');
		}
	}
	$('#selBirthYear').trigger('change');
    $('#selEmailDomain').trigger('change');
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
        	td.find('#postNumber').val(postNumber);
        	td.find('#address1').val(address1);
        	td.find('#address2').focus();
        }
    }).open();
}

/**
 * 사용자 정보 저장
 */
function saveUserInfo() {
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
	
	// 직분
	officer = $('#selOfficer option:selected').val();
	if(!officer) {
		common.showAlert('직분을 선택해주세요.');
		$('#selOfficer').focus();
		return;
	}
	// 교구
	diocese = $('#tiDiocese').val();
	if(!diocese) {
		common.showAlert('교구를 입력해주세요.');
		$('#tiDiocese').focus();
		return;
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
	if(phone1 || phone2 || phone3) {
		phone = phone1 + '-' + phone2 + '-' + phone3;	
	}
	if(phone && !common.isValidPhone(phone)) {
		common.showAlert('전화 양식이 올바르지 않습니다.');
		return;
	}
	
	// 주소
	postNumber = $('#postNumber').val();
	address1 = $('#address1').val();
	address2 = $('#address2').val();
	
	if(!postNumber || !address1) {
		common.showAlert('주소를 입력해주세요.');
		return;
	}
	if(!address2) {
		common.showAlert('상세주소를 입력해주세요.');
		$('#address2').focus();
		return;
	}
	
    email = $('#tiEmailAddr').val();
    if(email) {
    	email += '@' + $('#tiEmailDomain').val();
    	if(!common.isValidMail(email)) {
    		common.showAlert('이메일 형식이 올바르지 않습니다.');
    		return;
    	}
    }
	
    var userVo = {};
    userVo['userId'] = '${userId}';
    userVo['userName'] = userName;
    userVo['birthDate'] = birthDate;
    userVo['gender'] = gender;
    userVo['email'] = email;
    userVo['mobile'] = mobile;
    userVo['phone'] = phone;
    userVo['postNumber'] = postNumber;
    userVo['address1'] = address1;
    userVo['address2'] = address2;
    userVo['churchOfficer'] = officer;
    userVo['diocese'] = diocese;
	
	// 저장 호출
	common.ajax({
		url:"${contextPath}/sysadmin/saveAdminUserInfo", 
		data:JSON.stringify(userVo),
		contentType: 'application/json',
		success: function(result) {
			if(result && result.result) {
				common.showAlert("저장되었습니다.");
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/sysadmin/adminUserDetail";
				frm.submit();
			}
		}
	});
}

/**
 * 사용자 승인
 */
function approvalUserInfo() {
	if(confirm('해당 사용자를 승인하시겠습니까?')) {
		common.ajax({
			url:"${contextPath}/sysadmin/approvalAdminUser", 
			data:{userId:'${userId}'},
			success: function(result) {
				if(result && result.result) {
					common.showAlert("승인되었습니다.");
					var frm = document.getElementById("frm");
					frm.action = "${contextPath}/sysadmin/adminUserDetail";
					frm.submit();
				}
			}
		});
	}
}

/**
 * 사용자 삭제
 */
function deleteUserInfo() {
	if(confirm('해당 사용자를 삭제하시겠습니까?')) {
		common.ajax({
			url:"${contextPath}/sysadmin/deleteAdminUser", 
			data:{userId:'${userId}'},
			success: function(result) {
				if(result && result.result) {
					common.showAlert("삭제되었습니다.");
					goToList();
				}
			}
		});
	}
}

/**
 * 목록 클릭
 */
function goToList() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/sysadmin/adminUserMgmt";
	frm.submit();
}

</script>