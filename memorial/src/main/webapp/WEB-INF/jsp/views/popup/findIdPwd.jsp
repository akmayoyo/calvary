<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="poptitle">
    <strong>
    <c:choose>
    	<c:when test="${findType=='id'}">아이디 찾기</c:when>
    	<c:when test="${findType=='pwd'}">비밀번호 재설정</c:when>
    </c:choose>
    </strong>
    <button type="button" class="close btnClose" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
</div>

<div class="content" style="padding: 15px 15px;">
	
    <ul class="nav nav-tabs">
        <li <c:if test="${findType=='id'}">class="active"</c:if>><a href="${contextPath}/popup/findIdPwd?findType=id">아이디 찾기</a></li>
        <li <c:if test="${findType=='pwd'}">class="active"</c:if>><a href="${contextPath}/popup/findIdPwd?findType=pwd">비밀번호 재설정</a></li>
    </ul>

    <div class="tab-content">
    
    	<c:choose>
    	
    		<c:when test="${findType=='id'}">
    		<!-- 아이디 찾기 탭 -->
	        <div id="divInputAuth" class="tab-pane fade in active" style="margin-top: 20px;">
	            <div class="form-group" style="margin-bottom: 5px;">
	                <input type="text" class="form-control input-lg" id="userName" placeholder="성명">
	            </div>
	            <div class="input-group" style="margin-bottom: 5px;">
				  <input type="text" id="mobile" class="form-control input-lg" placeholder="휴대폰 (-제외)" data-mask="000-0000-0000">
					<span class="input-group-btn">
						<button id="btnSendAuthNo" class="btn btn-primary btn-lg disabled" type="button" onclick="_sendAuthNo()">인증번호</button>
				  	</span>
				</div>
	            <div class="form-group" style="margin-bottom: 20px;">
	                <input type="text" class="form-control input-lg" readonly="readonly" id="authno" placeholder="인증번호 6자리입력" data-mask="000000">
	            </div>
	            <button class="btn btn-lg btn-primary btn-block" type="button" onclick="_checkAuthAndFindId()">아이디 찾기</button>
	        </div>
	        
	        <div id="divAuthResult" style="display:none; text-align: center; margin-top: 45px;">
	        	<span id="resultId" style="font-size: 20px;"></span><br><br><br>
	        	<button class="btn btn-lg btn-default btnClose" type="button">닫기</button>
	        </div>
    		</c:when>
    		
    		<c:when test="${findType=='pwd'}">
    		<!-- 비밀번호 재설정 탭 -->
	        <div id="divInputId" class="tab-pane fade in active" style="margin-top: 20px;">
	        	<div class="form-group">
	                <span style="color: #337ab7;">비밀번호를 재설정할 아이디를 입력해주세요.</span>
	            </div>
				<div class="form-group" style="margin-bottom: 20px;">
	                <input type="text" class="form-control input-lg" id="userId" autofocus="autofocus">
	            </div>
	            <button id="btnCheckUserId" class="btn btn-lg btn-primary btn-block" type="button" onclick="_checkUserId()">확인</button>
	        </div>
	        
	        <div id="divInputAuth" class="tab-pane fade in active" style="margin-top: 20px; display: none;">
	            <div class="form-group" style="margin-bottom: 5px;">
	                <input type="text" class="form-control input-lg" id="userName" placeholder="성명">
	            </div>
	            <div class="input-group" style="margin-bottom: 5px;">
				  <input type="text" id="mobile" class="form-control input-lg" placeholder="휴대폰 (-제외)" data-mask="000-0000-0000">
					<span class="input-group-btn">
						<button id="btnSendAuthNo" class="btn btn-primary btn-lg disabled" type="button" onclick="_sendAuthNo()">인증번호</button>
				  	</span>
				</div>
	            <div class="form-group" style="margin-bottom: 20px;">
	                <input type="text" class="form-control input-lg" readonly="readonly" id="authno" placeholder="인증번호 6자리입력" data-mask="000000">
	            </div>
	            <button class="btn btn-lg btn-primary btn-block" type="button" onclick="_checkAuthAndFindPwd()">비밀번호 재설정</button>
	        </div>
	        
	        <div id="divResetPwd" class="tab-pane fade in active" style="margin-top: 20px; display: none;">
	            <div class="form-group" style="margin-bottom: 5px;">
	                <input type="password" class="form-control input-lg" id="password1" placeholder="새 비밀번호">
	            </div>
	            <div class="form-group" style="margin-bottom: 5px;">
	                <input type="password" class="form-control input-lg" id="password2" placeholder="새 비밀번호 확인">
	            </div>
	            <div class="form-group" style="margin-bottom: 20px;">
	                <span style="color: #337ab7;">* 영문/숫자/특수문자를 사용하여 6자리 이상</span>
	            </div>
	            <button id="btnResetPwd" class="btn btn-lg btn-primary btn-block" type="button" onclick="_resetPwd()">비밀번호 재설정</button>
	        </div>
    		</c:when>
    		
    	</c:choose>
        
    </div>
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.mask.js"></script>
<script type="text/javascript">

