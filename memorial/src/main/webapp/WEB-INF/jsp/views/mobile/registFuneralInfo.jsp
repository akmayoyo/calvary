<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
Calendar currDt = Calendar.getInstance();
int currYear = currDt.get(Calendar.YEAR);
int currMonth = currDt.get(Calendar.MONTH) + 1;
int currDay = currDt.get(Calendar.DATE);
%>

<style>
.m_table td{
	padding: 0;
}
.contract th{
	text-align: left;
}
</style>
<form id="frm" method="post">
</form>
<header class="m_header">
	<!-- 사이트 로고 -->
	<a class="logo" href="${contextPath}/mobile/main">
		<img src="${contextPath}/resources/assets/images/logo_w.png" alt="" style="width: 145px;">
	</a>

	<!-- 로그아웃 -->
	<div class="pull-right bx_logout">
		<a href="http://b2b.yonginparklife.com/mobile.b2b/m.index.asp#" target="_blank" style="display: inline-block;">용인공원</a>
		<a href="javascript:void(0)" onclick="_logout()" style="display: inline-block;">로그아웃</a></li>
	</div>
</header>

<!-- 부고 알림 정보 입력 -->
<div id="registInfo" class="m_contents">
	
	<!-- 아코디언 메뉴 -->
	<div id="m_menu" class="m_menu">

		<div class="panel">
			<div class="depth1">
				<a href="javascript:void(0)" style="font-size: 14px;">부고 알림 정보 입력</a>
			</div>
			<div id="menu2">
				<div class="padding-15">
					<table class="table m_table">
						<colgroup>
							<col width="30%">
							<col width="70%">
						</colgroup>
						<tbody>
							<tr>
								<th scope="sel">고인명</th>
								<td class="text-left">
									${useUserInfo.user_name}
								</td>
							</tr>
							<tr>
								<th scope="sel">부고일시</th>
								<td class="text-left">
									<select id="selDeathMonth" class="form-control input-sm dateselect">
										<option value="1">1월</option>
										<option value="2">2월</option>
										<option value="3">3월</option>
										<option value="4">4월</option>
										<option value="5">5월</option>
										<option value="6">6월</option>
										<option value="7">7월</option>
										<option value="8">8월</option>
										<option value="9">9월</option>
										<option value="10">10월</option>
										<option value="11">11월</option>
										<option value="12">12월</option>
									</select><span> - </span>
									<select id="selDeathDay" class="form-control input-sm dateselect"><option>1일</option></select><span> - </span>
									<select id="selDeathHour" class="form-control input-sm dateselect"></select>
								</td>
							</tr>
							<tr>
								<th scope="sel">장례식장명</th>
								<td class="text-left"><input id="tiFuneralHall" type="text" class="form-control"></td>
							</tr>
							<tr>
								<th scope="sel">장례식장<br>위치</th>
								<td class="text-left"><input id="tiFuneralHallLocation" type="text" class="form-control"></td>
							</tr>
							<tr>
								<th scope="sel">장례식장<br>연락처</th>
								<td class="text-left">
									<input id="tiFuneralHallPhon1" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input id="tiFuneralHallPhon2" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input id="tiFuneralHallPhon3" type="tel" class="form-control input-sm tel_input">
								</td>
							</tr>
							<tr>
								<th scope="sel">발인일시</th>
								<td class="text-left">
									<select id="selBorneOutMonth" class="form-control input-sm dateselect">
										<option value="1">1월</option>
										<option value="2">2월</option>
										<option value="3">3월</option>
										<option value="4">4월</option>
										<option value="5">5월</option>
										<option value="6">6월</option>
										<option value="7">7월</option>
										<option value="8">8월</option>
										<option value="9">9월</option>
										<option value="10">10월</option>
										<option value="11">11월</option>
										<option value="12">12월</option>
									</select><span> - </span>
									<select id="selBorneOutDay" class="form-control input-sm dateselect"><option>1일</option></select><span> - </span>
									<select id="selBorneOutHour" class="form-control input-sm dateselect"></select>
								</td>
							</tr>
							<tr>
								<th scope="sel">장지</th>
								<td class="text-left">
								용인공원 갈보리 추모동산<br>
								<span name="section_info" section_seq="${graveInfo.section_seq}" row_seq="${graveInfo.row_seq}" col_seq="${graveInfo.col_seq}" seq_no="${graveInfo.seq_no}"></span>
								</td>
							</tr>
							<tr>
								<th scope="sel">알리는분<br>성명</th>
								<td class="text-left"><input id="tiSenderName" type="text" class="form-control"></td>
							</tr>
							<tr>
								<th scope="sel">알리는분<br>연락처</th>
								<td class="text-left">
									<input id="tiSenderPhon1" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input id="tiSenderPhon2" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input id="tiSenderPhon3" type="tel" class="form-control input-sm tel_input">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	<div class="text-center" style="margin-top: 10; padding: 0 15px;">
        <button type="button" class="btn btn-primary btn-lg btn-block" onclick="_confirm()">확인</button>
    </div>
	
