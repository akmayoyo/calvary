<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<style>
.input-lg {
	font-size: 14px;
}
</style>

<c:choose>
	<c:when test="${not empty requestMobileUrl}">
		<c:set var="requestUrl" value="${requestMobileUrl}"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="requestUrl" value="/mobile/main"></c:set>
	</c:otherwise>
</c:choose>

<form id="frm" method="post">
</form>

<header class="m_header">
	<!-- 사이트 로고 -->
	<a class="logo" href="${contextPath}/mobile/main">
		<img src="${contextPath}/resources/assets/images/logo_w.png" alt="">
	</a>
</header>

<!-- 로그인 컨텐츠 -->
<div class="m_contents login">

    <!-- 중간 컨텐츠 -->
    <div class="container-fluid section" style="border-bottom: 1px solid #e0e0e0;">
        <div class="wrap">
            <div class="row">

                <div style="padding: 0 7%;">

                    <div class="form-group">
                        <label for="tiUserName" style="font-size: 14px;">성명</label>
                        <input id="tiUserName" type="text" class="form-control input-lg" autocomplete="off" autofocus="autofocus">
                    </div>
                    <div class="form-group">
                        <label for="tiMobile" style="font-size: 14px;">휴대폰</label>
                        <input id="tiMobile" type="tel" class="form-control input-lg" placeholder="'-'제외하고 숫자만 입력" autocomplete="off" data-mask="000-0000-0000">
                    </div>
                    <div class="form-group">
                        <label for="tiBirthDate" style="font-size: 14px;">생년월일</label>
                        <input id="tiBirthDate" type="tel" class="form-control input-lg" placeholder="생년월일 8자리 (ex. 19620110)" autocomplete="off" data-mask="0000-00-00">
                    </div>
<!--                     <div class="form-group"> -->
<!--                         <label for="tiUserId">휴대폰 번호</label> -->
<!--                         <div class="form-inline"> -->
<!--                         	<select style="width: 31%; display: inline-block;" class="form-control input-lg"><option value="1980">010</select> -->
<!--                         	<span>-</span> -->
<!--                         	<input style="width: 31%; display: inline-block;" type="text" class="form-control input-lg"> -->
<!--                         	<span>-</span> -->
<!--                         	<input style="width: 31%; display: inline-block;" type="text" class="form-control input-lg"> -->
<!--                         </div> -->
<!--                     </div> -->
                    
<!--                     <div class="form-group"> -->
<!--                         <label for="inputPw">생년월일</label> -->
<!--                         <div class="form-inline"> -->
<!--                         	<select style="width: 31%; display: inline-block;" class="form-control input-lg"><option value="1980">1980</select> -->
<!--                         	<span>-</span> -->
<!--                         	<select style="width: 31%; display: inline-block;" class="form-control input-lg"><option value="1980">01</select> -->
<!--                         	<span>-</span> -->
<!--                         	<select style="width: 31%; display: inline-block;" class="form-control input-lg"><option value="1980">10</select> -->
<!--                         </div> -->
<!--                     </div> -->

                    <div class="checkbox mb-3">
                        <label>
                            <input id="chkKeepLogin" type="checkbox" checked="checked"> 로그인유지
                        </label>
                    </div>

					<div style="height: 20px;">&nbsp;</div>

                    <button id="btnLogin" class="btn btn-lg btn-primary btn-block" type="button">로그인</button>
                    
                </div>
                
            </div>
            
        </div>
        
    </div>
    
</div>

<style>
	.m_footer {
		text-align: center;	
	}
	.m_footer a{
		color: #777777;
		text-align: center;
	}
	.m_footer p{
		color: #999;
		font-size: 13px;
	}
</style>
<!-- 하단 -->
<footer class="m_footer">
<!--     <div> -->
<!--         <a href="https://www.facebook.com/merecalvary/" target="_blank"> -->
<%--             <img src="${contextPath}/resources/assets/images/icon_facebook.jpg"> --%>
<!--         </a> -->
<!--         <a href="https://www.instagram.com/calvary8804/" target="_blank" style="margin-left: 10px;"> -->
<%--             <img src="${contextPath}/resources/assets/images/icon_insta.jpg"> --%>
<!--         </a> -->
<!--     </div> -->
    <div style="margin-top: 5px;">
        <a href="tel:031-789-8800">대표번호 031-789-8800</a>
    </div>
    <div>
        <a href="mailto:calvary@icalvarychurch.org">이메일 calvary@icalvarychurch.org</a>
    </div>
    <div style="margin-top: 7px;">
        <p>경기 성남시 분당구 이매로 132</p>
        <p>© 갈보리 교회 All rights reserved.</p>
    </div>
</footer>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.mask.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	$('#btnLogin').click(function(e){
		
		var userName = $('#tiUserName').val();
		var mobile = $('#tiMobile').val();
		var birthDate = $('#tiBirthDate').val();
		
		if(!userName) {
			common.showAlert('성명을 입력해주세요.');
			$('#tiUserName').focus();
			return;
		}
		if(!mobile) {
			common.showAlert('휴대폰번호를 입력해주세요.');
			$('#tiMobile').focus();
			return;
		}
		if(!birthDate) {
			common.showAlert('생년월일을 입력해주세요.');
			$('#tiBirthDate').focus();
			return;
		}
		
		mobile = common.toNumeric(mobile);
		birthDate = common.toNumeric(birthDate);
		
		common.ajax({
    		url:"${contextPath}/account/checkMobilelogin", 
    		data:{userName:userName, mobile:mobile, birthDate:birthDate, keepLogin:$('#chkKeepLogin').is(":checked") ? '1' : '0'},
    		success: function(result) {
    			if(result && result.result) {
    				var frm = document.getElementById("frm");
    				frm.action = "${contextPath}${requestUrl}";
    				frm.submit();
    			} else {
    				common.showAlert('일치하는 사용자 정보가 없습니다.');
    			}
    		}
    	});
		
	});
	
})();
</script>