<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<c:choose>
	<c:when test="${not empty requestUrl}">
		<c:set var="requestUrl" value="${requestUrl}"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="requestUrl" value="/"></c:set>
	</c:otherwise>
</c:choose>

<form id="frm" method="post">
</form>

<!-- 로그인 컨텐츠 -->
<div class="contents login">

	<!-- sub-title -->
	<div class="sub-title">
		<h1>로그인</h1>
	</div>

	<!-- breadcrumb -->
	<div class="breadcrumb_wrap">
		<div class="wrap">
			<ul class="breadcrumb">
				<li class="breadcrumb-item">홈</li>
				<li class="breadcrumb-item">로그인</li>
			</ul>
		</div>
	</div>
	
	<!-- 중간 컨텐츠 -->
	<div class="container-fluid section" style="margin-top: 50px;">
		<div class="wrap">
			<div class="row">
				<div class="col-sm-8 col-sm-offset-2 col-lg-6 col-lg-offset-3">

					<div class="bx-round">
						<form class="mb-20">

							<div class="form-group">
								<label class="sr-only" for="inputId">아이디</label>
								<input id="tiUserId" type="text" class="form-control input-lg font-15" id="inputid" placeholder="아이디" required="">
							</div>

							<div class="form-group">
								<label class="sr-only" for="inputPw">비밀번호</label>
								<input id="tiPassword" type="password" class="form-control input-lg font-15" id="inputPw" placeholder="비밀번호" required="" autocomplete="off" >
							</div>

							<div class="checkbox mb-3">
								<label>
									<input id="chkId" type="checkbox"> 아이디 저장
								</label>
							</div>

							<button id="btnLogin" class="btn btn-lg btn-primary btn-block" type="button">로그인</button>
						</form>

						<ul class="link-bar row">
							<li class="item col-xs-6"><a href="javascript:void(0)" onclick="showFindIdPwdPopup('id')">아이디 찾기</a>&nbsp;/&nbsp;<a href="javascript:void(0)" onclick="showFindIdPwdPopup('pwd')">비밀번호 찾기</a></li>
							<li class="item col-xs-6"><a href="${contextPath}/account/join">회원가입</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	var ck00001 = $.cookie("CK00001");
	if(ck00001) {
		$('#tiUserId').val(ck00001);
		$('#chkId').prop("checked", true);
		$('#tiPassword').focus();
	}else{
		$('#tiUserId').focus();
	}
	
	$('#tiUserId, #tiPassword').keyup(function(e) {
		if (e.keyCode == 13) {
			$('#btnLogin').trigger('click');
		}
	});
	
	$('#btnLogin').click(function(e){
		
		var userId = $('#tiUserId').val();
		var password = $('#tiPassword').val();
		
		if(!userId) {
			common.showAlert('아이디를 입력해주세요.');
			$('#tiUserId').focus();
			return;
		}
		if(!password) {
			common.showAlert('비밀번호를 입력해주세요.');
			$('#tiPassword').focus();
			return;
		}
		
		var checkedId = $('#chkId').is(":checked");
		if(checkedId) {
			$.cookie("CK00001", userId, {expires:1000});
		} else {
			$.removeCookie("CK00001");
		}
		
		common.ajax({
    		url:"${contextPath}/account/checklogin", 
    		data:{userId:userId, password:password},
    		success: function(result) {
    			if(result && result.result) {
    				var frm = document.getElementById("frm");
    				frm.action = "${contextPath}${requestUrl}";
    				frm.submit();
    			}
    		}
    	});
		
	});
	
})();

/**
 * 아이디/비밀번호 찾기 팝업 표시
 */
function showFindIdPwdPopup(type) {
	var winoption = {width:520, height:430};
	var param = {};
	common.openWindow("${contextPath}/popup/findIdPwd?findType="+type, "popFindIdPwd", winoption, param);
	
}
</script>