</div>

<!-- 알림 메세지 확인 및 수신인 입력-->
<div id="registContact" class="m_contents">
	
	<!-- 아코디언 메뉴 -->
	<div id="m_menu" class="m_menu">

		<div class="panel">
			<div class="depth1">
				<a href="javascript:void(0)" style="font-size: 14px;">부고 알림 메세지</a>
			</div>
			<div class="padding-15" style="font-size: 12px;">
				<p style="font-weight: bold;">
					[부고] 갈보리교회 <span id="sUserName2"></span>님 소천
				</p>
				<p>
					<span id="sUserName"></span>성도께서 하나님의 부름심을 받아 하늘나라로 가셨기에 다음과 같이 알립니다.
				</p>
				<p>
				1. 소천일시 : <span id="sDeathDate"></span><br>
				2. 장례식장 : <span id="sFuneralHall"></span><br>
				&nbsp;&nbsp;- 주소 : <span id="sFuneralHallLocation"></span><br>
				&nbsp;&nbsp;- 전화번호 : <span id="sFuneralHallPhone"></span><br>
				3. 장지 : 용인공원 갈보리추모동산&nbsp;&nbsp;<span id="sSection"></span><br>
				4. 발인일시 : <span id="sBorneOutDate"></span><br>
				5. 알리는분<br>
				&nbsp;&nbsp;- 성명 : <span id="sSenderName"></span><br>
				&nbsp;&nbsp;- 연락처 : <span id="sSenderPhone"></span>
				</p>
				<div><span>6. 추가메세지</span><textarea id="taMessage" style="width: 100%;" rows="2" maxlength="100" placeholder="100자이내로 입력"></textarea></div>
				<div><span id="sMessageLength" style="float: right; color: #777;">(0/100)</span></div>
				<div class="clearfix"></div>
			</div>
		</div>
		<div class="panel">
			<div class="depth1">
				<a href="javascript:void(0)" style="font-size: 14px;">알림처</a>
			</div>
			<div class="padding-15">
				<table class="table m_table contract">
					<colgroup>
						<col width="32%">
						<col width="68%">
					</colgroup>
					<tbody>
						<tr>
							<th scope="sel">1. 교구목사</th>
							<td class="text-left">
								<select id="receiverMinister" class="form-control">
								<c:forEach items="${contractMinister}" var="rowItem">
									<option value="${rowItem.mobile}" <c:if test="${rowItem.diocese == rowItem.user_diocese}">selected</c:if>>${rowItem.mobile} (${rowItem.diocese_name})</option>
								</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="sel">2. 교회행정담당</th>
							<td class="text-left">
								<span name="receiver">${contract1.mobile}</span>
							</td>
						</tr>
						<tr>
							<th scope="sel">3. 용인공원담당</th>
							<td class="text-left">
								<span name="receiverNot">${contract2.mobile}</span>
							</td>
						</tr>
<!-- 						<tr> -->
<!-- 							<th scope="sel">4. 용인공원라이프</th> -->
<!-- 							<td class="text-left"> -->
<!-- 								<select id="receiverYongin" class="form-control"> -->
<%-- 								<c:forEach items="${contract3}" var="rowItem"> --%>
<%-- 									<option value="${rowItem.mobile}">${rowItem.mobile}</option> --%>
<%-- 								</c:forEach> --%>
<!-- 								</select> -->
<!-- 							</td> -->
<!-- 						</tr> -->
						<tr>
							<th scope="sel">4. 상조회사</th>
							<td class="text-left">
								<div style="margin-bottom: 5px;">
									<input id="companyPhone1" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input id="companyPhone2" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input id="companyPhone3" type="tel" class="form-control input-sm tel_input">
								</div>
								<div><input type="checkbox" id="chkYonginLife"> <label for="chkYonginLife">용인공원라이프</label></div>
