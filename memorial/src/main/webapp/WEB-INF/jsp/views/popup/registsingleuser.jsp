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

	<!-- 부부형 사용자 1. -->
	<div>
		<p style="font-weight: bold; font-size: 18px; margin-top: 10px; margin-bottom: 10px; display: inline-block;">1인형 사용자</p>
		<input type="checkbox" id="chkOneSelf" style="margin-left: 10px;">
		<label style="font-size: 15px;" for="chkOneSelf">본인</label>
	</div>
	<div class="table-responsive" style="border-top: 1px solid #999;">
        <table id="tblUser1" class="table table-horizon table-condensed" style="border-top: 0;border-bottom: 1px solid #e0e0e0;">
        	<colgroup>
        		<col width="180">
        		<col width="*">
        	</colgroup>
            <tbody>
            	<tr>
            		<th class="required">사용(봉안)자명</th>
            		<td><input name="userName" class="form-control" type="text" style="width: 173px;" autofocus="autofocus"></td>
            	</tr>
            	<tr>
           			<th class="required">관계</th>
            		<td align="left" class="form-inline">
            			<select name="relation" class="form-control" style="width: 80px;">
            				<option value="">선택</option>
            				<c:forEach items="${relationList}" var="relationItem">
            					<c:if test="${not empty relationItem.couple_seq && relationItem.code_seq != 'ONESELF' && relationItem.code_seq != 'BAEUJA'}">
            						<option value="${relationItem.code_seq}" coupleSeq="${relationItem.couple_seq}" gender="${relationItem.gender}">${relationItem.code_name}</option>
            					</c:if>
            				</c:forEach>
            			</select>
            		</td>
           		</tr>
            	<tr>
            		<th class="required">생년월일</th>
            		<td align="left" class="form-inline">
            			<select name="birthYear" class="form-control" style="width: 80px;">
            				<c:forEach items="${yearList}" var="yearItem">
            					<option value="${yearItem.year_val}" <c:if test="${yearItem.year_val == 1970}">selected</c:if>>${yearItem.year_val}</option>
            				</c:forEach>
            			</select>
            			<span>-</span>
            			<select name="birthMonth" class="form-control" style="width: 80px;">
            				<c:forEach begin="1" end="12" varStatus="loop">
            					<c:choose>
            						<c:when test="${loop.index >= 10}"><option value="${loop.index}">${loop.index}</option></c:when>
            						<c:otherwise><option value="${loop.index}">0${loop.index}</option></c:otherwise>
            					</c:choose>
							</c:forEach>
            			</select>
            			<span>-</span>
            			<select name="birthDay" class="form-control" style="width: 80px; margin-right: 15px;">
            				<option value="1">01</option>
            			</select>
            			<span style="font-size: 13px;">성별</span>
            			<select name="gender" class="form-control" style="width: 80px; margin-left: 5px;">
            				<option value="1">남성</option>
            				<option value="2">여성</option>
            			</select>
            		</td>
            	</tr>
            	<tr>
           			<th class="required">주소</th>
           			<td align="left" class="form-inline" >
           				<input name="postNumber" type="text" class="form-control readonlywhite" style="width: 150px;" readonly="readonly" placeholder="우편번호">
           				<button name="postSearch" type="button" class="btn btn-sm btn-primary" onclick="goJusoPopup(this)">검색</button>
    					<select name="autoAddress" class="form-control" style="width: 135px; margin-left: 5px;">
    						<option value="">주소선택</option>
    						<c:forEach var="user" items="${users}">
    							<c:if test="${user.relationType != 'ONESELF'}">
    							<option postNumber="${user.postNumber}" address1="${user.address1}" address2="${user.address2}">
    								${user.userName}
    								<c:choose>
    									<c:when test="${user.refType == 'APPLY_USER'}">(신청자)</c:when>
    									<c:when test="${user.refType == 'AGENT_USER'}">(대리인)</c:when>
    									<c:when test="${user.refType == 'USE_USER'}">(${user.relationTypeName})</c:when>
    								</c:choose>
    							</option>
    							</c:if>
    						</c:forEach>
    					</select>
           				<br>
           				<input name="address1" type="text" class="form-control readonlywhite" readonly="readonly" placeholder="주소" style="width: 100%; margin-top: 5px;"><br>
           				<input name="address2" type="text" class="form-control" placeholder="상세주소" style="width: 100%; margin-top: 5px;">
           			</td>
           		</tr>
           		<tr>
           			<th class="required">연락처</th>
           			<td align="left" class="form-inline">
            			<input name="phone1" type="text" class="form-control" style="width: 80px;" maxlength="4">
            			<span>-</span>
            			<input name="phone2" type="text" class="form-control" style="width: 80px;" maxlength="4">
            			<span>-</span>
            			<input name="phone3" type="text" class="form-control" style="width: 80px;" maxlength="4">
            		</td>
           		</tr>
           		<tr>
           			<th class="required">갈보리교인</th>
           			<td align="left" class="form-inline" >
           				<select name="churchperson" class="form-control" style="width: 80px;">
            				<option value="Y">Y</option>
            				<option value="N">N</option>
            			</select>
           			</td>
           		</tr>
           		<tr>
           			<th class="required">이장대상</th>
           			<td align="left" class="form-inline" >
           				<select name="moveyn" class="form-control" style="width: 80px;">
            				<option value="Y">Y</option>
            				<option value="N" selected="selected">N</option>
            			</select>
           			</td>
           		</tr>
            </tbody>
        </table>
        
        <!-- 본인선택시 표시할 테이블 -->
        <table id="tblApplyUser" class="table table-style table-horizon hidden" style="border-top: 0;">
        	<colgroup>
        		<col width="180">
        		<col width="*">
        	</colgroup>
            <tbody>
            	<c:forEach var="userItem" items="${users}">
            		<c:if test="${userItem.refType == 'APPLY_USER'}">
	            		<tr>
		            		<th>사용(봉안)자명</th>
		            		<td align="left">${userItem.userName}</td>
		            	</tr>
		            	<tr>
		           			<th>관계</th>
		            		<td align="left">본인</td>
		           		</tr>
		            	<tr>
		            		<th>생년월일</th>
		            		<td align="left">
		            			${userItem.birthDate}(
		            			<c:choose>
		            				<c:when test="${userItem.gender == '1'}">남</c:when>
		            				<c:when test="${userItem.gender == '2'}">여</c:when>
		            			</c:choose>
		            			)
		            		</td>
		            	</tr>
		            	<tr>
		           			<th>주소</th>
		           			<td align="left">(${userItem.postNumber}) ${userItem.address1} ${userItem.address2}</td>
		           		</tr>
		           		<tr>
		           			<th>연락처</th>
		           			<td align="left">${userItem.mobile}</td>
		           		</tr>
		           		<tr>
		           			<th>갈보리교인</th>
		           			<td align="left">Y</td>
		           		</tr>
		           		<tr>
		           			<th class="required">이장대상</th>
		           			<td align="left" class="form-inline" >
		           				<select name="moveyn" class="form-control" style="width: 80px;">
		            				<option value="Y">Y</option>
		            				<option value="N" selected="selected">N</option>
		            			</select>
		           			</td>
		           		</tr>
            		</c:if>
            	</c:forEach>
            </tbody>
        </table>
    </div><!-- 부부형 사용자 1. -->
    
    <div class="text-center" style="margin-top: 20px; margin-bottom: 10px;">
		<button type="button" class="btn btn-primary btn-lg" onclick="_confirm();">확인</button>
		<button type="button" class="btn btn-default btn-lg btnClose">닫기</button>
	</div>
	
	<!-- 메인화면에서 입력한 사용자 정보 참조용 -->
	<ul id="userList" style="display: none;">
		<c:forEach var="user" items="${users}">
			<li refType="${user.refType}" userName="${user.userName}" birthDate="${user.birthDate }" gender="${user.gender }"
			churchOfficer="${user.churchOfficer}" diocese="${user.diocese}" relationType="${user.relationType}" relationTypeName="${user.relationTypeName}"  
			mobile="${user.mobile }" phone="${user.phone }" email="${user.email}"
			postNumber="${user.postNumber }" address1="${user.address1 }" address2="${user.address2}" fulladdress="${user.fulladdress}"
			isChurchPerson="${user.isChurchPerson}" isMove="${user.isMove}"
			></li>
		</c:forEach>
	</ul>
	
