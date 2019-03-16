<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<form id="frm" method="post">
</form>

<!-- 로그인 컨텐츠 -->
<div class="contents login">

    <!-- sub-title -->
    <div class="sub-title">
        <h1>회원가입</h1>
    </div>

    <!-- breadcrumb -->
    <div class="breadcrumb_wrap">
        <div class="wrap">
            <ul class="breadcrumb">
                <li class="breadcrumb-item">홈</li>
                <li class="breadcrumb-item">회원가입</li>
            </ul>
        </div>
    </div>

    <!-- 중간 컨텐츠 -->
    <div class="container-fluid section" style="margin-top: 10px;">
        <div class="wrap">
            <div class="row">
                <div class="col-sm-8 col-sm-offset-2 col-lg-6 col-lg-offset-3">

                    <form class="form-horizontal">
                        <div class="form-style">
                            <div class="form-group">
                                <div class="row">
                                    <label for="userId" class="col-sm-2 control-label required">아이디</label>
                                    <div class="col-sm-10 form-inline">
                                        <input type="text" class="form-control" id="userId" autofocus="autofocus" style="width: 192px;">
                                        <button id="btnConfirmId" type="button" class="btn btn-primary btn-md" onclick="checkDuplicateUserId()">확인</button>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <label for="password1" class="col-sm-2 control-label required">비밀번호</label>
                                    <div class="col-sm-10 form-inline">
                                        <input type="password" class="form-control" autocomplete="off" id="password1" placeholder="비밀번호" style="width: 192px;">
                                        <input type="password" class="form-control" autocomplete="off" id="password2" placeholder="비밀번호 확인" style="width: 192px;"><br>
                                        <span style="font-size: 12px; color: #337ab7;">* 영문/숫자/특수문자를 사용하여 6자리 이상</span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <label for="userName" class="col-sm-2 control-label required">성명</label>
                                    <div class="col-sm-10 form-inline">
                                        <input type="text" class="form-control" id="userName" style="width: 192px;">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <label for="birthYear" class="col-sm-2 control-label required">생년월일</label>
                                    <div class="col-sm-10 form-inline">
                                        <select class="form-control" id="birthYear" style="width: 90px;">
                                        <c:forEach items="${yearList}" var="yearItem">
                                    		<option value="${yearItem.year_val}" <c:if test="${yearItem.year_val == 1970}">selected</c:if>>${yearItem.year_val}</option>
                                		</c:forEach>
                                        </select>
                                        <span>-</span>
                                        <select class="form-control" id="birthMonth" style="width: 90px;">
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
                                        <select class="form-control" id="birthDate" style="width: 90px;">
                                        	<option value="1">01</option>
                                        </select>
                                        <span style="font-size: 13px;">성별</span>
			                            <select id="selGender" class="form-control" style="width: 80px; margin-left: 5px;">
			                                <option value="1">남성</option>
			                                <option value="2">여성</option>
			                            </select>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <label for="churchOfficer" class="col-sm-2 control-label required">직분/교구</label>
                                    <div class="col-sm-10 form-inline">
                                        <select class="form-control" id="churchOfficer" style="width: 90px;">
                                        <c:forEach items="${officerList}" var="officer">
		                                    <option value="${officer.code_seq}">${officer.code_name}</option>
		                                </c:forEach>
                                        </select>
                                        <span> / </span>
                                        <input type="text" class="form-control" id="diocese" style="width: 90px;" placeholder="교구입력">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <label for="mobile1" class="col-sm-2 control-label required">휴대전화</label>
                                    <div class="col-sm-10 form-inline">
                                        <select class="form-control" id="mobile1" style="width: 90px;">
	                                        <option>010</option>
			                                <option>011</option>
			                                <option>016</option>
			                                <option>017</option>
			                                <option>018</option>
			                                <option>019</option>
                                        </select>
                                        <span>-</span>
                                        <input type="text" class="form-control" id="mobile2" style="width: 90px;">
                                        <span>-</span>
                                        <input type="text" class="form-control" id="mobile3" style="width: 90px;">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <label for="phone1" class="col-sm-2 control-label">전화</label>
                                    <div class="col-sm-10 form-inline">
                                        <input type="text" class="form-control" id="phone1" style="width: 90px;">
                                        <span>-</span>
                                        <input type="text" class="form-control" id="phone2" style="width: 90px;">
                                        <span>-</span>
                                        <input type="text" class="form-control" id="phone3" style="width: 90px;">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <label class="col-sm-2 control-label required">주소</label>
                                    <div class="col-sm-10 form-inline">
                                        <input readonly="readonly" type="text" class="form-control readonlywhite" id="postNumber" style="width: 136px;" placeholder="우편번호">
                                        <button type="button" class="btn btn-primary btn-md" onclick="goJusoPopup(this)">검색</button><br>
                                        <input readonly="readonly" type="text" class="form-control readonlywhite" id="address1" style="width: 520px; margin-top: 4px;" placeholder="주소"><br>
                                        <input type="text" class="form-control" id="address2" style="width: 520px; margin-top: 4px;" placeholder="상세주소">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <label for="emailAddr" class="col-sm-2 control-label">이메일</label>
                                    <div class="col-sm-10 form-inline">
                                        <input id="emailAddr" type="text" class="form-control" style="width: 135px;">
			                            <span>@</span>
			                            <input id="emailDomain" type="text" class="form-control readonlywhite" style="width: 134px;">
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
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-30 text-center">
                            <button type="button" class="btn btn-primary btn-lg" onclick="saveUserInfo()">회원가입</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">