<!-- 								<span style="color: #337AB7;">※ 필요한 경우만 입력</span> -->
							</td>
						</tr>
						<tr>
							<th scope="sel">5. 추가연락처</th>
							<td class="text-left">
								<div>
									<input name="extraPhone1" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input name="extraPhone2" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input name="extraPhone3" type="tel" class="form-control input-sm tel_input">
								</div>
								<div style="margin-top: 5px;">
									<input name="extraPhone1" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input name="extraPhone2" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input name="extraPhone3" type="tel" class="form-control input-sm tel_input">
								</div>
								<div style="margin-top: 5px;">
									<input name="extraPhone1" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input name="extraPhone2" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input name="extraPhone3" type="tel" class="form-control input-sm tel_input">
								</div>
								<div style="margin-top: 5px;">
									<input name="extraPhone1" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input name="extraPhone2" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input name="extraPhone3" type="tel" class="form-control input-sm tel_input">
								</div>
								<div style="margin-top: 5px;">
									<input name="extraPhone1" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input name="extraPhone2" type="tel" class="form-control input-sm tel_input"><span> - </span>
									<input name="extraPhone3" type="tel" class="form-control input-sm tel_input">
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	
	<div class="text-center" style="margin-top: 15">
        <button type="button" class="btn btn-default btn-lg" onclick="_reReist()">다시입력</button>
        <button type="button" class="btn btn-primary btn-lg" onclick="_sendSms()">알림전송</button>
    </div>
	
</div>

<<ul style="display: none;">
<c:forEach items="${contract3}" var="rowItem"> --%>
	<li name="yonginLife" mobile="${rowItem.mobile}"></li>
</c:forEach>
</ul>

<script type="text/javascript" src="${contextPath}/resources/js/jquery.mask.js"></script>
<script type="text/javascript">

(function() {
	
	// 사용구역표시
	$('span[name="section_info"]').each(function(idx) {
		var section = $(this).attr('section_seq') + '구역';
		section += '  ' + $(this).attr('row_seq') + '행 - ' + seqToAlpha($(this).attr('col_seq')) + '열 (고유번호 : ' + $(this).attr('seq_no') + ')';
		$(this).text(section);
	});
	
	var hourOptions = "";
	for(var i = 0; i <= 23; i++) {
		hourOptions += '<option value="' + i + '">' + i + '시' + '</option>';
	}
	$('#selDeathHour, #selBorneOutHour').html(hourOptions);
	
	$('#selDeathMonth').change(function(e) {
		var selectedYear = <%=currYear%>;
		var selectedMonth = $(this).find('option:selected').val();
		generateDays(selectedYear, selectedMonth, $('#selDeathDay'));
	});
	$('#selBorneOutMonth').change(function(e) {
		var selectedYear = <%=currYear%>;
		var selectedMonth = $(this).find('option:selected').val();
		generateDays(selectedYear, selectedMonth, $('#selBorneOutDay'));
	});
	
	$('#selDeathMonth option[value=' + <%=currMonth%> + ']').attr('selected', 'selected');
	$('#selBorneOutMonth option[value=' + <%=currMonth%> + ']').attr('selected', 'selected');
	
	$('#selDeathMonth, #selBorneOutMonth').trigger('change');
	
	$('#selDeathDay option[value=' + <%=currDay%> + ']').attr('selected', 'selected');
	$('#selBorneOutDay option[value=' + <%=currDay%> + ']').attr('selected', 'selected');
	
	$("#taMessage").keyup(function(){
		var maxLen = $(this).attr('maxLength');
		var len = $(this).val().length;
		if(len > maxLen) {
			len = maxLen;
		}
	  $("#sMessageLength").text('(' + len + '/' + maxLen + ')');
	});
	
	$('#chkYonginLife').change(function() {
	    if($(this).is(':checked')) {
	    	var contact = $('li[name="yonginLife"]').eq(0).attr("mobile");
	    	if(contact) {
	    		var splited = contact.split('-');
	    		if(splited && splited.length == 3) {
	    			var idx = 0;
	    			$('#companyPhone1').val(splited[idx++]);
	    			$('#companyPhone2').val(splited[idx++]);
	    			$('#companyPhone3').val(splited[idx++]);
	    		}
	    	}
	    }
	  });
	
})();

/**
 * 
 */
function seqToAlpha(seq) {
	var seqOfA = "A".charCodeAt(0) + (seq-1);
	var alpha = String.fromCharCode(seqOfA);
	return alpha;
}

/**
 * 연월에 해당하는 날짜 선택용 select box 생성
 */