</div>

<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">

//신청자 정보
var applyUserInfo;

(function() {
	
	var tmp = getRefUserInfo('<%=CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER%>');
	if(tmp && tmp.length > 0) {
		applyUserInfo = tmp[0];
	}
	
	// 수정모드로 호출된 경우 기존 입력데이터 표시
	setEditInfo();
	
	// 본인 체크박스 변경 이벤트
	$('#chkOneSelf').change(chkOneSelfChangeHandler);
	
	// 생년월일의 연도,월 변경이벤트
	$('select[name="birthYear"], select[name="birthMonth"]').change(function(){
		generateDays($(this));
	});
	
	// 관계 변경이벤트
	$('select[name="relation"]').change(relationTypeChangeHandler);
	
	// 주소 상동 select box change 이벤트
	$('select[name="autoAddress"]').change(function() {
		var option = $(this).find('option:selected');
		if(option) {
			var td = $(this).parent('td');
			td.find('input[name="postNumber"]').val(option.attr('postNumber'));
			td.find('input[name="address1"]').val(option.attr('address1'));
			td.find('input[name="address2"]').val(option.attr('address2'));
		}
	});
	
    // 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
    
    $('select[name="birthYear"]').trigger('change');
})();

/**
 * 수정모드로 호출된 경우 기존 입력데이터 표시
 */