var checkedUserId;

// init 함수
(function(){
	// 생년월일의 연도,월 변경이벤트
	$('#birthYear, #birthMonth').change(function(){
		generateDays();
	});
	
	// 이메일 도메인 select box 변경이벤트
	$('#selEmailDomain').change(function(){
		var selectedVal = $(this).find('option:selected').val();
		$('#emailDomain').val(selectedVal);
		if(selectedVal) {
			$('#emailDomain').attr('readonly', true);
		} else {
			$('#emailDomain').attr('readonly', false);
		}
	});
	
	$('#userId').keyup(function(e) {
		if (e.keyCode == 13) {
			$('#btnConfirmId').trigger('click');
		}
	});
	
	$('#birthYear').trigger('change');
    $('#selEmailDomain').trigger('change');
	
})();

/**
 * 연월에 해당하는 날짜 선택용 select box 생성
 */
function generateDays()
{
	var year = $('#birthYear option:selected').val();
	var month = $('#birthMonth option:selected').val();
	var firstDay = 1;
	var lastDay = new Date(year, month, 0).getDate();
	var options = "";
	for(var i = firstDay; i <= lastDay; i++) {
		options += '<option value="' + i + '">' + (i >= 10 ? i : '0'+i) + '</option>';
	}
	var selectedDay = $('#birthDate option:selected').val();
	
	$('#birthDate').html(options);
	
	if(selectedDay > 0 && selectedDay <= lastDay) {
		$('#birthDate option[value=' + selectedDay + ']').attr('selected', 'selected');
	}
}

/**
 * 도로명주소 Open API 팝업호출
 */
function goJusoPopup(btn){
	new daum.Postcode({
        oncomplete: function(data) {
        	var postNumber = data.zonecode;
        	var address1 = data.address;
        	if(data.buildingName) {
        		address1 += '(' + data.buildingName + ')';
        	}
        	$('#postNumber').val(postNumber);
        	$('#address1').val(address1);
        	$('#address2').focus();
        }
    }).open();
}

/**
 * 아이디 중복확인
 */