function generateDays(year, month, el) {
	var firstDay = 1;
	var lastDay = new Date(year, month, 0).getDate();
	var options = "";
	for(var i = firstDay; i <= lastDay; i++) {
		options += '<option value="' + i + '">' + i + '일' + '</option>';
	}
	var selectedDay = $(el).val();
	$(el).html(options);
	if(selectedDay > 0 && selectedDay <= lastDay) {
		$(el).find('option[value=' + selectedDay + ']').attr('selected', 'selected');
	}
}

/**
 * 확인
 */
function _confirm() {
	var userName = '${useUserInfo.user_name}';
	var selectedHour = $('#selDeathHour option:selected').val();
	if(selectedHour < 10) {
		selectedHour = '0' + selectedHour;
	}
	selectedHour += '시';
	var deathDate = $('#selDeathMonth option:selected').text();
	deathDate += $('#selDeathDay option:selected').text();
	deathDate += ' ' + selectedHour;
	
	selectedHour = $('#selBorneOutHour option:selected').val();
	if(selectedHour < 10) {
		selectedHour = '0' + selectedHour;
	}
	selectedHour += '시';
	var borneOutDate = $('#selBorneOutMonth option:selected').text();
	borneOutDate += $('#selBorneOutDay option:selected').text();
	borneOutDate += ' ' + selectedHour;
	
	var el = $('#tiFuneralHall');
	var funeralHall = el.val();
	if(!funeralHall) {
		common.showAlert('장례식장명을 입력해주세요.');
		el.focus();
		return;
	}
	el = $('#tiFuneralHallLocation');
	var funeralHallLocation = el.val();
	if(!funeralHallLocation) {
		common.showAlert('장례식장 위치를 입력해주세요.');
		el.focus();
		return;
	}
	el = $('#tiFuneralHallPhon1');
	var funeralHallPhone1 = el.val();
	if(!funeralHallPhone1) {
		common.showAlert('장례식장 연락처를 입력해주세요.');
		el.focus();
		return;
	}
	el = $('#tiFuneralHallPhon2');
	var funeralHallPhone2 = el.val();
	if(!funeralHallPhone2) {
		common.showAlert('장례식장 연락처를 입력해주세요.');
		el.focus();
		return;
	}
	el = $('#tiFuneralHallPhon3');
	var funeralHallPhone3 = el.val();
	if(!funeralHallPhone3) {
		common.showAlert('장례식장 연락처를 입력해주세요.');
		el.focus();
		return;
	}
	var funeralHallPhone = funeralHallPhone1 + '-' + funeralHallPhone2 + '-' + funeralHallPhone3;
	if(!common.isValidPhone(funeralHallPhone)) {
		common.showAlert('장례식장 연락처 양식이 올바르지 않습니다.');
		return;
	}
	el = $('#tiSenderName');
	var senderName = el.val();
	if(!senderName) {
		common.showAlert('알리는분 성명을 입력해주세요.');
		el.focus();
		return;
	}
	
	el = $('#tiSenderPhon1');
	var senderPhone1 = el.val();
	if(!senderPhone1) {
		common.showAlert('알리는분 연락처를 입력해주세요.');
		el.focus();
		return;
	}
	el = $('#tiSenderPhon2');
	var senderPhone2 = el.val();
	if(!senderPhone2) {
		common.showAlert('알리는분 연락처를 입력해주세요.');
		el.focus();
		return;
	}
	el = $('#tiSenderPhon3');
	var senderPhone3 = el.val();
	if(!senderPhone3) {
		common.showAlert('알리는분 연락처를 입력해주세요.');
		el.focus();
		return;
	}
	var senderPhone = senderPhone1 + '-' + senderPhone2 + '-' + senderPhone3;
	if(!common.isValidPhone(senderPhone)) {
		common.showAlert('알리는분 연락처 양식이 올바르지 않습니다.');
		return;
	}
	
	$('#sUserName').text(userName);
	$('#sUserName2').text(userName);
	$('#sDeathDate').text(deathDate);
	$('#sBorneOutDate').text(borneOutDate);
	$('#sFuneralHall').text(funeralHall);
	$('#sFuneralHallLocation').text(funeralHallLocation);
	$('#sFuneralHallPhone').text(funeralHallPhone);
	$('#sSenderName').text(senderName);
	$('#sSenderPhone').text(senderPhone);
	$('#sSection').text($('span[name="section_info"]').text());
	
	$('#registInfo').hide();
	$('#registContact').show();
	scrollToTop();
}

/**
 * 다시입력
 */
function _reReist() {
	$('#registContact').hide();
	$('#registInfo').show();
	scrollToTop();
}

function scrollToTop() {
	$('html:not(:animated), body:not(:animated)').animate({
        scrollTop: 0
    }, 200);
}

