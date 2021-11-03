<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.body {
	background-color: #3a3a3a;
	color: #fff;
	height: 352px;
	padding: 20px;
}
.footer {
  position: fixed;
  left: 0;
  bottom: 0;
  width: 100%;
  text-align: right;
}
input[id="chkClose"] {
  position: relative;
  top: 1.5px;
}
label[for="chkClose"] {
  position: relative;
  top: -1.5px;
}
</style>
<div>
	<div class="body"	>
		<p style="font-size: 20px; font-weight: bold;">[부고] 갈보리교회 ${info.use_user_name} 님 소천</p><br>
		<p style="font-size: 15px;">${info.use_user_name} 성도께서 하나님의 부름심을 받아 하늘나라로 가셨기에 다음과 같이 알립니다.</p><br>
		<p style="font-size: 15px;">1. 소천일시 : ${info.death_date }</p>
		<p style="font-size: 15px;">2. 장지 : 용인공원 갈보리부활동산</p>
		<p style="font-size: 15px;">3. 발인일시 : ${info.borne_out_date }</p>
	</div>
	<div class="footer">
		<p style="padding-right: 15px;"><input type="checkbox" id="chkClose" style="margin-right: 3px;"><label for="chkClose">다시 보지 않음</label></p>
	</div>
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js?"<%= new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) %>></script>
<script type="text/javascript">
$('#chkClose').click(function() {
	common.setCookie('notiGrave'+'${info.seq}', 'expire', 1000);
	common.closeWindow();//
});
</script>