function checkDuplicateUserId() {
	var userId = $('#userId').val();
	if(!userId) {
		common.showAlert('아이디를 입력해주세요.');
		$('#userId').focus();
		return;
	}
	common.ajax({
		url:"${contextPath}/account/checkDuplicateUserId", 
		dataType:'text',
		data:{userId:userId},
		success: function(result) {
			if(result) {
				common.showAlert('이미 사용중인 아이디입니다.');
				$('#userId').focus();
			} else {
				checkedUserId = userId;
				common.showAlert('사용 가능한 아이디입니다.');
				$('#password1').focus();
			}
		}
	});
}

/**
 * 사용자 정보 저장
 */
function saveUserInfo() {
	var userId, pwd1, pwd2, userName, birthDate, gender, mobile, mobile2, mobile3, phone, phone1, phone2, phone3, postNumber, address1, address2, fulladdress, officer, officerName, diocese, email, relationType, relationTypeName;
	
	userId = $('#userId').val();
	if(!userId) {
		common.showAlert('아이디를 입력해주세요.');
		$('#userId').focus();
		return;
	}
	
	if(userId != checkedUserId) {
		common.showAlert('아이디 중복확인을 해주세요.');
		return;
	}
	
	pwd1 = $('#password1').val();
	pwd2 = $('#password2').val();
	var pwdRegExp = /[^a-z0-9\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/;
	
	if(!pwd1) {
		common.showAlert('비밀번호를 입력해주세요.');
		$('#password1').focus();
		return;
	}
	
	if(pwdRegExp.test(pwd1)) {
		common.showAlert('비밀번호는 영문,숫자,특수문자만 입력가능합니다.');
		$('#password1').focus();
		return;
	}
	
	if(pwd1.length < 6) {
		common.showAlert('6자리 이상 비밀번호를 입력해주세요.');
		$('#password1').focus();
		return;
	}
	
	if(!pwd2) {
		common.showAlert('비밀번호를 확인해주세요.');
		$('#password2').focus();
		return;
	}
	
	if(pwd1 != pwd2) {
		common.showAlert('비밀번호가 일치하지 않습니다.');
		$('#password2').focus();
		return;
	}
	
	// 성명
	userName = $('#userName').val();
	if(!userName) {
		common.showAlert('성명을 입력해주세요.');
		$('#userName').focus();
		return;
	}
	
	// 생년월일
	birthDate = $('#birthYear option:selected').text();
	birthDate += '-' + $('#birthMonth option:selected').text();
	birthDate += '-' + $('#birthDate option:selected').text();
	
	// 성별
	gender = $('#selGender option:selected').val();
	
	// 직분
	officer = $('#churchOfficer option:selected').val();
	if(!officer) {
		common.showAlert('직분을 선택해주세요.');
		$('#churchOfficer').focus();
		return;
	}
	// 교구
	diocese = $('#diocese').val();
	if(!diocese) {
		common.showAlert('교구를 입력해주세요.');
		$('#diocese').focus();
		return;
	}
	
	// 휴대전화
	mobile = $('#mobile1 option:selected').text();
	mobile2 = $('#mobile2').val();
	mobile3 = $('#mobile3').val();
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
	phone1 = $('#phone1').val();
	phone2 = $('#phone2').val();
	phone3 = $('#phone3').val();
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
	
    email = $('#emailAddr').val();
    if(email) {
    	email += '@' + $('#emailDomain').val();
    	if(!common.isValidMail(email)) {
    		common.showAlert('이메일 형식이 올바르지 않습니다.');
    		return;
    	}
    }
    
    var userVo = {};
    userVo['userId'] = userId;
    userVo['password'] = pwd1;
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
		url:"${contextPath}/account/saveJoinInfo", 
		data:JSON.stringify(userVo),
		contentType: 'application/json',
		success: function(result) {
			if(result && result.result) {
				common.showAlert("회원가입이 완료되었습니다.");
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/account/login";
				frm.submit();
			}
		}
	});
}
</script>