/**
 * 알림전송
 */
function _sendSms() {
	var receivers = [];
	var mobile;
	// 기지정된 담당자 연락처
	$('span[name="receiver"]').each(function(idx) {
		mobile = $(this).text();
		if(mobile && receivers.indexOf(mobile) < 0) {
			receivers.push(mobile);
		}
	});
	
	// 교구목사
	mobile = $('#receiverMinister option:selected').val();
	if(mobile && receivers.indexOf(mobile) < 0) {
		receivers.push(mobile);
	}
	// 용인공원라이프
// 	mobile = $('#receiverYongin option:selected').val();
// 	if(mobile && receivers.indexOf(mobile) < 0) {
// 		receivers.push(mobile);
// 	}
	
	// 상조회사
	var companyPhone1 = $('#companyPhone1').val();
	var companyPhone2 = $('#companyPhone2').val();
	var companyPhone3 = $('#companyPhone3').val();
	var companyPhone = '';
	if(companyPhone1 || companyPhone2 || companyPhone3) {
		companyPhone = companyPhone1 + '-' + companyPhone2 + '-' + companyPhone3;
		if(!common.isValidMobile(companyPhone)) {
			common.showAlert('상조회사 연락처가 올바른 핸드폰 번호가 아닙니다.');
			if(!companyPhone1) {
				$('#companyPhone1').focus();		
			}else if(!companyPhone2) {
				$('#companyPhone2').focus();
			}else if(!companyPhone3) {
				$('#companyPhone3').focus();
			}else {
				$('#companyPhone1').focus();
			}
			return;
		}
		if(companyPhone && receivers.indexOf(companyPhone) < 0) {
			//receivers.push(companyPhone);
		}
	}
	var bValid = true;
	// 추가연락처
	$('input[name="extraPhone1"]').each(function(idx) {
		var input1 = $(this);
		var input2 = $('input[name="extraPhone2"]').eq(idx);
		var input3 = $('input[name="extraPhone3"]').eq(idx);
		var phone1 = input1.val();
		var phone2 = input2.val();
		var phone3 = input3.val();
		var phone = '';
		if(phone1 || phone2 || phone3) {
			phone = phone1 + '-' + phone2 + '-' + phone3;
			if(!common.isValidMobile(phone)) {
				common.showAlert('추가로 입력한 연락처가 올바른 핸드폰 번호가 아닙니다.');
				if(!phone1) {
					$(input1).focus();		
				}else if(!phone2) {
					$(input2).focus();
				}else if(!phone3) {
					$(input3).focus();
				}else {
					$(input1).focus();
				}
				bValid = false;
				return false;
			}
			if(phone && receivers.indexOf(phone) < 0) {
				//receivers.push(phone);
			}
		}
	});
	
	if(receivers.length == 0) {
		common.showAlert('메세지 수신정보가 없습니다.');
		return;
	}
	
	if(bValid) {
		var userName = $('#sUserName').text();
		var deathDate = $('#sDeathDate').text();
		var funeralHall = $('#sFuneralHall').text();
		var funeralHallLocation = $('#sFuneralHallLocation').text();
		var funeralHallPhone = $('#sFuneralHallPhone').text();
		var borneOutDate = $('#sBorneOutDate').text();
		var senderName = $('#sSenderName').text();
		var senderPhone = $('#sSenderPhone').text();
		var extraMessage = $('#taMessage').val();
		
		if(!common.trimAll(extraMessage)) {
			extraMessage = '';
		}
		
		var sendSmsVo = {};
		sendSmsVo.msgKey = 'M0008';
		sendSmsVo.receivers = receivers.join(',');
		sendSmsVo.sequences = [userName, userName, deathDate, funeralHall, funeralHallLocation, funeralHallPhone, borneOutDate, senderName, senderPhone, extraMessage];
		common.sendSms(sendSmsVo, function(result) {
			common.showAlert('메세지가 전송되었습니다.');
			var frm = document.getElementById("frm");
			frm.action = "${contextPath}/mobile/main";
			frm.submit();
		}, function(xhr, status, message) {
			var frm = document.getElementById("frm");
			frm.action = "${contextPath}/mobile/main";
			frm.submit();
		});
	}
}

/**
 * 로그아웃처리
 */
function _logout() {
	common.ajax({
		url:"${contextPath}/account/mobile/logout", 
		data:{},
		success: function(result) {
			if(result) {
				location.replace('${contextPath}/account/mobile/login');
			}
		}
	});
}

</script>