function setEditInfo() {
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
    			$('#selOfficer option[value="' + churchOfficer + '"]').attr('selected', 'selected');	
    		}
    		if(diocese) {
    			$('#tiDiocese').val(diocese);
    		}
    	}else if('${popupType}' == '2') {// 대리인
    		if(relationType) {
    			$('#selAgentRealtion option[value="' + relationType + '"]').attr('selected', 'selected');	
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
}

/**
 * 본인 체크박스 변경이벤트 핸들러
 */
function chkOneSelfChangeHandler(e) {
	// 사용(봉안)대상자중 신청자 본인정보가 있는지 체크
	var existOneSelf = false;
	$('#userList li[refType="<%=CalvaryConstants.BUNYANG_REF_TYPE_USE_USER%>"]').each(function(idx) {
		var relationType = $(this).attr('relationType');
		if(${rowIdx} < 0) {// 신규추가
			if(relationType == 'ONESELF') {
				existOneSelf = true;
				return false;
			}
		} else {// 수정
			if(relationType == 'ONESELF' && idx != ${rowIdx}) {
				existOneSelf = true;
				return false;
			}
		}
	});
	if(existOneSelf) {
		common.showAlert('이미 본인으로 등록된 사용(봉안)대상자가 있습니다.');
		$('#chkOneSelf').prop('checked', false);
	} else {
		var checked = $('#chkOneSelf').is(':checked');
		if(checked) {
			$('#tblUser1').addClass('hidden');
			$('#tblApplyUser').removeClass('hidden');	
			$('#tdRelation').text('배우자');
			$('#tdRelation').attr('relationType', 'BAEUJA');
		} else {
			$('#tblApplyUser').addClass('hidden');	
			$('#tblUser1').removeClass('hidden');
			$('#tblUser1 select[name="relation"]').trigger('change');
		}	
	}
}

/**
 * 관계 select box 변경 이벤트 핸들러
 */
function relationTypeChangeHandler(e) {
	var option = $(this).find('option:selected');
	var value = option.val();
	var coupleSeq = option.attr('coupleSeq');
}

/**
 * 확인버튼 클릭 핸들러
 */
function _confirm() {
	
	var userName, birthDate, gender, mobile, mobile2, mobile3, phone, phone1, phone2, phone3, postNumber, address1, address2, fulladdress, officer, officerName, diocese, email, relationType, relationTypeName = '', isChurchPerson = '', isMove = '';
	
	//============================= 사용자1 =============================//
	var elUserName = $('#tblUser1').find('input[name="userName"]');	
	var elBirthYear = $('#tblUser1').find('select[name="birthYear"]');	
	var elBirthMonth = $('#tblUser1').find('select[name="birthMonth"]');	
	var elBirthDay = $('#tblUser1').find('select[name="birthDay"]');	
	var elRelationType = $('#tblUser1').find('select[name="relation"]');
	var elGender = $('#tblUser1').find('select[name="gender"]');	
	var elPostNumber = $('#tblUser1').find('input[name="postNumber"]');	
	var elAddress1 = $('#tblUser1').find('input[name="address1"]');	
	var elAddress2 = $('#tblUser1').find('input[name="address2"]');
	var elPhone1 = $('#tblUser1').find('input[name="phone1"]');	
	var elPhone2 = $('#tblUser1').find('input[name="phone2"]');	
	var elPhone3 = $('#tblUser1').find('input[name="phone3"]');
	var elChurchperson = $('#tblUser1').find('select[name="churchperson"]');
	var elMove = $('#tblUser1').find('select[name="moveyn"]');
	
	var isOneSelf = $('#chkOneSelf').is(":checked");
	
	var selectedItems1 = [];
	// 본인선택이 아닌경우
	if(!isOneSelf) {
		// 성명
		userName = elUserName.val();
		if(!userName) {
			common.showAlert('사용(봉안)자명을 입력해주세요.');
			elUserName.focus();
			return;
		}
		
		// 생년월일
		birthDate = elBirthYear.find('option:selected').text();
		birthDate += '-' + elBirthMonth.find('option:selected').text();
		birthDate += '-' + elBirthDay.find('option:selected').text();
		
		// 성별
		gender = elGender.find('option:selected').val();
		
		// 관계
		relationType = elRelationType.find('option:selected').val();
		relationTypeName = relationType ? elRelationType.find('option:selected').text() : '';
		if(!relationType) {
			common.showAlert('관계를 입력해주세요.');
			elRelationType.focus();
			return;
		}
		
		// 주소
		postNumber = elPostNumber.val();
		address1 = elAddress1.val();
		address2 = elAddress2.val();
		
		if(!postNumber || !address1) {
			common.showAlert('주소를 입력해주세요.');
			return;
		}
		if(!address2) {
			common.showAlert('상세주소를 입력해주세요.');
			elAddress2.focus();
			return;
		}
		fulladdress = '(' + postNumber + ') ' + address1 + ' ' + address2;
		
		// 연락처
		mobile = elPhone1.val();
		mobile2 = elPhone2.val();
		mobile3 = elPhone3.val();
		if(!mobile || !mobile2 || !mobile3) {
			if(!mobile) {
				elPhone1.focus();
			}else if(!mobile2) {
				elPhone2.focus();
			}else if(!mobile3) {
				elPhone3.focus();
			}
			common.showAlert('연락처를 입력해주세요.');
			return;
		}
		mobile = mobile + '-' + mobile2 + '-' + mobile3;
		
		if(!common.isValidMobile(mobile) && !common.isValidPhone(mobile)) {
			common.showAlert('연락처 양식이 올바르지 않습니다.');
			return;
		}
		
		// 교인여부
		isChurchPerson = elChurchperson.find('option:selected').val();
		// 이장여부
		isMove = elMove.find('option:selected').val();
		
		var existDuplicatedUser = false;
		
		// 메인화면에 기등록된 사용자중에 중복된 사람이 있는지 체크
		$('#userList li[refType="<%=CalvaryConstants.BUNYANG_REF_TYPE_USE_USER%>"]').each(function(idx) {
			// 수정모드로 표시된 경우 수정하려고 하는 행은 continue
			if(${rowIdx} >= 0 && ${rowIdx} == idx) {
				return true;
			}
			// 중복체크는 성명,생년월일,성별,연락처로
			if(userName == $(this).attr('userName') 
					&& birthDate == $(this).attr('birthDate')
					&& gender == $(this).attr('gender')
					&& mobile == $(this).attr('mobile')
			) {
				existDuplicatedUser = true;
				return false;
			}
		});
		
		if(existDuplicatedUser) {
			common.showAlert('입력하신 사용자와 성명,생년월일,성별,연락처가 동일한 기등록 사용자가 있습니다.');
			return;
		}
		
	    selectedItems1.push(userName);
	    selectedItems1.push(birthDate);
	    selectedItems1.push(gender);
	    selectedItems1.push(mobile);
	    selectedItems1.push(phone);
	    selectedItems1.push(postNumber);
	    selectedItems1.push(address1);
	    selectedItems1.push(address2);
	    selectedItems1.push(fulladdress);
	    selectedItems1.push(officer);
	    selectedItems1.push(officerName);
	    selectedItems1.push(diocese);
	    selectedItems1.push(email);
	    selectedItems1.push(relationType);
	    selectedItems1.push(relationTypeName);
	    selectedItems1.push(isChurchPerson);
	    selectedItems1.push(isMove);
	} else {
		// 본인등록인 경우는 신청자 정보로
		if(applyUserInfo) {
			isMove = $('#tblApplyUser').find('select[name="moveyn"]').find('option:selected').val();
			selectedItems1.push(applyUserInfo.userName);
		    selectedItems1.push(applyUserInfo.birthDate);
		    selectedItems1.push(applyUserInfo.gender);
		    selectedItems1.push(applyUserInfo.mobile);
		    selectedItems1.push(applyUserInfo.phone);
		    selectedItems1.push(applyUserInfo.postNumber);
		    selectedItems1.push(applyUserInfo.address1);
		    selectedItems1.push(applyUserInfo.address2);
		    selectedItems1.push(applyUserInfo.fulladdress);
		    selectedItems1.push(applyUserInfo.officer);
		    selectedItems1.push(applyUserInfo.officerName);
		    selectedItems1.push(applyUserInfo.diocese);
		    selectedItems1.push(applyUserInfo.email);
		    selectedItems1.push('ONESELF');
		    selectedItems1.push('본인');
			selectedItems1.push('Y');
			selectedItems1.push(isMove);
		}else {
			common.showAlert('신청자 정보가 없어서 본인 등록이 불가합니다.');
			return;
		}
	}
    
    var idx = 0;
    var userVo;
    
    if(isOneSelf) {
    	if(window.opener && window.opener.selectuserCallBack != 'undefined') {
			window.opener.selectuserCallBack(selectedItems1, isOneSelf);
		}
		common.closeWindow();
    } else {
    	userVo = {};
        userVo['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_USE_USER%>';
        userVo['userName'] = selectedItems1[idx++];
        userVo['birthDate'] = selectedItems1[idx++];
        userVo['gender'] = selectedItems1[idx++];
        userVo['mobile'] = selectedItems1[idx++];
        
        common.ajax({
    		url:"${contextPath}/popup/checkduplicateduser", 
    		data:userVo,
    		success: function(result) {
    			if(result && result.duplicatedUser) {
    				common.showAlert('입력하신 사용자와 동일한 사용자가 있습니다.');
    			}else {
    				if(window.opener && window.opener.selectuserCallBack != 'undefined') {
	        			window.opener.selectuserCallBack(selectedItems1, isOneSelf);
	        		}
	        		common.closeWindow();
    			}
    		},
    		error: function(xhr, status, message) {
    			alert(message);
    		}
    	});
    }
}

/**
 * 도로명주소 Open API 팝업호출
 */
function goJusoPopup(btn) {
	var winoption = {width:570, height:420};
	common.openWindow("${contextPath}/popup/jusopopup.jsp", "jusopopup", winoption, {});
	window.jusoCallBack = function(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn , detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo){
		var td = $(btn).parent('td');
		td.find('input[name="postNumber"]').val(zipNo);
		td.find('input[name="address1"]').val(roadAddrPart1 + roadAddrPart2);
		td.find('input[name="address2"]').val(addrDetail);
		td.find('input[name="address2"]').focus();
	};
}

/**
 * 연월에 해당하는 날짜 선택용 select box 생성
 */
function generateDays(el) {
	var td = $(el).parent('td');
	var year = td.find('select[name="birthYear"] option:selected').val();
	var month = td.find('select[name="birthMonth"] option:selected').val();
	var firstDay = 1;
	var lastDay = new Date(year, month, 0).getDate();
	var options = "";
	for(var i = firstDay; i <= lastDay; i++) {
		options += '<option value="' + i + '">' + (i >= 10 ? i : '0'+i) + '</option>';
	}
	var selectedDay = td.find('select[name="birthDay"] option:selected').val();
	
	td.find('select[name="birthDay"]').html(options);
	
	if(selectedDay > 0 && selectedDay <= lastDay) {
		td.find('select[name="birthDay"] option[value=' + selectedDay + ']').attr('selected', 'selected');
	}
}

/**
 * 사용자 정보를 화면에 표시
 */
function setUserInfo(userInfo, tbl) {
	if(userInfo) {
		var userName = userInfo.userName;
		var birthDate = userInfo.birthDate;
    	var gender = userInfo.gender;
    	var churchOfficer = userInfo.churchOfficer;
    	var diocese = userInfo.diocese;
    	var relationType = userInfo.relationType;
    	var mobile = userInfo.mobile;
    	var phone = userInfo.phone;
    	var postNumber = userInfo.postNumber;
    	var address1 = userInfo.address1;
    	var address2 = userInfo.address2;
    	var email = userInfo.email;
    	var isChurchPerson = userInfo.isChurchPerson;
    	var isMove = userInfo.isMove;
    	var splited;
		$(tbl).find('input[name="userName"]').val(userName);
		$(tbl).find('select[name="relation"] option[value="' + relationType + '"]').attr('selected', 'selected');
		$(tbl).find('select[name="relation"]').trigger('change');
		if(birthDate) {
    		splited = birthDate.split('-');
    		if(splited && splited.length == 3) {
    			$(tbl).find('select[name="birthYear"] option[value=' + splited[0] + ']').attr('selected', 'selected');
    			$(tbl).find('select[name="birthMonth"] option[value=' + parseInt(splited[1]) + ']').attr('selected', 'selected');
    			$(tbl).find('select[name="birthYear"]').trigger('change');
    			$(tbl).find('select[name="birthDay"] option[value=' + parseInt(splited[2]) + ']').attr('selected', 'selected');
    		}
    	}
		$(tbl).find('select[name="gender"] option[value="' + gender + '"]').attr('selected', 'selected');
		if(postNumber) {
			$(tbl).find('input[name="postNumber"]').val(postNumber);
    	}
    	if(address1) {
    		$(tbl).find('input[name="address1"]').val(address1);
    	}
    	if(address2) {
    		$(tbl).find('input[name="address2"]').val(address2);
    	}
		if(mobile) {
    		splited = mobile.split('-');
    		if(splited && splited.length == 3) {
    			$(tbl).find('input[name="phone1"]').val(splited[0]);
    			$(tbl).find('input[name="phone2"]').val(splited[1]);
    			$(tbl).find('input[name="phone3"]').val(splited[2]);
    		}
    	}
		if(!mobile && phone) {
    		splited = phone.split('-');
    		if(splited && splited.length == 3) {
    			$(tbl).find('input[name="phone1"]').val(splited[0]);
    			$(tbl).find('input[name="phone2"]').val(splited[1]);
    			$(tbl).find('input[name="phone3"]').val(splited[2]);
    		}
    	}
		$(tbl).find('select[name="churchperson"] option[value="' + isChurchPerson + '"]').attr('selected', 'selected');
		$(tbl).find('select[name="moveyn"] option[value="' + isMove + '"]').attr('selected', 'selected');
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
		userInfo.fulladdress = $(this).attr('fulladdress');
		userInfo.email = $(this).attr('email');
		userInfo.refType = $(this).attr('refType');
		userInfo.isChurchPerson = $(this).attr('isChurchPerson');
		userInfo.isMove = $(this).attr('isMove');
		userInfoes.push(userInfo);
	});
	return userInfoes;
}

</script>