var checekdUserId;
var checkedUserName;
var checkedMobile;

(function() {
	
	$('#userName, #mobile').keyup(function(e) {
		var userName = $('#userName').val();
		var mobile = $('#mobile').val();
		if(userName && common.isValidMobile(mobile)) {
			$('#btnSendAuthNo').removeClass('disabled');
			if (e.keyCode == 13) {
				$('#btnSendAuthNo').trigger('click');
			}
		} else {
			$('#btnSendAuthNo').addClass('disabled');
		}
	});
	
	$('#userId').keyup(function(e) {
		if (e.keyCode == 13) {
			$('#btnCheckUserId').trigger('click');
		}
	});
	
	$('#password1, #password2').keyup(function(e) {
		if (e.keyCode == 13) {
			$('#btnResetPwd').trigger('click');
		}
	});
	
    // 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
})();

/**
 * 인증번호발송
 */
function _sendAuthNo() {
	var userId = '${findType}' == 'id' ? '' : checekdUserId;
	var userName = $('#userName').val();
	var mobile = $('#mobile').val();
	common.ajax({
		url:"${contextPath}/account/sendAuthNo", 
		data:{userId:userId, userName:userName, mobile:mobile},
		success: function(result) {
			if(result > 0) {
				checkedUserName = userName;
				checkedMobile = mobile;
				$("#authno").attr("readonly", false);
				common.showAlert('인증번호를 발송하였습니다.\n인증번호가 오지 않는 경우, 입력한 성명/휴대폰번호를 확인 후 다시 요청해주세요.');
				$("#authno").focus();
			} else {
				common.showAlert('해당 정보로 등록된 사용자가 없습니다.');
			}
		}
	});
}

/**
 * 인증번호 체크후 아이디 찾기
 */
function _checkAuthAndFindId() {
	var authNo = $("#authno").val();
	if(!authNo || authNo.length != 6) {
		common.showAlert('6자리 인증번호를 올바르게 입력해주세요.');
		$("#authno").focus();
		return;
	}
	common.ajax({
		url:"${contextPath}/account/checkAuthAndFindId", 
		dataType:'text',
		data:{userName:checkedUserName, mobile:checkedMobile, authNo:authNo},
		success: function(result) {
			if(result) {
				$('#divInputAuth').hide();
				$('#resultId').text('아이디 : ' + result);
				$('#divAuthResult').show();
			} else {
				common.showAlert('인증번호가 올바르지 않습니다.');
			}
		}
	});
}

/*
 * 비밀번호 재설정 아이디 확인
 */
function _checkUserId() {
	var userId = $("#userId").val();
	if(!userId) {
		common.showAlert('아이디를 입력하세요.');
		return;
	}
	common.ajax({
		url:"${contextPath}/account/checkUserId", 
		dataType:'text',
		data:{userId:userId},
		success: function(result) {
			if(result) {
				checekdUserId = userId;
				$('#divInputId').hide();
				$('#divInputAuth').show();
			} else {
				common.showAlert('해당 아이디로 등록된 정보가 없습니다.');
			}
		}
	});
}

/**
 * 인증번호 체크후 비밀번호 재설정
 */
function _checkAuthAndFindPwd() {
	var authNo = $("#authno").val();
	if(!authNo || authNo.length != 6) {
		common.showAlert('6자리 인증번호를 올바르게 입력해주세요.');
		$("#authno").focus();
		return;
	}
	common.ajax({
		url:"${contextPath}/account/checkAuthAndFindPwd",
		dataType:'text',
		data:{userId:checekdUserId, userName:checkedUserName, mobile:checkedMobile, authNo:authNo},
		success: function(result) {
			if(result) {
				$('#divInputAuth').hide();
				$('#divResetPwd').show();
			} else {
				common.showAlert('인증번호가 올바르지 않습니다.');
			}
		}
	});
}

/**
 * 비밀번호 재설정
 */
function _resetPwd() {
	var pwd1 = $('#password1').val();
	var pwd2 = $('#password2').val();
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
	
	common.ajax({
		url:"${contextPath}/account/resetPwd", 
		data:{userId:checekdUserId, password:pwd1},
		success: function(result) {
			if(result > 0) {
				common.showAlert('비밀번호가 정상적으로 변경되었습니다.');
				common.closeWindow();
			} else {
				common.showAlert('비밀번호 변경에 실패하였습니다.');
			}
		}
	});
	
}


</script>