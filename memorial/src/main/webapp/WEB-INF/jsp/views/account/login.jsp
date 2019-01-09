<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

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
								<input id="tiUserId" type="text" class="form-control input-lg" id="inputid" placeholder="아이디" required="" autofocus="" value="calvaryadmin">
							</div>

							<div class="form-group">
								<label class="sr-only" for="inputPw">비밀번호</label>
								<input id="tiPassword" type="password" class="form-control input-lg" id="inputPw" placeholder="비밀번호" required="" autocomplete="off" value="calvaryadmin">
							</div>

							<div class="checkbox mb-3">
								<label>
									<input type="checkbox" checked="checked"> 아이디 저장
								</label>
							</div>

							<button id="btnLogin" class="btn btn-lg btn-primary btn-block" type="button">로그인</button>
						</form>

						<ul class="link-bar row">
							<li class="item col-xs-6"><a href="javascript:void(0)">아이디/비밀번호 찾기</a></li>
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
		
		common.ajax({
    		url:"${contextPath}/account/checklogin", 
    		data:{userId:userId, password:password},
    		success: function(result) {
    			if(result && result.result) {
    				var frm = document.getElementById("frm");
    				frm.action = "${contextPath}/main/index";
    				frm.submit();
    			}
    		}
    	});
		
	});
	
})();
</script>